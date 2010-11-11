# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Recorder::Application.initialize!

MEMCACHE_HOST = ['192.168.1.107:11211']
MEMCACHE_PREFIX = 'ttgate_'
