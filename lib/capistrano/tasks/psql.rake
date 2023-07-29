namespace :psql do
  desc 'create a database backup and download it'
  task :pull do
    backup = nil
    on roles(:all) do
      info "Capturing jenniferhawk-prod backup"
      backup = capture 'pg_dump -Fc jenniferhawk-prod'
      download! backup
    end
  end
end
