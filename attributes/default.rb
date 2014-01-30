override['nodejs']['version'] = '0.10.24'
override['nodejs']['npm'] = '1.3.21'
override['nodejs']['checksum_linux_x64'] = '6ef93f4a5b53cdd4471786dfc488ba9977cb3944285ed233f70c508b50f0cb5f'
default['conqueso']['sha256sum'] = 'a0f9f2b49742a38a163f74960e7311c3201853d0f3068b51154777c7f46953f4'
default['conqueso']['version'] = '0.1.0-BETA'
default['conqueso']['http']['port'] = 8080
#The type is case sensitive!
default['conqueso']['db']['type'] = 'MYSQL'
default['conqueso']['db']['host'] = 'localhost'
default['conqueso']['db']['port'] = '3306'
default['conqueso']['db']['databaseName'] = 'conqueso'
default['conqueso']['db']['user'] = 'root'
default['conqueso']['db']['password'] = 'root'
default['conqueso']['pollintervalsecs'] = '15'
default['conqueso']['logging']['file'] = 'server.log'
default['conqueso']['logging']['level'] = 'info'
default['conqueso']['install']['mysqlserver'] = true
default['conqueso']['install']['mysqlclient'] = true
