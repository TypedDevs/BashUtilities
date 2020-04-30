SHELL=/bin/bash

include .env
export $(shell sed 's/=.*//' .env)

# MySQL
MYSQL_DUMPS_DIR=data/db/dumps

help:
	@echo ""
	@echo "usage: make COMMAND"
	@echo ""
	@echo "Commands:"
	@echo "  init                    Gives permissions to scripts need it"
	@echo "  copy-env                Copy .env.example to .env"
	@echo "  update-env-example      Copy .env keys to .env.example"
	@echo "  composer-download       Install composer on docker"
	@echo "  composer-install        Install composer dependencies"
	@echo "  composer-up             Update PHP dependencies with composer"
	@echo "  composer-dump-autoload  Recreating autoload"
	@echo "  php-bash                🐘 Bash al contenedor php"
	@echo "  php-psysh               🐘 Shell interactiva de PHP"
	@echo "  mysql-bash              Bash al contenedor MySQL"
	@echo "  nginx-bash              Bash al contenedor NGIX"
	@echo "  redis-bash              Bash al contenedor Redis"
	@echo "  start                   🏎 💨 Starts all Docker containers from docker-compose.yml"
	@echo "  stop                    🛑 Stops all Docker containers from docker-compose.yml"
	@echo "  logs                    📜 Shows the logs of the docker containers"
	@echo "  clear-cache             🧽 Clears cache"
	@echo "  clear-views             🧽 Clears cache from the views"
	@echo "  clear-config            🧽 Clears cache from config files"
	@echo "  clear-all-cache         🧽 Clears all the caches"
	@echo "  generate-key            🔑 Generate key for Laravel app"
	@echo "  migrate                 Migraciones"
	@echo "  passport-key            🔑 Passport keys"
	@echo "  mysql-cli               MySQL CLI‍"
	@echo "  logs                    💾 Follow log output"
	@echo "  mysql-dump              🗃  Create backup of all databases"
	@echo "  mysql-restore           🗃  Restore backup of all databases"
	@echo "  test                    💯 Test PHP application"
	@echo "  horizon-install         Horizon install"

init:
	@chmod +x ./docker-artisan.sh
	@chmod +x ./docker.sh

update-env-example:
	@sed 's/=.*/=/' .env > .env.example

copy-env:
	@cp .env.example .env

composer-download:
	@echo "Installing dependencies ⬇️"
	@echo "--------------------------️"
	@./docker.sh exec php-fpm docker-php-ext-install curl
	@./docker.sh exec php-fpm docker-php-ext-install pcntl
	@./docker.sh exec php-fpm docker-php-ext-install exif
	@./docker.sh exec php-fpm apt-get update
	@./docker.sh exec php-fpm apt-get upgrade
	@echo "--------------------------️"
	@echo "Installing composer @ docker ⬇️"
	@echo "--------------------------️"
	@./docker.sh exec php-fpm curl -sS https://getcomposer.org/installer > composer-setup.php
	@./docker.sh exec php-fpm php composer-setup.php --install-dir=/usr/bin --filename=composer
	@./docker.sh exec php-fpm rm -rf composer-setup.php
	@make composer-faster
	@echo "--------------------------️"
	@echo " ⬇️ Installing prestissimo to make composer faster ⚡"
	@echo "--------------------------️"
	@./docker.sh exec php-fpm composer global require hirak/prestissimo
	@echo "--------------------------️"
	@echo "Installing composer dependencies ⬇️"
	@echo "--------------------------️"
	@./docker.sh exec php-fpm composer install
	@echo "--------------------------️"
	@echo "Cambiar propietario del directorio de las dependencias 🔐"
	@echo "--------------------------️"
	@chown $(USER):$(USER) -R vendor

composer-faster:
	@echo "--------------------------️"
	@echo " ⬇️ Installing prestissimo to make composer faster ⚡"
	@echo "--------------------------️"
	@./docker.sh exec php-fpm composer global require hirak/prestissimo

composer-install:
	@echo "--------------------------️"
	@echo "Installing composer dependencies ⬇️"
	@echo "--------------------------️"
	@./docker.sh exec php-fpm composer install
	@echo "--------------------------️"
	@echo "Cambiar propietario del directorio de las dependencias 🔐"
	@echo "--------------------------️"
	@chown $(USER):$(USER) -R vendor

composer-dump-autoload:
	@echo "--------------------------️"
	@echo "Recreating the autoload ♻️"
	@echo "--------------------------️"
	@./docker.sh exec php-fpm composer dump-autoload
	@echo "--------------------------️"
	@echo "Cambiar propietario del directorio de las dependencias 🔐"
	@echo "--------------------------️"
	@chown $(USER):$(USER) -R vendor

composer-up:
	@make nova-credentials
	@./docker.sh exec php-fpm composer update
	@echo "--------------------------️"
	@echo "Cambiar propietario del directorio de las dependencias 🔐"
	@echo "--------------------------️"
	@chown $(USER):$(USER) -R vendor

nova-credentials:
	@echo "--------------------------️"
	@echo " 🔐 NOVA credentials"
	@echo "--------------------------️"
	@echo "HORIZON_USER: $(HORIZON_USER)"
	@echo "NOVA_KEY: $(NOVA_KEY)"

php-bash:
	@./docker.sh exec php-fpm /bin/bash

php-psysh:
	@./docker.sh run --rm --entrypoint=vendor/bin/psysh php-fpm

mysql-bash:
	@./docker.sh exec mysql /bin/bash

nginx-bash:
	@./docker.sh exec nginx /bin/bash

redis-bash:
	@./docker.sh exec redis /bin/bash

start:
	@$(shell ./docker.sh up -d nginx mysql redis php-fpm)

stop:
	@$(shell ./docker.sh down -v)

logs:
	@./docker.sh logs -f

clear-cache:
	@./docker-artisan.sh cache:clear

clear-views:
	@./docker-artisan.sh view:clear

clear-config:
	@./docker-artisan.sh config:clear

clear-all-cache:
	@make clear-cache
	@make clear-views
	@make clear-config

generate-key:
	@./docker-artisan.sh key:generate

migrate:
	@./docker-artisan.sh migrate --seed

passport-key:
	@./docker-artisan.sh passport:keys

testing-db:
	@./docker-artisan.sh migrate --database=testing

mysql-cli:
	@./docker.sh exec mysql mysql -u$(DB_USERNAME) -p$(DB_USERNAME)

test:
	@./docker.sh run --rm --entrypoint=vendor/bin/phpunit php-fpm --colors=always

mysql-dump:
	@mkdir -p $(MYSQL_DUMPS_DIR)
	@./docker.sh exec mysql mysqldump --all-databases -u$(DB_USERNAME) -p$(DB_USERNAME) > $(MYSQL_DUMPS_DIR)/db.sql

mysql-restore:
	@./docker.sh exec mysql mysql -u$(DB_USERNAME) -p$(DB_PASSWORD) < $(MYSQL_DUMPS_DIR)/db.sql

horizon-install:
	@./docker-artisan.sh horizon:install

resert-owner:
	@sudo chown $(USER):$(USER) -R vendor
	@sudo chown $(USER):$(USER) -R build

.PHONY: test init
