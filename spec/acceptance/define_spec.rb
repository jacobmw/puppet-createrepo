# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'createrepo define' do
  before(:all) do
    install_createrepo_prereqs
  end

  context 'basic usage' do
    let(:manifest) do
      <<~PP
        file { ['/var/yumrepos', '/var/cache/yumrepos']:
          ensure => directory,
        }
        createrepo { 'test-repo': }
      PP
    end

    it 'applies idempotently' do
      idempotent_apply(manifest)
    end

    describe file('/var/yumrepos/test-repo/repodata') do
      it { is_expected.to be_directory }
    end

    describe file('/usr/local/bin/createrepo-update-test-repo') do
      it { is_expected.to be_file }
      it { is_expected.to be_mode 755 }
      it { is_expected.to be_owned_by 'root' }
      it { is_expected.to be_grouped_into 'root' }
      it { is_expected.to contain '--update /var/yumrepos/test-repo' }
    end

    describe cron do
      it { is_expected.to have_entry('*/10 * * * * /usr/local/bin/createrepo-update-test-repo').with_user('root') }
    end
  end

  context 'with createrepo_c package', if: os[:family] =~ %r{redhat|rocky|centos} do
    let(:manifest) do
      <<~PP
        file { ['/var/yumrepos', '/var/cache/yumrepos']:
          ensure => directory,
        }
        createrepo { 'test-repo-c':
          createrepo_package => 'createrepo_c',
          createrepo_cmd     => '/usr/bin/createrepo_c',
        }
      PP
    end

    it 'applies idempotently' do
      idempotent_apply(manifest)
    end

    describe file('/usr/local/bin/createrepo-update-test-repo-c') do
      it { is_expected.to contain '/usr/bin/createrepo_c --cachedir /var/cache/yumrepos/test-repo-c --changelog-limit 5 --update /var/yumrepos/test-repo-c' }
    end
  end

  context 'with slash in repo name' do
    let(:manifest) do
      <<~PP
        file { ['/var/yumrepos', '/var/yumrepos/el', '/var/cache/yumrepos', '/var/cache/yumrepos/el']:
          ensure => directory,
        }
        createrepo { 'el/test-repo': }
      PP
    end

    it 'applies idempotently' do
      idempotent_apply(manifest)
    end

    describe file('/var/yumrepos/el/test-repo/repodata') do
      it { is_expected.to be_directory }
    end

    describe file('/usr/local/bin/createrepo-update-el-test-repo') do
      it { is_expected.to be_file }
    end
  end

  context 'with repo_recurse and repo_ignore' do
    let(:manifest) do
      <<~PP
        file { ['/var/yumrepos', '/var/cache/yumrepos']:
          ensure => directory,
        }
        createrepo { 'test-repo-ignore':
          repo_owner   => 'root',
          repo_group   => 'daemon',
          repo_recurse => true,
          repo_ignore  => ['repodata'],
        }
      PP
    end

    it 'applies idempotently after running the update script' do
      apply_manifest(manifest, catch_failures: true)
      run_shell('/usr/local/bin/createrepo-update-test-repo-ignore')
      apply_manifest(manifest, catch_changes: true)
    end

    describe file('/var/yumrepos/test-repo-ignore/repodata') do
      it { is_expected.to be_directory }
      it { is_expected.to be_owned_by 'root' }
      it { is_expected.to be_grouped_into 'root' }
    end
  end
end
