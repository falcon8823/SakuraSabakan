require 'test_helper'

class ServerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "Server has errors" do
    s = Server.new address: 'hogehoge.com'
    s.save
    assert_equal 0, s.count_recent_errors
    assert_equal 0, s.count_errors_before(1.minute)

    pl = s.ping_logs.new status: 'Failed'
    pl.save
    assert_equal 1, s.count_recent_errors
    assert_equal 1, s.count_errors_before(1.minute)

    h = s.httping_logs.new status: '200', failed_rate: 0
    h.save
    assert_equal 1, s.count_recent_errors
    assert_equal 1, s.count_errors_before(1.minute)

    h = s.httping_logs.new status: '500', failed_rate: 100
    h.save
    assert_equal 2, s.count_recent_errors
    assert_equal 2, s.count_errors_before(1.minute)
    assert_equal 3, s.count_logs
  end
end
