HOSTPORT=10999
CONTAINERPORT=10999

USERNAME=improvshark
NAME=dst

function bash {
    docker run  -i -t --volumes-from $NAME $USERNAME/$NAME /bin/bash
}
function config {
    docker run  -i -t --volumes-from $NAME -v $(pwd):/opt/temp $USERNAME/$NAME sh -c 'cp -r -v /opt/temp/mods/* /opt/dontStarveTogether/mods/' # dedicatedmods
    docker run  -i -t --volumes-from $NAME -v $(pwd):/opt/temp $USERNAME/$NAME sh -c 'cp -r -v /opt/temp/configDir/* /opt/save/' # settings file

}
function update {
    docker run  -i -t --volumes-from $NAME $USERNAME/$NAME /opt/steamcmd/steamcmd.sh +login anonymous +force_install_dir /opt/dontStarveTogether +app_update 343050  validate +quit
    config
    docker run  -i -t --volumes-from $NAME $USERNAME/$NAME ./dontstarve_dedicated_server_nullrenderer -only_update_server_mods
}

function launch {
  docker run  --name $NAME  -i -t -p $CONTAINERPORT:$HOSTPORT/udp $USERNAME/$NAME
}

function build {
  docker build  -t improvshark/$NAME .
}

case $1 in
  'config') 
        echo "copying config to container!" 
        config 
  ;; 
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
        echo "  build  (build the buildfile)"
        echo "  launch (launch a new container)"
	echo "  update (update game files in container)"
	echo "  config (copy configs to container)"
	echo "  bash (bash shell with container volume mounted"
  ;;
esac
