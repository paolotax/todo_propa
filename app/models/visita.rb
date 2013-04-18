class Visita < ActiveRecord::Base
  
  WillFilter::Calendar::MONTHS = ['Gennaio', 'Febbraio', 'Marzo', 'Aprile', 'Maggio', 'Giugno', 'Luglio', 'Agosto', 'Settembre', 'Ottobre', 'Novembre', 'Dicembre'] 
  WillFilter::Calendar::DAYS = ['dom', 'lun', 'mar', 'mer', 'gio', 'ven', 'sab']
  
  
  belongs_to :cliente
  
  has_many   :da_fare, :through => :cliente, 
                       :class_name => "Appunto", 
                       :source => :appunti, 
                       :conditions => ['appunti.stato <> ?', 'X']
  
  has_many :visita_appunti, dependent: :destroy
  has_many :appunti, :through => :visita_appunti
  
  has_many :adozioni, :through => :cliente
  
  scope :nel_baule,     where(baule: true)
  scope :non_nel_baule, where(baule: false)
  
  scope :settembre, where("start > ?", Date.new(Time.now.year, 4, 15))
  
  after_create :add_appunti
  
  
  attr_writer :data, :step
  
  validates :cliente_id, :uniqueness => { :scope => :start, :message => "gia' nel giro" }
  
  validate    :check_data
  before_save :save_data
  
  
  def giorno
    if start
      start.to_date
    end
  end
  
  def data
    @data || start.try(:strftime, "%d-%m-%Y")
  end

  def to_s
    "#{start.strftime('%d-%m-%y')} #{titolo}"
  end
  
  def nel_baule?
    self.baule == true
  end

  def self.filtra(params)
    visite = scoped
    visite = visite.where("clienti.provincia = ?", params[:provincia]) if params[:provincia].present?
    visite
  end

  def mie_adozioni_grouped_titolo
    self.cliente.mie_adozioni.group_by(&:libro_id) || []
  end


  private
  
    def add_appunti
      self.da_fare.each do |appunto|
        self.appunti << appunto
      end
    end  

    def save_data
      if @data && @step
        self.start = Time.zone.parse(@data).beginning_of_day + 8.hours + 30.minutes + (30.minutes * @step.to_i)
        self.end   = self.start + 30.minutes
      end
    end

    def check_data
      if @data.present? && Date.parse(@data).nil?
        errors.add :data, "cannot be parsed"
      end
    rescue ArgumentError
      errors.add :data, "data non valida"
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

