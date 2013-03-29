# encoding: utf-8

class Server < ActiveRecord::Base
  attr_accessible :address, :description

  # Relation Ship
  belongs_to :account

  has_many :ping_logs,
    dependent: :delete_all
  has_many :http_logs,
    dependent: :delete_all

  # Validations
  validates :address,
    uniqueness: true,
    presence: true,
    length: {maximum: 30}
  validate :address_valid?

  validates :account_id,
    presence: true,
    numericality: :only_integer

  # 監視を実行
  def check
    # 前回の監視状態
    before_status = {}
    before_status[:ping] = ping_status_before 1.day
    before_status[:http] = http_status_before 1.day

    # 監視を実行
    self.check_ping
    self.check_http

    # 今回の監視状態
    after_status = {}
    after_status[:ping] = ping_status_before 1.day
    after_status[:http] = http_status_before 1.day

    notice = false
    after_status.each do |k, v|
      # 監視結果が前回と変わった場合
      unless before_status[k] == v
        notice = true
      end
    end

    # 監視結果が変わった場合メール通知
    MonitorMailer.status_changed(self).deliver if notice
  end

  # pingの監視を実行
  def check_ping
    # ping実行
    ping_str = `ping -c 5 #{self.address}`
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

    return ping_logs
  end

  # 最近のpingの稼働率
  def recent_ping_rate(from)
    logs = self.ping_logs.recent(from)
    rate = logs.success.count.to_f / logs.count * 100
    rate.round 1
  end

  def ping_status_before(from)
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




  # httpの監視を実行
  def check_http
    # http実行
    ping_str = `http -s -c 5 #{self.address}`
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
  def recent_http_rate(from)
    logs = self.http_logs.recent(from)
    rate = logs.success.count.to_f / logs.count * 100
    rate.round 1
  end

  def http_status_before(from)
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



  # 最近1日間サーバ（全サービス）の稼働率
  def recent_rate(from)
    service_rates = []
    service_rates << recent_ping_rate(from)
    service_rates << recent_http_rate(from)

    rate = service_rates.inject{|sum, i| sum + i } / service_rates.count
    rate.round 1
  end

  # 直前のログにエラーがいくつあるか
  def count_errors_just_before
    pings = self.ping_logs.recent(1.day).asc_by_date
    https = self.http_logs.recent(1.day).asc_by_date
    res = []

    res << (pings.last.status == 'Failed') if pings.last
    res << (https.last.status !~ /^[1-3].*$/) if https.last

    return res.count{|i| i }
  end

  # 最近の全エラー数
  def count_errors_before(span)
    res = []
    res << self.ping_logs.recent(span).failed.count
    res << self.http_logs.recent(span).failed.count

    return res.inject { |sum, i| sum + i }
  end

  # 監視ログがあるかどうか
  def count_logs
    res = []
    res << self.ping_logs.recent(1.day).count
    res << self.http_logs.recent(1.day).count

    return res.inject { |sum, i| sum + i }
  end

  def status_before(from)
    if self.count_logs == 0
      # ログが無ければブルー
      alert = :no_log

    elsif self.count_errors_just_before != 0
      # 前回のログにエラーがある場合は警告
      alert = :danger

    elsif self.count_errors_before(1.hour) != 0
      # 過去1時間にエラーがあれば注意
      alert = :warning
    else
      # 何も無ければグリーン
      alert = :success
    end
  end

  private
  def address_valid?
    errors.add(:address, 'に不正な文字が含まれています。（日本語ドメインには非対応です）') unless self.address =~ /^[0-9A-Za-z\-.]+$/
  end
end
