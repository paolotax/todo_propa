class ClassiInsertersController < ApplicationController

  def new
    @classi_inserter = ClassiInserter.new
  end
  
  def create
    # raise params.inspect
    @classi_inserter = ClassiInserter.new(params[:classi_inserter])
    
    if @classi_inserter.valid?
      @classi_inserter.insert_classi
      flash[:notice] = "Classi inserite."
      redirect_to :back
    else
      redirect_to :back
    end
  
  end

end
