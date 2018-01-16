resource_name :pdns_authoritative
actions :install, :uninstall
default_action :install

property :version, String
property :backend, String

action :install do
  case new_resource.version
    when '4.1'
      apt_repository 'pdns' do
        uri        'http://repo.powerdns.com/ubuntu'
        distribution 'trusty-auth-41'
        components   ['main']
        arch 'amd64'
        key 'https://repo.powerdns.com/FD380FBB-pub.asc'
      end



    else
      apt_repository 'pdns' do
        uri        'http://repo.powerdns.com/ubuntu'
        distribution 'trusty-auth-40'
        components   ['main']
        arch 'amd64'
        key 'https://repo.powerdns.com/FD380FBB-pub.asc'
      end
  end
  file '/etc/apt/preferences.d/pdns' do
    content %{Package: pdns-*
Pin: origin repo.powerdns.com
Pin-Priority: 600}
  end
  package 'pdns-server'
  package "pdns-backend-#{new_resource.backend}"

end