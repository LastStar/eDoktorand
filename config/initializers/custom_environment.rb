# mail configuration
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address => 'mail.oikt.czu.cz'
}

# localization
$KCODE = 'u'
require 'jcode'

# mixins
require 'first_char_changer'

# faculty dependent configurations
FACULTY_CFG =
  YAML::load(File.open("#{RAILS_ROOT}/config/initializers/faculty_configurations.yml"))


# webservices stuff
Dir['app/apis/*.rb'].each {|file| require file}
