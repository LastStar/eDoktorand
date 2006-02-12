class PlanSubject < ActiveRecord::Base
  belongs_to :study_plan
  belongs_to :subject
  # returns true if plan subject has exam
  def finished?
    return true unless self.finished_on.nil?
  end

  # returns all unfinished plan subjects with external subjects 
  # got one option :study_plan to find only for study plan
  def self.find_unfinished_external(options = {})
    sql = <<-SQL
    plan_subjects.finished_on is null and subjects.type = 'ExternalSubject' 
    and study_plans.approved_on is not null
    SQL
    if options[:study_plan]
      sql << "and study_plans.id = ?"
      sql = [sql, options[:study_plan].id]
    end
    find(:all, :conditions => sql, :include => [:subject, :study_plan])
  end

  # returns all unfinished plan subjects
  # got option :subjects for returning just subjects
  def self.find_unfinished_for(user, options = {})
    sql = "finished_on is null and subjects.id in (?)"
    subj_ids = Subject.find_for(user).map {|s| s.id}
    psubs = find(:all, :conditions => [sql, subj_ids], :include => :subject)
    options[:subjects] ? psubs.map {|ps| ps.subject}.uniq : psubs
  end

  # returns all unfinished plan subjects from approved study plans
  # got option to return study_plans
  def self.find_unfinished_by_subject(subject_id, options = {})
    plan_subjects = find(:all, :include => :study_plan, :conditions => 
      ['subject_id = ? and finished_on is null and approved_on is not null',
      subject_id])
    if options[:study_plans]
      plan_subjects.map {|ps| ps.study_plan}
    else
      plan_subjects
    end
  end
end
