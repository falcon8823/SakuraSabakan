class CreatePingLogs < ActiveRecord::Migration
  def change
    create_table :ping_logs do |t|
      t.timestamp :date
      t.integer :server_id
      t.string :status
      t.text :ping_detail

      t.timestamps
    end
  end
end
