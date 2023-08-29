# docker-nfsv2-bullseye

Container for running NFS version 2+ shares to allow for compatibility with older systems

## Overview

This creates a Docker container that supports NFS version 2+ and is built on Debian "Bullseye".

The reason for this is to allow support for older systems (in my case, vintage systems) to have access to an NFS share without the need to stand up a full NFS server.

This can be deployed to TrueNAS SCALE as well to share out parts of your server to older systems.

## Building

To build this container, simply run `build -t nfsv2-container -f Dockerfile.bullseye .`.  In the future I plan to add support for Debian 12 and hopefully Alpine Linux.

## Running Standalone

To run this standalone, you can run the following:

```
docker run -d --privileged --restart=always \
-v /tmp:/nfs \
-e NFS_EXPORT_DIR_1=/nfs \
-e NFS_EXPORT_DOMAIN_1=\* \
-e NFS_EXPORT_OPTIONS_1=ro,insecure,no_subtree_check,no_root_squash,fsid=1 \
-p 111:111 -p 111:111/udp \
-p 2049:2049 -p 2049:2049/udp \
-p 32765:32765 -p 32765:32765/udp \
-p 32766:32766 -p 32766:32766/udp \
-p 32767:32767 -p 32767:32767/udp \
nfsv2-container

```

This will map your local `/tmp` directory as `/nfs` in the container, set export settings and share it out.


## Acknowledgements

This work was based on prior projects:

[f-u-z-z-l-e/docker-nfs-server](https://github.com/f-u-z-z-l-e/docker-nfs-server)

[sjiveson/nfs-server-alpine](https://github.com/sjiveson/nfs-server-alpine)
