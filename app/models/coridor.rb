class Coridor < ActiveRecord::Base
  belongs_to :faculty
  has_many :candidates, :conditions => "finished_on IS NOT NULL"
  has_many :obligate_subjects
  has_many :voluntary_subjects
  has_many :seminar_subjects 
  has_many :requisite_subjects 
  has_one :exam_term
	has_many :indexes
  validates_presence_of :faculty
# returns array structured for html select
  def self.for_select(options = {})
    if options[:faculty]
      faculty = options[:faculty].is_a?(Faculty) ? options[:faculty].id : options[:faculty]
      result = self.find_all_by_faculty_id(faculty)
    else
      result = self.find(:all)
    end
    result = result.map {|d| [d.name, d.id]}
    if options[:include_empty]
      [['---', '0']].concat(result)
    else
      result
    end
  end
end
