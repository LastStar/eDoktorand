class Tutorship < ActiveRecord::Base
  untranslate_all
  belongs_to :tutor
  belongs_to :department
  belongs_to :coridor
  validates_presence_of :tutor
  validates_presence_of :department
  validates_presence_of :coridor
end
