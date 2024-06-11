#!/bin/ash
rm -rf /home/container/tmp/*

echo "⟳ Starting PHP-FPM..."
/usr/sbin/php-fpm83 --fpm-config /home/container/php-fpm/php-fpm.conf --daemonize

# Generate and install SSL certificates
echo "⚙️ Generating and installing SSL certificates..."
curl -O -f -L https://github.com/joohoi/acme-dns-certbot-joohoi/raw/master/acme-dns-auth.py > /home/container/acme-dns-auth.py
chmod +x /home/container/acme-dns-auth.py
sed -i '1s/$/3/' /home/container/acme-dns-auth.py
sed -i 's/^STORAGE_PATH =.*/STORAGE_PATH = "\/home\/container\/letsencrypt\/challenge.json"/' /home/container/acme-dns-auth.py

# CERTBOTOPTIONS="--standalone --non-interactive --agree-tos --register-unsafely-without-email --work-dir /home/container/letsencrypt --logs-dir /home/container/logs --config-dir /home/container/letsencrypt"
CERTBOTOPTIONS="--manual --manual-auth-hook /home/container/acme-dns-auth.py --preferred-challenges dns --debug-challenges --agree-tos --register-unsafely-without-email --work-dir /home/container/letsencrypt --logs-dir /home/container/logs --config-dir /home/container/letsencrypt"
for file in /home/container/nginx/conf.d/*; do
    if [[ -f "$file" ]]; then
        domain=$(grep -oe 'server_name\s\+\S\+' "$file" | awk '{print $2}' | sed 's/"//g' | tr -cd '[:alnum:].-')
        if [[ ! -z "$domain" ]]; then
            echo "Requesting certificate for domain: ${domain}"
            certbot certonly $CERTBOTOPTIONS --domains "$domain"
        else
            echo "No domain found in $file"
        fi
    fi
done

echo "✅ SSL certificates generated and installed successfully!"

echo "⟳ Starting Nginx..."
echo "✓ Successfully started"
/usr/sbin/nginx -c /home/container/nginx/nginx.conf -p /home/container/