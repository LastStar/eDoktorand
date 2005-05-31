class DisertTheme < ActiveRecord::Base
  belongs_to :index
  validates_presence_of :index
  validates_presence_of :title
  validates_presence_of :finishing_to
end
