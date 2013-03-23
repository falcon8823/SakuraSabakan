require 'test_helper'

class HttpingLogParserTest < ActiveSupport::TestCase
  test 'Parse status code' do
    raw_log = `httping -c 5 -s http://www.google.co.jp`
    parser = HttpingLogParser.new raw_log

    h = parser.status
    assert_equal h[:status], '200'
  end
end
