#!/bin/ash
rm -rf /home/container/tmp/*

echo "⟳ Starting PHP-FPM..."
/usr/sbin/php-fpm83 --fpm-config /home/container/php-fpm/php-fpm.conf --daemonize

echo "⟳ Starting Nginx..."
echo "✓ Successfully started"
/usr/sbin/nginx -c /home/container/nginx/nginx.conf -p /home/container/

# Generate and install SSL certificates
echo "⚙️ Generating and installing SSL certificates..."

CERTBOTOPTIONS="--standalone --agree-tos --register-unsafely-without-email --work-dir /home/container/letsencrypt --logs-dir /home/container/logs --config-dir /home/container/letsencrypt"
for file in /home/container/nginx/conf.d/*; do
    if [[ -f "$file" ]]; then
        domain=$(grep -oe '(?<=server_name\s).*?(?=\s)' "$file")
        certbot certonly $CERTBOTOPTIONS -d "$domain"
    fi
done

echo "✅ SSL certificates generated and installed successfully!"
