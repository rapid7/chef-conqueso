include_recipe 'apt'
Chef::Log.info("About to install from source....")

artifactdir = "conqueso-latest"

%w{git}.each do |pkg|
  package pkg do
    action :install
  end
end

git "/srv/conqueso-latest" do
  repository "https://github.com/rapid7/conqueso.git"
  reference "master"
end

execute "install grunt and bower" do
  command "npm install -g grunt-cli bower"
  cwd "/srv/#{artifactdir}"
end

execute "install dependencies" do
  command "npm install"
  cwd "/srv/#{artifactdir}"
end

#This is now keeying off the root user to make sure the 
#--allow-root flag INSIDE the grunt script is used.
execute "grunt" do
  command "grunt"
  cwd "/srv/#{artifactdir}"
end

directory "/srv/#{artifactdir}/logs" do
  owner "conqueso"
  group "conqueso"
  mode 00755
  recursive true
  action :create
end

#Wasn't quite sure how to make sure that this directory and all its children 
#are owned by conqueso so the log can be written.
execute "set /srv/#{artifactdir} owner" do
  command "chown -Rf conqueso:conqueso /srv/#{artifactdir}"
  only_if { Etc.getpwuid(File.stat("/srv/#{artifactdir}").uid).name != "conqueso" || Etc.getpwuid(File.stat("/srv/#{artifactdir}").gid).name != "conqueso" }
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

#If we're cloning from source, we're going to just 
#start the service
service "conqueso" do
  action :start 
end

