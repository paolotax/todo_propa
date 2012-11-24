class AppuntoEvent < ActiveRecord::Base

  belongs_to :appunto

  attr_accessible :state

  validates_presence_of :appunto_id
  validates_inclusion_of :state, in: Appunto::STATES

  def self.with_last_state(state)
    joins(:appunto).order("id desc").group(Appunto.column_names.collect { |c| "appunti.#{c}" }.join(",")).having(state: state)
  end

end
