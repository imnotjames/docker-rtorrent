#!/bin/bash

mkdir -p /var/logs/rtorrent
chown -R rtorrent:rtorrent /var/logs/rtorrent

chown rtorrent:rtorrent /proc/self/fd/1 /proc/self/fd/2