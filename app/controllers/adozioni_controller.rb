class AdozioniController < ApplicationController

  def index
    @adozioni =  current_user.adozioni.scolastico.includes(:libro, :classe).order("libri.titolo").all.group_by(&:libro).map do |libro, adozioni|
      { 
        materia_id: libro.materia_id, 
        id: libro.id, 
        titolo: libro.titolo, 
        image: libro.image_url(:small_thumb), 
        quantita: adozioni.count(&:classe) 
      }
    end    
  end

  def create
    @classe = current_user.classi.find(params[:classe_id])    
    
    @adozione = @classe.adozioni.build(params[:adozione])

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
    @classe = @adozione.classe
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
    @adozioni = current_user.adozioni.joins(:classe).find(params[:adozione_ids], order: "classi.classe, adozioni.libro_id, classi.sezione")    
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
