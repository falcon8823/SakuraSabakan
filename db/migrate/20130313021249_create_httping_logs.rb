class CreateHttpingLogs < ActiveRecord::Migration
  def change
    create_table :httping_logs do |t|
      t.timestamp :date
      t.integer :server_id
      t.string :status
      t.text :detail
      t.float :min
      t.float :max
      t.float :avg
      t.float :failed_rate

      t.timestamps
    end
  end
end
