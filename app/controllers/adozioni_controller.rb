class AdozioniController < ApplicationController

  def index

    @adozioni_per_titolo =  current_user.adozioni.scolastico.includes(:libro, :classe => :cliente).order("libri.materia_id, libri.titolo").filtra(params)
    
    @adozioni = current_user.adozioni.scolastico.includes(:libro, :classe => :cliente).per_scuola.filtra(params)
    
    @provincie = current_user.adozioni.joins(:classe => :cliente).per_scuola.pluck("clienti.provincia").uniq
    
    @giro = Giro.new(user_id: current_user.id, baule: true) 

    if params[:titolo]
      @libro = Libro.find_by_titolo(params[:titolo])
    end 
  end

  def create
    @classe = current_user.classi.find(params[:classe_id])    
    
    @adozione = @classe.adozioni.build(params[:adozione])

    @adozione.nr_copie = @classe.nr_alunni
    respond_to do |format|
      if @adozione.save
        format.html   { redirect_to :back }
        format.js
      else
        format.html   { redirect_to :back }
        format.js
      end
    end
  end

  def update
    @adozione = current_user.adozioni.find(params[:id])    
    @classe  = @adozione.classe
    @cliente = @classe.cliente

    respond_to do |format|
      if @adozione.update_attributes(params[:adozione])
        format.html { redirect_to :back }
        format.js
      else
        #correggere
        format.html { redirect_to :back }
        format.js
      end
    end
  end

  def update_multiple
    @adozioni = current_user.adozioni.find(params[:adozione_ids]) 
    @classe = @adozioni[0].classe
       
    @adozioni.reject! do |adozione|
      adozione.update_attributes(params[:adozione])
    end

    if @adozioni.empty?
      respond_to do |format|
        format.html { redirect_to :back }
        format.js do
          @provincie = current_user.adozioni.scolastico.joins(:classe => :cliente).per_scuola.pluck("clienti.provincia").uniq
          @adozioni = current_user.adozioni.find(params[:adozione_ids]) 
        end
     
      end 
    else
      # @product = Product.new(params[:product])
      # render "edit_multiple"
    end
  end

  def destroy
    @adozione = current_user.adozioni.find(params[:id])
    @classe = @adozione.classe
    @adozione.destroy
    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end    
  end

  def destroy_all
    @adozioni = Adozione.destroy(params[:adozioni][:adozione_ids])

    respond_to do |format|
      format.html { redirect_to :back }
      format.js {
        @cliente = @adozioni.first.classe.cliente
      }
      format.json { head :no_content }
    end
  end

  def print_multiple
    @adozioni = current_user.adozioni.joins(:classe).find(params[:adozione_ids], order: "classi.cliente_id, classi.classe, adozioni.libro_id, classi.sezione")    
    respond_to do |format|
      format.pdf do         
        pdf = AdozionePdf.new(@adozioni, view_context)
        send_data pdf.render, filename: "sovrapacchi_adozioni_#{Time.now.strftime("%Y%m%d%h%M")}.pdf",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end   
  end

end
