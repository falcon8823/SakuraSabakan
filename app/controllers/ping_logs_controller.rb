class PingLogsController < ApplicationController
  # GET /servers/1/ping_logs
  # GET /servers/1/ping_logs.json
  def index
    @server = Server.find(params[:server_id])

    @ping_logs = @server.ping_logs.desc_by_date.recent(RECENT[params[:recent]])

    @hour_logs = []
    24.downto 1 do |i|
      now = Time.now
      @hour_logs << @server.ping_logs.desc_by_date.where('date >= ? AND date < ?', now.change(hour: i - 1), now.change(hour: i))
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json {
        render json: @ping_logs.as_json(only: [:id, :date, :avg])
      }
    end
  end

  # GET /servers/1/ping_logs/1
  # GET /servers/1/ping_logs/1.json
  def show
    @server = Server.find(params[:server_id])
    @ping_log = @server.ping_logs.find(params[:id])

    respond_to do |format|
      format.html { render :show, layout: false } # show.html.erb
      format.json { render json: @ping_log }
    end
  end

  # DELETE /servers/1/ping_logs/1
  # DELETE /servers/1/ping_logs/1.json
  def destroy
    @server = Server.find(params[:server_id])
    @ping_log = @server.ping_logs.find(params[:id])
    @ping_log.destroy

    respond_to do |format|
      format.html { redirect_to servers_path }
      format.json { head :no_content }
    end
  end
end
