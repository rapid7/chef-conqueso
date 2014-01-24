#
# Cookbook Name:: conqueso-chef
# Recipe:: default
#
# Copyright 2014, Rapid7, LLC.
#
# All rights reserved - Do Not Redistribute
#
include_recipe "nodejs::install_from_binary"
include_recipe "nodejs::npm"
if node['install']['mysqlserver']
   include_recipe "mysql::server"
end
if node['install']['mysqlclient']
   include_recipe "mysql::client"
end


version = node['conqueso']['version']
artifactdir = "conqueso-#{version}"
artifactname = "conqueso-server-#{node['conqueso']['version']}.zip"
artifactdldir = "#{Chef::Config['file_cache_path']}/" 
artifactdlfile = artifactdldir + artifactname
baseurl = "https://github.com/rapid7/conqueso/releases/download/"
url = baseurl+"#{node['conqueso']['version']}/"+artifactname

package "unzip" do
  action :install
end

remote_file artifactdlfile do
  source url
  mode 00644
end

directory "/srv/#{artifactdir}" do
  owner "root"
  group "root"
  mode 00755
  action :create
end

execute "unzip" do
  installation_dir = "/srv/#{artifactdir}"
  cwd installation_dir
  command "unzip -o #{artifactdlfile}"
  action :run
  not_if "test -d /srv/#{artifactdir}/server"
end

template "/srv/#{artifactdir}/server/config/settings.json" do
  local true
  source "/srv/#{artifactdir}/templates/settings.json.erb"
end

link "/srv/conqueso" do
  action :delete
  only_if "test -L /srv/conqueso"
end

link "/srv/conqueso" do
  to "/srv/#{artifactdir}"
end
