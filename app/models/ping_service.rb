class PingService < Service
  has_many :ping_logs,
    foreign_key: :service_id,
    dependent: :delete_all

  # pingの監視を実行
  def check
    # ping実行
    ping_str = `ping -c 5 "#{self.server.address}"`
    # pingのログから情報を抽出
    parser = PingLogParser.new ping_str
    rtt = parser.rtt
    stat = parser.stat

    # ログに記録
    ping_log = self.ping_logs.new
    ping_log.attributes = rtt
    ping_log.attributes = stat
    ping_log.ping_detail = ping_str
    # ロス率80%以上でエラー
    ping_log.status = (stat[:packet_loss] >= 80.0 ? 'Failed' : 'Success')

    ping_log.save!

    return ping_log
  end

  # 最近のpingの稼働率
  def recent_rate(from)
    logs = self.ping_logs.recent(from)
    rate = logs.success.count.to_f / logs.count * 100
    rate.round 1
  end

  def status_before(from)
    if self.ping_logs.recent(from).count == 0
      h = :no_log
    elsif self.ping_logs.recent(from).asc_by_date.last.status == 'Failed'
      h = :danger
    elsif self.ping_logs.failed.recent(1.hour).count != 0
      h = :waring
    else
      h = :success
    end

    return h
  end
end
