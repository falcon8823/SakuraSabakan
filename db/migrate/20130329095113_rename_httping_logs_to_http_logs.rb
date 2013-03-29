class RenameHttpingLogsToHttpLogs < ActiveRecord::Migration
  def change
    rename_table :httping_logs, :http_logs
  end
end
