class Indirizzo < ActiveRecord::Base
  
  belongs_to :indirizzable, :polymorphic => true

  validates :citta,        :presence => true
  validates :provincia,    :presence => true, :length => { :is => 2 }

  geocoded_by :full_street_address
  
  # after_validation :geocode, 
  #                        :if => lambda{ |obj| obj.indirizzo_changed? || obj.cap_changed? || obj.citta_changed? || obj.cap_changed? || obj.indirizzable.cytta_changed? }

  def full_street_address
    [self.indirizzo, self.cap, self.citta, self.indirizzable.citta, self.provincia].join(', ')
  end

  acts_as_gmappable

  def gmaps4rails_address
    "#{self.indirizzo}, #{self.indirizzable.citta}, #{self.citta}, #{self.provincia}"
  end
  
  def gmaps4rails_infowindow
    "#{self.indirizzable.nome} </br> #{self.indirizzable.citta}"
  end
  
  def gmaps4rails_marker_picture
    {
     "picture" => "/images/#{self.indirizzable.cliente_tipo.parameterize}.png",
     "width" => "32",
     "height" => "37",
     "marker_anchor" => [ 16, 38],
     "shadow_picture" => "/images/morgan.png" ,
     "shadow_width" => "110",
     "shadow_height" => "110",
     "shadow_anchor" => [ 5, 10],
    }
  end
  
  # def self.gmaps4rails_trusted_scopes
  #   ["find", 'max_qi', 'first']
  # end
  # 
  # def gmaps4rails_infowindow
  #   name = self.citta.nil? ? "default" : self.citta
  #   "<em>" + self.citta + "</em>"
  # end
  # 
  # def to_gomap_marker
  #   data = []
  #   data << { :latitude => self.latitude, :longitude => self.longitude, :title => self.citta, :draggable => true, :id => 'baseMarker', :html => { :content => self.label_indirizzo, :popup => true  } }    
  # end

end
