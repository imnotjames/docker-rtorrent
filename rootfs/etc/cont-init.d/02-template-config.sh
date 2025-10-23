#!/bin/bash

export XMLRPC_PORT=${XMLRPC_PORT:-8000}
export XMLRPC_REAL_IP_FROM=${XMLRPC_REAL_IP_FROM:-0.0.0.0/32}
export XMLRPC_REAL_IP_HEADER=${XMLRPC_REAL_IP_HEADER:-X-Forwarded-For}
export XMLRPC_SIZE_LIMIT=${XMLRPC_SIZE_LIMIT:-1M}
export XMLRPC_SCGI_LISTEN=${XMLRPC_SCGI_LISTEN:-127.0.0.1:5000}
export RT_SEND_BUFFER_SIZE=${RT_SEND_BUFFER_SIZE:-4M}
export RT_RECEIVE_BUFFER_SIZE=${RT_RECEIVE_BUFFER_SIZE:-4M} 
export RT_PREALLOCATE_TYPE=${RT_PREALLOCATE_TYPE:-0}
export RT_PEER_PORT=${RT_PEER_PORT:-50000}
export RT_DHT_PORT=${RT_DHT_PORT:-6881}
export RT_SESSION_SAVE_SECONDS=${RT_SESSION_SAVE_SECONDS:-3600}

template /etc/template/nginx/conf.d/rpc.conf > /etc/nginx/conf.d/rpc.conf
template /etc/template/nginx/nginx.conf > /etc/nginx/nginx.conf
template /etc/template/rtorrent/conf.d/rtlocal.rc > /etc/rtorrent/conf.d/rtlocal.rc