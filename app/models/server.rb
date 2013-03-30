# encoding: utf-8

class Server < ActiveRecord::Base
  attr_accessible :address, :description

  # Relation Ship
  belongs_to :account
  has_many :services, dependent: :delete_all

  # Validations
  validates :address,
    uniqueness: true,
    presence: true,
    length: { maximum: 30 }
  validate :address_valid?


  # 全サービスの監視を実行
  def check
    before = []
    after = []

    self.services.each do |s|
      before << s.status_before(1.day)
      s.check
      after << s.status_before(1.day)
    end

    # 前回の監視結果と異なる場合メール通知
    MonitorMailer.status_changed(self).deliver unless before == after
  end

  # サーバ（全サービス）の稼働率
  def recent_rate(from)
    rate = 100.0
    rate = self.services.inject(0) { |sum, service| sum + service.recent_rate(from) } / self.services.count unless self.services.empty?

    return rate.round(1)
  end

  def status_before(from)
    # ステータスに重みをつける
    h = { danger: 3, warning: 2, success: 1, no_log: 0 }

    # 全サービスの中で重みが高いステータスを返す
    return self.services.inject(:no_log) { |most, srv|
      now = srv.status_before(from)
      h[now] > h[most] ? now : most
    }
  end

  private
  def address_valid?
    errors.add(:address, 'に不正な文字が含まれています。（日本語ドメインには非対応です）') unless self.address =~ /^[0-9A-Za-z\-.]+$/
  end
end
