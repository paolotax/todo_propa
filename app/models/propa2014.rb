class Propa2014 < ActiveRecord::Base

  belongs_to :cliente
  belongs_to :user

  validates :cliente_id, uniqueness: true

  # def self.create_visite_for_user(user)

  #   user.propa2014s.all.each do |p|
      
  #     ["data_visita", "data_vacanze", "data_ritiro"].each do |f|

  #       if p.send(f).present?

  #         visita = user.visite.find_or_initialize_by_cliente_id_and_data( p.cliente_id, p.send(f))
  #         visita.baule = false
            
  #         if f == 'data_visita'
  #           visita.add_scopo("serie")
  #         elsif f == 'data_vacanze'
  #           visita.add_scopo("vacanze")
  #         else
  #           visita.add_scopo("ritiro")
  #         end


  #         visita.save

  #       end
  #     end

  #   end
  # end

end
