class Interupt < ActiveRecord::Base
  belongs_to :index
  validates_presence_of :index
end
