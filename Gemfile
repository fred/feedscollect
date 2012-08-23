source 'http://rubygems.org'

gem 'rails', '3.2.8'
gem 'thin'
gem 'pg'
gem 'rack-cache'

gem 'dalli', '~> 2.0'

# Autthentication
gem 'cancan'
gem 'devise', '~> 1.5.3'

### File Uploading
gem 'aws-sdk'
gem 'paperclip', '~> 2.7.0'

gem 'sass', '~> 3.1.21'
gem 'sass-rails', '~> 3.2.5'
gem 'coffee-rails', '~> 3.2.2'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'libv8'
  gem 'execjs'
  gem 'therubyracer', '0.10.2', require: 'v8', platform: :mri_19
  gem 'json'
  gem 'uglifier', '>= 1.2.4'
end

# Views
gem 'jquery-rails', '~> 2.0.2'

# Data parsing
gem 'feedzirra', git: 'git://github.com/lumpidu/feedzirra.git'

# To use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.0.0'


# Use unicorn as the web server
group :production, :development do
  gem 'unicorn', require: false, platform: :mri_19
end

group :test do
  gem 'turn', require: false
end

### Active Admin, loaded at end.
gem 'meta_search'
gem 'formtastic', '~> 2.1.1'
gem 'activeadmin', '~> 0.4.4'

# Twitter Bootstrap for Rails 3 Asset Pipeline
gem 'twitter-bootstrap-rails',
  git: 'git://github.com/seyhunak/twitter-bootstrap-rails.git',
  ref: '44cfe7f25a0fd305c763f1a299a418a92d027e64'


### Queueing System using Resque for Job Scheduling
gem 'resque', git: 'https://github.com/hone/resque.git', branch: 'keepalive'
gem 'resque-scheduler', require: 'resque_scheduler'
gem 'resque-history', git: 'git://github.com/fred/resque-history.git'

### For running all processes in the Procfile
gem 'foreman'

