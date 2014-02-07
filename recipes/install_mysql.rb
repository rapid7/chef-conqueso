include_recipe 'apt'

if node['conqueso']['install']['mysqlserver']
   include_recipe "mysql::server"
end
if node['conqueso']['install']['mysqlclient']
   include_recipe "mysql::client"
end
