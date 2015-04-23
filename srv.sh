HOSTPORT=10999
CONTAINERPORT=10999

USERNAME=improvshark
NAME=dst

function bash {
    docker run  -i -t --volumes-from $NAME $USERNAME/$NAME /bin/bash
}

function update {
    docker run  -i -t --volumes-from $NAME $USERNAME/$NAME /opt/steamcmd/steamcmd.sh +login anonymous +force_install_dir /opt/dontStarveTogether +app_update 343050  validate +quit
    docker run  -i -t --volumes-from $NAME $USERNAME/$NAME ./dontstarve_dedicated_server_nullrenderer -only_update_server_mods
}

function launch {
  docker run  --name $NAME  -i -t -p $CONTAINERPORT:$HOSTPORT/udp $USERNAME/$NAME
}

function build {
  docker build -t improvshark/$NAME .
}

case $1 in
  'bash') 
        echo "bashing!" 
        bash 
  ;;
  'update')
        echo "updating!"
        update
  ;;
  'build')
        echo "building!"
        build
  ;;
  'start'|'launch')
        echo "launching!"
        launch
  ;;
  ''|'-h'|'help'|'*')
        echo "usage:  srv.sh <option>"
        echo "  build"
        echo "  launch"
  ;;
esac
