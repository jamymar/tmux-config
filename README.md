# Dotfiles — Development Environment

Personal development environment configuration for macOS, Linux and Docker containers.

Optimized for Python, Deep Learning, Machine Learning and remote GPU development.

## Features

- **tmux** — Terminal multiplexer with persistent sessions
- **Catppuccin Macchiato** — Consistent theme with Zed
- **TPM** — Automatic tmux plugin management
- **GPU monitoring** — NVIDIA GPU usage, VRAM and temperature
- **Remote development** — SSH and Docker compatibility
- **Portable setup** — Reusable configuration across machines

## Repository structure

```text
dotfiles/
├── tmux/
│   └── .tmux.conf
├── scripts/
│   └── gpu-status.sh
├── setup.sh
└── README.md
```

## Installation

### 1. Clone the repository

```bash
git clone git@github.com:YOUR_USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

For a public repository, HTTPS can also be used.

### 2. Run the installer

```bash
chmod +x setup.sh
./setup.sh
```

The installer will:

1. Check and install tmux and Git if needed.
2. Back up an existing tmux configuration.
3. Link the repository configuration to `~/.tmux.conf`.
4. Install TPM and the configured plugins.
5. Enable GPU monitoring when the script is available.

### 3. Start tmux

```bash
tmux new -s dev
```

## Keyboard shortcuts

The default tmux prefix is `Ctrl + B`.

| Shortcut | Action |
|---|---|
| `Ctrl+B`, `C` | New window |
| `Ctrl+B`, `%` | Split vertically |
| `Ctrl+B`, `"` | Split horizontally |
| `Ctrl+B`, `D` | Detach session |
| `Ctrl+B`, `R` | Reload configuration |
| `Ctrl+B`, `[` | Enter copy mode |
| `Ctrl+B`, `N` | Next window |
| `Ctrl+B`, `P` | Previous window |

## Session management

Create a session:

```bash
tmux new -s training
```

Detach without stopping running processes:

```text
Ctrl+B, D
```

List sessions:

```bash
tmux ls
```

Reconnect:

```bash
tmux attach -t training
```

## GPU monitoring

The status bar displays:

- GPU utilization
- VRAM usage and capacity
- VRAM utilization percentage
- GPU temperature

GPU monitoring requires NVIDIA drivers and a working `nvidia-smi` command.

On machines without an NVIDIA GPU, the module is hidden.

In Docker, GPU visibility must be enabled when the container is created.

## Docker usage

The setup can be installed during image creation:

```dockerfile
COPY dotfiles /opt/dotfiles
RUN bash /opt/dotfiles/setup.sh
```

Run the installer as the same user who will use tmux. Ensure that Git and the package manager are available and that the image build can access the plugin repositories.

Alternatively, mount an existing dotfiles directory into a container and run the setup script there.

## Remote development

The same configuration can be installed on:

- macOS development machines
- Linux GPU servers
- Docker development containers
- Remote SSH workspaces

Each environment requires its own tmux installation and TPM plugins.

## Updating

From the repository directory:

```bash
git pull
./setup.sh
```

Reload an active tmux server:

```bash
tmux source-file ~/.tmux.conf
```

## Security

This repository must not contain:

- SSH private keys
- API tokens
- Cloud credentials
- Company secrets
- Sensitive environment variables

Follow your organization's security policies before installing personal configurations on corporate infrastructure.

## License

Personal configuration. Adapt and reuse according to your needs.
