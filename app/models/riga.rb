class Riga < ActiveRecord::Base
  belongs_to :appunto
  belongs_to :libro
end
