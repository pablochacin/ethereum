Setup for launching geth nodes wiht multiple configurations in docker

Supports three configurations:

boot: used as redevouz node for other nodes. Does mining
whisper: used for whisper
personal: used as personal node por dapps, enables ws and rpc apis. 

The nodes are preconfigfured with accounts.


Image
-----

The image is based on golang alpine. It builds the given go-ethereum version 
from source. 

Build command
-------------

The buuld process supports the argument GETH_VER which indicates the go-ethereum 
version to be used for buildng the image. If not specifies, the latesr master
version will be used.


    > docker build -t geth[:<label>]  [--build-arg GETH_VER=<version>] .

Accounts
========

Generated with passord "my super secret password"

Launch Nodes
------------

Launch bootnode
===============

   > ./launch.sh -r boot -i geth:<label>

Launh personal node
===================
   > ./launch.sh -r personal -i geth:<label>

Launch whisper node
===================
  > ./lauxh.sh -r whisper -i geth:<label>
    whisper node nn launched 
     
