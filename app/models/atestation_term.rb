class AtestationTerm < ActiveRecord::Base
  belongs_to :faculty
  validates_presence_of :opening_on, :faculty
  has_many :atestation_detail
  # returns true if is atestation time now
  def self.actual?(faculty)
    count(['opening_on <= NOW() and faculty_id = ?', faculty.id]) > 0
  end
  # returns true if next atestation is set up
  def self.next?(faculty)
    count(['opening_on > NOW() and faculty_id = ?', faculty.id],
    :order => ["created_on"]) > 0
  end
  # return actual atestation 
  def self.actual(faculty)
    find(:first, :conditions => ['opening_on <= NOW() and faculty_id = ?',
    faculty.id], :order => ["created_on"])
  end
  # return next atestation 
  def self.next(faculty)
    find(:first, :conditions => ['opening_on > NOW() and faculty_id = ?',
    faculty.id], :order => ["created_on"])
  end
end
