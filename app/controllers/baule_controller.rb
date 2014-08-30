class BauleController < ApplicationController
  
  before_filter :select_visite

  def show
    
  end
  

  def destroy
    # @visite = current_user.visite.nel_baule
    @visite.destroy_all

    respond_to do |format|
      format.html { redirect_to :back, notice: "Baule svuotato" }
    end
  end
  
  def update

    #raise params.inspect

    #  @visite = current_user.visite.nel_baule.order(:start)
    @visite.each_with_index do |visita, index|
      
      #visita.update_attributes!(params[:visita].merge(step: index).reject { |k,v| v.blank? })  #  unless k == 'stato'

      visita.baule = false
      visita.scopo = params[:visita][:scopo]
      visita.data  = params[:visita][:data]

      if visita.valid?
        visita.save
      else
        visita.destroy
      end
    end
    
    respond_to do |format|
      format.html { redirect_to :back, notice: "Il giro e' stato salvato" }
    end
  end

  private

    def select_visite
      @giro = Giro.new(user: current_user, baule: true) 
      @visite = @giro.visite
    end 

end
