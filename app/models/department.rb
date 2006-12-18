# this is stub for admit form. In application should be changed to unit
class Department < ActiveRecord::Base
  untranslate_all
  has_many :candidates
  has_many :indices
  has_many :tutorships
  has_many :tutors, :through => :tutorships
  has_one :leadership
  has_one :department_employment, :foreign_key => 'unit_id'
  belongs_to :faculty
  has_and_belongs_to_many :subjects

  # returns array structured for html select
  def self.for_select(options = {})
    if options[:faculty]
      faculty = options[:faculty].is_a?(Faculty) ? options[:faculty].id :
                                                   options[:faculty]
      result = find_all_by_faculty_id(faculty)
    else
      result = find(:all)
    end
    result = result.map {|d| [d.name, d.id]}
    if options[:include_empty]
      [['---', '0']].concat(result)
    else
      result
    end
  end

  def leader
    leadership.leader
  end

  def department_secretary
    department_employment.person
  end
end
