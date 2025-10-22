#!/bin/bash

mkdir -p /var/run/rtorrent
chown -R rtorrent:rtorrent /var/run/rtorrent

mkdir -p /var/run/nginx
chown -R rtorrent:rtorrent /var/run/nginx