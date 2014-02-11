require 'open-uri'
include_recipe 'apt'
Chef::Log.info("About to install from a prepared package....")

version = node['conqueso']['version']
artifactdir = "conqueso-#{version}"
artifactname = "conqueso-server-#{node['conqueso']['version']}.zip"
artifactdldir = "#{Chef::Config['file_cache_path']}/" 
artifactdlfile = artifactdldir + artifactname
baseurl = "https://github.com/rapid7/conqueso/releases/download/"
url = baseurl+"#{node['conqueso']['version']}/"+artifactname

remote_file artifactdlfile do
  source url
  #Doing this for chef10 because the embedded certs are out of date
  conqueso_sha256 = node['conqueso']['sha256sum'] || open('https://github.com/rapid7/conqueso/releases/download/0.3.1/sha256sum.txt', :ssl_ca_cert=>"/etc/ssl/certs/ca-certificates.crt").read
  checksum conqueso_sha256
  mode 00644
end

directory "/srv/#{artifactdir}/logs" do
  owner "conqueso"
  group "conqueso"
  mode 00755
  recursive true
  action :create
end

execute "unzip" do
  installation_dir = "/srv/#{artifactdir}"
  cwd installation_dir
  command "unzip -q -o #{artifactdlfile}"
  action :run
  not_if { Dir.exists?("/srv/#{artifactdir}/server") }
end

file "/srv/#{artifactdir}/node_modules/sequelize/bin/sequelize" do
  mode 00755
end

#Wasn't quite sure how to make sure that this directory and all its children 
#are owned by conqueso so the log can be written.
execute "set /srv/#{artifactdir} owner" do
  command "chown -Rf conqueso:conqueso /srv/#{artifactdir}"
  only_if { Etc.getpwuid(File.stat("/srv/#{artifactdir}").uid).name != "conqueso" || Etc.getpwuid(File.stat("/srv/#{artifactdir}").gid).name != "conqueso" }
end

template "/srv/#{artifactdir}/server/config/settings.json" do
  source "/srv/#{artifactdir}/templates/settings.json.erb"
  local true
  owner "conqueso"
  group "conqueso"
end

link "/srv/conqueso" do
  to "/srv/#{artifactdir}"
  owner "conqueso"
  group "conqueso"
end

cookbook_file "/etc/init.d/conqueso" do
  source "conqueso-init.sh"
  mode 00755
end

#The goal of this next part is to only start up the service IF we've been asked to.
#The reasoning is if you're running chef-solo as part of an ami baking process, say 
#packer or something, you just want the service dumped out, but not started.  By 
#default, the service will start up to speed up dev work on this cookbook.
Chef::Log.info("The desired start mode is #{node['conqueso']['start']}.")
if node['conqueso']['start']
  service "conqueso" do
    status_command "service conqueso status"
    action [:enable, :start]
  end
else
  service "conqueso" do
    action :enable 
  end
end


