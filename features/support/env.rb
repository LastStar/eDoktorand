require 'rubygems'

# Sets up the Rails environment for Cucumber
ENV["RAILS_ENV"] = "cucumber"
require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')

require 'webrat'

Webrat.configure do |config|
  config.mode = :rails
end

require 'webrat/core/matchers'
require 'cucumber'

# Comment out the next line if you don't want Cucumber Unicode support
require 'cucumber/formatter/unicode'
require 'spec/rails'
require 'cucumber/rails/rspec'
