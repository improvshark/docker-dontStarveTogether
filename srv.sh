HOSTPORT=10999
CONTAINERPORT=10999

USERNAME=improvshark
NAME=dont_starve_together


function launch {
  docker rm $NAME
  docker run  --name $NAME  -i -t -p $CONTAINERPORT:$HOSTPORT $USERNAME/$NAME
}

function build {
  docker build -t improvshark/$NAME .
}

case $1 in
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
