class AppuntoEvent < ActiveRecord::Base


  belongs_to :appunto


  attr_accessible :state


  validates_presence_of :appunto_id


  def self.with_last_state(state)
    joins(:appunto).order("id desc").group(Appunto.column_names.collect { |c| "appunti.#{c}" }.join(",")).having(state: state)
  end


end

# == Schema Information
#
# Table name: appunto_events
#
#  id         :integer         not null, primary key
#  appunto_id :integer
#  state      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

