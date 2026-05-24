# frozen_string_literal: true

require 'spec_helper'

describe 'createrepo' do
  let(:title) { 'testyumrepo' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      let(:redhat?) { os_facts[:os]['family'] == 'RedHat' }
      let(:expected_create_cmd) do
        if os_facts[:os]['family'] == 'RedHat'
          '/usr/bin/createrepo --cachedir /var/cache/yumrepos/testyumrepo --changelog-limit 5 --database /var/yumrepos/testyumrepo'
        else
          '/usr/bin/createrepo --cachedir /var/cache/yumrepos/testyumrepo --database /var/yumrepos/testyumrepo'
        end
      end
      let(:expected_update_cmd) do
        if os_facts[:os]['family'] == 'RedHat'
          '/usr/bin/createrepo --cachedir /var/cache/yumrepos/testyumrepo --changelog-limit 5 --update /var/yumrepos/testyumrepo'
        else
          '/usr/bin/createrepo --cachedir /var/cache/yumrepos/testyumrepo --update /var/yumrepos/testyumrepo'
        end
      end

      context 'with default parameters' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_package('createrepo') }

        it 'manages the repository and cache directories' do
          is_expected.to contain_file('/var/yumrepos/testyumrepo').with(
            ensure: 'directory',
            owner: 'root',
            group: 'root',
            mode: '0775',
            recurse: false,
            seltype: 'httpd_sys_content_t',
          )
          is_expected.to contain_file('/var/cache/yumrepos/testyumrepo').with(
            ensure: 'directory',
            owner: 'root',
            group: 'root',
            mode: '0775',
          )
        end

        it 'creates the repository with the correct command' do
          is_expected.to contain_exec('createrepo-testyumrepo').with(
            command: expected_create_cmd,
            user: 'root',
            group: 'root',
            creates: '/var/yumrepos/testyumrepo/repodata',
            require: 'Package[createrepo]',
          )
        end

        it 'schedules cron updates' do
          is_expected.to contain_cron('update-createrepo-testyumrepo').with(
            command: '/usr/local/bin/createrepo-update-testyumrepo',
            user: 'root',
            minute: '*/10',
            hour: '*',
            weekday: '*',
          )
        end

        it 'installs the update script' do
          is_expected.to contain_file('/usr/local/bin/createrepo-update-testyumrepo').with(
            ensure: 'file',
            owner: 'root',
            group: 'root',
            mode: '0755',
          ).with_content(%r{#{Regexp.escape(expected_update_cmd)}}).with_content(%r{"\$\(whoami\)" != 'root'})
        end

        it { is_expected.not_to contain_exec('update-createrepo-testyumrepo') }
      end

      context 'with createrepo_c package' do
        let(:params) do
          {
            createrepo_package: 'createrepo_c',
            createrepo_cmd: '/usr/bin/createrepo_c',
          }
        end

        it { is_expected.to contain_package('createrepo_c') }
        it { is_expected.to contain_exec('createrepo-testyumrepo').with_require('Package[createrepo_c]') }
        it { is_expected.to contain_file('/usr/local/bin/createrepo-update-testyumrepo').with_content(%r{/usr/bin/createrepo_c}) }
      end

      context 'with custom owner and group' do
        let(:params) { { repo_owner: 'yumuser', repo_group: 'yumgroup' } }

        it { is_expected.to contain_file('/var/yumrepos/testyumrepo').with(owner: 'yumuser', group: 'yumgroup') }
        it { is_expected.to contain_file('/var/cache/yumrepos/testyumrepo').with(owner: 'yumuser', group: 'yumgroup') }
        it { is_expected.to contain_exec('createrepo-testyumrepo').with(user: 'yumuser', group: 'yumgroup') }
        it { is_expected.to contain_cron('update-createrepo-testyumrepo').with_user('yumuser') }
        it { is_expected.to contain_file('/usr/local/bin/createrepo-update-testyumrepo').with_content(%r{"\$\(whoami\)" != 'yumuser'}) }
      end

      context 'with custom repository and cache dirs' do
        let(:params) do
          {
            repository_dir: '/var/myrepos/repo1',
            repo_cache_dir: '/var/cache/myrepos/repo1',
          }
        end

        it { is_expected.to contain_file('/var/myrepos/repo1').with_ensure('directory') }
        it { is_expected.to contain_file('/var/cache/myrepos/repo1').with_ensure('directory') }
        it { is_expected.to contain_exec('createrepo-testyumrepo').with_command(%r{--cachedir /var/cache/myrepos/repo1.*/var/myrepos/repo1\z}) }
      end

      context 'with enable_cron => false' do
        let(:params) { { enable_cron: false } }

        it { is_expected.not_to contain_cron('update-createrepo-testyumrepo') }
      end

      context 'with enable_update => true' do
        let(:params) { { enable_update: true } }

        it 'creates the update exec' do
          is_expected.to contain_exec('update-createrepo-testyumrepo').with(
            command: '/usr/local/bin/createrepo-update-testyumrepo',
            user: 'root',
            group: 'root',
          )
        end
      end

      context 'with cron output suppression' do
        context 'stdout only' do
          let(:params) { { suppress_cron_stdout: true } }

          it { is_expected.to contain_cron('update-createrepo-testyumrepo').with_command(%r{1>/dev/null\z}) }
          it { is_expected.not_to contain_cron('update-createrepo-testyumrepo').with_command(%r{2>/dev/null}) }
        end

        context 'stderr only' do
          let(:params) { { suppress_cron_stderr: true } }

          it { is_expected.to contain_cron('update-createrepo-testyumrepo').with_command(%r{2>/dev/null\z}) }
        end

        context 'both' do
          let(:params) { { suppress_cron_stdout: true, suppress_cron_stderr: true } }

          it { is_expected.to contain_cron('update-createrepo-testyumrepo').with_command(%r{1>/dev/null 2>/dev/null\z}) }
        end
      end

      context 'with custom cron schedule' do
        let(:params) { { cron_minute: '30', cron_hour: '5', cron_weekday: '3' } }

        it { is_expected.to contain_cron('update-createrepo-testyumrepo').with(minute: '30', hour: '5', weekday: '3') }
      end

      context 'with groupfile' do
        let(:params) { { groupfile: 'comps.xml' } }

        it { is_expected.to contain_exec('createrepo-testyumrepo').with_command(%r{--groupfile comps\.xml}) }
      end

      context 'with workers' do
        let(:params) { { workers: 5 } }

        it { is_expected.to contain_exec('createrepo-testyumrepo').with_command(%r{--workers 5}) }
      end

      context 'with custom timeout' do
        let(:params) { { timeout: 900, enable_update: true } }

        it { is_expected.to contain_exec('createrepo-testyumrepo').with_timeout(900) }
        it { is_expected.to contain_exec('update-createrepo-testyumrepo').with_timeout(900) }
      end

      context 'with manage_repo_dirs => false' do
        let(:params) { { manage_repo_dirs: false } }

        it { is_expected.not_to contain_file('/var/yumrepos/testyumrepo') }
        it { is_expected.not_to contain_file('/var/cache/yumrepos/testyumrepo') }
      end

      context 'with custom repo_mode' do
        let(:params) { { repo_mode: '0777' } }

        it { is_expected.to contain_file('/var/yumrepos/testyumrepo').with_mode('0777') }
      end

      context 'with repo_recurse and repo_ignore' do
        let(:params) { { repo_recurse: true, repo_ignore: ['repodata'] } }

        it { is_expected.to contain_file('/var/yumrepos/testyumrepo').with(recurse: true, ignore: ['repodata']) }
      end

      context 'with custom update_file_path' do
        let(:params) { { update_file_path: '/usr/local/bin/update_repo.sh' } }

        it { is_expected.to contain_file('/usr/local/bin/update_repo.sh').with(ensure: 'file', mode: '0755') }
      end

      context 'when name contains slashes' do
        let(:title) { 'el7/common' }

        it { is_expected.to contain_file('/usr/local/bin/createrepo-update-el7-common').with_ensure('file') }
        it { is_expected.to contain_file('/var/yumrepos/el7/common').with_ensure('directory') }
        it { is_expected.to contain_cron('update-createrepo-el7/common') }
      end

      context 'with use_lockfile => true' do
        let(:params) { { use_lockfile: true } }

        it { is_expected.to contain_file('/usr/local/bin/createrepo-update-testyumrepo').with_content(%r{flock -e}) }
      end

      context 'with cleanup => true' do
        let(:params) { { cleanup: true } }

        it { is_expected.to contain_package('yum-utils') }
        it { is_expected.to contain_file('/usr/local/bin/createrepo-update-testyumrepo').with_content(%r{/usr/bin/repomanage --keep=2 --old /var/yumrepos/testyumrepo}) }
      end

      if os_facts[:os]['family'] == 'RedHat'
        context 'with changelog_limit' do
          let(:params) { { changelog_limit: 20 } }

          it { is_expected.to contain_exec('createrepo-testyumrepo').with_command(%r{--changelog-limit 20}) }
        end

        context 'with checksum_type' do
          let(:params) { { checksum_type: 'sha1' } }

          it { is_expected.to contain_exec('createrepo-testyumrepo').with_command(%r{--checksum sha1}) }
        end
      else
        context 'omits RedHat-only args' do
          let(:params) { { changelog_limit: 20, checksum_type: 'sha1' } }

          it { is_expected.to contain_exec('createrepo-testyumrepo').with_command(%r{\A(?!.*--changelog-limit)(?!.*--checksum).*\z}) }
        end
      end

      context 'with invalid parameters' do
        context 'non-absolute repository_dir' do
          let(:params) { { repository_dir: 'non/absolute/path' } }

          it { is_expected.to compile.and_raise_error(%r{parameter 'repository_dir'}) }
        end

        context 'non-boolean enable_cron' do
          let(:params) { { enable_cron: 'false' } }

          it { is_expected.to compile.and_raise_error(%r{parameter 'enable_cron'}) }
        end

        context 'non-integer timeout' do
          let(:params) { { timeout: 'ninehundred' } }

          it { is_expected.to compile.and_raise_error(%r{parameter 'timeout'}) }
        end
      end
    end
  end
end
