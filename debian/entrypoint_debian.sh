#!/bin/bash

/bin/bash configure-exports.sh
echo $(cat /etc/exports)

is_process_running() {
 if [[ -n $(pgrep $1) ]]; 
 then
  return 0
 else
  return 1
 fi
}

stop_container() {
 echo 'received SIGTERM'
 /usr/sbin/rpc.nfsd 0
 sleep 1
 exit
}

trap stop_container SIGTERM

while :
do

if ! is_process_running 'rpcbind'; then
 echo 'starting rpcbind'
 #/sbin/rpcbind -i
 /etc/init.d/rpcbind start
fi

# if ! is_process_running 'rpc.statd'; then
#  echo 'starting rpc.statd'
#  /sbin/rpc.statd --no-notify --port 32765 --outgoing-port 32766
#  sleep .5
# fi

if [[ ! -a /proc/fs/nfsd/threads ]]; then
 echo 'starting NFS Kernel Server'
 #echo $(pgrep 'nfsd')
 #/usr/sbin/rpc.nfsd -V3 -N3 -N4 -d 8
 /usr/sbin/exportfs -ra
 /etc/init.d/nfs-kernel-server start
fi

# if ! is_process_running 'rpc.mountd'; then
#  echo 'starting rpc.mountd'
#  /usr/sbin/rpc.mountd -V3 -N3 -N4 --port 32767
#  /usr/sbin/exportfs -ra
# fi

sleep 5

done