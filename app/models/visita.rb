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
  
  scope :nel_baule, where(baule: true)

  after_create :add_appunti
  
  
  attr_writer :data
  validate    :check_data
  before_save :save_data
  
  def nel_baule?
    self.baule == true
  end
  

  
  def mie_adozioni_grouped_titolo
    self.cliente.mie_adozioni.group_by(&:libro_id) || []
  end
  
  def self.filtra(params)
    visite = scoped
    visite = visite.where("clienti.provincia = ?", params[:provincia]) if params[:provincia].present?
    # appunti = appunti.where("clienti.comune = ?",    params[:comune])    if params[:comune].present?
    #     appunti = appunti.in_corso   if params[:status].present? && params[:status] == 'in_corso'
    #     appunti = appunti.completo   if params[:status].present? && params[:status] == "completati"
    #     appunti = appunti.da_fare    if params[:status].present? && params[:status] == "da_fare"
    #     appunti = appunti.in_sospeso if params[:status].present? && params[:status] == "in_sospeso"
    #     
    visite
  end
  
  
  def data
    @data || start.try(:strftime, "%d-%m-%Y")
  end

  # def data
  #   self.start
  # end
  # 
  # def data=(data)
  #   self.start = Date.parse(data).beginning_of_day
  #   self.end   = Date.parse(data).end_of_day
  # end

  private
  
    def add_appunti
      self.da_fare.each do |appunto|
        self.appunti << appunto
      end
    end  

    def save_data
      self.start = Date.parse(@data).beginning_of_day if @data.present?
      self.end   = Date.parse(@data).end_of_day if @data.present?
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

