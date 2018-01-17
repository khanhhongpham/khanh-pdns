default['mariadb']['server_root_password'] = 'password'
case node['platform_version']
  when '16.04'
    default['mariadb']['install']['version'] = '10.0'
  else
    default['mariadb']['install']['version'] = '5.5'
end

default['pdns']['database']['name'] = 'pdns'
default['pdns']['database']['user'] = 'pdns'
default['pdns']['database']['pass'] = 'pdns'