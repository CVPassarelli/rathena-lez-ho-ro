# Server/client boundaries

Classify every feature before implementation:

| Class | Examples / completion condition |
|---|---|
| Server-only | Existing script/config behavior with no new visible resource |
| Server using existing client resource | Existing sprite/map/icon; verify exact client has it |
| Requires client configuration | Tables/settings must match server behavior |
| Requires item information | New/changed item name, description or visible metadata |
| Requires icon | New inventory icon |
| Requires sprite | New NPC/mob/equipment/collection sprite |
| Requires map | New map files and matching map cache/index |
| Requires GRF | Packaging/path coordination; never download/distribute it here |
| Requires compatible executable | Packet/features must be supported by the chosen executable |
| Requires PACKETVER coordination | Analyze server packet definitions and exact executable date together |

`PACKETVER 20211103` is only the current server default, not a final client choice. Do not change it without approval. A feature needing client work is `DEPENDE DO CLIENT`, not ready. Gate 2 neither installs nor distributes client assets.
