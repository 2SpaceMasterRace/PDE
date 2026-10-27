local python = require("config.python")

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "python", "ninja", "rst" } },
  },
  {
    "neovim/nvim-lspconfig",
    init = function()
      vim.api.nvim_create_user_command("PythonLsp", function(args)
        if args.args == "" then
          python.select()
        else
          python.switch(args.args)
        end
      end, {
        nargs = "?",
        complete = function()
          return { "pyrefly", "ty" }
        end,
      })
      vim.api.nvim_create_user_command("PythonInfo", python.info, {})
    end,
    opts = function(_, opts)
      opts.servers.pyright = { enabled = false }
      opts.servers.basedpyright = { enabled = false }
      opts.servers.ruff_lsp = { enabled = false }
      local common = {
        before_init = python.before_init,
        -- Native macOS LSP file watchers produced EMFILE in the old setup.
        -- Text edits still sync; restart LSP after external dependency changes.
        capabilities = { workspace = { didChangeWatchedFiles = { dynamicRegistration = false } } },
      }
      opts.servers.pyrefly = vim.tbl_deep_extend("force", common, {
        enabled = true,
        on_exit = function() end,
        settings = {
          python = {
            pyrefly = {
              typeCheckingMode = "default",
              diagnosticMode = "openFilesOnly",
            },
            analysis = { autoImportCompletions = true },
          },
        },
      })
      opts.servers.ty = vim.tbl_deep_extend("force", common, {
        enabled = true,
        settings = { ty = { diagnosticMode = "openFilesOnly" } },
      })
      for _, server in ipairs({ "pyrefly", "ty" }) do
        opts.setup[server] = function(name, config)
          -- Configure both; exclude the inactive server from Mason auto-activation.
          vim.lsp.config(name, config)
          return name ~= vim.g.lazyvim_python_lsp
        end
      end
      opts.servers.ruff = vim.tbl_deep_extend("force", opts.servers.ruff or {}, {
        enabled = true,
        capabilities = common.capabilities,
        init_options = { settings = { logLevel = "error" } },
        on_attach = function(client)
          client.server_capabilities.hoverProvider = false
        end,
        keys = {
          { "<leader>cL", python.select, desc = "Select Python LSP" },
          { "<leader>cP", python.info, desc = "Python Environment Info" },
        },
      })
    end,
  },
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "pyrefly", "ty", "ruff" } },
  },
  {
    "stevearc/conform.nvim",
    opts = { formatters_by_ft = { python = { "ruff_organize_imports", "ruff_format" } } },
  },
  {
    "linux-cultist/venv-selector.nvim",
    cmd = "VenvSelect",
    ft = "python",
    keys = { { "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv", ft = "python" } },
    opts = {
      options = {
        on_venv_activate_callback = python.remember_environment,
        set_environment_variables = false,
        notify_user_on_venv_activation = true,
      },
    },
  },
  {
    "nvim-neotest/neotest",
    dependencies = { "nvim-neotest/neotest-python" },
    opts = {
      adapters = {
        ["neotest-python"] = {
          runner = "pytest",
          python = function(root)
            return { python.interpreter(root) }
          end,
        },
      },
    },
  },
  { "mfussenegger/nvim-dap", optional = true, enabled = false },
  { "mfussenegger/nvim-dap-python", optional = true, enabled = false },
  { "jay-babu/mason-nvim-dap.nvim", optional = true, enabled = false },
}
