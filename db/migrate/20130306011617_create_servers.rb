class CreateServers < ActiveRecord::Migration
  def change
    create_table :servers do |t|
      t.string :address
      t.string :description

      t.timestamps
    end
  end
end
