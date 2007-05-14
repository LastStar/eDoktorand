class Faculty < ActiveRecord::Base
  untranslate_all
  has_many :coridors
  has_many :departments
  has_many :documents
  has_many :faculty_employments, :foreign_key => 'unit_id'
  has_one :secretary_employment, :class_name => 'FacultyEmployment',
      :foreign_key => 'unit_id', :order => :id
  has_one :deanship

  # returns array for html select
  def self.for_select(options = {})
    result = self.find(:all).map {|f| [f.name, f.id]}
    if options[:include_empty]
      [['---', '0']].concat(result)
    else
      result
    end
  end

  # TODO refactor to use department ids
  # returns string for sql IN statement
  def departments_for_sql
    self.departments.map {|dep| dep.id}.join(', ')
  end

  # returns array of corridor ids
  def coridors_ids
    self.coridors.map {|c| c.id}
  end

  # returns array of department ids
  def departments_ids
    self.departments.map {|d| d.id}
  end

  # return acredited corridors
  def accredited_coridors
    Coridor.find(:all, 
                :conditions => ['faculty_id = ? AND accredited = ? ', id, 1])
  end

  # retuns dean of the faculty
  def dean
    deanship.dean
  end

  def secretary
    FacultySecretary.find(:first, :include => 'faculty_employment',
        :conditions => ["unit_id = ?", id])
  end

  # retuns dean of the faculty
  def dean_label
    return _('director') if id==2
    _('dean')
  end

  # retuns dean of the faculty
  # TODO redone with faculty configuration
  def dean_label_en
    return 'director' if id == 2
    'dean'
  end

  def subjects
    departments.map {|d| d.subjects}.flatten
  end

  def study_plans
    StudyPlan.find(:all, :include => [:index => :department], 
                   :conditions => ["departments.faculty_id = ? \
                                   and indices.finished_on is null 
                                   and study_plans.canceled_on is null", self.id])
  end
end
