class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string :type
      t.integer :server_id

      t.timestamps
    end
  end
end
