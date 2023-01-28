# sudo is configured on the servers to not require a password for apt and reboot
namespace :sys do
  desc 'update system'
  task :update do
    on roles(:all) do
      execute 'sudo apt update'
      execute 'sudo apt --assume-yes upgrade'
    end
  end

  desc 'reboot system'
  task :reboot do
    on roles(:all) do
      execute 'sudo reboot'
    end
  end

  ssh_params = ' -i ~/.ssh/jhawk-aws.pem deploy@'
  desc 'open a login shell'
  task :login do
    on roles(:all) do |host|
      exec 'ssh' + ssh_params + host.hostname
    end
  end

  desc 'open an ftp connection'
  task :ftp do
    on roles(:all) do |host|
      exec 'sftp' + ssh_params + host.hostname
    end
  end

  rails_cmd = "RAILS_ENV=production bundle exec rails "
  desc 'open a rails console'
  task :rails do
    on roles(:all) do |host|
      cd_cmd = "cd #{fetch(:deploy_to)}/current && "
      command = cd_cmd + rails_cmd + 'console'
      exec 'ssh' + ssh_params + host.hostname + " -t '#{command}'"
    end
  end

  desc 'open a database console'
  task :db do
    on roles(:all) do |host|
      cd_cmd = "cd #{fetch(:deploy_to)}/current && "
      command = cd_cmd + rails_cmd + 'dbconsole'
      exec 'ssh' + ssh_params + host.hostname + " -t '#{command}'"
    end
  end
end
