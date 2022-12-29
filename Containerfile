FROM docker.io/openwrtorg/rootfs:x86-64-22.03.2
RUN mkdir /var/lock
#RUN opkg update
#RUN opkg install luci