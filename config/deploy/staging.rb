set :stage, :staging
server '', user: 'ubuntu', roles: %w{app web db}
set :linked_files, %w{ config/database.yml .env.staging config/secrets.yml }
set :deploy_to, '/home/ubuntu/study2u_backend'
set :branch, "staging"
