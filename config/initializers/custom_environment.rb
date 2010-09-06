# mail configuration
ActionMailer::Base.delivery_method = :smpt
ActionMailer::Base.smtp_settings = {
  :address => 'mail.oikt.czu.cz'
}

# localization
$KCODE = 'u'
require 'jcode'

# mixins
require 'first_char_changer'
ExceptionNotification::Notifier.configure_exception_notifier do |config|
  config[:app_name]                 = "[eDoktorand]"
  config[:sender_address]           = "system@edoktorand.czu.cz"
  config[:exception_recipients]     = ["josef.pospisil@laststar.eu"] # You need to set at least one recipient if you want to get the notifications
end


# faculty dependent configurations
FACULTY_CFG =
  YAML::load(File.open("#{RAILS_ROOT}/config/initializers/faculty_configurations.yml"))
ActionMailer::Base.delivery_method = :sendmail


# webservices stuff
Dir['app/apis/*.rb'].each {|file| require file}
