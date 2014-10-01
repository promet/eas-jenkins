normal['jenkins']['master']['install_method'] = 'war'
normal['jenkins']['master']['version'] = '1.555'
normal['jenkins']['master']['source'] = "#{node['jenkins']['master']['mirror']}/war/#{node['jenkins']['master']['version']}/jenkins.war"
