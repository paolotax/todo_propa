class Propa2014sController < ApplicationController
  
  
  def index

    @clienti = current_user.clienti.scuole.filtra(params).per_localita

    @clienti_grouped = @clienti.scuola_primaria.all.group_by(&:parent)

    @direzioni = @clienti_grouped.keys.reject{ |c| c.nil? }.sort_by{|c| [c.provincia, c.comune, c.id] }
    
    @provincie = current_user.clienti.not_deleted.direzioni.select_provincia.map(&:provincia)
    
    @date = params[:calendar] ? Date.parse(params[:calendar]) : Date.today
  
    params[:calendar] = @date

    @visite         = current_user.visite.includes(:cliente => :visite).where(baule: false).filtra(params)
    
    @visite_grouped = @visite.order("data desc").group_by(&:data)
    
  end


  def pianifica
    @clienti = current_user.clienti.not_deleted.scuola_primaria.nel_baule

    @clienti.each do |c|
      if params[:data_visita].present?
        if params[:data_visita] == 'no'
          c.propa2014.data_visita = Date.new(2014, 1, 1) 
        elsif params[:data_visita] == "da_fare"
          c.propa2014.data_visita = nil
        else
          c.propa2014.data_visita = Chronic::parse(params[:data_visita])
        end
      elsif params[:data_vacanze].present?
        if params[:data_vacanze] == 'no'
          c.propa2014.data_vacanze = Date.new(2014, 1, 1)  
        elsif params[:data_vacanze] == "da_fare"
          c.propa2014.data_vacanze = nil
        else
          c.propa2014.data_vacanze = Chronic::parse(params[:data_vacanze])
        end
      elsif params[:data_ritiro].present?
        if params[:data_ritiro] == 'no'
          c.propa2014.data_ritiro = Date.new(2014, 1, 1)  
        elsif params[:data_ritiro] == "da_fare"
          c.propa2014.data_ritiro = nil
        else
          c.propa2014.data_ritiro = Chronic::parse(params[:data_ritiro])
        end
      end
      c.propa2014.save
    end
    redirect_to :back
  end


  def svuota_baule
    @visite = current_user.visite.nel_baule
    @visite.each do |v|
      v.destroy
    end
    redirect_to :back
  end

  
  # def show
  #   @propa2014 = Propa2014.find(params[:id])

  #   respond_to do |format|
  #     format.html # show.html.erb
  #     format.json { render json: @propa2014 }
  #   end
  # end

  
  # def new
  #   @propa2014 = Propa2014.new

  #   respond_to do |format|
  #     format.html # new.html.erb
  #     format.json { render json: @propa2014 }
  #   end
  # end

  
  # def edit
  #   @propa2014 = Propa2014.find(params[:id])
  # end

  # # POST /propa2014s
  # # POST /propa2014s.json
  # def create
  #   @propa2014 = Propa2014.new(params[:propa2014])

  #   respond_to do |format|
  #     if @propa2014.save
  #       format.html { redirect_to @propa2014, notice: 'Propa2014 was successfully created.' }
  #       format.json { render json: @propa2014, status: :created, location: @propa2014 }
  #     else
  #       format.html { render action: "new" }
  #       format.json { render json: @propa2014.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # PUT /propa2014s/1
  # # PUT /propa2014s/1.json
  # def update
  #   @propa2014 = Propa2014.find(params[:id])

  #   respond_to do |format|
  #     if @propa2014.update_attributes(params[:propa2014])
  #       format.html { redirect_to @propa2014, notice: 'Propa2014 was successfully updated.' }
  #       format.json { head :no_content }
  #     else
  #       format.html { render action: "edit" }
  #       format.json { render json: @propa2014.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # DELETE /propa2014s/1
  # # DELETE /propa2014s/1.json
  # def destroy
  #   @propa2014 = Propa2014.find(params[:id])
  #   @propa2014.destroy

  #   respond_to do |format|
  #     format.html { redirect_to propa2014s_url }
  #     format.json { head :no_content }
  #   end
  # end
end
