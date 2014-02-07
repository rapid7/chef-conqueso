include_recipe 'apt'
puts "installing from github"

artifactdir = "conqueso-latest"

user "conqueso" do
  comment "conqueso system user"
  system true
  shell "/bin/false"
end

%w{unzip vim git}.each do |pkg|
  package pkg do
    action :install
  end
end

#specific version of node
package "nodejs" do
  version "0.10.25-1chl1~precise1" #these versions tend to disappear frequently...
  action :install
end

###
###   insert git clone into /srv/artifact dir here
###

git "/srv/conqueso-latest" do
  repository "https://github.com/rapid7/conqueso.git"
  reference "master"
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

