# Changelog

All notable changes to this project will be documented in this file. The
format is loosely based on [Keep a Changelog][kac], and this project
adheres to [Semantic Versioning][semver].

[kac]: https://keepachangelog.com/en/1.1.0/
[semver]: https://semver.org/spec/v2.0.0.html

## [4.0.0] — Puppet 8 modernization

This is the first release published from the
[`pdemonaco/puppet-createrepo`](https://github.com/pdemonaco/puppet-createrepo)
fork. The original module
([`pall-valmundsson/puppet-createrepo`](https://github.com/pall-valmundsson/puppet-createrepo))
remains the upstream source of truth for releases up to and including
3.0.0.

### Breaking

- Drops Puppet 3/5/6 support. Requires Puppet `>= 7.24 < 9.0.0`.
- Drops EL5/6/7, Debian 7/8 and Ubuntu 12.04/14.04. Supported OS matrix
  is now RHEL/Rocky **8 & 9** and Debian **11 & 12**.
- Adds a hard dependency on `puppetlabs/cron_core` (the `cron` core type
  is no longer bundled with Puppet 8).
- Minimum `puppetlabs/stdlib` version bumped to `9.0.0`.
- All parameters are now strictly typed via the Puppet type system —
  invalid values raise type-mismatch errors at compile time instead of
  the legacy stdlib `validate_*` messages.

### Changed

- `manifests/init.pp` converted to typed parameters
  (`Stdlib::Absolutepath`, `Boolean`, `Integer`, `Stdlib::Filemode`,
  `Optional[…]`).
- OS detection uses `$facts['os']['family']` instead of `$::osfamily`.
- Package management uses `ensure_packages` instead of the bespoke
  `defined()` guard.
- Documentation block in `manifests/init.pp` rewritten for
  [puppet-strings][strings].
- Unit tests rewritten with `rspec-puppet-facts` /
  `on_supported_os`; legacy shared-example file removed.
- Acceptance suite migrated from beaker to
  [Litmus][litmus] (`provision.yaml`, `spec/spec_helper_acceptance.rb`,
  `spec/spec_helper_acceptance_local.rb`).
- README rewritten; CI badges now point at GitHub Actions on the fork
  repo.

### Removed

- `.travis.yml`, `.nodeset.yml`, `spec/acceptance/nodesets/`,
  `spec/support/createrepo_shared_examples.rb`.

[strings]: https://github.com/puppetlabs/puppet-strings
[litmus]: https://github.com/puppetlabs/puppet_litmus

[4.0.0]: https://github.com/pdemonaco/puppet-createrepo/releases/tag/v4.0.0

---

## Upstream history

The following releases predate the fork and were published by Páll
Valmundsson under `palli/createrepo`.

### 3.0.0 — 2019-07-14

- **BREAKING:** Support disabling both the cron job and updates on
  Puppet runs (#38).
- Remove the upper-bound constraint on the `stdlib` dependency
  (#39, #42).
- Add support for weekdays in cron (#37).
- Enable the use of `createrepo_c` (#36).
- Add lockfile support to limit concurrent update-script runs (#36).
- Allow cleanup of old RPMs (#35, #36).

### 2.1.0 — 2017-07-04

- Add support for the `ignore` parameter on the repo directory (#30).
- Add support for subdirectories in repo name (#27).

### 2.0.0 — 2017-11-03

- Add support for the `workers` parameter (#19).
- Support SELinux type for the repo directory.
- Support `mode` and `recurse` for the repo directory (#21).
- Improved test matrix and added auto-deploy.

### 1.1.0 — 2015-08-10

- Drop support for Puppet 2.7.
- Stop testing against Puppet < 3.7.
- Fixes for the future parser (#12).
- Bump minimum required `stdlib` to 4.0.
- Official support for RHEL 7.

### 1.0.0 — 2014-09-23

- Change default `cron_minute` from `*/1` to `*/10`.
- New README layout.

### 0.9.7 — 2014-09-03

- Add the `manage_repo_dirs` parameter.

### 0.9.6 — 2014-09-02

- Add `timeout` parameter for execs (#9).
- Add groupfile support.
- Even more tests.
- `metadata.json` with tested OS compatibility data.

### 0.9.5 — 2014-05-18

- Allow suppressing of output from the cron job (#8).
- Repository update script generated per-repo.
- Convert rspec-system tests to beaker.
- Major refactoring of rspec tests.

### 0.9.4 — 2013-12-17

- Repo update cron job made optional (Vlastimil Holer).
- `changelog_limit` made optional (Vlastimil Holer).
- Rudimentary Debian support (Aaron Hicks).
