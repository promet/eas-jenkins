# eas-jenkins-cookbook

Bootstrapping a single jenkins CI instance for EAS infrastructure project. Sets up a Jenkins instance using os based authentication. Adds 2 sample build jobs and installs `git`, `gerrit` plugins.

## Supported Platforms

- Ubuntu 14.04 (may work on other versions of Ubuntu, but target release is 14.04)

## Attributes
Currently this cookbook requires a jenkins version 1.555 due to an [issue in Jenkins CLI](https://issues.jenkins-ci.org/browse/JENKINS-22346) with newer versions. On Debian based operating systems the use of the WAR based installing is therefore necessary. 

```rb
normal['jenkins']['master']['install_method'] = 'war'
normal['jenkins']['master']['version'] = '1.555'
normal['jenkins']['master']['source'] = "#{node['jenkins']['master']['mirror']}/war/#{node['jenkins']['master']['version']}/jenkins.war"
default['eas-jenkins']['AuthorizationStrategy'] = 'FullControlOnceLoggedInAuthorizationStrategy'
```

## Usage

### Jenkins Plugins

Plugins are added to the jenkins configuration via the `jenkins_plugin` resource in the `default` recipe. Currently only the `github` and  `gerrit` will be installed - besides plugins installed by default. Adding or removing plugins is achieved by edithing the list of names in the `default` recipe (see code snippet below):

```
%w(github gerrit).each do |plugin|
```

### Adding jobs

Similar to the way jenkins plugin are added to the configuration, build jobs can be added to the initial configuration (see code snippet): 

```
%w(test_eas test2_eas).each do |job|
```
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
