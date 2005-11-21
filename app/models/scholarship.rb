class Scholarship < ActiveRecord::Base
  belongs_to :index
  validates_presence_of :index
  acts_as_audited
end
