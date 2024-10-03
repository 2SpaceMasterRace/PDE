# PDE
> [!WARNING]  
> This is still under progress, use at your own  disk. I will be documenting and testing everything before I release it as a full blown, opiniated developer system

PDE aka Personal Development Environment is a crash course in creating the ultimate produtive developer workflow for modern web-development, low-level programming and light chores. This also serves as a backup of all my dotfiles which is fully automated and reproducable in any machine. It's about being blazingly fast in any machine regardless of specs and minimizes the latency from the mind to body. 

# Features
More distro-specific optimizations and keyboard-focused shortcuts are to be included. I'll be building a CLI app using Go and Charm that can navigate between different distros such as Nix or Void Linux and set everything from scratch; something similar to Omakub. Currently it has the bare-essentials, so please open an issue if you'd like to contribute or report bugs.

I really hate distractions and tools that serve no purpose, so my workflow is limted to a single main screen with an occassional secondary screen that plays random youtube content. I very rarely display more than 3 buffers on nthe mains creen at a time. i3 and Zellij makes it super easy and fast to switch between things that I barely use the mouse anymore.

All of my configurations is managed using Git for version control and I like writing tools that support text-based configuration files with exception to a few rare one-off cases. I'm still learning more to make my setup highly customizable and be literate for everyone to get a idea on how my system is abstracted.


# GNU Stow
The dotfiles are managed using [GNU Stow(https://www.gnu.org/software/stow/), It allows me to create symlinks for all user-level configuration. An important thing to remember with stow is that the dotfile you are “stowing” must be contained within a directory structure that exactly matches that of the original directory structure. 

## Requirements

'''bash
# Install Git and Stow using your package manager (I use Arch btw)
pacman -S git stow
'''

The dot files are structured and abstracted in this way for quick configuration:
'''shell
.config -> All configurations like themes and fonts go here
default -> Base configuration stays here that sources the .config file
scripts -> Some scripts for system-level configuration and automate 
installation scripts
install -> Scripts that install all the tools in the config
'''


# License

PDE is released under the MIT License. This is an opiniated take on dotfiles that maximzes on bespoke configs for every essential tool and make use of the best Linux has to offer.
