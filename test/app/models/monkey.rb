class Monkey < ActiveRecord::Base
  attr_accessor :unique, :counter
    
  belongs_to :pirate
  validates_presence_of :name
end
