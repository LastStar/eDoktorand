# mail configuration
ActionMailer::Base.delivery_method = :sendmail

# localization
$KCODE = 'u'
require 'jcode'

# mixins
require 'first_char_changer'
ExceptionNotifier.exception_recipients = %w(pepe@gravastar.cz)
ExceptionNotifier.sender_address = 
  %("Edoktorand Exception Notifier" <exception.notifier@edoktorand.czu.cz>)

# Set authenticate method of user login
AUTH_SYSTEM = 'ldap'

# faculty dependent configurations
FACULTY_CFG =
  YAML::load(File.open("#{RAILS_ROOT}/config/initializers/faculty_configurations.yml"))
ActionMailer::Base.delivery_method = :sendmail


# webservices stuff
Dir['app/apis/*.rb'].each {|file| require file}
