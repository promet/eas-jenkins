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

jenkins_script 'setup authentication' do
  command <<-EOH.gsub(/^ {4}/, '')
    import jenkins.model.*
    def instance = Jenkins.getInstance()

    import hudson.security.*
    def realm = new PAMSecurityRealm("sshd")
    instance.setSecurityRealm(realm)

    def strategy = new #{node['eas-jenkins']['AuthorizationStrategy']}()
    instance.setAuthorizationStrategy(strategy)

    instance.save()
  EOH
end
