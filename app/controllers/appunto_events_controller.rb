class AppuntoEventsController < ApplicationController
  # GET /appunto_events
  # GET /appunto_events.json
  def index
    @appunto_events = AppuntoEvent.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @appunto_events }
    end
  end

  # GET /appunto_events/1
  # GET /appunto_events/1.json
  def show
    @appunto_event = AppuntoEvent.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @appunto_event }
    end
  end

  # GET /appunto_events/new
  # GET /appunto_events/new.json
  def new
    @appunto_event = AppuntoEvent.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @appunto_event }
    end
  end

  # GET /appunto_events/1/edit
  def edit
    @appunto_event = AppuntoEvent.find(params[:id])
  end

  # POST /appunto_events
  # POST /appunto_events.json
  def create
    @appunto_event = AppuntoEvent.new(params[:appunto_event])

    respond_to do |format|
      if @appunto_event.save
        format.html { redirect_to @appunto_event, notice: 'Appunto event was successfully created.' }
        format.json { render json: @appunto_event, status: :created, location: @appunto_event }
      else
        format.html { render action: "new" }
        format.json { render json: @appunto_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /appunto_events/1
  # PUT /appunto_events/1.json
  def update
    @appunto_event = AppuntoEvent.find(params[:id])

    respond_to do |format|
      if @appunto_event.update_attributes(params[:appunto_event])
        format.html { redirect_to @appunto_event, notice: 'Appunto event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @appunto_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /appunto_events/1
  # DELETE /appunto_events/1.json
  def destroy
    @appunto_event = AppuntoEvent.find(params[:id])
    @appunto_event.destroy

    respond_to do |format|
      format.html { redirect_to appunto_events_url }
      format.json { head :no_content }
    end
  end
end
