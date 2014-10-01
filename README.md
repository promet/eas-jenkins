# eas-jenkins-cookbook

Bootstrapping a single jenkins CI instance for EAS infrastructure project. Sets up a Jenkins instance using Jenkins’ own user database for authentication.

## Supported Platforms

- Ubuntu 14.04 (may work on other versions of Ubuntu, but target release is 14.04)

## Attributes
Currently this cookbook requires a jenkins version 1.555 due to an [issue in Jenkins CLI](https://issues.jenkins-ci.org/browse/JENKINS-22346) with newer versions. On Debian based operating systems the use of the WAR based installing is therefore necessary. 

```rb
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
```
Overwrites to community cookbook:
```
normal['jenkins']['master']['install_method'] = 'war'
normal['jenkins']['master']['version'] = '1.555'
normal['jenkins']['master']['source'] = "#{node['jenkins']['master']['mirror']}/war/#{node['jenkins']['master']['version']}/jenkins.war"
```
## Usage

### Data Bags
Jenkins user are created using data bags
```
{
  "id": "juser2",
  "password": "jpass",
  "email": "juser2@example.com",
  "full_name": "J the User II",
  "ssh_keys": [ "ssh-rsa AAAAB3McaC1yc......" ]
}
```

### Jenkins Plugins

Plugins are added to the jenkins configuration via the `['eas-jenkins']['plugins']` resource in the `default` attributes. Adding or removing plugins is achieved by edithing the list of names in the `default` attributes file:

### Adding jobs

Similar to the way jenkins plugin are added to the configuration, build jobs can be added to the initial configuration.
In addition to adding the job name to the list a `config.xml` file need to get added to `files/default/` directory of the cookbook for each job. The following naming convention is implemented - a `JOBNAME-config.xml` relates to a job named `JOBNAME`. 


### eas-jenkins::default

Include `eas-jenkins` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[eas-jenkins::default]"
  ]
}
```

## License and Authors

Author:: opscale (<cookbooks@opscale.com>)
