#!/bin/bash
echo "Login ke Cloudflare..."
cloudflared tunnel login

echo "Buat tunnel baru..."
cloudflared tunnel create infinix-server

echo "Copy config.yml.example ke ~/.cloudflared/config.yml dan edit sesuai kebutuhan!"
