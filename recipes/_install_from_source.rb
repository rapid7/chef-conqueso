#
# Cookbook Name:: conqueso
# Recipe:: _install_from_source
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
package 'git'
node.default['conqueso']['install_dir'] = "/srv/conqueso-#{ node['conqueso']['git_ref'] }"

## Installation directory
directory node['conqueso']['install_dir'] do
  owner node['conqueso']['user']
  group node['conqueso']['group']
  recursive true
end

git node['conqueso']['install_dir'] do
  repository node['conqueso']['git_url']
  reference node['conqueso']['git_ref']
  user node['conqueso']['user']
  group node['conqueso']['group']
end

log 'Install build dependencies' do
  notifies :install, 'nodejs_npm[install]', :immediate
end

## Install build dependencies
nodejs_npm 'grunt-cli'
nodejs_npm 'bower'

# This is now keeying off the root user to make sure the
# --allow-root flag INSIDE the grunt script is used.
execute 'grunt' do
  cwd node['conqueso']['install_dir']
  user node['conqueso']['user']
  group node['conqueso']['group']
  environment 'HOME' => node['conqueso']['home_dir']
end
