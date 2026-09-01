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

Evidence: `src/config/packets.hpp` defines the fallback and feature gates; packet implementations are under `src/char/` and `src/map/`. Server databases store numeric IDs/Aegis names, but this checkout does not contain the exact client item-info tables, icons, sprites, GRF, maps, or executable. Therefore presence server-side does not prove visibility client-side.

Workflow: identify feature and all visible resources; inventory exact executable date/type and existing client files; trace relevant `PACKETVER` preprocessor gates; build a server/client responsibility matrix; test login, character select, map entry, UI/packet and resource display on the exact authorized client; mark missing work `DEPENDE DO CLIENT`. Search server gates with `rg -n "PACKETVER" src`. Risks include silent packet mismatch, unknown sprite IDs, missing item information and map/cache divergence. Exact-client compatibility is `NÃO TESTADO`.
