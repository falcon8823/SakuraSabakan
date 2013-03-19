class AddAccountIdToServers < ActiveRecord::Migration
  def change
    add_column :servers, :account_id, :integer
  end
end
