class Monkey < ActiveRecord::Base
  attr_accessor :unique
  
  belongs_to :pirate
  validates_presence_of :name
end
