class Methodology < ActiveRecord::Base
  belongs_to :disert_theme
  validates_presence_of :disert_theme
end

