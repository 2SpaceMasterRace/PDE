local M = {}
local servers = { "pyrefly", "ty" }
local preference = vim.fn.stdpath("state") .. "/python-lsp"
local selected_python = {}
local shell_venv = vim.env.VIRTUAL_ENV or vim.env.CONDA_PREFIX

function M.preferred_server()
  if vim.fn.filereadable(preference) == 1 then
    local name = vim.fn.readfile(preference)[1]
    if vim.tbl_contains(servers, name) then
      return name
    end
  end
  return "pyrefly"
end

function M.root(buf)
  buf = buf or 0
  local filename = vim.api.nvim_buf_get_name(buf)
  return vim.fs.root(buf, {
    "pyproject.toml",
    "pyrefly.toml",
    "ty.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    ".git",
  }) or (filename ~= "" and vim.fs.dirname(filename) or nil) or vim.fn.getcwd()
end

function M.interpreter(root)
  root = root or M.root()
  local candidates = { selected_python[root] or "", root .. "/.venv/bin/python", root .. "/venv/bin/python" }
  if shell_venv then
    candidates[#candidates + 1] = shell_venv .. "/bin/python"
  end
  for _, path in ipairs(candidates) do
    if path ~= "" and vim.fn.executable(path) == 1 then
      return path
    end
  end
  return vim.fn.exepath("python3")
end

-- venv-selector restarts clients with python.pythonPath; translate it for ty too.
function M.before_init(_, config)
  local python = vim.tbl_get(config, "settings", "python", "pythonPath") or M.interpreter(config.root_dir)
  if not python or python == "" then
    return
  end
  -- Neovim captures this table before before_init; preserve its identity.
  config.settings = config.settings or {}
  config.settings.python = vim.tbl_deep_extend("force", config.settings.python or {}, { pythonPath = python })
  if config.name == "ty" then
    config.settings.ty = vim.tbl_deep_extend("force", config.settings.ty or {}, {
      configuration = { environment = { python = python } },
    })
  end
end

function M.remember_environment()
  local root = require("venv-selector.venv").active_project_root() or M.root()
  selected_python[root] = require("venv-selector").python()
end

function M.switch(name)
  if not vim.tbl_contains(servers, name) then
    vim.notify("Choose pyrefly or ty", vim.log.levels.ERROR)
    return
  end
  require("lazy").load({ plugins = { "nvim-lspconfig" } })
  if vim.fn.executable(name) ~= 1 then
    vim.notify("Install " .. name .. " with :MasonInstall " .. name, vim.log.levels.ERROR)
    return
  end
  for _, server in ipairs({ "pyrefly", "ty", "pyright", "basedpyright" }) do
    vim.lsp.enable(server, false)
  end
  vim.g.lazyvim_python_lsp = name
  vim.fn.mkdir(vim.fn.stdpath("state"), "p")
  vim.fn.writefile({ name }, preference)
  vim.lsp.enable(name)
  vim.notify("Python LSP: " .. name .. " (saved for future sessions)")
end

function M.select()
  vim.ui.select(servers, { prompt = "Python language server" }, function(name)
    if name then
      M.switch(name)
    end
  end)
end

function M.info()
  local lines = {
    "Preferred server: " .. vim.g.lazyvim_python_lsp,
    "Project: " .. M.root(),
    "Python: " .. M.interpreter(),
    "",
  }
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    lines[#lines + 1] = client.name .. ": " .. table.concat(client.config.cmd or {}, " ")
  end
  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO, { title = "Python environment" })
end

return M
