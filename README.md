# Ninjatronics DevOps IDE

Portable DevPod/devcontainer environment for DevOps, Kubernetes, Infrastructure-as-Code, Linux administration, automation, and cloud engineering.

---

## Features

This environment includes:

* LazyVim
* Docker-in-Docker
* kubectl
* Helm
* FluxCD
* Terraform
* Ansible
* GitHub CLI (gh)
* Azure CLI
* PowerShell
* Python
* Node.js
* lazygit
* tmux
* jq
* yq
* shellcheck
* shfmt

---

## Supported Platforms

Validated on:

* Windows 11 + WSL2
* Ubuntu 24.04 LTS
* Docker Engine
* DevPod v0.6.x
* AMD64 (x86_64)
* ARM64 (aarch64)

No desktop environment is required.

---

# Quick Start

Clone the repository:

```bash
git clone https://github.com/GMakeziG/devops-devpod.git
cd devops-devpod
```

Start the workspace:

```bash
devpod up .
```

Expected output:

```text
DevOps LazyVim IDE is ready.
```

---

# Installation Requirements

## Docker

Install Docker:

```bash
sudo apt update
sudo apt install -y docker.io git curl
sudo usermod -aG docker $USER
newgrp docker
```

Verify:

```bash
docker version
docker ps
```

---

## DevPod

AMD64:

```bash
curl -L -o devpod https://github.com/loft-sh/devpod/releases/latest/download/devpod-linux-amd64

chmod +x devpod

sudo mv devpod /usr/local/bin/
```

ARM64:

```bash
curl -L -o devpod https://github.com/loft-sh/devpod/releases/latest/download/devpod-linux-arm64

chmod +x devpod

sudo mv devpod /usr/local/bin/
```

Verify:

```bash
devpod version
```

---

# Recommended Directory Layout

Create a dedicated workspace folder:

```bash
mkdir -p ~/workspace
cd ~/workspace
```

Clone the repository:

```bash
git clone https://github.com/GMakeziG/devops-devpod.git

cd devops-devpod
```

---

# Configure DevPod Provider

DevPod requires a default provider.

View providers:

```bash
devpod provider list
```

Add Docker provider:

```bash
devpod provider add docker
```

Select Docker provider:

```bash
devpod provider use docker
```

Verify:

```bash
devpod provider list
```

---

# Build Workspace

Create the development environment:

```bash
devpod up .
```

The initial build may take several minutes while Docker images, extensions, and tools are downloaded.

Expected output:

```text
DevOps LazyVim IDE is ready.
```

---

# WSL2 Setup

Verified working on:

* Windows 11
* Ubuntu 24.04 WSL2
* VS Code Remote SSH

Verify WSL:

```powershell
wsl -l -v
```

Example:

```text
Ubuntu-24.04 Running Version 2
```

---

# Headless Linux Setup

This project works fully on headless Linux servers.

Example:

```bash
cd ~/workspace/devops-devpod

devpod up .
```

If OpenVSCode Server starts:

```text
Successfully started vscode in browser mode
```

Keep the terminal open.

---

## Prevent Idle Shutdown

If DevPod automatically exits:

```text
Stopping devpod up, because it stayed idle for a while
```

Disable timeout:

```bash
devpod context set-options -o EXIT_AFTER_TIMEOUT=false
```

Then run:

```bash
devpod up .
```

again.

---

# Browser Access

DevPod automatically launches OpenVSCode Server.

Typical URL:

```text
http://localhost:10800
```

For remote servers:

```bash
ssh -L 10800:localhost:10800 user@server
```

Then open:

```text
http://localhost:10800
```

in your browser.

---

# SSH Access

Open another terminal:

```bash
devpod ssh devops-devpod
```

Expected prompt:

```text
vscode ➜ /workspaces/devops-devpod $
```

---

# Verify Installation

Run:

```bash
nvim --version

lazygit --version

kubectl version --client

helm version

flux --version

terraform version

pwsh --version
```

Expected:

* Neovim installed
* LazyGit installed
* kubectl installed
* Helm installed
* Flux installed
* Terraform installed
* PowerShell installed

---

# Git Configuration

Configure Git:

```bash
git config --global user.name "Gerso Robayo-Guillen"

git config --global user.email "06ninjatronics@gmail.com"

git config --global init.defaultBranch main
```

Verify:

```bash
git config --global --list
```

---

# GitHub Authentication

## Preferred Method: SSH

Generate key if needed:

```bash
ssh-keygen -t ed25519 -C "06ninjatronics@gmail.com"
```

Display public key:

```bash
cat ~/.ssh/id_ed25519.pub
```

Add the key to GitHub.

Verify:

```bash
ssh -T git@github.com
```

Expected:

```text
Hi GMakeziG! You've successfully authenticated...
```

Convert repository to SSH:

```bash
git remote set-url origin git@github.com:GMakeziG/devops-devpod.git
```

Verify:

```bash
git remote -v
```

Push:

```bash
git push
```

---

# Neovim Clipboard Support

Remote containers do not automatically have clipboard integration.

Clipboard support is provided using OSC52.

Verify:

```vim
:checkhealth vim.provider
```

If clipboard warnings appear, ensure the OSC52 configuration exists in:

```lua
vim.g.clipboard = {
  name = "OSC52",
  ...
}

vim.opt.clipboard = "unnamedplus"
```

Reload Neovim:

```vim
:source %
```

or restart Neovim.

---

# Architecture Detection

Verify architecture:

AMD64:

```bash
uname -m
```

Output:

```text
x86_64
```

ARM64:

```bash
uname -m
```

Output:

```text
aarch64
```

The Dockerfile automatically downloads:

* Correct Neovim release
* Correct LazyGit release

for the detected architecture.

---

# Rebuild Workspace

Delete workspace:

```bash
devpod delete devops-devpod
```

Recreate:

```bash
devpod up .
```

---

# Troubleshooting

## No Default Provider Found

Error:

```text
no default provider found
```

Fix:

```bash
devpod provider add docker

devpod provider use docker
```

---

## Docker Permission Denied

Fix:

```bash
sudo usermod -aG docker $USER

newgrp docker
```

Logout and log back in if required.

---

## GitHub Authentication Failed

Error:

```text
Invalid username or token
```

GitHub no longer supports password authentication.

Use SSH:

```bash
ssh -T git@github.com
```

and configure the repository remote to use SSH.

---

## DevPod Workspace Not Starting

Check:

```bash
docker ps

docker version

devpod version

devpod provider list
```

---

## Verify Workspace Health

Connect:

```bash
devpod ssh devops-devpod
```

If successful, the workspace is healthy.

---

# Lessons Learned

* Always use a dedicated `~/workspace` directory.
* Always configure a DevPod provider before running `devpod up`.
* SSH authentication is more reliable than HTTPS authentication for GitHub.
* ARM64 support works correctly on modern Linux systems.
* WSL2 works well with DevPod and VS Code Remote SSH.
* OpenVSCode Server is useful for headless systems.
* Disable idle shutdown for long-running remote sessions.
* Verify Neovim clipboard support early when working remotely.
* Test tool versions immediately after a fresh build.
* Keep repository remotes configured for SSH to avoid authentication prompts.

