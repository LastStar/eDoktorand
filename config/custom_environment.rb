
# mail configuration
ActionMailer::Base.server_settings = {
  :address  => "smtp.beneta.cz",
  :port  => 25, 
	:domain  => "smtp.beneta.cz",
  :authentication  => :plain
  } 

# localization
require 'gettext_extension'
$KCODE = 'UTF8'
require 'jcode'

ActionController::CgiRequest::DEFAULT_SESSION_OPTIONS.update(
 :database_manager => CGI::Session::ActiveRecordStore
)

# faculty dependent configurations
FACULTY_CFG =
YAML::load(File.open("#{RAILS_ROOT}/config/faculty_configurations.yml"))

