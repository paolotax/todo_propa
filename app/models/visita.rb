class Visita < ActiveRecord::Base
  
  # WillFilter::Calendar::MONTHS = ['Gennaio', 'Febbraio', 'Marzo', 'Aprile', 'Maggio', 'Giugno', 'Luglio', 'Agosto', 'Settembre', 'Ottobre', 'Novembre', 'Dicembre'] 
  # WillFilter::Calendar::DAYS = ['dom', 'lun', 'mar', 'mer', 'gio', 'ven', 'sab']
  
  # include ActiveModel::ForbiddenAttributesProtection

  belongs_to :cliente, touch: true
  
  # belongs_to :user

  # has_many   :da_fare, :through => :cliente, 
  #                      :class_name => "Appunto", 
  #                      :source => :appunti, 
  #                      :conditions => ['appunti.stato <> ?', 'X']
  

  # has_many :visita_appunti, dependent: :destroy
  
  # has_many :appunti, :through => :visita_appunti
  
  # after_create :add_appunti


  has_many :adozioni, :through => :cliente
  
        
  attr_writer :step
  
  validates :cliente_id, presence: true
  validates :cliente_id, :uniqueness => { :scope => :data, :message => "gia' nel giro" }

  # validate    :check_data
  
  before_save :save_data

  after_commit :flush_cache


  scope :nel_baule,     where(baule: true)
  scope :non_nel_baule, where(baule: false)
  

  scope :settembre, where("visite.data > ?", Date.new(Time.now.year, 7, 31))  # fino al compleanno
    
  scope :filter_calendar, lambda {|d| where("data >= ? AND data <= ?", d.beginning_of_month - 7.day, d.end_of_month + 7.day)}

  
  scope :previous, where("visite.data > ?", Date.today).order("visite.data DESC").limit(1)
  scope :oggi,     where("visite.data = ?", Date.today).order(:data).limit(1)
  scope :next,     where("visite.data > ?", Date.today).order(:data).limit(1)

  

  def flush_cache
    Rails.cache.delete([ cliente.user, "baule_count"])
  end
  

  def giorno
    if start
      start.to_date
    end
  end
  
  
  def to_s
    "#{data} #{scopo}"
  end
  
  
  def nel_baule?
    self.baule == true
  end

  
  def self.filtra(params)
    visite = scoped
    visite = visite.where("clienti.provincia = ?", params[:provincia]) if params[:provincia].present?
    visite = visite.filter_calendar(params[:calendar]) if params[:calendar].present?
    visite
  end

  
  def add_scopo(new_scopo)

    if self.scopo.nil?
      self.scopo = new_scopo
    else
      self.scopo = self.scopo.split(", ").push(new_scopo).uniq.sort.join(", ")
    end
  end

  
  def appunti
    
    if nel_baule?

      cliente.appunti.in_corso
    else

      []
    end
  end


  # def mie_adozioni_grouped_titolo
  #   self.cliente.mie_adozioni.group_by(&:libro_id) || []
  # end


  private
  
 
    # def add_appunti
    #   self.da_fare.each do |appunto|
    #     self.appunti << appunto
    #   end
    # end  

 
    def save_data

      data.nil? ? self.baule = true : self.baule = false

      if @step
        self.start = data.beginning_of_day + 8.hours + 30.minutes + (30.minutes * @step.to_i)
        self.end   = start + 30.minutes
      end
    end


    # def check_data
    #   if @data.present? && Date.parse(@data).nil?
    #     errors.add :data, "cannot be parsed"
    #   end
    # rescue ArgumentError
    #   errors.add :data, "data non valida"
    # end

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
#  data       :date
#

