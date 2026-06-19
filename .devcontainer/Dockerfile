FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

USER root

RUN apt-get update && apt-get install -y \
    curl wget git unzip zip tar gzip xz-utils \
    build-essential cmake pkg-config \
    ripgrep fd-find fzf jq yq tree \
    shellcheck shfmt \
    python3-pip pipx \
    lua5.4 luarocks \
    tmux zsh bash-completion \
    ca-certificates gnupg lsb-release \
    net-tools dnsutils iputils-ping traceroute nmap tcpdump \
    openssh-client rsync \
    bat eza zoxide \
    && ln -sf /usr/bin/fdfind /usr/local/bin/fd \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN if [ "$(uname -m)" = "aarch64" ]; then \
      curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-arm64.tar.gz && \
      tar xzf nvim-linux-arm64.tar.gz && \
      mv nvim-linux-arm64 /opt/nvim && \
      ln -s /opt/nvim/bin/nvim /usr/local/bin/nvim && \
      rm nvim-linux-arm64.tar.gz; \
    else \
      curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage && \
      chmod +x nvim-linux-x86_64.appimage && \
      ./nvim-linux-x86_64.appimage --appimage-extract && \
      mv squashfs-root /opt/nvim && \
      ln -s /opt/nvim/AppRun /usr/local/bin/nvim && \
      rm nvim-linux-x86_64.appimage; \
    fi

RUN curl -s https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
RUN curl -fsSL https://raw.githubusercontent.com/fluxcd/flux2/main/install/flux.sh | bash

RUN LAZYGIT_VERSION=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | jq -r .tag_name | sed 's/v//') \
    && ARCH="$(uname -m)" \
    && if [ "$ARCH" = "aarch64" ]; then LAZYGIT_ARCH="arm64"; else LAZYGIT_ARCH="x86_64"; fi \
    && curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_${LAZYGIT_ARCH}.tar.gz" \
    && tar xf lazygit.tar.gz lazygit \
    && install lazygit /usr/local/bin \
    && rm lazygit lazygit.tar.gz

USER vscode
