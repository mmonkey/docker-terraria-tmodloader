# terraria-tmodloader

Docker image to run a [Terraria](https://www.terraria.org/) server with [tModLoader](https://www.tmodloader.net/). Heavily inspired by [beardedio/terraria](https://github.com/beardedio/terraria) docker image.

## Usage

```
docker run --rm -it \
  -v $HOME/terraria/config:/config \
  -v $HOME/terraria/ModLoader:/ModLoader \
  -e TERRARIA_VERSION=1432 \
  -e TMOD_VERSION=0.11.8.5 \
  -e WORLD=<world_file_name> \
  -p 7777:7777 \
  --name=terraria \
  mmonkey/terraria-tmodloader
```

Docker image is availabe on [Docker Hub](https://hub.docker.com/r/mmonkey/terraria-tmodloader).

## How to Use

### Generate a New World

This will start a temporaray docker container in interactive mode until you quit `[ctrl] + [c]`, at which point it will delete the container. Follow the promps in the command line to create a new terraria world.

```
docker run --rm -it \
  -v $HOME/terraria/config:/config \
  -v $HOME/terraria/ModLoader:/ModLoader \
  -e TERRARIA_VERSION=1432 \
  -e TMOD_VERSION=0.11.8.5 \
  -p 7777:7777 \
  --name=terraria \
  mmonkey/terraria-tmodloader
```

### Starting with a Preexisting World

Passing a name to the `WORLD` environment variable, will pre-select this world when the docker image is started. Worlds are saved in the `ModLoader/Worlds` directory.

```
docker run --rm -dit \
  -v $HOME/terraria/config:/config \
  -v $HOME/terraria/ModLoader:/ModLoader \
  -e TERRARIA_VERSION=1432 \
  -e TMOD_VERSION=0.11.8.5 \
  -e WORLD=<world_file_name> \
  -p 7777:7777 \
  --name=terraria \
  mmonkey/terraria-tmodloader
```

### Docker Compose

Here is an example docker-compose file. Be certain to inclue the `tty` and `stdin_open` properties in order to manage the server while the docker-container is running.

```
version: '3'

services:
  terraria:
    image: mmonkey/terraria-tmodloader
    ports:
      - '7777:7777'
    restart: unless-stopped
    environment:
      - TERRARIA_VERSION=1432
      - TMOD_VERSION=0.11.8.5
      - WORLD=<world_file_name>
    volumes:
      - $HOME/terraria/config:/config
      - $HOME/terraria/ModLoader:/ModLoader
    tty: true
    stdin_open: true
```

### Running Commands

1. Attach to the running docker container:
	```
	$ docker attach terraria
	```

2. Run your command, for example:
	```
	$ playing
	```

3. Detach from the running docker container by pressing `[ctrl] + [p]` then `[ctrl] + [q]`.

### Adding Mods

1. Add `.tmod` mods in the `ModLoader/Mods` folder.

2. If it doesn't already exist, create a new file called `enabled.json` in the `ModLoader/Mods` folder.

3. Add the name of the mod to the `enabled.json` list, it should look something like this:
	```json
	[
	  "AccessorySlotsPlus",
	  "CalamityMod",
	  "HEROsMod",
	  "Loadouts",
	  "MagicStorage",
	  "SmartDoors",
	  "ThoriumMod"
	]
	```

