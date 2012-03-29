class Visita < ActiveRecord::Base
  
  
  
  belongs_to :cliente
  has_many   :da_fare, :through => :cliente, 
                       :class_name => "Appunto", 
                       :source => :appunti, 
                       :conditions => ['appunti.stato <> ?', 'X']
  
  has_many :visita_appunti, dependent: :destroy
  has_many :appunti, :through => :visita_appunti

  scope :nel_baule, where(baule: true)
  
  after_create :add_appunti
  
  def nel_baule?
    self.baule == true
  end
  
  def add_appunti
    self.da_fare.each do |appunto|
      self.appunti << appunto
    end
  end  

end


# == Schema Information
#
# Table name: visite
#
#  id         :integer         not null, primary key
#  cliente_id :integer
#  titolo     :string(255)
#  start      :datetime
#  end        :datetime
#  all_day    :boolean
#  baule      :boolean
#  scopo      :string(255)
#  giro_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

