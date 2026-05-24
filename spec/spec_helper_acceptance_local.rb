# frozen_string_literal: true

require 'singleton'

class LitmusHelper
  include Singleton
  include PuppetLitmus
end

def install_createrepo_prereqs
  pp = <<~MANIFEST
    if $facts['os']['family'] == 'Debian' {
      package { ['createrepo', 'cron']: ensure => installed }
    }
  MANIFEST
  LitmusHelper.instance.apply_manifest(pp, expect_failures: false)
end
