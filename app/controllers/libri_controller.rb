class LibriController < ApplicationController
  
  
  # respond_to :html, :js, :json 
  
  
  can_edit_on_the_spot
  
  
  def index

    session[:return_to] = request.path

    @search = Libro.filtra(params).ordina(params)

    unless params[:adottabile_per_classe].present?
      @libri = @search.page(params[:page])
    else
      @libri = @search
    end
    
    # @stat_appunti = current_user.appunti.filtra(params.except(:status))
    # @in_corso     = @stat_appunti.in_corso.size
    # @da_fare      = @stat_appunti.da_fare.size
    # @in_sospeso   = @stat_appunti.in_sospeso.size
    # @preparati    = @stat_appunti.preparato.size    
    @tutti        = Libro.all.size

    # @libri = Libro.per_settore.per_titolo
    # respond_with @libri

  end

  
  def show
    @libro = Libro.includes(righe: [ :libro, :appunto ] ).find(params[:id])
    
    
    @adozioni = current_user.adozioni.includes(:classe => :cliente).del_libro(@libro.id).per_scuola


    @giacenza = GiacenzaLibro.new(libro: @libro, user: current_user)

    respond_to do |format|
      format.html
      format.json { render :rabl => @libro }
    end
    
    #respond_with @libro
    
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
    redirect_to @libro
  end

  
  def edit
    session[:return_to] = request.referer
    @libro = Libro.find(params[:id])
  end

  
  def update
    @libro = Libro.find(params[:id])
    respond_to do |format|
      if @libro.update_attributes(params[:libro])
        format.html   { redirect_to session[:return_to], notice: 'Libro modificato.' }
        format.js
      else
        format.html { render action: "edit" }
        format.js
        format.json { render rabl: @libro.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @libro = Libro.find_by_slug(params[:id])
    @libro.destroy
    respond_to do |format|
      format.html { redirect_to libri_url }
      format.js
    end
  end

end
