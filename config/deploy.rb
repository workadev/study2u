set :rvm_type, :user
set :rvm_ruby_version, '3.1.2'
set :repo_url, 'git@github.com:workadev/study2u.git'
set :application, 'study2u_backend'
set :user, 'ubuntu'
set :puma_user, 'ubuntu'
set :puma_threads, [5, 5]
set :puma_workers, 3
set :pty, true
set :use_sudo, false
set :deploy_via, :remote_cache
set :puma_bind, "unix:///#{shared_path}/tmp/sockets/puma.sock"
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{shared_path}/log/puma.error.log"
set :puma_error_log, "#{shared_path}/log/puma.access.log"
set :ssh_options, { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true
set :branch, "development"
set :keep_releases, 3
set :linked_dirs, %w{ log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system }

namespace :deploy do
  desc "Run rake yarn install"
  task :yarn_install do
    on roles(:web) do
      within release_path do
        execute("cd #{release_path} && yarn install --silent --no-progress --no-audit --no-optional")
      end
    end
  end

  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/#{fetch(:branch)}`
        puts "WARNING: HEAD is not the same as origin/#{fetch(:branch)}"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart nginx and sidekiq'
  task :restart_server do
    on roles(:app) do
      execute "sudo service nginx restart"
      execute "sudo service sidekiq restart"
    end
  end

  before "deploy:assets:precompile", "deploy:yarn_install"
  before :starting, :check_revision
  after :finishing, :cleanup
  after :finishing, :restart
  after :finishing, :restart_server
  after :finishing, "anycable:restart"
end
