class HttpingLogsController < ApplicationController
  # GET /servers/1/httping_logs
  # GET /servers/1/httping_logs.json
  def index
    @server = Server.find(params[:server_id])
    @httping_logs = @server.httping_logs.desc_by_date

    case params[:recent]
    when '1hour'
      @httping_logs = @httping_logs.recent(1.hour)
    when '1day'
      @httping_logs = @httping_logs.recent(1.day)
    when '1week'
      @httping_logs = @httping_logs.recent(1.week)
    when '1month'
      @httping_logs = @httping_logs.recent(1.month)
    else
      @httping_logs = @httping_logs.recent(1.day)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @httping_logs }
    end
  end

  # GET /servers/1/httping_logs/1
  # GET /servers/1/httping_logs/1.json
  def show
    @server = Server.find(params[:server_id])
    @httping_log = @server.httping_logs.find(params[:id])

    respond_to do |format|
      format.html { render :show, layout: false } # show.html.erb
      format.json { render json: @httping_log }
    end
  end

  # DELETE /servers/1/httping_logs/1
  # DELETE /servers/1/httping_logs/1.json
  def destroy
    @server = Server.find(params[:server_id])
    @httping_log = @server.httping_logs.find(params[:id])
    @httping_log.destroy

    respond_to do |format|
      format.html { redirect_to server_httping_logs_path(@server) }
      format.json { head :no_content }
    end
  end
end
