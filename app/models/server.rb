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
end
