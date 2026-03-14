# .idx/dev.nix - 蝦家班特製實驗蝦盒 (Shrimp Box Edition)
{ pkgs, ... }: {
channel = "stable-23.11";
packages = [
pkgs.nodejs_20
pkgs.bun
pkgs.python311
pkgs.python311Packages.pip
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
onCreate = {
npm-install = "npm install";
pip-install = "pip install -r requirements.txt || echo 'No python requirements yet'";
};
onStart = {
connect-tailscale = "if [ -n \"\$TS_AUTHKEY\" ]; then sudo tailscaled --tun=userspace-networking --socks5-server=localhost:1055 & sleep 5 && sudo tailscale up --authkey=\$TS_AUTHKEY --hostname=shrimp-box-firebase; fi";
start-openclaw = "npm run start";
};
};
};
}
