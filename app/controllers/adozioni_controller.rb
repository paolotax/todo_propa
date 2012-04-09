class AdozioniController < ApplicationController

  def index
    
    @adozioni =  current_user.adozioni.scolastico.includes(:libro).joins(:classe).order("libri.titolo").all.group_by(&:libro).map do |libro,adozioni|
      { materia_id: libro.materia_id, id: libro.id, titolo: libro.titolo, image: libro.image, quantita: adozioni.count(&:classe) }
    end
    
  end

  # def show
  #   @adozione = Adozione.find(params[:id])
  # 
  #   respond_to do |format|
  #     format.html # show.html.erb
  #     format.json { render json: @adozione }
  #   end
  # end
  # 
  # def new
  #   @adozione = Adozione.new
  # 
  #   respond_to do |format|
  #     format.html # new.html.erb
  #     format.json { render json: @adozione }
  #   end
  # end
  # 
  # def edit
  #   @adozione = Adozione.find(params[:id])
  # end
  # 
  # def create
  #   @adozione = Adozione.new(params[:adozione])
  # 
  #   respond_to do |format|
  #     if @adozione.save
  #       format.html { redirect_to @adozione, notice: 'Adozione was successfully created.' }
  #       format.json { render json: @adozione, status: :created, location: @adozione }
  #     else
  #       format.html { render action: "new" }
  #       format.json { render json: @adozione.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end
  # 
  # def update
  #   @adozione = Adozione.find(params[:id])
  # 
  #   respond_to do |format|
  #     if @adozione.update_attributes(params[:adozione])
  #       format.html { redirect_to @adozione, notice: 'Adozione was successfully updated.' }
  #       format.json { head :no_content }
  #     else
  #       format.html { render action: "edit" }
  #       format.json { render json: @adozione.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end
  # 
  # def destroy
  #   @adozione = Adozione.find(params[:id])
  #   @adozione.destroy
  # 
  #   respond_to do |format|
  #     format.html { redirect_to adozioni_url }
  #     format.json { head :no_content }
  #   end
  # end
end
