class Department < ActiveRecord::Base

  has_many :candidates, :conditions => "finished_on IS NOT NULL"
  has_many :indices
  has_many :tutorships
  has_many :tutors, :through => :department_employment
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

  def self.find(*args)
    if args.first.is_a?(Hash) && user = args.first[:user]
      if user.has_role?('vicerector')
        return super(:all)
      else
        return user.person.faculty.departments
      end
    else
      super
    end

  end
end
