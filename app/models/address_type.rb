class AddressType < ActiveRecord::Base
  validates_presence_of :label
end
