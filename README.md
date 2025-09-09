<!DOCTYPE html>
<html lang="id">
<head>
  <meta charset="UTF-8">
  <title>Infinix Server Setup - Panduan Lengkap</title>
  <style>
    body { font-family: monospace; background: #111; color: #eee; padding: 20px; line-height: 1.6; }
    h1, h2, h3 { color: #6cf; }
    pre { background: #222; padding: 10px; border-radius: 5px; overflow-x: auto; }
    code { color: #0f0; }
    .step { margin-bottom: 40px; }
  </style>
</head>
<body>

<h1>📱 Infinix Server Setup</h1>
<p>Panduan lengkap mengubah HP Infinix (Android) menjadi server mini menggunakan <b>Termux</b>, <b>OpenSSH</b>, <b>Ngrok/Cloudflare Tunnel</b>, dan pembatasan resource agar stabil.</p>

<hr>

<div class="step">
  <h2>1. Setup Awal di Termux</h2>
  <pre><code>
# Update & Upgrade Termux
pkg update -y && pkg upgrade -y

# Install paket dasar
pkg install -y git curl wget nano htop

# Install Python & Pip
pkg install -y python
pip install --upgrade pip

# Install OpenSSH untuk akses remote
pkg install -y openssh

# Install NodeJS (opsional, untuk backend JS)
pkg install -y nodejs
  </code></pre>
</div>

<div class="step">
  <h2>2. Konfigurasi OpenSSH (Akses Online)</h2>
  <pre><code>
# Set password untuk user Termux
passwd

# Jalankan SSH server
sshd

# Default port SSH Termux: 8022
# Cek IP lokal
ifconfig
  </code></pre>
  <p>Akses dari laptop/PC (dalam jaringan WiFi sama):</p>
  <pre><code>
ssh -p 8022 u0_a123@192.168.xxx.xxx
  </code></pre>
</div>

<div class="step">
  <h2>3. Membatasi Resource (Agar Stabil)</h2>
  <pre><code>
# Install cgroups-utils (via proot-distro Ubuntu/Alpine)
pkg install -y proot-distro
proot-distro install ubuntu
proot-distro login ubuntu

# Dalam Ubuntu: install cgroups
apt update && apt install -y cgroup-tools

# Batasi memory (misal 90% dari total)
cgcreate -g memory:/hpserver
echo 1024M > /sys/fs/cgroup/memory/hpserver/memory.limit_in_bytes
  </code></pre>
</div>

<div class="step">
  <h2>4. Akses Online Gratis (tanpa VPN)</h2>

  <h3>🔹 Metode 1: Ngrok</h3>
  <pre><code>
# Install ngrok
pkg install -y wget unzip
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm.zip
unzip ngrok-stable-linux-arm.zip
mv ngrok $PREFIX/bin/

# Authtoken (daftar di ngrok.com)
ngrok config add-authtoken &lt;YOUR_TOKEN&gt;

# Jalankan tunnel SSH
ngrok tcp 8022
  </code></pre>

  <h3>🔹 Metode 2: Cloudflare Tunnel</h3>
  <pre><code>
# Install Cloudflare Tunnel
pkg install -y cloudflared

# Login (buka URL di browser dan hubungkan akun Cloudflare)
cloudflared tunnel login

# Buat tunnel untuk SSH
cloudflared tunnel create hpserver
cloudflared tunnel route dns hpserver serverhp.example.com

# Jalankan tunnel
cloudflared tunnel run hpserver
  </code></pre>
</div>

<div class="step">
  <h2>5. Jalankan Web Server (Opsional)</h2>
  <pre><code>
# Install simple HTTP server (Python)
cd ~/storage/shared
python -m http.server 8080

# Akses via Ngrok/Cloudflare
ngrok http 8080
  </code></pre>
</div>

<div class="step">
  <h2>6. Menjaga Server Tetap Jalan</h2>
  <pre><code>
# Install tmux / screen
pkg install -y tmux

# Buka session baru
tmux new -s hpserver

# Jalankan service (misalnya sshd, python, cloudflared)
sshd
python -m http.server 8080
cloudflared tunnel run hpserver

# Detach (biar tetap jalan di background)
Ctrl + B, lalu tekan D
  </code></pre>
</div>

<hr>

<h2>📌 Kesimpulan</h2>
<ul>
  <li>Termux = basis server</li>
  <li>OpenSSH = remote akses</li>
  <li>Ngrok / Cloudflare Tunnel = online gratis</li>
  <li>cgroups = pembatasan resource</li>
  <li>tmux = menjaga service tetap hidup</li>
</ul>

<p><b>Dengan ini, HP Infinix bisa dipakai sebagai server mini untuk belajar, eksperimen, atau portofolio project.</b></p>

</body>
</html>
