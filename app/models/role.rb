class Role < ActiveRecord::Base
  untranslate_all
  has_and_belongs_to_many :permissions
  has_and_belongs_to_many :users
end
