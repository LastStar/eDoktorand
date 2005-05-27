
ActionMailer::Base.server_settings = {
  :address  => "smtp.beneta.cz",
  :port  => 25, 
	:domain  => "smtp.beneta.cz",
  :authentication  => :plain
  } 

require 'gettext_extension'
$KCODE = 'u'
require 'jcode'
