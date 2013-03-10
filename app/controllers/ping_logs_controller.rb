class PingLogsController < ApplicationController
  # GET /servers/1/ping_logs
  # GET /servers/1/ping_logs.json
  def index
    @server = Server.find(params[:server_id])
    @ping_logs = @server.ping_logs.desc_by_date

    case params[:recent]
    when '1hour'
      @ping_logs = @ping_logs.recent(1.hour)
    when '1day'
      @ping_logs = @ping_logs.recent(1.day)
    when '1week'
      @ping_logs = @ping_logs.recent(1.week)
    when '1month'
      @ping_logs = @ping_logs.recent(1.month)
    else
      @ping_logs = @ping_logs.recent(1.day)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @ping_logs }
    end
  end

  # GET /servers/1/ping_logs/1
  # GET /servers/1/ping_logs/1.json
  def show
    @server = Server.find(params[:server_id])
    @ping_log = @server.ping_logs.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
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
      format.html { redirect_to server_ping_logs_path(@server) }
      format.json { head :no_content }
    end
  end
end
