# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path(File.join(File.dirname(__FILE__),'..','config','environment'))
require 'spec/autorun'
require 'spec/rails'
require "timecop"
require "factory_girl"
require "./spec/factories"
require "curb"


Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

Spec::Runner.configure do |config|
  # If you're not using ActiveRecord you should remove these
  # lines, delete config/database.yml and disable :active_record
  # in your config/boot.rb
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'

end

# mocks user
def mocked_user
  @mocked_user ||= mock(User)
end

def mock_service(body)
  headers =<<HEADERS
Connection: close
Content-Type: text/xml;charset=UTF-8
Date: #{Time.now.strftime('%c')}
Server: Apache-Coyote/1.1
HEADERS
  Handsoap::Http.drivers[:mock] = Handsoap::Http::Drivers::MockDriver.new :headers => headers.gsub(/\n/, "\r\n"),
                                                                          :content => body,
                                                                          :status => 200
  Handsoap.http_driver = :mock
  Handsoap::Http.drivers[:mock].new
end

def prepare_scholarships
  [User, Role, Index, Scholarship].each {|c| c.send(:delete_all)}
  Timecop.freeze(Date.parse('2012-02-02'))
  ScholarshipMonth.open
  @index1 = Factory(:index, :student => Factory(:student))
  @index2 = Factory(:index, :department => Factory(:department,
                                                   :faculty => @index1.faculty),
                    :student => Factory(:student))
  @index3 = Factory(:index, :student => Factory(:student))
  [@index1, @index2].each do |i|
    RegularScholarship.create(:index => i,
                              :scholarship_month => ScholarshipMonth.current)
  end
  ExtraScholarship.create(:index => @index1, :amount => '1000', :commission_head => '1234',
                          :commission_body => '12345', :commission_tail => '1234',
                          :scholarship_month => ScholarshipMonth.current)
  ExtraScholarship.create(:index => @index3, :amount => '1000', :commission_head => '1234',
                          :commission_body => '12345', :commission_tail => '1234',
                          :scholarship_month => ScholarshipMonth.current)
  @user = Factory(:user)
  @user.person.stub(:faculty).and_return(@index1.faculty)
  @user.person.stub(:department).and_return(@index1.department)
end
