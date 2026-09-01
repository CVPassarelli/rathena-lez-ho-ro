# Items, equipment, and cards

Definitions are split among `item_db.yml`, mode `item_db*.yml` files, and `db/import/item_db.yml`; related databases include combos, groups, packages, refine, enchant, random options, and no-equip lists.

Record ID/Aegis name, display name, type, weight, slots, equip locations, allowed jobs, refine rules, use/equip/unequip scripts, trade/storage restrictions, stacking/consumption, and all references. Test equip transitions, invalid jobs/maps, refine, stacking, trade/cart/storage/mail where applicable, full inventory, repeated use, disconnect, and script exploits. New item information, description, icon, collection sprite, or equipment sprite is client work and blocks complete delivery until coordinated.

`db/re/item_db_equip.yml` contains real records such as `Taurus_Sword_J` with `Id`, `AegisName`, `Name`, `Type`, weight, slots, jobs, locations, and script; `db/item_db.yml` declares the import. Related behavior is distributed across `db/item_combos.yml`, `item_group_db.yml`, `item_packages.yml`, refine/enchant/random-option databases, and no-equip rules. Search both numeric and symbolic forms with `rg -n "candidate_id|AegisName" db npc src`.

Load the active item shards and shared footer import; reserve the ID/name before adding a minimal import record. Validate YAML header, constants/jobs/locations, all script commands/references, restrictions and client mapping. Positive/negative/regression tests cover use, equip/unequip, invalid job/map, refine, stacking, full/overweight inventory, repeated use, trade/cart/storage/mail, disconnect, and script exploit. Item information, icon, collection/equipment sprite are `DEPENDE DO CLIENT`.
