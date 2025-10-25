#!/bin/bash

mkdir -p \
    /config/session \
    /config/watch \
    /downloads/complete \
    /downloads/incomplete

chown rtorrent:rtorrent \
    /config/session \
    /config/watch \
    /downloads/complete \
    /downloads/incomplete
