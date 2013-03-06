class PingLog < ActiveRecord::Base
  attr_accessible :date, :ping_detail, :server_id, :status
end
