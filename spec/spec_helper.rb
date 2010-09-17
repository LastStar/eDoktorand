# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require File.expand_path(File.dirname(__FILE__) + "/blueprints")
require 'rspec/rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # Machinist stuff
  config.before(:all)    { Sham.reset(:before_all)  }
  config.before(:each)   { Sham.reset(:before_each) }

  # Set locale to cs
  I18n.locale = :cs
end

# mocks user
def mocked_user
  @mocked_user ||= mock(User)
end

def mocked_faculty(stubs = {})
  @mock_faculty ||= mock(Faculty, stubs)
end

def mocked_specialization
  @mock_specialization ||= mock(Specialization, :to_yaml => "specialization") # hacked to_yaml cause dup of anonymous class burns 
end
  
def mocked_relation
  @mocked_relation ||= mock(ActiveRecord::Relation)
end

def mocked_faculty_secretary(stubs = {})
  @mocked_faculty_secretary ||= mock(FacultySecretary, stubs)
end

def mocked_candidate(stubs = {})
  @mocked_candidate ||= mock(Candidate, stubs)
end

def mocked_department(stubs = {})
  @mocked_department ||= mock(Department, stubs)
end

def mocked_email
  @mocked_email = mock(Contact, :name => 'example@example.com')
end

