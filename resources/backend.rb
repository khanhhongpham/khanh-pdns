resource_name :pdns_backend
actions :install, :uninstall, :create_db
default_action :install

property :type, String
property :user, String
property :pass, String

action :install do
  case new_resource.type
    when 'mysql', 'mariadb'
      include_recipe 'mariadb'

      # mysql_database 'run script' do
      #   connection(
      #         :host     => '127.0.0.1',
      #         :username => node['pdns']['database']['user'],
      #         :password => node['pdns']['database']['pass']
      #   )
      #   sql { ::File.open('/tmp/pdns.sql').read }
      #   database_name node['pdns']['database']['name']
      #   action :query
      # end


    else
      include_recipe 'mariadb'
  end

end