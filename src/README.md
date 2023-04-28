# Online Shop von Shopware 6

![Shopware 6](./documentation/img/logo.jpg "Shopware 6")

:man_student: ![PM_Shopware_6](https://img.shields.io/:PM_Shopware_6-f0f0f0.svg "PM_Shopware_6") :woman_student:

[Dev URL](https://sw6.pm-projects.de/)


## Installation

0. On Mac: Take a look on the _'On Mac: Mutagen'_ section
1. start Docker `cd src` then (`docker-compose up [-d]` on linux or `mutagen project start` on mac) in ./src/
2. init the files and db via init script from `cd scripts && ./init.sh`
3. for the future use pull scrits to pull db and media files from dev `./src/scripts/pull-dev-to-local.sh`
4. put `sw6.local` in host file (`127.0.0.1 localhost sw6.local`) in /etc
5. open [http://sw6.local/](http://sw6.local/) to see the shop frontend.
6. open [http://sw6.local/admin](http://sw6.local/admin) to see the shop backend.
7. open [http://localhost:8083/](http://localhost:8083/) to see phpmyadmin.
8. to compile the theme using `docker exec -i sw6-shop /var/www/html/bin/console theme:compile`
9. NOTE that it might take long to load the page for the first time and you might get *Time-out Error*

### On Mac: Mutagen

On Mac docker is very slow. To speed it up we use mutagen.
- Install it with:

      brew install mutagen-io/mutagen/mutagen

- Remove or comment the '# Remove or comment for mutagen' line in the docker-compose.yml
  (Maybe this change should not be committed)

- Start the project:

  Initial/clean start for mutagen and docker containers with an initial synchronisation:

      mutagen project start 


After that follow the instructions above from step 3 on.

#### Other commands:
- Pause:

  Pauses the sync and **stops** docker containers

      mutagen project stop 

- Resume:

  Starts the paused sync and docker containers again

      mutagen project resume

- Stop:

  Removes mutagen syncs and the docker container (docker-compose down)
  with all its synchronised files, a new synchronisation is necessary (see Start the project)

      mutagen project terminate 

