#
# Cookbook Name:: conqueso
# Recipe:: _install_from_package
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
package 'unzip'

node.default['conqueso']['package_name'] = "conqueso-server-#{ node['conqueso']['version'] }.zip"
node.default['conqueso']['install_dir'] = "/srv/conqueso-#{ node['conqueso']['version'] }"
node.default['conqueso']['package_url'] = 'https://github.com/rapid7/conqueso/'\
  "releases/download/#{ node['conqueso']['version'] }/#{ node['conqueso']['package_name'] }"
package_artifact = ::File.join(Chef::Config['cache_path'], node['conqueso']['package_name'])

remote_file package_artifact do
  source node['conqueso']['package_url']
  checksum node['conqueso']['package_shasum']
end

directory node['conqueso']['install_dir'] do
  owner node['conqueso']['user']
  group node['conqueso']['group']
  recursive true
end

execute 'unzip-conqueso-package' do
  cwd node['conqueso']['install_dir']
  user node['conqueso']['user']
  group node['conqueso']['group']
  command "unzip -q -o #{ package_artifact }"
  not_if { ::File.exist?(::File.join(node['conqueso']['install_dir'], 'package.json')) }
end

template ::File.join(node['conqueso']['install_dir'], 'server/config/settings.json') do
  source ::File.join(node['conqueso']['install_dir'], 'templates/settings.json.erb')
  local true
  owner node['conqueso']['user']
  group node['conqueso']['group']
  notifies :restart, 'service[conqueso]' if node['conqueso']['start']
end
