class AtestationTerm < ActiveRecord::Base
  belongs_to :faculty
  validates_presence_of :opening_on, :closing_on, :faculty
  # return actual atestation 
  def self.actual(faculty)
    find(:first, :conditions => ['opening_on <= NOW() and closing_on >= NOW() and
    faculty_id = ?', faculty.id], :order => ["created_on"])
  end
  # returns true if si atestation time now
  def self.actual?(faculty)
    return true if count(['opening_on <= NOW() and closing_on >= NOW() and
    faculty_id = ?', faculty.id]) > 0
  end
end
