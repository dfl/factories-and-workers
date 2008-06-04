class Monkey < ActiveRecord::Base
  belongs_to :pirate
  validates_presence_of :name
end
