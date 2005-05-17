require File.dirname(__FILE__) + '/../test_helper'
require 'notifications'

class NotificationsTest < Test::Unit::TestCase
  FIXTURES_PATH = File.dirname(__FILE__) + '/../fixtures'
  CHARSET = "utf-8"

  def setup
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    @expected = TMail::Mail.new
    @expected.set_content_type "text", "plain", { "charset" => CHARSET }
  end

  def test_invite_candidate
    @expected.subject = encode 'Notifications#invite_candidate'
    @expected.body    = read_fixture('invite_candidate')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Notifications.create_invite_candidate(@expected.date).encoded
  end

  private
    def read_fixture(action)
      IO.readlines("#{FIXTURES_PATH}/notifications/#{action}")
    end

    def encode(subject)
      ActionMailer::Base.quoted_printable(subject, CHARSET)
    end
end
