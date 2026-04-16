# rm/tools

Automated workstation setup using Ansible. Supports **Arch Linux (WSL)** and **macOS**.

## Requirements

| Platform | Prerequisites |
|----------|--------------|
| macOS    | Nothing — `make bootstrap` installs Homebrew + Ansible |
| Arch WSL | Nothing — `make bootstrap` installs Ansible via pacman  |

## Quick start

```bash
git clone https://github.com/oromulomartins/tools.git ~/tools
cd ~/tools
make bootstrap
```

Or, if Ansible is already installed:

```bash
make setup
```

## Available targets

```
make setup       Full workstation setup (all roles)
make base        Base packages only (curl, git, make, etc.)
make cli         CLI tools (bat, ripgrep, fzf, eza, lazygit, etc.)
make k8s         Kubernetes tools (kubectl, kubectx, k9s, helm)
make dev         Dev environment (asdf, lunarvim, tmux)
make infra       Infra tools (terraform, aws cli)
make apps        macOS GUI apps
make dotfiles    Clone dotfiles repo and run GNU Stow
make bootstrap   Install Ansible + deps, then run full setup
make lint        Run ansible-lint on all playbooks
```

## What gets installed

### Shell & Terminal
- **Zsh** + Zinit plugin manager
- **Powerlevel10k** theme (via dotfiles)
- **Alacritty** terminal (Arch/WSL only)
- **MesloLGS NF** fonts

### Dev Environment
- **asdf** version manager with plugins:
  - Python 3.13, Node.js 23, Rust 1.86, Java (OpenJDK 24)
  - Neovim, Colima, Lima
- **LunarVim** (config managed via dotfiles)
- **tmux** + TPM

### CLI Tools
`bat` · `ripgrep` · `jq` · `yq` · `lazygit` · `gh` · `git-delta` · `eza` · `fzf` · `zoxide` · `btop` · `httpie` · `dust` · `curlie`

### Kubernetes
`kubectl` · `kubectx` / `kubens` · `k9s` · `helm`

### Infra / Cloud
- **Terraform** (latest)
- **AWS CLI v2**

### Containers
- **Arch WSL**: Docker Engine + Compose plugin + Colima (via asdf)
- **macOS**: Docker Desktop (via brew cask)

### macOS GUI Apps
`iTerm2` · `Slack` · `IntelliJ IDEA CE` · `Google Chrome` · `DBeaver Community` · `Docker Desktop`
> Xcode CLI tools are installed via `xcode-select --install`. Full Xcode must be installed manually from the App Store.

## Dotfiles

Dotfiles are managed separately at [oromulomartins/dotfiles](https://github.com/oromulomartins/dotfiles) using GNU Stow.

```bash
make dotfiles
```

## Updating tool versions

Edit `group_vars/all.yml` to change versions:

```yaml
asdf_tools:
  - { name: python, version: "3.13.1" }
  # ...

kubectl_version:   "1.32.0"
helm_version:      "3.17.1"
terraform_version: "1.10.5"
```
