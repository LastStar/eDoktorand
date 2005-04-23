class DisertTheme < ActiveRecord::Base
  belongs_to :index
  has_one :methodology
  validates_presence_of :index
  validates_presence_of :title
end
