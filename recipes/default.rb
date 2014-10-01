#
# Cookbook Name:: eas-jenkins
# Recipe:: default
#
# Copyright (C) 2014 opscale
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'jenkins::java'
include_recipe 'jenkins::master'
include_recipe 'git'

require 'net/ssh'

key = OpenSSL::PKey::RSA.new(4096)
private_key = key.to_pem
public_key  = "#{key.ssh_type} #{[key.to_blob].pack('m0')}"

pkey = "#{node['eas-jenkins']['jenkins_key_dir']}/#{node['eas-jenkins']['jenkins_key_file']}"

directory node['eas-jenkins']['jenkins_key_dir'] do
  owner node['eas-jenkins']['jenkins_user']
  group node['eas-jenkins']['jenkins_group']
  mode 00700
end

template pkey do
  owner node['eas-jenkins']['jenkins_user']
  group node['eas-jenkins']['jenkins_group']
  variables(private_key: private_key)
  mode 00600
  action :create_if_missing
end

# Create the Jenkins user with the public key access -only once!!!
# Otherwise the next chef-client run will fail
jenkins_user node['eas-jenkins']['jenkins_master'] do
  public_keys [public_key]
  not_if { File.exist?("#{node['jenkins']['master']['home']}/users/#{node['eas-jenkins']['jenkins_master']}") }
end

# Set the private key on the Jenkins executor
ruby_block 'set private key' do
  # Note: leave this line as is will not work with preferred syntax
  # Ignore Foodcritic FC001 warning
  block { node.run_state[:jenkins_private_key] = File.read(pkey) }
end

jenkins_users = data_bag('jenkins_users')
Chef::Log.info("Juser: #{jenkins_users}")
jenkins_users.each do |juser|
  jenkins_user = data_bag_item('jenkins_users', juser)
  Chef::Log.info("Juser: #{juser}")
  jenkins_user juser do
    full_name jenkins_user['full_name']
    email jenkins_user['email']
    password jenkins_user['password']
    public_keys jenkins_user['public_keys']
  end

end

node['eas-jenkins']['plugins'].each do |plugin|
  jenkins_plugin plugin do
    notifies :restart, 'service[jenkins]'
  end
end

jenkins_plugin node['eas-jenkins']['chef-client']['name'] do
  source node['eas-jenkins']['chef-client']['source']
  notifies :restart, 'service[jenkins]'
end

include_recipe 'eas-jenkins::_auth_basic'

node['eas-jenkins']['jobs'].each do |job|
  xml = File.join(Chef::Config[:file_cache_path], "#{job}-config.xml")

  cookbook_file xml do
    source "#{job}-config.xml"
  end

  jenkins_job job do
    config xml
  end
end
