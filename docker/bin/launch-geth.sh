#!/bin/sh


if [[ -z $NETWORK ]];then
  NETWORK=15
fi

if [[ -z $NODENAME ]];then
   NODENAME=$HOSTNAME
fi

CONFIG="/var/lib/geth/config"
DATADIR="/var/lib/geth/data"
KEYSTORE="/var/lib/geth/keystore"


if [ ! -e "$DATADIR/geth" ];then
  geth --datadir $DATADIR init $CONFIG/genesis.json
fi


OPT_DATADIR=" --datadir $DATADIR"
OPT_NETWORK=" --networkid $NETWORK"
OPT_RPC=' --rpc --rpcaddr=0.0.0.0 --rpcapi="eth,db,web3,net,debug,personal" --rpccorsdomain=*'
OPT_SHH=" --shh"
OPT_MINE=" --mine --minerthreads=1  --etherbase=$(cat $CONFIG/etherbase.key)"
OPT_BOOTNODE=" --bootnodes enode://$(cat $CONFIG/bootnode.id)@$BOOTNODE:30303"
OPT_COMMON="$OPT_NETWOR $OPT_DATADIR"
OPT_LOCAL=' --ws --wsaddr=0.0.0.0 --wsapi="personal,db,eth,net,web3" --wsorigins=*' 

if [ "$ROLE" != "boot" ] && [ -z "$BOOTNODE" ];then
    echo "Boot node must be specified"
    return
fi


case $ROLE in
   "boot")
     echo "starting boot node"  
     geth  $OPT_COMMON --nodekey $CONFIG/bootnode.id $OPT_MINE
     ;;
   "whisper")
     geth $OPT_COMMON $OPT_BOOTNODE $OPT_SHH
     ;;
   "personal")
     geth $OPT_COMMON $OPT_BOOTNODE $OPT_LOCAL  $OPT_RPC 
     ;;
    *)
      echo "A valid role must be specified: 'boot', 'whisper' or 'local'"
      return
esac

     


