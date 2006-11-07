class Permission < ActiveRecord::Base
  untranslate_all
  has_and_belongs_to_many :roles
end
