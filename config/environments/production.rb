# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_view.cache_template_loading            = true

# See everything in the log (default is :info)
# config.log_level = :debug

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

# Enable threaded mode
# config.threadsafe!
#
GET_SUBJECT_SERVICE_ENDPOINT = {
  :uri => 'http://comanche.czu.cz/axis2/services/GetSubjectService.GetSubjectServiceHttpSoap12Endpoint/',
  :version => 2
}

CENTRAL_REGISTER_SERVICE = {
  :uri => 'http://193.84.33.16:80/axis2/services/OSZService.OSZServiceHttpSoap11Endpoint/',
  :version => 2
}
