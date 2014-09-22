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

user 'chef'

require 'net/ssh'

key = OpenSSL::PKey::RSA.new(4096)
private_key = key.to_pem
public_key  = "#{key.ssh_type} #{[key.to_blob].pack('m0')}"

# Create the Jenkins user with the public key
jenkins_user 'chef' do
  public_keys [public_key]
end

# Set the private key on the Jenkins executor
ruby_block 'set private key' do
  # Note: leave this line as is will not work with preferred syntax
  # Ignore Foodcritic FC001 warning
  block { node.run_state[:jenkins_private_key] = private_key }
end

%w(github gerrit).each do |plugin|
  jenkins_plugin plugin do
    notifies :restart, 'service[jenkins]'
  end
end

group 'shadow' do
  action :modify
  members [node['jenkins']['master']['user']]
  append true
end

include_recipe 'eas-jenkins::_auth_os'

jenkins_command 'login'

%w(test_eas test2_eas).each do |job|
  xml = File.join(Chef::Config[:file_cache_path], "#{job}-config.xml")

  cookbook_file xml do
    source "#{job}-config.xml"
  end

  jenkins_job job do
    config xml
  end
end
