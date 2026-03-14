# .idx/dev.nix - 蝦家班實驗蝦盒 (Shrimp Workshop Ported Edition)
{ pkgs, ... }: {
  channel = "stable-23.11"; # 使用穩定的 NixOS 頻道

  # 🛠️ 蝦工坊核心裝備清單
  packages = [
    pkgs.python311
    pkgs.python311Packages.pip
    # 關鍵修正：加上這行才能在專案內建立虛擬環境，避開系統保護
    pkgs.python311Packages.virtualenv 
    pkgs.sudo
    pkgs.more
    pkgs.xclip
    pkgs.tmux      # 必備：讓我們即使斷線程式也不會死掉
    pkgs.htop      # 必備：監控系統資源
    pkgs.tailscale # 必備：內網穿透
    pkgs.nodejs_20 # OpenClaw 建議使用 LTS 版本 (v20)，比 v24 更穩定
    pkgs.bun       # OpenClaw 官方建議的執行器
    pkgs.git
  ];

  env = {
    PORT = "3000";
    # 讓 Terminal 自動知道虛擬環境在哪
    # VIRTUAL_ENV = "/home/user/myapp/.venv"; 
  };

  idx = {
    extensions = [
      "esbenp.prettier-vscode"
      "dbaeumer.vscode-eslint"
      "ms-python.python"
    ];

    workspace = {
      # 🌱 誕生時刻 (首次建立)
      onCreate = {
        # 1. 建立 Python 虛擬環境並安裝相依套件 (解決 PEP 668 問題)
        setup-python = "python3 -m venv .venv && source .venv/bin/activate && pip install --upgrade pip && (pip install -r requirements.txt || echo 'No requirements.txt found, skipping pip install')";
        # 2. 安裝 Node.js 套件
        npm-install = "npm install";
      };
      
      # ▶️ 啟動時刻 (每次開啟)
      onStart = {
        # 1. 自動拉起 Tailscale (如果有 Authkey)
        connect-tailscale = "if [ -n \"$TS_AUTHKEY\" ]; then sudo tailscaled --tun=userspace-networking --socks5-server=localhost:1055 & sleep 5 && sudo tailscale up --authkey=$TS_AUTHKEY --hostname=shrimp-box-firebase --accept-routes; fi";
        
        # 2. 啟動 OpenClaw
        start-openclaw = "npm run start"; 
      };
    };
  };
}
