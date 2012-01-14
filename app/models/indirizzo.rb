class Indirizzo < ActiveRecord::Base
  
  # geocoded_by :full_street_address
  # after_validation :geocode, 
  #                     :if => lambda{ |obj| obj.indirizzo_changed? || obj.cap_changed? || obj.citta_changed? || obj.cap_changed? }
  
  #acts_as_gmappable :process_geocoding => "before_save"
  
  belongs_to :indirizzable, :polymorphic => true
  
  def label_indirizzo
    '<em>'+ self.destinatario + '</em></br>' +
    self.indirizzo + '</br>' +
    self.cap + ' ' + self.citta + ' ' + self.provincia
  end
  
  def to_s
    return "#{destinatario}\n#{indirizzo}\n#{cap} #{citta} #{provincia}"
  end
  
  def full_street_address
    [self.indirizzo, self.cap, self.citta, self.provincia].join(', ')
  end
  
  # def gmaps4rails_address
  #   [self.indirizzo, self.cap, self.citta, self.provincia].join(', ')
  # end
  # 
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
