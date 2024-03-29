source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.7'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.0.6'
# Use PostgresQL as the database for Active Record
gem 'pg', '~> 1.4'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Use SCSS for stylesheets
 gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'
gem "net-http"
# Use Active Storage variant
# gem 'image_processing', '~> 1.2'
# For HTML meta tags
gem "meta-tags"

gem "ed25519", "< 2.0"
gem "bcrypt_pbkdf", "< 2.0"

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

### Custom Dependencies ###

# Change console to pry from irb
gem 'pry-rails'

# Add Solargraph for VSCode
gem 'solargraph', group: :development

# Use JQuery for Rails
# Should test if these are working and remove if not
gem 'jquery-rails'
gem 'jquery-ui-rails'

#Support Placements primary key scheme
gem 'composite_primary_keys'

gem 'figaro'
gem 'listen', '~> 3.2'

## OmniAuth & OmniAuth-Twitch
gem 'omniauth'
gem 'omniauth-rails_csrf_protection'
gem 'omniauth-twitch'

### End Custom Dependencies ###

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

## from https://gist.github.com/linuxdevops-34/664236a011db3ebe3c12a1f2646f49e6
  gem 'capistrano'
  gem 'capistrano3-puma'
  gem 'capistrano-rails', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rvm'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
