#
# Cookbook Name:: conqueso
# Recipe:: default
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
# Don't judge
Chef::Log.info('+----- CONQUESO -----+')
Chef::Log.info('|     ___ _____      |')
Chef::Log.info('|    /\ (_)    \     |')
Chef::Log.info('|   /  \      (_,    |')
Chef::Log.info('|  _)  _\   _    \   |')
Chef::Log.info('| /   (_)\_( )____\  |')
Chef::Log.info('| \_     /    _  _/  |')
Chef::Log.info('|   ) /\/  _ (o)(    |')
Chef::Log.info('|   \ \_) (o)   /    |')
Chef::Log.info('|    \/________/     |')
Chef::Log.info('|____________________|')

include_recipe 'apt'
apt_repository 'nodejs' do
  uri 'ppa:chris-lea/node.js'
  distribution node['lsb']['codename']
end

package 'nodejs'
include_recipe "#{ cookbook_name }::_install_mysql"

## Set up Operator user/group
group(node['conqueso']['group']) { system true }
user node['conqueso']['user'] do
  comment 'Conqueso operator'
  gid node['conqueso']['group']
  home '/home/conqueso'
  shell '/usr/sbin/nologin'
  system true
end
directory node['conqueso']['home_dir'] do
  owner node['conqueso']['user']
  group node['conqueso']['group']
  recursive true
end

## Select installation method
Chef::Log.info("Installing conqueso from #{ node['conqueso']['install_method'] }")
case node['conqueso']['install_method'].to_s
when 'source'
  include_recipe "#{ cookbook_name }::_install_from_source"
when 'package'
  include_recipe "#{ cookbook_name }::_install_from_package"
else
  Chef::Application.fatal!('Instalation method '\
  "#{ node['conqueso']['install_method'] } is not supported")
end

## Log directory
directory ::File.join(node['conqueso']['install_dir'], 'logs') do
  owner node['conqueso']['user']
  group node['conqueso']['group']
  recursive true
end

## Install runtime dependencies
nodejs_npm 'install' do
  path node['conqueso']['install_dir']
  json true
  user node['conqueso']['user']
  group node['conqueso']['group']
  notifies :start, 'service[conqueso]' if node['conqueso']['start']
end

link node['conqueso']['service_dir'] do
  to node['conqueso']['install_dir']
  owner node['conqueso']['user']
  group node['conqueso']['group']
end

## Install forever globally
nodejs_npm 'forever' do
  version node['conqueso']['foreverversion']
end

## Configure init.d
cookbook_file '/etc/init.d/conqueso' do
  source 'conqueso-init.sh'
  mode '0755'
end

service 'conqueso' do
  supports :status => true, :restart => true
  action [:enable]
  action << :start if node['conqueso']['start']
end
