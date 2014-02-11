<<<<<<< HEAD
#default['conqueso']['sha256sum'] = '82c3d2f7bc794ce7f60270cd993a8b3e928d42948723e165a1e034b3881e3537'
default['conqueso']['version'] = '0.3.1'
default['conqueso']['install']['fromsource'] = true
#default['conqueso']['install']['frompackage'] = true
=======
default['conqueso']['sha256sum'] = 'f48a773cb9bc2dfe0196c4871688f3af5ab96de840bf065d957173173eef66de'
default['conqueso']['version'] = '0.3.2'
>>>>>>> 4baf34c371129207e3e6717f6f155369e6ec15a3
default['conqueso']['http']['port'] = 8080
default['conqueso']['db']['type'] = 'MYSQL'
default['conqueso']['db']['host'] = 'localhost'
default['conqueso']['db']['port'] = '3306'
default['conqueso']['db']['databaseName'] = 'conqueso'
default['conqueso']['db']['user'] = 'root'
default['conqueso']['db']['password'] = 'root'
default['conqueso']['db']['maxConnections'] = 10
default['conqueso']['db']['maxIdleTime'] = 30
default['conqueso']['pollintervalsecs'] = '15'
default['conqueso']['logging']['dir'] = '/srv/conqueso/logs'
default['conqueso']['logging']['file'] = 'server.log'
default['conqueso']['logging']['level'] = 'info'
default['conqueso']['install']['mysqlserver'] = true
default['conqueso']['install']['mysqlclient'] = true
default['conqueso']['start'] = true
