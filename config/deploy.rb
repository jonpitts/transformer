require 'mina/bundler'
require 'mina/rails'
require 'mina/git'


# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :domain, ''
set :deploy_to, '/var/www/transformer'
set :repository, 'ssh://fclacode.fcla.edu/data/git/DLS/mods-transformer.git'
set :branch, 'master'
set :term_mode, :system

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, ['config/database.yml', 'log']

# Optional settings:
#   set :user, 'foobar'    # Username in the server to SSH to.
#   set :port, '30000'     # SSH port number.

set :user, 'deploy'
set :port, '22'

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  if ENV["USER"] == "Carol"
    set :user, 'cchou'
  else
    set :user, ENV['USER']
  end
  queue %{
    echo "-----> loading environment"
    #{echo_cmd %[export PATH=/opt/ruby-1.9.3-p545/bin:/usr/pgsql-9.0/bin:$PATH]}
    #{echo_cmd %[echo $PATH]}
  }
  
end

#subtasks for different deployments
#deploy to ripple
task :ripple => :environment do
  set :domain, 'ripple.fcla.edu'
  set :keep_releases, 3
  invoke :deploy
end

#deploy to marsala
task :marsala => :environment do
  set :domain, 'marsala.fcla.edu'
  set :keep_releases, 5
  invoke :deploy
end

task :test => :environment do
  set :bundle_options, lambda { %{--path "#{bundle_path}" --binstubs bin/ --deployment} }
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  invoke :arg_check
  
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]

  queue! %[touch "#{deploy_to}/shared/config/database.yml"]
  queue  %[echo "-----> Be sure to edit 'shared/config/database.yml'."]
end

desc "Check for parameters.  Used in setup."
task :arg_check do
  case ARGV[1]
  when 'ripple'
    set :domain, 'ripple.fcla.edu'
  when 'marsala'
    set :domain, 'marsala.fcla.edu'
  else
    puts "Example setup use: mina setup ripple"
    exit
  end
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'deploy:cleanup'
    #invoke :'rails:db_migrate'
    #invoke :'rails:assets_precompile'

    to :launch do
      queue "touch #{deploy_to}/tmp/restart.txt"
    end
  end
end

# For help in making your deploy script, see the Mina documentation:
#
#  - http://nadarei.co/mina
#  - http://nadarei.co/mina/tasks
#  - http://nadarei.co/mina/settings
#  - http://nadarei.co/mina/helpers

