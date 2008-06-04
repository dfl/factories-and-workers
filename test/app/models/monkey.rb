class Monkey < ActiveRecord::Base
  has_and_belongs_to_many :pirates
  has_and_belongs_to_many :fruits
  
  validates_presence_of :name
end
