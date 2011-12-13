class LibriController < ApplicationController
  
  respond_to :html, :js, :json 
  
  def index
  end

  def show
    @libro = Libro.find(params[:id])
    respond_with @libro
  end

  def new
    @libro = Libro.new
  end

  def create
    @libro = Libro.create(params[:libro])

    respond_to do |format|
      if @libro.save
        format.html { redirect_to @libro, notice: 'Appunto creato!' }
        format.json
      else
        format.html { render action: "new" }
        format.json { render rabl: @libro.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @libro = Libro.find(params[:id])
  end

  def update
    @libro = Libro.find(params[:id])

    respond_to do |format|
      if @libro.update_attributes(params[:libro])
        format.html { redirect_to @libro, notice: 'Libro modificato.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @libro.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
  end

end
