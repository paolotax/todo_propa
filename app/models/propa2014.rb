class Propa2014 < ActiveRecord::Base

  belongs_to :cliente
  belongs_to :user

  validates :cliente_id, uniqueness: true

  def self.create_visite_for_user(user)

    user.propa2014s.all.each do |p|


      puts p.cliente.visite.map { |e| e.start.to_date }

    end

  end

end
