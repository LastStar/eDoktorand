# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.3' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.i18n.default_locale = :cs

  config.time_zone = 'UTC'

  config.action_controller.session = {
    :session_key => '_trunk-phd_session',
    :secret      => 'c485da746d1515cc7b6753b1b4b440f4313f429f30d3aa148b67a1da4b139eef8143902fd37670874ffc609ffa1cff25d675d5631b4ac83fca8200ae8c831f53'
  }

  config.action_controller.session_store = :active_record_store

  config.plugins = [ :localized_country_select, :translate, :exception_notification, :ar_fixtures, :acts_as_audited, :rtex, :tiny_mce ]

  config.gem "log4r"
  config.gem "mongrel"
  config.gem "ruby-net-ldap", :lib => "net/ldap"
  config.gem "mislav-will_paginate", :lib => 'will_paginate'
  config.gem "actionwebservice", :lib => 'actionwebservice', :version => '2.3.2'

end
