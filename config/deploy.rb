# config valid for current version and patch releases of Capistrano
lock "~> 3.11.2"

set :application, "Qna"
set :repo_url, "git@github.com:novill/qna.git"

ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call
# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deployer/qna"
set :deploy_user, 'deployer'

# Default value for :linked_files is []
append :linked_files, "config/database.yml", "config/master.key",'.env'

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system","storage"

