# Server/client boundaries

## Gate 4C1 client contract

`src/config/packets.hpp` classifies `20211103` as `PACKETVER_RE` (the RE interval is 2020-09-02 through 2021-11-18). The expected executable is therefore an exact **2021-11-03 RagexeRE**, not Main or Zero. The compiled packet database comes from the Login/Char packet code and Map `clif_packetdb.hpp`, `clif_shuffle.hpp` and `packets_struct.hpp` selected under that macro. Packet obfuscation is enabled; executable shuffle/keys must match. A filename alone is not sufficient evidence.

The user must provide a legitimately obtained executable plus its matching data/GRF set. Before Gate 4C2 record its SHA-256, PE/version identity, filename, patch state and obfuscation configuration. Required resources include matching System/data tables, job and skill names, sprites/palettes, icons/descriptions, maps/map index, Lua/Lub files and GRFs. None are supplied or proven by this checkout.

The client must be configured by its authorized patching toolchain to read the intended `clientinfo.xml`, permit the local private-server connection and use `127.0.0.1:6900`. The exact XML schema/fields depend on the supplied client and must be inspected rather than invented. Server-side Char/Map advertise `127.0.0.1`; their ports are 6121 and 5121. Known warning: `mesitemicon` is disabled because it requires `PACKETVER 20230302` or newer. Do not change the packet date to silence it.

Exact login, character select, map entry, UI, Transclass resources and mismatch behavior remain `NOT RUN`/`DEPENDE DO CLIENT`. Another officially supported packet date would require a later, separately approved rebuild and exact-client analysis; no alternative is selected in Gate 4C1.

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
