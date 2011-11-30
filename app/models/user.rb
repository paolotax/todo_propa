class User < ActiveRecord::Base
  
  has_many :scuole
  has_many :appunti, :through => :scuole
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  validates :username, presence: true
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me
  
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
