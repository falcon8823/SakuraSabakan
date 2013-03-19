require 'test_helper'

class MonitorMailerTest < ActionMailer::TestCase
  test "status_changed" do
    mail = MonitorMailer.status_changed
    assert_equal "Status changed", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
