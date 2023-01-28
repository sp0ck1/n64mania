namespace :pg do
    desc 'run any pending database migrations'
    task :migrate do
      on roles(:all) do |h|
        info "Migration #{h} database"
        execute 'cd ~/skudb-gamma/current; RAILS_ENV=production bundle exec rake db:migrate'
      end
    end
  
    desc 'create a database backup of this instance'
    task :dump do
      on roles(:all) do |h|
        info "Capturing #{h} backup"
        execute 'pg dump'
      end
    end
  
    desc 'create a database backup and download it'
    task :pull do
      backup = nil
      on roles(:all) do |h|
        info "Capturing #{h} backup"
        backup = capture 'pg dump'
        download! backup, './'
      end
    end
  
    desc 'upload a database backup and restore from it'
    task :push do
      ask :name, nil
      on roles(:all) do
        upload! "#{fetch(:name)}", "/home/deploy/db/"
        name = File.basename(fetch(:name))
        execute "pg put -b '#{name}'"
        execute "pg restore -b '#{name}'"
      end
    end
  
    desc 'download an existing database backup'
    task :get do
      backup = nil
      on roles(:all) do |h|
        info "Downloading latest #{h} backup"
        backup = capture "pg get"
        download! backup, './'
      end
    end
  
    namespace :get do
      desc 'download an existing database backup matched by ID'
      task :id do
        ask :id, nil
        backup = nil
        on roles(:all) do |h|
          info "Downloading #{h} backup: #{fetch(:id)}"
          backup = capture "pg get -i #{fetch(:id)}"
          download! backup, './'
        end
      end
  
      desc 'download an existing database backup matched by name'
      task :name do
        ask :name, nil
        backup = nil
        on roles(:all) do |h|
          info "Downloading #{h} backup: #{fetch(:name)}"
          backup = capture "pg get -n #{fetch(:name)}"
          download! backup, './'
        end
      end
    end
  
    desc 'upload a database backup'
    task :put do
      ask :name, nil
      on roles(:all) do
        upload! "#{fetch(:name)}", "/home/deploy/db/"
        name = File.basename(fetch(:name))
        execute "pg put -b '#{name}'"
      end
    end
  
    namespace :restore do
      desc 'restore database from an existing backup'
      task :latest do
        on roles(:all) do
          execute "pg restore"
        end
      end
  
      desc 'restore database from an existing backup'
      task :id do
        ask :id, nil
        on roles(:all) do
          execute "pg restore -i #{fetch(:id)}"
        end
      end
  
      desc 'restore database from an existing named backup'
      task :name do
        ask :name, nil
        on roles(:all) do
          execute "pg restore -n #{fetch(:name)}"
        end
      end
    end
  
    desc 'list most recent database backups'
    task :list do
      on roles(:all) do
        execute 'pg list'
      end
    end
  
    namespace :list do
      desc 'list all available backups'
      task :all do
        on roles(:all) do
          execute 'pg list -a'
        end
      end
    end
  end
  