class Tutor < Person
  has_one :tutorship
  belongs_to :title_before, :class_name => 'Title', :foreign_key => 'title_before_id'
  belongs_to :title_after, :class_name => 'Title', :foreign_key => 'title_after_id'

  validates_presence_of :tutorship
end
