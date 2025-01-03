# Basic Commands

`docker run -d -p 8080:80 docker/getting-started`
`docker ps`
`docker exec <docker-id> <command>`
    e.g: `docker exec 098c2ae23e5a ls`


execute a shell:
`docker exec -it 098c2ae23e5a /bin/sh`

# Stopping a container

`docker stop <container-id>`
`docker kill <container-id>`

# Images vs Containers
- **docker image** is the read only *definition* of a container
- **docker container** is a virtualized read-write environment

*a container is essentially just ann image that's actively running.*

*containers are stateful*

# Create volume for persistency
to gain persistency, use *storage volumes*

create new volume:
`docker volume create <volume-name>`
list volumes:
`docker volume ls`
`docker volume inspect <volume-name>`

# Connect container to volume
`docker run -d -e NODE_ENV=development -e url=http://localhost:3001 -p 3001:2368 -v ghost-vol:/var/lib/ghost/content ghost`
    `-e NODE_ENV=development` run ghost in development environment
    `-e url=http://localhost:3001` another env var, make ghost accessible via specified url
    `-p 3001:2368` port forwarding, as used before
    `-v ghost-vol:/var/lib/ghost/content` mounts ghost-vol to var/lib/ghost/content. ghost will use this dir to persist stateful data.
        - the `-v` flag creates the `ghost-vol` volume if it doesn't exist

# Deleting volumes
`docker ps -a` see *all* containers (even those not running)
`docker rm <container-id>` remove container
`docker volume rm <volume-name>` removes volume

# Networking
`docker run -d --network none <container>` removes network interface
`docker exec <container-id> ping google.com -W 2` test whether interface was actually removed

# Loadbalancing with caddy
`docker pull caddy`
`docker run -p 8001:80 -v $PWD/index1.html:/usr/share/caddy/index.html caddy` run a container for `index1.html` on port `8001`
`docker run -p 8002:80 -v $PWD/index2.html:/usr/share/caddy/index.html caddy` run a container for `index2.html` on port `8002`
run them detached with `-d`

# Custom network, bridges and shit
`docker network create <network-name>` creates custom bridge-network
`docker network ls` lists networks
`docker run --network <network-name> --name <nw-attached-container-name> -p 8002:80 -v $PWD/index2.html:/usr/share/caddy/index.html caddy` attach container like this
## now you can curl them from a third container:
`docker run -it --network <network-name> docker/getting-started /bin/sh`
## inspect your network:
`docker network inspect caddytest`

## Create Loadbalancer config
see `Caddyfile`
provide `Caddyfile` instead of `index.html`:
`docker run --network <network-name> -p 8080:80 -v $PWD/Caddyfile:/etc/caddy/Caddyfile caddy`

# Building Images
`docker build . -t helloworld:latest`
