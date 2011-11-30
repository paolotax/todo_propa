class AppuntiController < ApplicationController
  
  can_edit_on_the_spot
  
  def index
    
    @search = current_user.appunti.includes(:scuola).filtra(params)

    @appunti = @search.recente.limit(20)
    @appunti = @appunti.offset((params[:page].to_i-1)*20) if params[:page].present?

    @provincie = current_user.scuole.select_provincia.filtra(params.except(:provincia).except(:citta)).order(:provincia)
    @citta     = current_user.scuole.select_citta.filtra(params.except(:citta)).order(:citta)
    
    respond_to do |format|
      format.html
      format.json do
        render json: @appunti.map { |a| view_context.appunto_for_mustache(a) }
      end
    end
  end
  
  def get_note
    @appunto = current_user.appunti.find(params[:id])
    render :inline => "<%= markdown @appunto.note %>"
  end

  def show
    @appunto = current_user.appunti.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @appunto }
    end
  end

  def new
    @appunto = current_user.appunti.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @appunto }
    end
  end

  def edit
    @appunto = current_user.appunti.find(params[:id])
  end

  def create
    @appunto = current_user.appunti.build(params[:appunto])

    respond_to do |format|
      if @appunto.save
        format.html { redirect_to @appunto, notice: 'Appunto creato!' }
        format.json { render json: @appunto, status: :created, location: @appunto }
      else
        format.html { render action: "new" }
        format.json { render json: @appunto.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @appunto = current_user.appunti.find(params[:id])

    respond_to do |format|
      if @appunto.update_attributes(params[:appunto])
        format.html { redirect_to @appunto, notice: 'Appunto modificato.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @appunto.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @appunto = current_user.appunti.find(params[:id])
    @appunto.destroy

    respond_to do |format|
      format.html { redirect_to appunti_url }
      format.json { head :ok }
      format.js
    end
  end
end
