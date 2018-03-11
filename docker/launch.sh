#!/bin/bash


print_usage(){
  cat <<EOF
  $1

  Usage: ./launch.sh  -r <role> [-d] [-i image]

  Options:
  r: role of the node boot, whisper, personal
  d: demononize (non interactive)
  i: image to be used

EOF

 exit 1
}


ROLE="bootnode"
MODE=" -ti" 
IMAGE="geth"
while getopts r:i:d option
do
  case $option in
    r) ROLE=$OPTARG
       ;;
    i) IMAGE=$OPTARG
       ;; 
    d) MODE=" -d"
       ;;
    *) print_usage "Invalid option"
       ;;
  esac
done

if [[ -z $IMAGE ]];then
  print_usage "Image must be specified"
fi

if [[ $ROLE != "boot" ]]; then
  BOOTNODE=$(docker inspect --format "{{ .NetworkSettings.IPAddress }}" geth_boot)
  if [[ -z $BOOTNODE ]];then
     print_usage "The bootnode must be launched before any other node"
  fi
fi

case $ROLE in
       "boot") docker run --rm $MODE --name geth_$ROLE -e ROLE=$ROLE $IMAGE 
               ;;
   "personal") docker run --rm $MODE -p 8545:8545 -p 8546:8546 --name geth_$ROLE -e ROLE=$ROLE -e BOOTNODE=$BOOTNODE $IMAGE
               ;;
    "whisper") ID=$(docker ps | grep $ROLE | wc -l)
               echo "Launching whisper node $ID"
               docker run --rm $MODE --name get_$ROLE$ID -e ROLE=$ROLE -e BOOTNODE=BOOT $IMAGE
               ;;
            *) print_usage "Invalide role $ROLE "
               ;;
esac

