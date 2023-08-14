set :stage, :production
server '', user: 'ubuntu', roles: %w{app web db}
set :linked_files, %w{ config/database.yml .env.production config/secrets.yml }
set :deploy_to, '/home/ubuntu/study2u_backend'
set :branch, "production"
