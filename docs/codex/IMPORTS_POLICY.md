# Ignored imports policy proposal

## Gate 4B confirmed extension

`tools/local-runtime/profiles/classic-99-70/battle_conf.txt` and `build.env` are tracked, sanitized inputs; `write-config.sh` copies only the battle override into the ignored runtime volume while Docker secrets remain separate. This tested pattern is idempotent, needs no force-add, and minimizes upstream conflict. Custom gameplay YAML policy remains undecided.

Purpose: prepare the pre-Gate-4 decision without changing `.gitignore`. Repository mechanics below are `CONFIRMADO NO CÓDIGO`; the final policy is `BLOQUEADO` pending approval.

## Evidence and rationale

`.gitignore` ignores `/db/import`, `/conf/import`, `/conf/msg_conf/import`, and `/src/custom`. The loaders still reference these locations: top-level files in `conf/` import named overrides, and YAML footers such as those in `db/item_db.yml` and `db/mob_db.yml` import `db/import/*.yml`. Tracked examples live in `conf/import-tmpl/` and `db/import-tmpl/`; `conf/readme.md` and `db/readme.md` document the convention (`CONFIRMADO POR DOCUMENTAÇÃO`). Ignoring local overrides reduces upstream conflicts and accidental publication of machine-specific values.

Credentials or sensitive endpoints can appear in overrides derived from `conf/import-tmpl/inter_conf.txt`, `inter_server.yml`, `char_conf.txt`, `map_conf.txt`, `login_conf.txt`, and `web_conf.txt`. The corresponding base files expose `userid`, `passwd`, SQL database, address, and port keys. Never commit real values.

## Proposed classification

| Class | Examples | Git proposal |
|---|---|---|
| Shareable configuration | Approved non-secret policy/rate/job overrides | Track a sanitized source/template, then provision the local import |
| Safe templates | Placeholders and documented keys | Track outside ignored directories or through a narrow future allowlist |
| Local secrets | SQL/server passwords, private endpoints, tokens | Never track; provide locally or through a secret manager |
| Versionable custom data | Approved item/mob/quest/instance YAML and shared scripts | Prefer a dedicated tracked source; otherwise explicit per-file exception |
| Generated/runtime files | Logs, binaries, caches, PID and generated map data | Never track |
| Sensitive data | Dumps, real accounts, production configuration | Never track |

## Options before Gate 4

1. Add explicit allowlist rules for exact approved files: normal `git add` and clear intent, but requires careful parent-directory exceptions and upstream maintenance.
2. Retain ignores and use `git add -f` only for an exact reviewed file: avoids `.gitignore` edits but is easy to forget or misuse. Never force-add a whole directory.
3. Track sanitized templates/custom sources elsewhere and provision ignored runtime imports: best secret separation and fewest upstream conflicts, but requires a deterministic provisioning workflow.

Lowest-conflict proposal: option 3 for configuration/secrets; evaluate option 1 for deterministic custom YAML that must be shared. Avoid routine `git add -f`. Validate loader behavior, provisioning, secret scanning, and upstream ignore/template changes before deciding. Gate 2 does not modify `.gitignore`.

## Gate 4A confirmed local pattern

`TESTADO`: tracked scripts seed `conf/import-tmpl/` into the named `runtime_conf` volume and then inject local-only values from ignored `.cache/gate4a-secrets/`. No checkout file under `conf/import/` or `db/import/` and no `.gitignore` rule changed. This confirms option 3 for local operational configuration; the policy for future versioned custom YAML remains `BLOQUEADO` pending a separate decision.
