require 'resque/server'
require 'resque_scheduler'

if ENV["REDISTOGO_URL"]
  uri = URI.parse(ENV["REDISTOGO_URL"])
  Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
else
  Resque.redis = Redis.new(:host => "127.0.0.1", :port => 6379)
end

RESQUE_USERNAME = "welcomez" || ENV['RESQUE_USERNAME']
RESQUE_PASSWORD = "welcomez" || ENV['RESQUE_PASSWORD']

Resque::Server.use Rack::Auth::Basic, "Resque-Technews" do |username, password|
  [username, password] == [RESQUE_USERNAME, RESQUE_PASSWORD]
end

# The schedule doesn't need to be stored in a YAML, it just needs to
# be a hash.  YAML is usually the easiest.
Resque.schedule = YAML.load_file(Rails.root.join('config', 'resque_schedule.yml'))
