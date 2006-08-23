
# mail configuration
ActionMailer::Base.delivery_method = :sendmail

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

# mixins
require 'first_char_changer'
ExceptionNotifier.exception_recipients = %w(pepe@gravastar.cz dvorakv@oikt.czu.cz)
ExceptionNotifier.sender_address = 
  %("Edoktorand Exception Notifier" <exception.notifier@edoktorand.czu.cz>)
