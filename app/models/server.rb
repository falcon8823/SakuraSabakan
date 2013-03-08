class Server < ActiveRecord::Base
  attr_accessible :address, :description

  # Relation Ship
  has_many :ping_logs,
    dependent: :delete_all

  # Validations
  validates :address,
    uniqueness: true,
    presence: true,
    length: {maximum: 30}

  # pingの監視を実行
	def check_ping
		# ping実行
		ping_str = `ping -c 5 #{self.address}`
		# pingのログから情報を抽出
		parser = PingLogParser.new ping_str
		time = parser.parse_time
		stat = parser.parse_stat

		# ログに記録
		ping_log = self.ping_logs.new
		ping_log.attributes = time
		ping_log.attributes = stat
		ping_log.ping_detail = ping_str
		ping_log.status = (stat[:packet_loss] > 0.0 ? 'Failed' : 'Success')

		ping_log.save!
	end
end
