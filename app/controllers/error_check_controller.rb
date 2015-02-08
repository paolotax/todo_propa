class ErrorCheckController < ApplicationController

  def index

    @appunti_errore_importo = current_user.appunti.includes(:righe).select(&:importo_errato?)
    
    @fatture_errore_importo = current_user.fatture.includes(:righe).order("causale_id desc, data desc, numero desc").select(&:importo_errato?)

    appunti_fattura_id_errata = []

    current_user.righe.not_deleted.where("fattura_id is not null").each do |r|
      unless current_user.fatture.exists?(r.fattura_id)
        appunti_fattura_id_errata << r.appunto_id
      end
    end.uniq

    @appunti_fattura_id_errata = current_user.appunti.find appunti_fattura_id_errata

  end

end
