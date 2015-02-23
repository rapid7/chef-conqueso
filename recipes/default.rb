include_recipe 'apt'

#Don't judge
Chef::Log.info("______ CONQUESO ______")
Chef::Log.info("|     ___ _____      |")
Chef::Log.info("|    /\\ (_)    \\     |")
Chef::Log.info("|   /  \\      (_,    | ")
Chef::Log.info("|  _)  _\\   _    \\   |  ")
Chef::Log.info("| /   (_)\\_( )____\\  |  ")
Chef::Log.info("| \\_     /    _  _/  | ")
Chef::Log.info("|   ) /\\/  _ (o)(    | ")
Chef::Log.info("|   \\ \\_) (o)   /    |  ")
Chef::Log.info("|    \\/________/     | ")
Chef::Log.info("|____________________|")

version = node['conqueso']['version']
artifactdir = "conqueso-#{version}"
artifactname = "conqueso-server-#{node['conqueso']['version']}.zip"
artifactdldir = "#{Chef::Config['file_cache_path']}/"
artifactdlfile = artifactdldir + artifactname
baseurl = "https://github.com/rapid7/conqueso/releases/download/"
url = baseurl+"#{node['conqueso']['version']}/"+artifactname

user "conqueso" do
  comment "conqueso system user"
  system true
  shell "/bin/false"
end

%w{unzip vim}.each do |pkg|
  package pkg do
    action :install
  end
end

include_recipe "conqueso-chef::install_nodejs"
include_recipe "conqueso-chef::install_mysql"

execute "install forever" do
  command "npm install -g forever@#{node['conqueso']['foreverversion']}"
end

if node['conqueso']['install']['fromsource'] && node['conqueso']['install']['frompackage']
   Chef::Log.fatal("You've chosen two sources for installation - please choose one or the other.")
   Chef::Log.fatal("Skipping the rest of the install at this point....")
else
  if node['conqueso']['install']['fromsource']
     include_recipe "conqueso-chef::install_from_source"
  end
  if node['conqueso']['install']['frompackage']
     include_recipe "conqueso-chef::install_from_package"
  end
end
