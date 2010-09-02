class Faculty < ActiveRecord::Base
  
  has_many :specializations
  has_many :departments
  has_many :documents
  has_many :faculty_employments, :foreign_key => 'unit_id'
  has_one :secretary_employment, :class_name => 'FacultyEmployment',
      :foreign_key => 'unit_id', :order => :id
  has_one :deanship
  has_many :candidates, :through => :specializations

  # return acredited specializations
  def accredited_specializations
    Specialization.find(:all, 
                :conditions => ['faculty_id = ? AND accredited = ? ', id, 1])
  end

  # retuns dean of the faculty
  def dean
    deanship.dean
  end

  def secretary
    FacultySecretary.find(:first, :include => :faculty_employment,
                          :conditions => ["employments.unit_id = ?", id])
  end

  # retuns dean of the faculty
  def dean_label
    I18n::t(:message_0, :scope => [:txt, :model, :faculty])
  end

  # retuns dean of the faculty
  # TODO redone with faculty configuration
  def dean_label_en
    return FACULTY_CFG[self.id]['attestation_title'] if FACULTY_CFG[self.id]['attestation_title']
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
