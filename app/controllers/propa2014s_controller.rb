class Propa2014sController < ApplicationController
  
  can_edit_on_the_spot

  def index

    @vacanze_dates = [
      Date.new(2014, 4, 23),
      Date.new(2014, 4, 24),
      Date.new(2014, 4, 26),
      Date.new(2014, 4, 28),
      Date.new(2014, 4, 29),
      Date.new(2014, 4, 30),
      Date.new(2014, 5, 2),
      Date.new(2014, 5, 3),
      Date.new(2014, 5, 5),
      Date.new(2014, 5, 6),
      Date.new(2014, 5, 7),
      Date.new(2014, 5, 8),
      Date.new(2014, 5, 9),
      Date.new(2014, 5, 10)
    ]  

    @clienti = current_user.clienti.not_deleted.joins(:propa2014).per_localita
    @tutti = @clienti.all

    if params[:provincia]
      @clienti = @clienti.where(provincia: params[:provincia])
    end

    if params[:data].present?
      @clienti = @clienti.where("propa2014s.data_visita = ? OR propa2014s.data_vacanze = ? OR propa2014s.data_ritiro = ?", Chronic::parse(params[:data]), Chronic::parse(params[:data]), Chronic::parse(params[:data]))
    else
      if params[:status].present?
        if params[:status] == "da_fare"
          @clienti = @clienti.where("propa2014s.data_visita is null or propa2014s.data_visita > ?", Time.now.to_date)
        elsif params[:status] == "da_pianificare"
          @clienti = @clienti.where("propa2014s.data_visita is null")
        elsif params[:status] == "dare_vacanze"
          @clienti = @clienti.where("propa2014s.data_vacanze is null")
        elsif params[:status] == "da_ritirare"
          @clienti = @clienti.where("propa2014s.data_ritiro is null")
        end
      end
    end

    @count_elementari = @clienti.select { |c| c.scuola_primaria? == true}.count
    @provincie = current_user.clienti.not_deleted.direzioni.select_provincia.map(&:provincia)
    #@clienti = current_user.clienti.where(:ancestry => Cliente.roots.pluck(:id)).per_localita
  
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
