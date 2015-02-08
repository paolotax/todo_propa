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
# == Schema Information
#
# Table name: propa2014s
#
#  id               :integer         not null, primary key
#  cliente_id       :integer
#  data_visita      :date
#  data_ritiro      :date
#  data_interclasse :date
#  data_collegio    :date
#  kit_123          :string(255)
#  nr_123           :integer
#  kit_45           :string(255)
#  nr_45            :integer
#  kit_123_ing      :string(255)
#  nr_45_ing        :integer
#  kit_123_rel      :string(255)
#  nr_123_rel       :integer
#  kit_45_rel       :string(255)
#  nr_45_rel        :integer
#  vac_1            :string(255)
#  vac_2            :string(255)
#  vac_3            :string(255)
#  vac_4            :string(255)
#  vac_5            :string(255)
#  nr_vac_1         :integer
#  nr_vac_2         :integer
#  nr_vac_3         :integer
#  nr_vac_4         :integer
#  nr_vac_5         :integer
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#  data_vacanze     :date
#

