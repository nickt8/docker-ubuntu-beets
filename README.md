# [docker-ubuntu-beets](https://github.com/nickt8/docker-ubuntu-beets)

[![GitHub Stars](https://img.shields.io/github/stars/nickt8/docker-ubuntu-beets.svg?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&logo=github)](https://github.com/nickt8/docker-ubuntu-beets)
[![GitHub Release](https://img.shields.io/github/release/nickt8/docker-ubuntu-beets.svg?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&logo=github)](https://github.com/nickt8/docker-ubuntu-beets/releases)

A community fork of [linuxserver/docker-beets](https://github.com/linuxserver/docker-beets) using **Ubuntu Noble** as the base image instead of Alpine Linux.

[Beets](http://beets.io/) is a music library manager and not, for the most part, a music player. It does include a simple player plugin and an experimental Web-based player, but it generally leaves actual sound-reproduction to specialized tools.

[![beets](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/beets-icon.png)](http://beets.io/)

## Supported Architectures

This image uses the docker manifest for multi-platform awareness. More information is available from docker [here](https://distribution.github.io/distribution/spec/manifest-v2-2/#manifest-list).

Simply pulling `ghcr.io/nickt8/docker-ubuntu-beets:latest` should retrieve the correct image for your arch, but you can also pull specific arch images via tags.

The architectures supported by this image are:

| Architecture | Available | Tag                     |
| :----------: | :-------: | ----------------------- |
|    x86-64    |    ✅     | amd64-\<version tag\>   |
|    arm64     |    ✅     | arm64v8-\<version tag\> |

## Version Tags

This image provides various versions that are available via tags. Please read the descriptions carefully and exercise caution when using unstable or development tags.

|                   Tag                   | Available | Description                                                |
| :-------------------------------------: | :-------: | ---------------------------------------------------------- |
|                `latest`                 |    ✅     | Stable release built from the latest Beets release on PyPI |
|           `beets_version-rN`            |    ✅     | Pinned release tag, for example `2.9.0-r1`                 |
|         `dev-beets_version-rN`          |    ✅     | Development build published from the `develop` branch      |
| `amd64-<version>` / `arm64v8-<version>` |    ✅     | Architecture-specific tags                                 |

## Application Setup

Edit the config file in /config

To edit the config from within the container use `beet config -e`

For a command prompt as user abc `docker exec -it -u abc beets bash`

See [Beets](http://beets.io/) for more info.

Contains [beets-extrafiles](https://github.com/Holzhaus/beets-extrafiles) plugin, [configuration details](https://github.com/Holzhaus/beets-extrafiles#usage)

## Read-Only Operation

This image can be run with a read-only container filesystem. For details please [read the docs](https://docs.linuxserver.io/misc/read-only/).

## Non-Root Operation

This image can be run with a non-root user. For details please [read the docs](https://docs.linuxserver.io/misc/non-root/).

## Usage

To help you get started creating a container from this image you can either use docker-compose or the docker cli.

> [!NOTE]
> Unless a parameter is flagged as 'optional', it is _mandatory_ and a value must be provided.

### docker-compose (recommended, [click here for more info](https://docs.linuxserver.io/general/docker-compose))

```yaml
---
services:
  beets:
    image: ghcr.io/nickt8/docker-ubuntu-beets:latest
    container_name: beets
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
    volumes:
      - /path/to/beets/config:/config
      - /path/to/music/library:/music
      - /path/to/ingest:/downloads
    ports:
      - 8337:8337
    restart: unless-stopped
```

### docker cli ([click here for more info](https://docs.docker.com/engine/reference/commandline/cli/))

```bash
docker run -d \
  --name=beets \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -p 8337:8337 \
  -v /path/to/beets/config:/config \
  -v /path/to/music/library:/music \
  -v /path/to/ingest:/downloads \
  --restart unless-stopped \
  ghcr.io/nickt8/docker-ubuntu-beets:latest
```

## Parameters

Containers are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate `<external>:<internal>` respectively. For example, `-p 8080:80` would expose port `80` from inside the container to be accessible from the host's IP on port `8080` outside the container.

|     Parameter      | Function                                                                                                        |
| :----------------: | --------------------------------------------------------------------------------------------------------------- |
|   `-p 8337:8337`   | Application WebUI                                                                                               |
|   `-e PUID=1000`   | for UserID - see below for explanation                                                                          |
|   `-e PGID=1000`   | for GroupID - see below for explanation                                                                         |
|  `-e TZ=Etc/UTC`   | specify a timezone to use, see this [list](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List).  |
|    `-v /config`    | Persistent config files                                                                                         |
|    `-v /music`     | Music library                                                                                                   |
|  `-v /downloads`   | Non processed music                                                                                             |
| `--read-only=true` | Run container with a read-only filesystem. Please [read the docs](https://docs.linuxserver.io/misc/read-only/). |
| `--user=1000:1000` | Run container with a non-root user. Please [read the docs](https://docs.linuxserver.io/misc/non-root/).         |

## Environment variables from files (Docker secrets)

You can set any environment variable from a file by using a special prepend `FILE__`.

As an example:

```bash
-e FILE__MYVAR=/run/secrets/mysecretvariable
```

Will set the environment variable `MYVAR` based on the contents of the `/run/secrets/mysecretvariable` file.

## Umask for running applications

For all of our images we provide the ability to override the default umask settings for services started within the containers using the optional `-e UMASK=022` setting.
Keep in mind umask is not chmod it subtracts from permissions based on it's value it does not add. Please read up [here](https://en.wikipedia.org/wiki/Umask) before asking for support.

## User / Group Identifiers

When using volumes (`-v` flags), permissions issues can arise between the host OS and the container, we avoid this issue by allowing you to specify the user `PUID` and group `PGID`.

Ensure any volume directories on the host are owned by the same user you specify and any permissions issues will vanish like magic.

In this instance `PUID=1000` and `PGID=1000`, to find yours use `id your_user` as below:

```bash
id your_user
```

Example output:

```text
uid=1000(your_user) gid=1000(your_user) groups=1000(your_user)
```

## Docker Mods

[![Docker Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=beets&query=%24.mods%5B%27beets%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=beets "view available mods for this container.") [![Docker Universal Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=universal&query=%24.mods%5B%27universal%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=universal "view available universal mods.")

We publish various [Docker Mods](https://github.com/linuxserver/docker-mods) to enable additional functionality within the containers. The list of Mods available for this image (if any) as well as universal mods that can be applied to any one of our images can be accessed via the dynamic badges above.

## Support Info

- Shell access whilst the container is running:

  ```bash
  docker exec -it beets /bin/bash
  ```

- To monitor the logs of the container in realtime:

  ```bash
  docker logs -f beets
  ```

- Container version number:

  ```bash
  docker inspect -f '{{ index .Config.Labels "org.opencontainers.image.version" }}' beets
  ```

- Image version number:

  ```bash
  docker inspect -f '{{ index .Config.Labels "org.opencontainers.image.version" }}' ghcr.io/nickt8/docker-ubuntu-beets:latest
  ```

## Updating Info

Most of our images are static, versioned, and require an image update and container recreation to update the app inside. With some exceptions (noted in the relevant readme.md), we do not recommend or support updating apps inside the container. Please consult the [Application Setup](#application-setup) section above to see if it is recommended for the image.

Below are the instructions for updating containers:

### Via Docker Compose

- Update images:
  - All images:

    ```bash
    docker-compose pull
    ```

  - Single image:

    ```bash
    docker-compose pull beets
    ```

- Update containers:
  - All containers:

    ```bash
    docker-compose up -d
    ```

  - Single container:

    ```bash
    docker-compose up -d beets
    ```

- You can also remove the old dangling images:

  ```bash
  docker image prune
  ```

### Via Docker Run

- Update the image:

  ```bash
  docker pull ghcr.io/nickt8/docker-ubuntu-beets:latest
  ```

- Stop the running container:

  ```bash
  docker stop beets
  ```

- Delete the container:

  ```bash
  docker rm beets
  ```

- Recreate a new container with the same docker run parameters as instructed above (if mapped correctly to a host folder, your `/config` folder and settings will be preserved)
- You can also remove the old dangling images:

  ```bash
  docker image prune
  ```

### Image Update Notifications - Diun (Docker Image Update Notifier)

> [!TIP]
> We recommend [Diun](https://crazymax.dev/diun/) for update notifications. Other tools that automatically update containers unattended are not recommended or supported.

## Building locally

If you want to make local modifications to these images for development purposes or just to customize the logic:

```bash
git clone https://github.com/nickt8/docker-ubuntu-beets.git
cd docker-ubuntu-beets
docker build \
  --no-cache \
  --pull \
  -t ghcr.io/nickt8/docker-ubuntu-beets:latest .
```

Multi-arch builds are published automatically through the GitHub Actions workflow in this repository.

## Versions
- **18.04.26:** - Publish images to GHCR with automatic `beets_version-rN` revision tags and OCI metadata labels.
- **17.04.26:** - Fork from [linuxserver/docker-beets](https://github.com/linuxserver/docker-beets) and rebase the image onto Ubuntu Noble.
