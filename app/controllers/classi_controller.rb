class ClassiController < ApplicationController

  can_edit_on_the_spot

  def update
    @classe = current_user.classi.find(params[:id])    
    @cliente = @classe.cliente

    respond_to do |format|
      if @classe.update_attributes(params[:classe])
        format.html { redirect_to :back }
        format.js
      else
        #correggere
        format.html { redirect_to :back }
        format.js
      end
    end
  end
  
  def copia_adozioni
    @classe = current_user.classi.find(params[:id])    
    @cliente = @classe.cliente

    @classe.adozioni.each  { |a| a.destroy }

    libri = Libro.joins(:adozioni => :classe).where('classi.cliente_id = ?', @cliente.id).where("classi.classe = ?", @classe.classe).where("classi.id != ?", @classe.id).where(settore: 'Scolastico').uniq

    libri.each do |l|      
      @classe.adozioni.create! ({        
              libro_id: l.id,
              nr_copie: @classe.nr_alunni
            })
    end    
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :ok }
      format.js
    end   
  end

  def aggiungi_sezione
    
    @classe = current_user.classi.find(params[:id])   
    @cliente = @classe.cliente
    last_classe = @cliente.classi.where(classe: @classe.classe).order("sezione desc").first
    
    @cliente.classi.create! ({
      nr_alunni: last_classe.nr_alunni,
      sezione: last_classe.sezione.succ,
      classe: last_classe.classe,
      anno: last_classe.anno
    })

    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :ok }
      format.js { @cliente.reload }
    end     
  end

  def destroy
    @classe = current_user.classi.find(params[:id])
    @cliente = @classe.cliente
    @classe.destroy
    respond_to do |format|
      format.html { redirect_to @cliente }
      format.json { head :ok }
      format.js
    end
  end
  
  def destroy_all
    @classi = Classe.destroy(params[:classi][:classe_ids])

    respond_to do |format|
      format.html { redirect_to :back }
      format.js {
        @cliente = @classi.first.cliente
      }
      format.json { head :no_content }
    end
  end
 
end
