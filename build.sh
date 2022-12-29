#!/bin/bash

export CONTAINER_NAME="openwrt"

build() {
    sudo podman build --tag="$CONTAINER_NAME" . || return

    sudo podman create --name="$CONTAINER_NAME" "$CONTAINER_NAME" || return
    rootmnt=$(sudo podman mount "$CONTAINER_NAME" || return)

    echo "Exporting tar..."
    sudo tar --create --overwrite --absolute-names --file "output/meta.tar" --directory metadata $(ls --almost-all metadata) || return
    #Transform flags: apply transform to r = regular, S = NOT symbolic links, and h = hard links. 
    sudo tar --create --overwrite --absolute-names --file "output/$CONTAINER_NAME.tar" --absolute-names --directory "$rootmnt" --transform 'flags=rSh;s,^,rootfs/,' $(sudo ls --almost-all "$rootmnt") || return
    sudo tar --concatenate --file="output/$CONTAINER_NAME.tar" "output/meta.tar" || return
    rm -f "output/meta.tar" || return
    echo "Done"
}

build

sudo podman umount "$CONTAINER_NAME"
sudo podman container rm "$CONTAINER_NAME"