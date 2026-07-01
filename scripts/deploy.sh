#!/usr/bin/env bash
set -euo pipefail

APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$APP_DIR"

for item in favicon.ico mix-manifest.json robots.txt themes temp dash error; do
  if [ -e "$item" ] && [ ! -e "public/$item" ]; then
    ln -sfn "../$item" "public/$item"
  fi
done

if [ -f .htaccess ]; then
  mv -f .htaccess .htaccess.root-deploy-bak
fi

composer install --no-dev --optimize-autoloader --no-interaction --ignore-platform-reqs

if ! php artisan migrate --force; then
  echo "migrate: skipped or partially applied (existing database)"
fi

php artisan config:clear
php artisan cache:clear
