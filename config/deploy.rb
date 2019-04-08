# Config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

set :application, 'Instantly'
set :repo_url,    'git@github.com:E-Xor/Instantly.git'
set :deploy_to,   '/var/www/vhosts/Instantly'
set :user,        'deploy'

# Otherwise it will use defaut gemset. Gemset should be created prior to first cap run.
set :rvm_ruby_version, 'ruby-2.6.2@instantly'

# Symlinks to dirs in shared folder
set :linked_dirs, %w{log tmp public/assets} # Removed bin, was causing issues with rails command in production

set :keep_releases, 2

set :ssh_options, { forward_agent: true, user: 'deploy' }

# Defaults are --deployment --quiet
set :bundle_flags, '--deployment'

namespace :deploy do

  desc 'Put real configs in place'
  before 'symlink:shared', :copy_configs do
    on roles(:web) do
      within release_path do
        info '===========> COPY CONFIGS'
        execute "cp /home/deploy/configs/* #{release_path}/config/"
      end
    end
  end

  desc 'Migrations'
  before :restart, :run_migrations do
    on roles(:web) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          info '===========>> RUN MIGRATIONS'
          execute :rake, 'db:migrate'
        end
      end
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:web) do
      info '===========> RESTART APP'
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

end
