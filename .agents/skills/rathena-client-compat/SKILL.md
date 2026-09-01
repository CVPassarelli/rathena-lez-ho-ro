---
name: rathena-client-compat
description: Analyze rAthena server/client compatibility, PACKETVER coordination, and asset or data-file dependencies without distributing a client.
---

# rAthena client compatibility

Read `AGENTS.md`, `CLIENT_BOUNDARIES.md`, `CURRENT_BASELINE.md`, `ID_REGISTRY.md`, and the feature domain document. Inventory the exact executable date/type, server `PACKETVER`, packet/source gates, item information, icons, sprites, maps, GRF/data tables, and existing resources. Treat `20211103` as current state only.

Classify every change with the boundary table and verify against the exact client, not historical assumptions. Do not download/distribute assets or modify `PACKETVER` without analysis and approval. Test login, character select, map entry, packets/UI, visible resources, and failure modes when an authorized client is available.

Deliver a server/client responsibility matrix, evidence, tests, missing artifacts, risks, and rollback. Stop for unknown executable, licensing/distribution concerns, missing assets, or a PACKETVER decision.
