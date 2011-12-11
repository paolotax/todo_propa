class LibriController < ApplicationController
  
  respond_to :html, :js, :json 
  
  def index
  end

  def show
    @libro = Libro.find(params[:id])
    respond_with @libro
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

end
