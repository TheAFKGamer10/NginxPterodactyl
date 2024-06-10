#!/bin/ash
rm -rf /home/container/tmp/*

echo "⟳ Starting PHP-FPM..."
/home/container/sbin/php-fpm83 --fpm-config /home/container/php-fpm/php-fpm.conf --daemonize

echo "⟳ Starting Nginx..."
echo "✓ Successfully started"
certbot --nginx --non-interactive --agree-tos --register-unsafely-without-email --redirect --nginx-ctl /home/container/sbin/nginx --work-dir /home/container/letsencrypt --logs-dir /home/container/logs --config-dir /home/container/letsencrypt
/home/container/sbin/nginx -c /home/container/nginx/nginx.conf -p /home/container/
