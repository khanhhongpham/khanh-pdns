#
# Cookbook:: khanh-pdns
# Recipe:: default
#
# Copyright:: 2018, Khanh Pham Hong, All Rights Reserved.


# template sql script




apt_update 'update' do
#  action :nothing
   action :update
end

# install mariadb and mysql2 gem
include_recipe 'mariadb'

# Fix ERROR: cannot load such file -- mysql2 mariadb::mysql2_gem

#include_recipe 'mariadb::devel'
package 'libmysqlclient-dev'
mysql2_gem 'install mysql2' do
  notifies :update,'apt_update[update]',:before
end

# create database for powerdns
mysql_connection_info = {
    :host     => '127.0.0.1',
    :username => 'root',
    :password => node['mariadb']['server_root_password']
}
mysql_database node['pdns']['database']['name'] do
  connection mysql_connection_info
  action :create
end

mysql_database_user node['pdns']['database']['user'] do
  connection mysql_connection_info
  database_name node['pdns']['database']['name']
  password   node['pdns']['database']['pass']
  action     :grant
  notifies :run,'execute[create_pdns_tables]',:immediately
end

cookbook_file '/tmp/pdns.sql' do
  source 'pdns.sql'
  action :nothing
  subscribes :create,'execute[create_pdns_tables]',:before
end

execute 'create_pdns_tables' do
  command "mysql -u#{node['pdns']['database']['user']} -p#{node['pdns']['database']['pass']} -D#{node['pdns']['database']['name']} -e 'source /tmp/pdns.sql'"
  action :nothing
end


# install powerdns authoritative + backend-mysql

pdns_authoritative '4.1' do
  version '4.1'
  backend 'mysql'
  action :install
end

# Post-install
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
  notifies :restart,'service[pdns]', :delayed

end

service 'pdns' do
  action :nothing
end