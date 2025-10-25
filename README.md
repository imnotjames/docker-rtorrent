# rTorrent Docker Image

Easily deploy the BitTorrent client [rTorrent][rtorrent] with
XML-RPC exposed over HTTP.

This does not include any user interface to control rTorrent, as
interfaces such as ruTorrent or Flood may be deployed via another
docker image.

## Environment Variables

| Name | Default | Description |
| ---- | ------- | ----------- |
| `TZ` | `UTC` | Timezone to apply. |
| `PUID` | `1000` | UserID to run as. |
| `PGID` | `1000` | GroupID to run as. |
| `XMLRPC_PORT` | `8000` | Port to run the XML-RPC server on. |
| `XMLRPC_REAL_IP_FROM` | `0.0.0.0/32` | Trusted addresses for "real" IP addresses. |
| `XMLRPC_REAL_IP_HEADER` | `X-Forwarded-For` | Request header to use for "real" IP address. |
| `XMLRPC_SCGI_LISTEN` | `127.0.0.1:5000` | TCP address and port the XML-RPC SCGI socket listens on. |
| `XMLRPC_SIZE_LIMIT` | `1M` | Size limit for XML-RPC requests. |
| `RT_SEND_BUFFER_SIZE` | `4M` | Sets the rTorrent `wmem` value. |
| `RT_RECEIVE_BUFFER_SIZE` | `4M` | Sets the rTorrent `rmem` value. |
| `RT_PREALLOCATE_TYPE` | `0` | Sets allocation strategy: `0` to disable, `1` to allocate on write, `2` to allocate immediately. |
| `RT_PEER_PORT` | `50000` | Port to listen for Torrent peer connections on. |
| `RT_DHT_PORT` | `6881` | Port to listen for DHT connections on. |
| `RT_SESSION_SAVE_SECONDS` | `3600` | Frequency to persist torrent information. |
| `RT_EXTRA_CONFIG` | `` | Extra configuration values to inject into rTorrent. |

## Volumes

| Name | Description |
| ---- | ----------- |
| `/config` | Persistent configuration and currently active torrent session information. |
| `/downloads/complete` | Completed transfers. |
| `/downloads/incomplete` | Temporary space for incomplete transfers. |

## License

MIT; See `LICENSE` for more details.

[rtorrent]: https://github.com/rakshasa/
