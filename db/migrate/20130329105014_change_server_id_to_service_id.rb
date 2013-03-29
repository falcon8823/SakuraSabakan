class ChangeServerIdToServiceId < ActiveRecord::Migration
  def up
    add_column :ping_logs, :service_id, :integer
    add_column :http_logs, :service_id, :integer

    Server.all.each do |srv|
      ps = PingService.new
      ps.server_id = srv.id
      ps.save!
      PingLog.update_all "service_id = #{ps.id}", ['server_id = ?', srv.id]

      hs = HttpService.new
      hs.server_id = srv.id
      hs.save!
      HttpLog.update_all "service_id = #{hs.id}", ['server_id = ?', srv.id]
    end

    remove_column :ping_logs, :server_id, :integer
    remove_column :http_logs, :server_id, :integer
  end

  def down
    raise
  end
end
