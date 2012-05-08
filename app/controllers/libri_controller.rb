class LibriController < ApplicationController
  
  respond_to :html, :js, :json 
  
  can_edit_on_the_spot
  
  def index
    @libri = Libro.per_settore.per_titolo
    respond_with @libri
  end

  def show
    @libro = Libro.find(params[:id])
    respond_with @libro
    # if request.path != libro_path(@libro)
    #   redirect_to @libro, status: :moved_permanently
    # end
  end

  def new
    @libro = Libro.new
  end

  def create
    @libro = Libro.new(params[:libro])
    @libro.save
    respond_with @libro
  end

  def edit
    @libro = Libro.find(params[:id])
  end

  def update
    @libro = Libro.find(params[:id])
    @libro.update_attributes(params[:libro])
    respond_with @libro
  end

  def destroy


  end

end
