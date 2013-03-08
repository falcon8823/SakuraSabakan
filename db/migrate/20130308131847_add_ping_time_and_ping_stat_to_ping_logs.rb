class AddPingTimeAndPingStatToPingLogs < ActiveRecord::Migration
  def change
    add_column :ping_logs, :min, :float
    add_column :ping_logs, :max, :float
    add_column :ping_logs, :avg, :float
    add_column :ping_logs, :stddev, :float

    add_column :ping_logs, :transmitted, :integer
    add_column :ping_logs, :received, :integer
    add_column :ping_logs, :packet_loss, :float
  end
end
