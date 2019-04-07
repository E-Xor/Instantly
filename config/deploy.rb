# Config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

set :application, 'Instantly'
set :repo_url,    'git@github.com:E-Xor/Instantly.git'
set :deploy_to,   '/var/www/vhosts/Instantly'
set :user,        'deploy'

# Otherwise it will use defaut gemset. Gemset should be created prior to first cap run.
set :rvm_ruby_version, 'ruby-2.6.2@instantly'

# Symlinks to dirs in shared folder
set :linked_dirs, %w{bin log tmp public/assets}

set :keep_releases, 2

set :ssh_options, { forward_agent: true, user: 'deploy' }

# Defaults are --deployment --quiet
set :bundle_flags, '--deployment'

set :assets_roles, [] # temporarily disable assets

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app) do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

end
