require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Auto-require default libraries and those for the current Rails environment.
Bundler.require :default, Rails.env

module Phdstudy
  class Application < Rails::Application
    config.i18n.default_locale = :cs
    config.time_zone = 'UTC'
    config.action_controller.session = {
      :session_key => '_trunk-phd_session',
      :secret      => 'c485da746d1515cc7b6753b1b4b440f4313f429f30d3aa148b67a1da4b139eef8143902fd37670874ffc609ffa1cff25d675d5631b4ac83fca8200ae8c831f53'
    }

    config.action_controller.session_store = :active_record_store

    config.plugins = [ :localized_country_select, :exception_notification, :rtex, :tiny_mce ]
  end
end

