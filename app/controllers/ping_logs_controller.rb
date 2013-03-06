class PingLogsController < ApplicationController
  # GET /ping_logs
  # GET /ping_logs.json
  def index
    @ping_logs = PingLog.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @ping_logs }
    end
  end

  # GET /ping_logs/1
  # GET /ping_logs/1.json
  def show
    @ping_log = PingLog.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @ping_log }
    end
  end

  # GET /ping_logs/new
  # GET /ping_logs/new.json
  def new
    @ping_log = PingLog.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ping_log }
    end
  end

  # GET /ping_logs/1/edit
  def edit
    @ping_log = PingLog.find(params[:id])
  end

  # POST /ping_logs
  # POST /ping_logs.json
  def create
    @ping_log = PingLog.new(params[:ping_log])

    respond_to do |format|
      if @ping_log.save
        format.html { redirect_to @ping_log, notice: 'Ping log was successfully created.' }
        format.json { render json: @ping_log, status: :created, location: @ping_log }
      else
        format.html { render action: "new" }
        format.json { render json: @ping_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /ping_logs/1
  # PUT /ping_logs/1.json
  def update
    @ping_log = PingLog.find(params[:id])

    respond_to do |format|
      if @ping_log.update_attributes(params[:ping_log])
        format.html { redirect_to @ping_log, notice: 'Ping log was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @ping_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ping_logs/1
  # DELETE /ping_logs/1.json
  def destroy
    @ping_log = PingLog.find(params[:id])
    @ping_log.destroy

    respond_to do |format|
      format.html { redirect_to ping_logs_url }
      format.json { head :no_content }
    end
  end
end
