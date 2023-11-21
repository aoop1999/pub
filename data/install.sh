#!/bin/bash

# Cloudflare IP ranges (IPv4 and IPv6)
CF_IPV4_RANGES=$(curl -s https://www.cloudflare.com/ips-v4)
CF_IPV6_RANGES=$(curl -s https://www.cloudflare.com/ips-v6)

# Add IPv4 ranges to UFW
for ip in $CF_IPV4_RANGES; do
    sudo ufw allow from $ip to any port 80,443 proto tcp
done

# Add IPv6 ranges to UFW
for ip in $CF_IPV6_RANGES; do
    sudo ufw allow from $ip to any port 80,443 proto tcp
done

# Enable UFW
sudo ufw enable

# Display UFW status
sudo ufw status
