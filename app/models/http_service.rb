class HttpService < Service
  has_many :http_logs,
    foreign_key: :service_id,
    dependent: :delete_all

 # httpの監視を実行
  def check
    # http実行
    ping_str = `httping -s -c 5 "#{self.server.address}"`
    # httpのログから情報を抽出
    parser = HttpingLogParser.new ping_str
    rtt = parser.rtt
    stat = parser.stat

    # ログに記録
    log = self.http_logs.new
    log.attributes = rtt
    log.attributes = stat
    log.detail = ping_str
    log.status = parser.status[:status]

    log.save!

    return log
  end

  # 最近1日間のHTTPの稼働率
  def recent_rate(from)
    logs = self.http_logs.recent(from)
    rate = logs.success.count.to_f / logs.count * 100
    rate.round 1
  end

  def status_before(from)
    if self.http_logs.recent(from).count == 0
      h = :no_log
    elsif self.http_logs.recent(from).asc_by_date.last.status !~ /^[1-3].*$/
      h = :danger
    elsif self.http_logs.failed.recent(1.hour).count != 0
      h = :waring
    else
      h = :success
    end

    return h
  end
end
