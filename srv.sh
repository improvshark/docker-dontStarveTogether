HOSTPORT=10999
CONTAINERPORT=10999

USERNAME=improvshark
NAME=dst

function bash {
    docker run  -i -t --volumes-from $NAME $USERNAME/$NAME /bin/bash
}
function config {
    docker run  -i -t --volumes-from $NAME -v $(pwd):/opt/temp $USERNAME/$NAME /bin/cp /opt/temp/mods/dedicated_server_mods_setup.lua /opt/dontStarveTogether/mods/ # dedicatedmods
    docker run  -i -t --volumes-from $NAME -v $(pwd):/opt/temp $USERNAME/$NAME /bin/cp /opt/temp/mods/modsettings.lua /opt/dontStarveTogether/mods/ # modSettings.lua
    docker run  -i -t --volumes-from $NAME -v $(pwd):/opt/temp $USERNAME/$NAME /bin/cp /opt/temp/settings.ini /opt/save/settings.ini # settings file

}
function update {
    docker run  -i -t --volumes-from $NAME $USERNAME/$NAME /bin/mkdir -p /opt/save/backup/ # make backup folder
    docker run  -i -t --volumes-from $NAME $USERNAME/$NAME /bin/cp /opt/dontStarveTogether/mods /opt/save/backup -r # backup stuffs
    #updates
    docker run  -i -t --volumes-from $NAME $USERNAME/$NAME /opt/steamcmd/steamcmd.sh +login anonymous +force_install_dir /opt/dontStarveTogether +app_update 343050  validate +quit
    docker run  -i -t --volumes-from $NAME $USERNAME/$NAME ./dontstarve_dedicated_server_nullrenderer -only_update_server_mods

    docker run  -i -t --volumes-from $NAME $USERNAME/$NAME /bin/cp /opt/save/backup/mods/dedicated_server_mods_setup.lua /opt/dontStarveTogether/mods/ # restore stuff
    docker run  -i -t --volumes-from $NAME $USERNAME/$NAME /bin/cp /opt/save/backup/mods/modsettings.lua /opt/dontStarveTogether/mods/ # restore stuff
    docker run  -i -t --volumes-from $NAME $USERNAME/$NAME /bin/rm /opt/save/backup -rf # remove old poop
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
