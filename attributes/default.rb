default['eas-jenkins']['jenkins_master'] = 'chef'
default['eas-jenkins']['jenkins_key_dir'] = '/root/.ssh'
default['eas-jenkins']['jenkins_key_file'] = 'id_rsa'
default['eas-jenkins']['jenkins_user'] = 'root'
default['eas-jenkins']['jenkins_group'] = 'root'
default['eas-jenkins']['AuthorizationStrategy'] = 'FullControlOnceLoggedInAuthorizationStrategy'
# installable software plugins
default['eas-jenkins']['plugins'] = ['ec2', 'chef-identity', 'email-ext', 'ruby-runtime',
                                     'git-client', 'git-parameter', 'git', 'github-api', 'github',
                                     'ghprb', 'gitlab-plugin', 'phing', 'repo', 'token-macro']

default['eas-jenkins']['chef-client']['name'] = 'chef-plugin'
default['eas-jenkins']['chef-client']['source'] = 'http://repo.jenkins-ci.org/releases/org/jenkins-ci/ruby-plugins/chef/0.1.1/chef-0.1.1.hpi'

default['eas-jenkins']['jobs'] = ['test_eas', 'test2_eas', 'eas-defaultd7', 'test_eas_demosite']
