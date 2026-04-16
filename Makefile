.PHONY: help setup base cli k8s dev infra apps dotfiles bootstrap deps lint

PLAYBOOK_DIR := playbooks
ANSIBLE      := ansible-playbook
GALAXY       := ansible-galaxy
BECOME       := --ask-become-pass

## deps        Install Ansible Galaxy collections
deps:
	$(GALAXY) collection install -r requirements.yml

## setup       Full workstation setup (all roles)
setup: deps
	$(ANSIBLE) $(PLAYBOOK_DIR)/site.yml $(BECOME)

## base        Base packages only (curl, git, make, etc.)
base: deps
	$(ANSIBLE) $(PLAYBOOK_DIR)/base.yml $(BECOME)

## cli         CLI tools (bat, ripgrep, fzf, eza, lazygit, etc.)
cli: deps
	$(ANSIBLE) $(PLAYBOOK_DIR)/cli.yml $(BECOME)

## k8s         Kubernetes tools (kubectl, kubectx, k9s, helm)
k8s: deps
	$(ANSIBLE) $(PLAYBOOK_DIR)/k8s.yml $(BECOME)

## dev         Dev environment (asdf, lunarvim, tmux)
dev: deps
	$(ANSIBLE) $(PLAYBOOK_DIR)/dev.yml $(BECOME)

## infra       Infra tools (terraform, aws cli)
infra: deps
	$(ANSIBLE) $(PLAYBOOK_DIR)/infra.yml $(BECOME)

## apps        macOS GUI apps (iTerm2, Slack, IntelliJ CE, Chrome, DBeaver, Docker Desktop)
apps: deps
	$(ANSIBLE) $(PLAYBOOK_DIR)/apps.yml $(BECOME)

## dotfiles    Clone dotfiles repo and run GNU Stow
dotfiles:
	@bash scripts/dotfiles.sh

## bootstrap   Install Ansible + deps, then run full setup
bootstrap:
	@bash scripts/bootstrap.sh

## lint        Run ansible-lint on all playbooks
lint:
	ansible-lint $(PLAYBOOK_DIR)/

## help        Show this help message
help:
	@echo "Usage: make <target>"
	@echo ""
	@grep -E '^## ' Makefile | sed 's/## /  /'

.DEFAULT_GOAL := help
