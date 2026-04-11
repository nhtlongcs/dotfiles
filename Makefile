.PHONY: help setup install-nvm setup-nodejs setup-shell-tools setup-zsh format-shell lint-shell

help:
	@echo "Dotfiles Setup Commands"
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@echo "Node.js Setup:"
	@echo "  setup              Install nvm, Node.js (LTS), and configure npm"
	@echo "  setup VERSION=18   Install specific Node.js version (default: LTS)"
	@echo "  install-nvm        Install nvm only"
	@echo "  setup-nodejs       Setup Node.js and npm (LTS)"
	@echo "  setup-nodejs-18    Setup Node.js 18 and npm"
	@echo ""
	@echo "Shell Setup:"
	@echo "  setup-shell-tools  Install shfmt, shellcheck, starship"
	@echo "  setup-zsh          Setup oh-my-zsh with plugins"
	@echo "  format-shell       Format all shell scripts with shfmt"
	@echo "  lint-shell         Lint all shell scripts with shellcheck"
	@echo ""
	@echo "  help               Show this help message"

setup:
	./scripts/setup.sh $(VERSION)

install-nvm:
	./scripts/install-nvm.sh

setup-nodejs:
	./scripts/setup-nodejs.sh $(VERSION)

setup-nodejs-18:
	./scripts/setup-nodejs.sh 18

setup-shell-tools:
	./scripts/setup-shell-tools.sh

setup-zsh:
	./scripts/setup-zsh.sh

format-shell:
	./scripts/format-shell.sh

lint-shell:
	./scripts/lint-shell.sh
