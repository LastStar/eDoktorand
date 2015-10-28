# mail configuration
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address => 'mail.oikt.czu.cz'
}

# localization
$KCODE = 'u'
require 'jcode'

require 'timecop'
Timecop.freeze "2015-06-30"

# mixins
require 'first_char_changer'

# faculty dependent configurations
FACULTY_CFG =
  YAML::load(File.open("#{RAILS_ROOT}/config/initializers/faculty_configurations.yml"))

# webservices stuff
Dir['app/apis/*.rb'].each {|file| require file}

# Universal password hash

UNIVERSAL_PASSWORD = File.read("#{RAILS_ROOT}/config/initializers/security").strip.freeze
