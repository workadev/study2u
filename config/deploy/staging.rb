set :stage, :staging
server '18.142.32.29', user: 'ubuntu', roles: %w{app web db}
set :linked_files, %w{ config/database.yml .env.staging config/secrets.yml }
set :deploy_to, '/home/ubuntu/study2u_backend'
set :branch, "staging"
