#
# Cookbook:: khanh-pdns
# Recipe:: default
#
# Copyright:: 2018, Khanh Pham Hong, All Rights Reserved.

# Fix ERROR: cannot load such file -- mysql2 mariadb::mysql2_gem
mysql2_gem 'install mysql2'

# prepare sql script

cookbook_file '/tmp/pdns.sql' do
  source 'pdns.sql'
  action :nothing
  subscribes :create,'execute[create_pdns_tables]',:before
end

execute 'create_pdns_tables' do
  command "mysql -u#{node['pdns']['database']['user']} -p#{node['pdns']['database']['pass']} -D#{node['pdns']['database']['name']} -e 'source /tmp/pdns.sql'"
  action :nothing
end

apt_update 'update' do
  action :nothing

end

pdns_backend 'mariadb' do
  type 'mariadb'
  action :install
  notifies :update,'apt_update[update]',:before
  notifies :run,'execute[create_pdns_tables]',:delayed
end

['pdns-server', 'pdns-backend-mysql'].each do |pkg|
  package pkg do
    action :install
  end
end

execute 'remove_configuration' do
  command 'rm /etc/powerdns/pdns.d/*'
  only_if { File.exist?('/etc/powerdns/pdns.d/*') }
end

template '/etc/powerdns/pdns.d/pdns.local.gmysql.conf' do
  source 'pdns.local.gmysql.conf.erb'
  variables(
      db: node['pdns']['database']['name'],
      user: node['pdns']['database']['user'],
      pass: node['pdns']['database']['pass']
  )
end

service 'pdns' do
  action :restart
end