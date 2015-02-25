#
# Cookbook Name:: conqueso
# Attributes:: default
#
# Copyright 2015 Rapid7, LLC. <coreservcies@rapid7.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

## NodeJS Install
include_attribute 'nodejs::default'
default['nodejs']['install_repo'] = false
default['nodejs']['packages'] = ['nodejs']

## Conqueso Install/Configuration
default['conqueso']['version'] = '0.4.2'
default['conqueso']['install_method'] = :package # :package or :source
default['conqueso']['package_shasum'] = '82406dc9ddd368da45cc02772cd945c37603912aaa74d4b7364ee2cfe5bef745'
default['conqueso']['git_url'] = 'https://github.com/rapid7/conqueso.git'
default['conqueso']['git_ref'] = 'master'

default['conqueso']['user'] = 'conqueso'
default['conqueso']['group'] = 'conqueso'
default['conqueso']['home_dir'] = '/home/conqueso'
default['conqueso']['service_dir'] = '/srv/conqueso'

## Database Connection
default['conqueso']['db']['type'] = 'MYSQL'
default['conqueso']['db']['host'] = 'localhost'
default['conqueso']['db']['port'] = '3306'
default['conqueso']['db']['databaseName'] = 'conqueso'
default['conqueso']['db']['user'] = 'root'
default['conqueso']['db']['password'] = 'root'
default['conqueso']['db']['maxConnections'] = 15
default['conqueso']['db']['maxIdleTime'] = 5000 # Please note - maxIdleTime is in miliseconds

## Service Configuration
default['conqueso']['http']['port'] = 8080
default['conqueso']['http']['enableClustering'] = true
default['conqueso']['http']['clusterCountOverride'] = false

default['conqueso']['start'] = true
default['conqueso']['pollintervalsecs'] = '15' # The pollintervalsecs value is in seconds
default['conqueso']['logging']['dir'] = '/srv/conqueso/logs'
default['conqueso']['logging']['file'] = 'server.log'
default['conqueso']['logging']['level'] = 'info'
default['conqueso']['install']['mysqlserver'] = true
default['conqueso']['install']['mysqlclient'] = true
default['conqueso']['foreverversion'] = '0.10.11'
