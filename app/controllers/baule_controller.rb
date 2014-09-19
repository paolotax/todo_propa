class BauleController < ApplicationController
  
  before_filter :select_visite

  def show
    
  end
  

  def destroy

    @visite.destroy_all
    respond_to do |format|
      format.html { redirect_to :back, notice: "Baule svuotato" }
    end
  end
  
  def update

    @giro.salva_baule(params)

    respond_to do |format|
      format.html { redirect_to giro_path( giorno: params[:visita][:data]), notice: "Il giro e' stato salvato" }
    end  
  end

  private

    def select_visite
      @giro = Giro.new(user: current_user, baule: true) 
      @visite = @giro.visite
    end 


end
