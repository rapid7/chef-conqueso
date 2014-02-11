include_recipe 'apt'

apt_repository 'node.js' do
  uri 'http://ppa.launchpad.net/chris-lea/node.js/ubuntu'
  distribution 'precise'
  components ['main']
  keyserver "keyserver.ubuntu.com"
  key "C7917B12"
  action :add
end

#specific version of node
package "nodejs" do
  version "0.10.25-1chl1~precise1" #these versions tend to disappear frequently...
  action :install
end

