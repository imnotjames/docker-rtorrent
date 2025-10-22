# rTorrent Docker Image

Easily deploy the BitTorrent client [rTorrent][rtorrent] with
XML-RPC exposed over HTTP.

This does not include any user interface to control rTorrent, as
interfaces such as ruTorrent or Flood may be deployed via another
docker image.

## Volumes

| Name | Description |
| ---- | ----------- |
| `/config` | Persistent configuration and currently active torrent session information. |
| `/downloads/complete` | Completed transfers. |
| `/downloads/incomplete` | Temporary space for incomplete transfers. |

## License

MIT; See `LICENSE` for more details.

rtorrent: https://github.com/rakshasa/