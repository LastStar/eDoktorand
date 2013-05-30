require 'mina/bundler'
require 'mina/rails'
require 'mina/git'

set :domain, 'edoktorand.czu.cz'
set :deploy_to, '/var/apps/new.edoktorand.czu.cz'
set :repository, 'git@github.com:LastStar/eDoktorand.git'
set :branch, 'master'
set :user, 'deploy'    # Username in the server to SSH to.

set :shared_paths, ['config/database.yml', 'log', 'public/pdf', 'tmp']

task :environment do
end

task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/shared/public/pdf"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/public/pdf"]

  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]

  queue! %[mkdir -p "#{deploy_to}/shared/tmp"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp"]

  queue! %[touch "#{deploy_to}/shared/config/database.yml"]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'

    invoke :'rails:db_migrate'

    to :launch do
      queue 'touch tmp/restart.txt'
    end
  end
end
