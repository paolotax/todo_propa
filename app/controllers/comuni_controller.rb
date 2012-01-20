# encoding: UTF-8

class ComuniController < ApplicationController

  def index
    
    if params[:per_provincia].present?
      @comuni = Comune.per_provincia(params[:per_provincia]).ordine_per_comune
    else
      @comuni = Comune.ordine_per_comune.all
    end
  end

  def show
    @comune = Comune.find(params[:id])
  end

  def new
    @comune = Comune.new
  end

  def edit
    @comune = Comune.find(params[:id])
  end

  def create
    @comune = Comune.new(params[:comune])

    respond_to do |format|
      if @comune.save
        format.html { redirect_to @comune, notice: 'Il Comune è stato creato.' }
        format.json { render json: @comune, status: :created, location: @comune }
      else
        format.html { render action: "new" }
        format.json { render json: @comune.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @comune = Comune.find(params[:id])

    respond_to do |format|
      if @comune.update_attributes(params[:comune])
        format.html { redirect_to @comune, notice: 'Il Comune è stato modificato.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @comune.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comune = Comune.find(params[:id])
    @comune.destroy

    respond_to do |format|
      format.html { redirect_to comuni_url }
      format.json { head :ok }
    end
  end
end
