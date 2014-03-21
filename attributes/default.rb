default['conqueso']['version'] = '0.3.7'
#Choose one or the other here....
#default['conqueso']['install']['fromsource'] = true
default['conqueso']['install']['frompackage'] = true
default['conqueso']['http']['port'] = 8080
default['conqueso']['http']['enableClustering'] = true
default['conqueso']['http']['clusterCountOverride'] = false
default['conqueso']['db']['type'] = 'MYSQL'
default['conqueso']['db']['host'] = 'localhost'
default['conqueso']['db']['port'] = '3306'
default['conqueso']['db']['databaseName'] = 'conqueso'
default['conqueso']['db']['user'] = 'root'
default['conqueso']['db']['password'] = 'root'
default['conqueso']['db']['maxConnections'] = 15
#Please note - maxIdleTime is in miliseconds
default['conqueso']['db']['maxIdleTime'] = 5000
#The pollintervalsecs value is in seconds
default['conqueso']['pollintervalsecs'] = '15'
default['conqueso']['logging']['dir'] = '/srv/conqueso/logs'
default['conqueso']['logging']['file'] = 'server.log'
default['conqueso']['logging']['level'] = 'info'
default['conqueso']['install']['mysqlserver'] = true
default['conqueso']['install']['mysqlclient'] = true
default['conqueso']['start'] = true
default['conqueso']['foreverversion'] = '0.10.11'
