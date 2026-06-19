# Lessons Learned

This document captures issues encountered while building the Ninjatronics DevOps IDE so future rebuilds are easier.

---

# Environment

Host:

- Windows 11 ARM64
- WSL2 Ubuntu 24.04
- Docker Desktop
- DevPod
- VS Code

Architecture:

```bash
uname -m
```

Output:

```text
aarch64
```

This is important because many tools require ARM64-specific binaries.

---

# Issue: DevPod "Exec format error"

Error:

```text
cannot execute binary file: Exec format error
```

Cause:

Downloaded x86_64 DevPod binary on an ARM64 machine.

Verify architecture:

```bash
uname -m
```

Expected:

```text
aarch64
```

Fix:

Install ARM64 DevPod release.

Verify:

```bash
devpod version
```

---

# Issue: Neovim Would Not Run Correctly On ARM

Cause:

Dockerfile originally downloaded x86_64 Neovim binaries.

Fix:

ARM64:

```bash
nvim-linux-arm64.tar.gz
```

x86_64:

```bash
nvim-linux-x86_64.appimage
```

Final Dockerfile automatically detects architecture.

---

# Issue: LazyGit Failed On ARM

Cause:

Dockerfile used:

```text
Linux_x86_64.tar.gz
```

on ARM hardware.

Fix:

Detect architecture:

```bash
uname -m
```

Use:

```text
Linux_arm64.tar.gz
```

for ARM systems.

---

# Issue: DevPod Workspace Created Successfully But VS Code Failed

Symptoms:

```text
Could not resolve hostname
```

VS Code could not connect.

However:

```bash
devpod ssh devops-devpod
```

worked.

Root Cause:

DevPod SSH configuration existed inside WSL.

VS Code Remote SSH was trying to use Windows SSH configuration.

---

# Issue: Windows SSH Could Not Use DevPod Host

Error:

```text
Could not resolve hostname
```

Fix:

Copy DevPod SSH configuration from WSL into Windows.

WSL location:

```bash
~/.ssh/config
```

Windows location:

```text
C:\Users\<username>\.ssh\config
```

Copied block:

```ssh
Host devops-devpod.devpod
    ForwardAgent yes
    LogLevel error
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
    HostKeyAlgorithms rsa-sha2-256,rsa-sha2-512,ssh-rsa
    ProxyCommand wsl.exe -d Ubuntu-24.04 -e /usr/local/bin/devpod ssh --stdio --context default --user vscode devops-devpod
    User vscode
```

---

# Issue: PowerShell SSH Failed

Error:

```text
banner exchange: Connection to UNKNOWN port 65535
```

Cause:

Windows SSH was not launching DevPod through WSL.

Fix:

Use:

```ssh
ProxyCommand wsl.exe -d Ubuntu-24.04 -e /usr/local/bin/devpod ssh --stdio --context default --user vscode devops-devpod
```

instead of:

```ssh
ProxyCommand /usr/local/bin/devpod ...
```

---

# Verification

Test from PowerShell:

```powershell
ssh devops-devpod.devpod
```

Expected:

```text
vscode ➜ /workspaces/devops-devpod $
```

If this works, VS Code should also work.

---

# Issue: Nerd Font Icons Missing

Symptoms:

Prompt displayed:

```text
�
```

instead of icons.

Cause:

Windows Terminal was not using a Nerd Font.

Fix:

Install:

```powershell
winget install DEVCOM.JetBrainsMonoNerdFont
```

Then configure Windows Terminal:

Settings
→ Ubuntu Profile
→ Appearance
→ Font Face

Select:

```text
JetBrainsMono Nerd Font
```

Restart terminal.

---

# Issue: LazyVim Configuration Structure

Important:

Do NOT create a custom `init.lua` before installing LazyVim Starter.

Correct process:

```bash
git clone https://github.com/LazyVim/starter ~/.config/nvim
```

Then remove:

```bash
rm -rf ~/.config/nvim/.git
```

LazyVim already provides:

```text
init.lua
lua/
plugins/
```

Creating a separate blank `init.lua` beforehand causes confusion.

---

# Issue: DevPod Built Successfully But Needed Verification

After every build run:

```bash
devpod ssh devops-devpod
```

Verify:

```bash
nvim --version
kubectl version --client
helm version
flux --version
terraform version
pwsh --version
lazygit --version
```

---

# Git Configuration

Standard Git identity:

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

# GitHub Repository Creation

Install GitHub CLI:

```bash
sudo apt update
sudo apt install gh -y
```

Login:

```bash
gh auth login
```

Create repository:

```bash
gh repo create devops-devpod \
  --public \
  --source=. \
  --remote=origin \
  --push
```

Repository:

```text
https://github.com/GMakeziG/devops-devpod
```

---

# Workspace Location

Recommended:

```bash
~/workspace/devops-devpod
```

instead of:

```bash
~/devops-devpod
```

Keeps repositories organized and easier to back up.

---

# Future Improvements

- GitHub Actions
- OpenTofu support
- AWS CLI
- Azure CLI improvements
- Fortinet tooling
- Kubernetes examples
- Terraform examples
- Ansible examples
- PowerShell modules
- CMMC automation templates

---

# Rebuild Procedure

Delete workspace:

```bash
devpod delete devops-devpod
```

Rebuild:

```bash
devpod up .
```

Connect:

```bash
devpod ssh devops-devpod
```

Verify tooling.

---

# Success Criteria

Environment is considered healthy when:

- DevPod builds successfully
- VS Code connects successfully
- PowerShell SSH works
- Nerd Font icons render correctly
- LazyVim launches
- :LazyHealth shows no critical errors
- GitHub repository syncs successfully
- All DevOps tooling reports valid versions
