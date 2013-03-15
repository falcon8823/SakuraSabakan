class Server < ActiveRecord::Base
  attr_accessible :address, :description

  # Relation Ship
  has_many :ping_logs,
    dependent: :delete_all
  has_many :httping_logs,
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
    rtt = parser.parse_rtt
    stat = parser.parse_stat

    # ログに記録
    ping_log = self.ping_logs.new
    ping_log.attributes = rtt
    ping_log.attributes = stat
    ping_log.ping_detail = ping_str
    ping_log.status = (stat[:packet_loss] > 0.0 ? 'Failed' : 'Success')

    ping_log.save!
  end

  # 最近1日間のpingの稼働率
  def recent_ping_rate
    logs = self.ping_logs.recent(1.day)
    rate = logs.success.count.to_f / logs.count * 100
    rate.round 1
  end

  # httpの監視を実行
  def check_http
    # httping実行
    ping_str = `httping -s -c 5 #{self.address}`
    # httpingのログから情報を抽出
    parser = HttpingLogParser.new ping_str
    rtt = parser.parse_rtt
    stat = parser.parse_stat

    # ログに記録
    log = self.httping_logs.new
    log.attributes = rtt
    log.attributes = stat
    log.detail = ping_str
    log.status = parser.parse_status[:status]

    log.save!
  end

	# 最近1日間のHTTPの稼働率
  def recent_http_rate
    logs = self.httping_logs.recent(1.day)
    rate = logs.success.count.to_f / logs.count * 100
    rate.round 1
  end
end
