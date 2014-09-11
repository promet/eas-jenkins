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

include_recipe 'jenkins::master'
include_recipe 'git'



%w(github gerrit).each do |plugin|
  jenkins_plugin plugin
end

group 'shadow' do
  action :modify
  members ['jenkins']
  append true
end


xml = File.join(Chef::Config[:file_cache_path], 'test_eas-config.xml')

cookbook_file xml do
  source 'test_eas-config.xml'
end


jenkins_job 'test_eas' do
  config xml
end

jenkins_job 'test_eas' do
  action :enable
end


cookbook_file '/var/lib/jenkins/config.xml' do
  source 'config.xml'
  owner 'jenkins'
  group 'jenkins'
  mode 0644
  action :create_if_missing
  notifies :restart, 'service[jenkins]'
end
