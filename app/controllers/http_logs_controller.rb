class HttpLogsController < ApplicationController
  # GET /servers/1/http_logs
  # GET /servers/1/http_logs.json
  def index
    @server = Server.find(params[:server_id])
    @http_logs = @server.http_logs.desc_by_date.recent(RECENT[params[:recent]])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @http_logs.as_json(only: [:id, :date, :avg]) }
    end
  end

  # GET /servers/1/http_logs/1
  # GET /servers/1/http_logs/1.json
  def show
    @server = Server.find(params[:server_id])
    @http_log = @server.http_logs.find(params[:id])

    respond_to do |format|
      format.html { render :show, layout: false } # show.html.erb
      format.json { render json: @http_log  }
    end
  end

  # DELETE /servers/1/http_logs/1
  # DELETE /servers/1/http_logs/1.json
  def destroy
    @server = Server.find(params[:server_id])
    @http_log = @server.http_logs.find(params[:id])
    @http_log.destroy

    respond_to do |format|
      format.html { redirect_to servers_path }
      format.json { head :no_content }
    end
  end
end
