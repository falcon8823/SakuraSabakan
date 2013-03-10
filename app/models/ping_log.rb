class PingLog < ActiveRecord::Base
  attr_accessible :ping_detail, :server_id, :status,
    :min, :max, :avg, :stddev,
    :transmitted, :received, :packet_loss

  # Relation Ship
  belongs_to :server

  # Validations
  validates :server_id,
  	numericality: :only_integer
  validates :server_id, :status,
  	presence: true

  # Scopes
  scope :asc_by_date, lambda { order 'date ASC' }
  scope :desc_by_date, lambda { order 'date DESC' }

  scope :recent, lambda { |fixn| where('date >= ?', fixn.ago) }

  # Callback
  before_create :timestamp_date

  private

  def timestamp_date
  	self.date = Time.now
  end
end
