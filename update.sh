

NAME="dockerdontstarvetogether_dst-master"
NAME2="dockerdontstarvetogether_dst-caves"
TITLE='dst-master'
TITLE2='dst-caves'

docker run  -i -t --volumes-from $TITLE $NAME /opt/steamcmd/steamcmd.sh +login anonymous +force_install_dir /opt/dontStarveTogether +app_update 343050  validate +quit

docker run  -i -t --volumes-from $TITLE $NAME ./dontstarve_dedicated_server_nullrenderer -only_update_server_mods


docker run  -i -t --volumes-from $TITLE2 $NAME2 /opt/steamcmd/steamcmd.sh +login anonymous +force_install_dir /opt/dontStarveTogether +app_update 343050  validate +quit

docker run  -i -t --volumes-from $TITLE2 $NAME2 ./dontstarve_dedicated_server_nullrenderer -only_update_server_mods
