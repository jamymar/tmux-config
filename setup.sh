```bash
#!/usr/bin/env bash
set -euo pipefail

# ==========================================
# DOTFILES SETUP — macOS / Linux / Docker
# ==========================================

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMUX_CONF="$HOME/.tmux.conf"
TPM_DIR="$HOME/.tmux/plugins/tpm"

info() {
    printf '\033[0;34m[INFO]\033[0m %s\n' "$1"
}

success() {
    printf '\033[0;32m[OK]\033[0m %s\n' "$1"
}

error() {
    printf '\033[0;31m[ERROR]\033[0m %s\n' "$1" >&2
    exit 1
}

# ==========================================
# 1. Install dependencies
# ==========================================

install_dependencies() {
    info "Checking dependencies..."

    if command -v tmux >/dev/null 2>&1 &&
       command -v git >/dev/null 2>&1; then
        success "tmux and git already installed"
        return
    fi

    case "$(uname -s)" in
        Darwin)
            command -v brew >/dev/null 2>&1 ||
                error "Homebrew is required: https://brew.sh"

            brew install tmux git
            ;;

        Linux)
            if command -v apt-get >/dev/null 2>&1; then
                if [ "$(id -u)" -eq 0 ]; then
                    apt-get update
                    apt-get install -y tmux git
                elif command -v sudo >/dev/null 2>&1; then
                    sudo apt-get update
                    sudo apt-get install -y tmux git
                else
                    error "Run as root or install tmux and git manually"
                fi
            else
                error "Unsupported package manager. Install tmux and git manually."
            fi
            ;;

        *)
            error "Unsupported operating system"
            ;;
    esac

    success "Dependencies installed"
}

# ==========================================
# 2. Configure tmux
# ==========================================

setup_tmux() {
    info "Configuring tmux..."

    local source="$DOTFILES_DIR/tmux/.tmux.conf"

    [ -f "$source" ] ||
        error "Missing configuration: $source"

    if [ -L "$TMUX_CONF" ] &&
       [ "$(readlink "$TMUX_CONF")" = "$source" ]; then
        success "tmux configuration already linked"
        return
    fi

    if [ -e "$TMUX_CONF" ] || [ -L "$TMUX_CONF" ]; then
        local backup="${TMUX_CONF}.backup.$(date +%Y%m%d%H%M%S)"
        mv "$TMUX_CONF" "$backup"
        info "Previous configuration saved to $backup"
    fi

    ln -s "$source" "$TMUX_CONF"
    success "tmux configuration linked"
}

# ==========================================
# 3. Install TPM
# ==========================================

install_tpm() {
    info "Checking TPM..."

    if [ ! -d "$TPM_DIR/.git" ]; then
        mkdir -p "$(dirname "$TPM_DIR")"
        git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
    fi

    success "TPM ready"
}

# ==========================================
# 4. Install tmux plugins
# ==========================================

install_plugins() {
    info "Installing tmux plugins..."

    "$TPM_DIR/bin/install_plugins"

    success "Plugins installed"
}

# ==========================================
# 5. GPU monitoring script
# ==========================================

setup_gpu() {
    local script="$DOTFILES_DIR/scripts/gpu-status.sh"

    if [ -f "$script" ]; then
        chmod +x "$script"
        mkdir -p "$HOME/.local/bin"
        ln -sf "$script" "$HOME/.local/bin/tmux-gpu-status"
        success "GPU monitoring enabled"
    else
        info "GPU script not found, skipping"
    fi
}

# ==========================================
# 6. Finish
# ==========================================

main() {
    echo ""
    echo "=================================="
    echo "       DOTFILES INSTALLER"
    echo "=================================="
    echo ""

    install_dependencies
    setup_tmux
    install_tpm
    setup_gpu
    install_plugins

    echo ""
    success "Setup completed!"
    echo ""
    echo "Start tmux with:"
    echo "  tmux new -s dev"
    echo ""
}

main "$@"
```
