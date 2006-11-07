class AddressType < ActiveRecord::Base
untranslate_all
  validates_presence_of :label
end
