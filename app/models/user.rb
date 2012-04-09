class User < ActiveRecord::Base

  has_many :clienti
  has_many :appunti, :through => :clienti
  has_many :righe,  :through => :appunti
  has_many :visite,  :through => :clienti
  has_many :fatture, :through => :clienti
  has_many :adozioni, :through => :clienti
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  
  validates :username, presence: true
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me, :avatar
  attr_accessible  :nome_completo, :telefono, :codice_fiscale, :partita_iva
  
  mount_uploader :avatar, AvatarUploader
  
  require 'controlla_c_f'
  # require 'controlla_p_i'
  
  def controlla_cf(text)
    if ControllaCF.valid?(text)
      text
    else
      "Codice non valido"
    end
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

