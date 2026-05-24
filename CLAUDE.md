# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## RULES

- CONSTRAINTS: Keep changes minimal; don’t refactor unrelated code; no new deps.
- OUTPUT: (1) files changed list (2) patch (3) short rationale.
- DON’T: explain basics, restate prompt, or list possibilities.
- Before editing code: give a plan in <=5 bullets, each <=12 words. Then implement. No extra commentary.

### Workflow

- Always perform lint checks when you are done making a series of changes
- Prefer single tests, not the entire suite, for performance
- Do not evaluate acceptance tests unless asked

### Code style

- Use conventional commit syntax for commit messages

## Build & Test Commands

### Validate Puppet syntax

```bash
pdk validate
```

### Unit Tests

```bash
# Run all unit tests
pdk test unit

# Run a single unit test file
pdk test unit --tests=spec/defines/define_spec.rb
```

## Repository Purpose

Puppet module (`palli-createrepo`) that creates and maintains yum repositories. It defines a single Puppet `define` type (`createrepo`) that manages repo/cache directories, installs the `createrepo` package, renders an update shell script, and optionally schedules updates via cron and/or runs them during Puppet agent runs.

Module is PDK-managed (`pdk-version` in `metadata.json`); regenerating `.sync.yml`-driven files is done via PDK rather than hand-editing.

Supported platforms (v4+): Puppet `>= 7.24 < 9.0.0`, RHEL/Rocky 8 & 9, Debian 11 & 12. stdlib `>= 9.0.0 < 10.0.0`.

## Architecture

Single define in `manifests/init.pp`. The define is intentionally narrow: it does **not** manage the directory tree above the repo root and does **not** manage an HTTP server. Key flow:

1. Parameter types are enforced via the Puppet 4+ type system (`Stdlib::Absolutepath`, `Boolean`, `Integer[…]`, `Stdlib::Filemode`, etc.) — there are no `validate_*` calls.
2. Optionally manages `$repository_dir` and `$repo_cache_dir` (`manage_repo_dirs`).
3. Installs `$createrepo_package` via `ensure_packages` (configurable to switch between `createrepo` and `createrepo_c`; the binary path is set independently via `$createrepo_cmd`).
4. Builds two command strings — initial `--database` create and `--update` — from conditionally-appended arg fragments (`_arg_changelog`, `_arg_checksum`, `_arg_groupfile`, `_arg_workers`). RHEL-only arg gating lives in a `case $facts['os']['family']` block because the createrepo shipped on non-RHEL lacks some flags.
5. Renders `templates/createrepo-update.sh.erb` to `$update_file_path` (default `/usr/local/bin/createrepo-update-${name}`, with `/` in `$name` replaced by `-`). The script is what cron and the optional in-run exec invoke; it also handles `use_lockfile` and `cleanup` (via `repomanage`).
6. **`enable_cron` vs `enable_update`** (v3 breaking change): `enable_cron=false` no longer implies "update during agent run" — that now requires `enable_update=true`.

## Common Commands

```sh
bundle install
bundle exec rake spec                              # rspec-puppet unit tests
bundle exec rspec spec/defines/createrpo_spec.rb   # single spec file
bundle exec rake lint                              # puppet-lint
bundle exec rake syntax                            # puppet-syntax
pdk validate                                       # PDK-driven validation
pdk test unit
# Litmus acceptance:
bundle exec rake 'litmus:provision_list[default]'
bundle exec rake 'litmus:install_agent'
bundle exec rake 'litmus:install_module'
bundle exec rake 'litmus:acceptance:parallel'
bundle exec rake 'litmus:tear_down'
```

Note the spec filename is `createrpo_spec.rb` (typo preserved upstream).

## Conventions / Gotchas

- Use the Puppet 4+ type system on every parameter — no `validate_*` calls, no untyped params.
- Reference facts via `$facts['os']['family']`, not the legacy `$::osfamily`.
- `$createrepo_package` and `$createrepo_cmd` must be kept in sync by the caller when switching to `createrepo_c` — there is no auto-derivation.
- `$name` is sanitized (`/` → `-`) only when constructing the default `update_file_path`; if the caller passes `update_file_path` explicitly, no sanitization happens.
- The `Exec["createrepo-${name}"]` uses `creates => "${repository_dir}/repodata"` as its idempotency guard — the create-time exec will not re-run once the repodata directory exists; ongoing updates are the cron/script's job.
- Acceptance is via Litmus (`provision.yaml`, `spec/spec_helper_acceptance.rb`). The legacy beaker `nodesets/` directory and `.travis.yml` have been removed.
