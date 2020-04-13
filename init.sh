#!/usr/bin/env bash
##: Author: Kestutis Arlauskas
##: Description:
##: 2019-2020

if [ "$1" = '--help' ] || [ "$1" = '-h' ]; then
  echo
  echo '********************************'
  echo '* Dashboard Backend Initiation *'
  echo '********************************'
  echo
  echo 'Usage: ./init.sh [OPTION]'
  echo 'Initiate dashboard backend. It resolves your host ip and copies environment variables.'
  echo
  echo 'Optional parameters:'
  echo '-c, --clean     Recreates schema, builds docker containers, run composer, loads fixtures.'
  echo '                This option will remove all data from your database. It also good option when you build your project first time.'
  echo '-f, --full      Builds docker containers without cache, run composer, updates schema.'
  echo '                This option will rebuild containers without cache, it will take long enough. Build from cache use --regular option.'
  echo '-p, --prune     Removes all docker images and containers from system'
  echo '                All docker containers and images will be removed from your system. Be carefull if you using this option.'
  echo '-r, --regular   Builds docker containers, run composer, updates schema.'

  exit 0;
fi

rm -rf .env

export HOST_IP=$(ifconfig | grep inet | grep 192 | head -1 | awk '{print $2}')

echo 'HOST_IP='$HOST_IP >> .env
echo '' >> .env

echo 'Host ip' $HOST_IP 'added to .env file.'

cat .env.dist >> .env

echo '.env.dist content added to .env file.'


if [ "$1" = '--regular' ] || [ "$1" = '-r' ]; then
  docker-compose down || true
  docker-compose build
  docker-compose up -d
  docker exec -it food_sched_php composer install
  docker exec -it food_sched_php bin/console doctrine:schema:update --force
fi

if [ "$1" = '--full' ] || [ "$1" = '-f' ]; then
  read -p "This option will rebuild containers without cache, it will take long enough. Build from cache use --regular option. Do you want to proceed (y/N)?" choice
  if [ "$choice" = 'y' ] || [ "$choice" = 'Y' ]; then
    docker-compose down || true
    docker-compose build --no-cache
    docker-compose up -d
    docker exec -it food_sched_php composer install
    docker exec -it food_sched_php bin/console doctrine:schema:update --force
  fi
fi

if [ "$1" = '--clean' ] || [ "$1" = '-c' ]; then
  read -p "This option will remove all data from your database. Do you want to proceed (y/N)?" choice
  if [ "$choice" = 'y' ] || [ "$choice" = 'Y' ]; then
    docker-compose down || true
    docker-compose build
    docker-compose up -d
    docker exec -it food_sched_php composer install
    docker exec -it food_sched_php bin/console doctrine:schema:drop --force || true
    docker exec -it food_sched_php bin/console doctrine:schema:create
    docker exec -it food_sched_php bin/console doctrine:fixtures:load -n
  fi
fi

if [ "$1" = '--prune' ] || [ "$1" = '-p' ]; then
  read -p "All docker containers and images will be removed from your system. Do you know what you are doing (y/N)?" choice
  if [ "$choice" = 'y' ] || [ "$choice" = 'Y' ]; then
    docker-compose down || true
    docker container prune -f
    docker system prune --all -f
  fi
fi
