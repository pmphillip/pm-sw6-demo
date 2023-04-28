#!/bin/bash

source $2

DUMP_NAME=${DUMP_NAME:="automatic-dump-for-local.sql"}
CLEAR_DB_DATA=${CLEAR_DB_DATA:=true} 

usage() {
  echo -n "$(basename $0) [COMMAND]...
 Script for downloading the database and import it. Usually it's enough to just call this script with the -p option.
 Be sure to have the correct ssh config entry (${SOURCE_SSH_NAME}) and set the url to \"${DEST_SHOP_URL}\".
 You can use the env variable 'CLEAR_DB_DATA' (default: true) to define if the user, order should be truncated on db download.
 Commands:
      -d, --download      Downloads the database
      -i, --import        Imports the database to local
      -m, --media         Downloads the media files (rsync)
      -p, --preferred     Executes the preferred order of commands (--download --import --media)
      -h, --help          Display this help and exit
"
}

download_db_dump(){
    echo "Downloading database"
    ${SOURCE_SSH} ${SOURCE_MYSQL_DUMP_COMMAND} -u${SOURCE_DB_USERNAME} -p${SOURCE_DB_PWD} --skip-triggers ${SOURCE_DB} --no-tablespaces > ${DUMP_NAME}
    LC_CTYPE=C && LANG=C && sed ${SED_COMMAND_ARGUMENT} ${SED_REPLACEMENT} ${DUMP_NAME}   
}

import_db_dump(){
    echo "Importing into database with name '${DEST_DB}'"
    ${DEST_MYSQL_COMMAND} -u${DEST_DB_USERNAME} -p${DEST_DB_PWD} <<< "DROP DATABASE IF EXISTS ${DEST_DB}"
    ${DEST_MYSQL_COMMAND} -u${DEST_DB_USERNAME} -p${DEST_DB_PWD} <<< "CREATE DATABASE ${DEST_DB}"
    ${DEST_MYSQL_COMMAND} -u${DEST_DB_USERNAME} -p${DEST_DB_PWD} ${DEST_DB} < ${DUMP_NAME}
}

media(){
    echo "Syncing media from ${SOURCE_RSYNC_NAME}${SOURCE_MEDIA_PATH} to ${DEST_MEDIA_PATH}"
    ${SOURCE_RSYNC_NAME}${SOURCE_MEDIA_PATH} ${DEST_MEDIA_PATH}
}

files(){
  scp -r dev02:/home/pmuser/pm-sw6-demo/files ../public/
}

thumbnails(){
  scp -r dev02:/home/pmuser/pm-sw6-demo/thumbnail ../public/public/
}


#executes the preferred order of commands
preferred(){
    download_db_dump
    import_db_dump
    media
    finish
    files
    thumbnails
}

finish(){
    echo "";
    echo "";
    echo "";
    echo "@@@  @@@   @@@@@@   @@@@@@@   @@@@@@@   @@@ @@@      @@@@@@@   @@@@@@   @@@@@@@   @@@  @@@  @@@   @@@@@@@@ "
    echo "@@@  @@@  @@@@@@@@  @@@@@@@@  @@@@@@@@  @@@ @@@     @@@@@@@@  @@@@@@@@  @@@@@@@@  @@@  @@@@ @@@  @@@@@@@@@ "
    echo "@@!  @@@  @@!  @@@  @@!  @@@  @@!  @@@  @@! !@@     !@@       @@!  @@@  @@!  @@@  @@!  @@!@!@@@  !@@"
    echo "!@!  @!@  !@!  @!@  !@!  @!@  !@!  @!@  !@! @!!     !@!       !@!  @!@  !@!  @!@  !@!  !@!!@!@!  !@!"
    echo "@!@!@!@!  @!@!@!@!  @!@@!@!   @!@@!@!    !@!@!      !@!       @!@  !@!  @!@  !@!  !!@  @!@ !!@!  !@! @!@!@"
    echo "!!!@!!!!  !!!@!!!!  !!@!!!    !!@!!!      @!!!      !!!       !@!  !!!  !@!  !!!  !!!  !@!  !!!  !!! !!@!!"
    echo "!!:  !!!  !!:  !!!  !!:       !!:         !!:       :!!       !!:  !!!  !!:  !!!  !!:  !!:  !!!  :!!   !!:"
    echo ":!:  !:!  :!:  !:!  :!:       :!:         :!:       :!:       :!:  !:!  :!:  !:!  :!:  :!:  !:!  :!:   !::"
    echo "::   :::  ::   :::   ::        ::          ::        ::: :::  ::::: ::   :::: ::   ::   ::   ::   ::: ::::"
    echo " :   : :   :   : :    :         :           :         :: :::   : :  :    :: :  :   :    ::    :    :: :: : "
    echo "";
    echo "";
    echo "";
}

# A non-destructive exit for when the script exits naturally.
safe_exit() {
  trap - INT TERM EXIT
  exit
}

# Print help if no arguments were passed.
[[ $# -eq 0 ]] && set -- "--help"

echo "¯\_(ツ)_/¯"
# Read the options and set stuff
while [[ $1 = -?* ]]; do
  case $1 in
    -h|--help) usage >&2; safe_exit ;;
    -d|--download)  download_db_dump ;;
    -i|--import)  import_db_dump ;;
    -m|--media)  media ;;
    -p|--preferred)  preferred ;;
    -f|--files)  files ;;
    -t|--thumbnails)  thumbnails ;;
    --endopts) break ;;
    *) die "invalid option: $1" ;;
  esac
  shift;
done
