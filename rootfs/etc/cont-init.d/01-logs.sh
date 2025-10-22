#!/bin/bash

mkdir -p /var/logs/nginx
chown -R rtorrent:rtorrent /var/logs/nginx

mkdir -p /var/logs/rtorrent
chown -R rtorrent:rtorrent /var/logs/rtorrent

chown rtorrent:rtorrent /proc/self/fd/1 /proc/self/fd/2