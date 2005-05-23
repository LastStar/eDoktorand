class CoridorSubject < ActiveRecord::Base
  belongs_to :coridor
  belongs_to :subject
  validates_presence_of :coridor
  validates_presence_of :subject
end
