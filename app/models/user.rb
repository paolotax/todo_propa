class User < ActiveRecord::Base

  has_many :clienti
  has_many :appunti,  :through => :clienti
  has_many :righe,    :through => :appunti
  has_many :classi,   :through => :clienti
  has_many :propa2014s,   :through => :clienti
  
  has_many :visite,   :through => :clienti

  has_many :fatture
  
  has_many :righe_fattura, :through => :fatture, :source => :righe

  has_many :adozioni, :through => :clienti
  has_many :mie_adozioni, :through => :clienti, :source => :adozioni, :include => :libro, :conditions => "libri.settore = 'Scolastico'"
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         

  validates :username, presence: true
  
  attr_accessor :login
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me, :avatar
  attr_accessible  :nome_completo, :telefono, :codice_fiscale, :partita_iva, :login
  
  
  
  mount_uploader :avatar, AvatarUploader
  
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end
  
  require 'controlla_c_f'
  # require 'controlla_p_i'
  
  def controlla_cf(text)
    if ControllaCF.valid?(text)
      text
    else
      "Codice Fiscale non valido"
    end
  end
  
  %w[indirizzo cap citta provincia iban].each do |key|
    attr_accessible key
    scope "has_#{key}", lambda { |value| where("properties @> (? => ?)", key, value) }

    define_method(key) do
      properties && properties[key]
    end

    define_method("#{key}=") do |value|
      self.properties = (properties || {}).merge(key => value)
    end
  end

  def cached_baule_count
    Rails.cache.fetch([self, 'baule_count']) { visite.nel_baule.size }
  end
  
  
  
end


# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(128)     default(""), not null
#  username               :string(255)
#  avatar                 :string(255)
#  telefono               :string(255)
#  web_site               :string(255)
#  nome_completo          :string(255)
#  codice_fiscale         :string(255)
#  partita_iva            :string(255)
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#

