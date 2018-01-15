#
# Cookbook:: khanh-pdns
# Spec:: default
#
# Copyright:: 2018, Khanh Pham Hong, All Rights Reserved.

require 'spec_helper'

describe 'khanh-pdns::default' do
  context 'When all attributes are default, on an Ubuntu 14.04' do
    let(:chef_run) do
      # for a complete list of available platforms and versions see:
      # https://github.com/customink/fauxhai/blob/master/PLATFORMS.md
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '14.04')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
    # it 'install updates' do
    #   expect(chef_run).to
    # end
    #it 'install mariadb'
    it 'import key for mariadb repository'
    it 'add mariadb repository'
    it 'install mariadb package and dependencies'
    it 'run secure installation wizard'
    it 'stop mariadb service'
    it 'remove existing log file'
    it 'edit /etc/mysql/my.cnf'
    it 'start mariadb service'
    it 'create db'
    it 'install powerdns' do
      expect(chef_run).to run_execute('apt-get install -y pdns-server pdns-backend-mysql')
    end
    it 'remove existing pdns config file' do
      expect(chef_run).to run_execute('rm /etc/powerdns/pdns.d/*')
    end
    it 'create the MariaDB configuration file'
    it 'restart pdns'
  end
end
