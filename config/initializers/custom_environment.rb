# mail configuration
ActionMailer::Base.delivery_method = :sendmail

# localization
$KCODE = 'u'
require 'jcode'

# mixins
require 'first_char_changer'
ExceptionNotifier.exception_recipients = %w(pepe@gravastar.cz dvorakv@oikt.czu.cz)
ExceptionNotifier.sender_address = 
  %("Edoktorand Exception Notifier" <exception.notifier@edoktorand.czu.cz>)
require 'gettext/rails'

