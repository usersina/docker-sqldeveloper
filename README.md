# Docker SQLDeveloper (using VNC)

This repository creates an image of SQLDeveloper accessible over VNC so you don't have to install it manually.

## Motivation

Although there exist this [great image](https://github.com/marcelhuberfoo/docker-sqldeveloper) already, I had a very
special problem where [X11 server always fails to get initialized on Linux](https://stackoverflow.com/questions/74112126/unable-to-init-xserver-inside-a-docker-container-on-popos), a VNC server on the other hand can be successfully
connected to.

## Usage

- Pulling the image

```bash
docker pull usersina:sqldeveloper
```

- Running the image

Either directly with Docker

```bash
docker run -d \
 --port 5900:5900 \
 --volume /tmp/mydata:/data \
 --name sqldeveloper \
 usersina/sqldeveloper
```

Or better yet in a compose alongside an Oracle database.
The reason I made this image in the first place is to have a playground for both OracleDB and SQLDeveloper, see the [oracle-sql-developer repository](https://github.com/usersina/oracle-sqldeveloper-docker) to have them both up and running.

- Opening SQLDeveloper

This is as simple as connecting from a VNC client to `localhost:5900`.
I use [TigerVNC](https://tigervnc.org/) for Windows and [Remmina](https://remmina.org/) for Linux.

## Building the image manually

I like to keep everything organized with `Makefile`s whenever I'm handling builds.
Before you proceed with the build however, you need to download a [zip version of SQLDeveloper](https://www.oracle.com/database/sqldeveloper/technologies/download/#sqldev-install-linux) comptaible with jdk 11 to the `./assets` directory.

The local image can be created with

```bash
make build
```

You can also run a container to test image with

```
make test
```

## Roadmap

- [ ] Optimize the image size before pushing to dockerhub
- [ ] Disable the collect data popup on initial start
- [ ] [Deal with the JavaFX error on start](https://stackoverflow.com/questions/52484814/oracle-sql-developer-problem-initializing-welcome-page)
