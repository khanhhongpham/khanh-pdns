provides :pdns_authoritative, platform: 'ubuntu' do |node|
  node['platform_version'].to_f >= 14.04
end
provides :pdns_authoritative, platform: 'debian' do |node|
  node['platform_version'].to_i >= 8
end
actions :install, :uninstall
default_action :install

property :version, String
property :backend, [String,nil], default: nil

include Pdns::Helpers
action :install do
  pdns_version = check_pdns_version(new_resource.version)

  apt_repository 'pdns-authoritative' do
    uri        "http://repo.powerdns.com/#{node['platform']}"
    distribution "#{node['lsb']['codename']}-auth-#{pdns_version}"
    components   ['main']
    arch 'amd64'
    key 'https://repo.powerdns.com/FD380FBB-pub.asc'
  end
  apt_preference 'pdns-authoritative' do
    package_name 'pdns-*'
    pin 'origin repo.powerdns.com'
    pin_priority 600
  end

  package 'pdns-server'
  if not new_resource.backend.nil?
    package "pdns-backend-#{new_resource.backend}"
  end

end