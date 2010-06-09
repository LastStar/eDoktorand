# mail configuration
ActionMailer::Base.delivery_method = :smpt
ActionMailer::Base.smtp_settings = {
  :address => 'mail.oikt.czu.cz'
}

# mixins
require 'first_char_changer'

ExceptionNotification::Notifier.configure_exception_notifier do |config|
  config[:app_name]                 = "[eDoktorand]"
  config[:sender_address]           = "system@edoktorand.czu.cz"
  config[:exception_recipients]     = ["josef.pospisil@laststar.eu"] # You need to set at least one recipient if you want to get the notifications
end

# faculty dependent configurations
FACULTY_CFG =
  YAML::load(File.open("#{Rails.root}/config/initializers/faculty_configurations.yml"))
