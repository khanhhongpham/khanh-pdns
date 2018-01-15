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
      end

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
      include_recipe 'mariadbb'
  end

end