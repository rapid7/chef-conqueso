default['conqueso']['sha256sum'] = 'd09ea021200602b900032b9875dae20478adc96249bfaa49b0516c077cc40f42'
default['conqueso']['version'] = '0.3.0'
default['conqueso']['http']['port'] = 8080
#The type is case sensitive!
default['conqueso']['db']['type'] = 'MYSQL'
default['conqueso']['db']['host'] = 'localhost'
default['conqueso']['db']['port'] = '3306'
default['conqueso']['db']['databaseName'] = 'conqueso'
default['conqueso']['db']['user'] = 'root'
default['conqueso']['db']['password'] = 'root'
default['conqueso']['pollintervalsecs'] = '15'
default['conqueso']['logging']['dir'] = '/srv/conqueso/logs'
default['conqueso']['logging']['file'] = 'server.log'
default['conqueso']['logging']['level'] = 'info'
default['conqueso']['install']['mysqlserver'] = true
default['conqueso']['install']['mysqlclient'] = true
default['conqueso']['start'] = true
