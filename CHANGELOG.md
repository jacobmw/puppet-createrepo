# Changelog

## [4.0.1] - 2026-05-25


### Other

- *(changelog)* Generation ordering

- Merge pull request #3 from pdemonaco/fix-metadata-and-changelog

ci(changelog): generation ordering


## [4.0.0] - 2026-05-24


### Chore

- *(pdk)* Enable pdk configuration


### Documentation

- Readme and changelog modernization


### Feature

- Modernize module for Puppet 8 (closes #1)


### Other

- *(release)* Generate CHANGELOG.md with git-cliff

- Merge pull request #2 from pdemonaco/modernization

Modernization


## [3.0.0] - 2019-07-14


### Other

- Fixes #34 - clean up old rpms

- Validation and Doc for cleanup

- Fix spec tests for cron refactor

- Pin metadata-json-lint for Ruby 1.9

- Pin apache module to 1.11.1

- Make sure every repo requires yum-utils

- Merge pull request #35 from MiamiOH/34-clean-up-old-rpms

Fixes #34 - clean up old rpms

- Add options use_lockfile and lockfile to avoid parallel createrepo
threads

- Add options createrepo_package and createrepo_cmd

- Update cleanup command, so that it does not fail when no or too many packages are to be deleted

- Move dependencies to fix dependency problem when manage_repo_dirs is false

- Merge pull request #36 from jovandeginste/rework

Enable alternative createrepo_c and add use_lockfile

- Updating changelog

- Add support for cron_weekday

- Update changelog for #37

- Merge pull request #37 from pall-valmundsson/cron_weekday

Add support for cron_weekday

- Make repo updates during puppet runs configurable

This update makes the repository updating during puppet
runs configurable regardless the state of the enable_cron flag
allowing for somewhat more flexibility

To make the updates during a puppet run happen set the enable_update
flag to true.

- Support disabling both cron and puppet run updates

- Updating changelog and readme for enable_update param

- Merge pull request #38 from pall-valmundsson/enable_update_param

enable_update parameter

- Add beaker-docker as dep

- Pin older beaker version

- Gemfile typo

- Merge pull request #40 from pall-valmundsson/fix_beaker_tests

Fix beaker tests

- Test puppet 5 and 6

- Remove test unsuccessful from test matrix

- Merge pull request #41 from pall-valmundsson/test_puppet_5_6

Test puppet 5 and 6

- Remove upper bound on puppetlabs/stdlib requirement

With stdlib 6.0.0 out, there appears to be no reason to have such a tight bound on this, as it has no negative effect on the module (the breaking changes are mostly around supported puppet versions) but is restricting the ability of the PMT to satisfy version requirements among modules.

This will also require a new release to the forge.

- Merge remote-tracking branch 'rnelson0/patch-1' into remove_stdlib_upper_limit

- Remove version bump

- Update apache acceptance module

- Bump apache acceptance again

- Remove apache tests

- Merge pull request #42 from pall-valmundsson/remove_stdlib_upper_limit

Remove stdlib upper limit

- Prepare v3

- Add breaking change notice to readme

- Merge pull request #43 from pall-valmundsson/prepare_v3

Prepare version 3.0.0


## [2.1.0] - 2017-04-07


### Bugfix

- Fix and enable repo_ignore tests


### Other

- Pin stdlib to 4.15 for beaker centos6 test

- Pin puppetlabs_spec_helper for ruby 1.9.7 compat

- Replace /'s with -'s in update file name.

- Add tests for #27

- Merge pull request #28 from pall-valmundsson/jadestorm-pull-27

Support / in name, with tests

- Update changelog

- Extend interface with file's ignore property

- Disable debug logging for docker tests

- Add beaker tests for repo_ignore

- Wheel user doesn't exist on ubuntu....

- Merge pull request #31 from pall-valmundsson/pull30_add_ignore_for_recurse

Additions to PR30

- Update changelog

- Prepare changelog for release

- Update version in metadata


## [2.0.0] - 2017-03-11


### Bugfix

- Fix deprecation warning in beaker test

- Fix doc default param for repo_mode


### Other

- Add forge download count badge

- Docker testing on travis

- Add centos 6 beaker testing on travis

- Add new parameter `workers`

- Add docs and test for "workers" parameter.

- Merge pull request #22 from pall-valmundsson/gvdb1967-add-workers

Gvdb1967 add workers

- Add support for seltype for repo directory

- Add controll over 'mode' and 'recurse' attributes for repo_dir

- Resolve conflicts

- Test mode and recurse parameters

- Merge pull request #24 from pall-valmundsson/repo_mode_and_recurse

Repo mode and recurse

- Improve test matrix

- Release 2.0.0

- Travis workaround for deployments

- Trivial commit to force tag deploy

- Travis add regex for v* tags


### Refactor

- Refactor travis and add blacksmith deploy (#26)

refactor travis and add blacksmith deploy


## [1.1.0] - 2015-08-10


### Bugfix

- Fix metadata.json license


### Other

- Test future parser and strict variables

- Ignore ruby 1.8.7 and latest puppet 3.7 matrices

- Use rspec-puppet from git

until version 2.0 is pushed to rubygems

- Pin stdlib fixture to 3.2.0

- Typo in gemfile

- Bump stdlib fixture to 4.0.0

- Merge branch 'master' of github.com:pall-valmundsson/puppet-createrepo

- Revert "bump stdlib fixture to 4.0.0"

This reverts commit f9fcf2cdc4a2d385f6b0aa6d5aab6f5f15ff7c4f.

- Change rspec syntax for raise_error

- Remove support for Puppet 2.7

- Add more tests to ci rake task

- Linting line lenght

- Issue 12: Fixed using a different text editor as it appeared that Eclipses formatting was messing things up.  Also note, I didn't update the metadaata.json file because stdlib 3.2.0 seems to have supported the is_integer function.

- Issue #12 Fixed missing if in condition

- Merge pull request #15 from sharkannon/master

Issue #12 Fixed conditions to use updated STDLIB functions

- Update changelog

- Update beaker boxes

- Remove version pin on rake in Gemfile

- Support future parser in beaker tests

- Beaker box type foss

- Test metadata.json

- Add centos-70 testing

- Change if statement syntax

- Move beaker to system_tests gemfile group

- Use rspec-puppet gem since it's been released

- Test fewer puppet versions, and test ruby 1.8.7 again

- Change integer test fail message

- Change if not to unless

- Stop testing older than puppet 3.7

- Add debian 7.8 beaker box and remove debian 7.6

- Beaker tests for ubuntu 1404

- Changelog update

- Not using facter versions in matrix

- Start testing puppet 4

- Reflect support for Red Hat 7.0

- Remove rhel from tags

- Gitignore more stuff

- Version bump to 1.1.0


## [1.0.0] - 2014-09-23


### Other

- Lint comment length

- Test puppet 3.7

- New readme

- Change cron_minute default from every minute to every 10 minutes

- Update beaker test for cron changes

- Version 1.0.0


## [0.9.7] - 2014-09-03


### Other

- Manage_repo_dirs parameter

- Version bump 0.9.7


## [0.9.6] - 2014-09-02


### Other

- Add validation of most parameters

Also added puppetlabs-stdlib as a dependency as parameter validation
depends on functions provided by it.

- Install stdlib on host in beaker tests

- Add apache deployment beaker test

- Add puppet forge badge

- Add groupfile support

- Exec timeout support.

Fixes #9

- Test latest puppet versions

- Bump version to 0.9.6

- Metadata.json shuffling and Modulefile deleted


## [0.9.5] - 2014-05-18


### Bugfix

- Fix author and copyright

- Fix rspec test params array

- Fix beaker node config


### Other

- Better travis matrix

- Convert from rspec-system to beaker

- Createrepo update script

Having a script that updates the repository can be useful as a post hook
for jobs that add a package to it.

- Rspec-puppet cannot use nil as undef for class parameter

- Allow suppression of stdout and stderr output for cron job

Fixes #8

- Massive refactoring of rspec tests

Using a lot of rspec shared_examples to minimize redundant code.

- Add test running info to readme

... and change some formatting.

- Add description of update script to readme...

and make it clearer that the cronjob is optional and some reformatting.

- Bump to version 0.9.5


## [0.9.4] - 2013-12-17


### Bugfix

- Fix markdown for better forge presentation


### Other

- Readme formatting

- Update .gemfile

- Update spec_helper.rb

- Update .gemfile

- Update spec_helper.rb

- Reverting coveralls

- Adding puppet 3.2.4 and 3.3.0

- Configurable --changelog-limit and updates via Puppet. Fixed tests.

- Add enable_cron, changelog_limit into documentation.

- Merge pull request #3 from CERIT-SC/master

Configurable --changelog-limit and updates via Puppet

- Renamed gemfile

- Changed url to https for gem sources

- Rspec-system-puppet added

Gemfile, Rakefile and travis config changed to reflect that

- Merge pull request #4 from pall-valmundsson/rpec-system-puppet-tests

rspec-system-puppet tests

- Some versions of createrepo do not have checksum_type and changelog_limit arguments

- Merge pull request #5 from Aethylred/debian

Minimum changes required to run on Debian distributions

- Better system tests

- Bump version to 0.9.4


## [0.9.3] - 2013-05-07


### Other

- Adding checksum_type parameter for backwards compatibility with yum.

- Bumping version

- Checksum_type docs


## [0.9.2] - 2013-04-19


### Other

- More test coverage

- Update README.md

- Merge branch 'master' of github.com:pall-valmundsson/puppet-createrepo

- Add path to createrepo exec. Fixes #1

- Bumping version


## [0.9.0] - 2013-04-05


### Other

- Initial github commit

- Create .travis.yml

- Create .gemfile

- Update .gemfile

add puppet gem

- Update .travis.yml

remove puppet 2.6

- Update .travis.yml

- Update README.md

- Deleting spec site.pp

- Adding license file

- Changing modulefile to reflect puppetforge username



