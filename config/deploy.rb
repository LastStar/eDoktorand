require 'mina/bundler'
require 'mina/rails'
require 'mina/git'

set :domain, 'edoktorand.czu.cz'
set :repository, 'git@github.com:LastStar/eDoktorand.git'
set :user, 'deploy'    # Username in the server to SSH to.

set :shared_paths, ['config/database.yml', 'log', 'public/pdf', 'tmp',
  'public/csv', 'config/initializers/security']

desc "Sets the production path and branch"
task :production do
  set :deploy_to, '/var/apps/new.edoktorand.czu.cz'
  set :branch, 'master'
end

desc "Sets the staging path and branch"
task :staging do
  set :deploy_to, '/var/apps/staging.edoktorand.czu.cz'
  set :branch, 'develop'
end

desc "Sets up environment on the server"
task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/shared/public/pdf"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/public/pdf"]

  queue! %[mkdir -p "#{deploy_to}/shared/public/csv"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/public/csv"]

  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]

  queue! %[mkdir -p "#{deploy_to}/shared/config/initializers"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config/initializers"]

  queue! %[mkdir -p "#{deploy_to}/shared/tmp"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp"]

  queue! %[touch "#{deploy_to}/shared/config/database.yml"]
  queue! %[chmod g+r,u+rw "#{deploy_to}/shared/config/database.yml"]
  queue! %[echo "copy ./config/database.yml.sample to #{deploy_to}/shared/config/database.yml and edit it"]

  queue! %[touch "#{deploy_to}/shared/config/initializers/security"]
  queue! %[chmod g+r,u+rw "#{deploy_to}/shared/config/initializers/security"]
  queue! %[echo "copy ./config/initializers/security.sample to #{deploy_to}/shared/config/initializers/security and edit it"]
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
