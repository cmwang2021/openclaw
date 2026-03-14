# .idx/dev.nix - 蝦家班特製實驗蝦盒 v1.1 (Fix PEP 668)
{ pkgs, ... }: {
  channel = "stable-23.11";

  packages = [
    pkgs.nodejs_20
    pkgs.bun
    pkgs.python311
    # 增加這兩個關鍵套件
    pkgs.python311Packages.pip
    pkgs.python311Packages.virtualenv
    pkgs.tailscale
    pkgs.git
    pkgs.jq
  ];

  env = {
    PORT = "3000";
  };

  idx = {
    extensions = [
      "esbenp.prettier-vscode"
      "dbaeumer.vscode-eslint"
      "ms-python.python"
    ];

    workspace = {
      # 🛠️ 誕生時刻：建立虛擬環境 -> 啟用 -> 安裝
      onCreate = {
        npm-install = "npm install";
        setup-python = "python3 -m venv .venv && source .venv/bin/activate && pip install --upgrade pip && (pip install -r requirements.txt || echo 'No requirements.txt found, skipping pip install')";
      };
      
      # ▶️ 啟動時刻：同時拉起 Tailscale 與 OpenClaw
      onStart = {
        connect-tailscale = "if [ -n \"$TS_AUTHKEY\" ]; then sudo tailscaled --tun=userspace-networking --socks5-server=localhost:1055 & sleep 5 && sudo tailscale up --authkey=$TS_AUTHKEY --hostname=shrimp-box-firebase --accept-routes; fi";
        start-openclaw = "npm run start"; 
      };
    };
  };
}
