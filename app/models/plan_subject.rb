class PlanSubject < ActiveRecord::Base

  belongs_to :study_plan
  belongs_to :subject
  EMPTY_SUBJECT_COUNT = 3

  # returns true if plan subject has exam
  def finished?
    true unless self.finished_on.nil?
  end

  def finish!(time = Time.now)
    update_attribute('finished_on', time) unless finished?
  end

  # returns all unfinished plan subjects with external subjects
  # got one option :study_plan to find only for study plan
  def self.find_unfinished_external_for(user, options = {})
    sql = <<-SQL
    plan_subjects.finished_on is null and subjects.type = 'ExternalSubject' \
    and study_plans.approved_on is not null \
    and study_plans.actual = 1
    SQL
    if options[:study_plan]
      sql << "and study_plans.id = ?"
      sql = [sql, options[:study_plan].id]
    else
      sql << "and study_plans.id in (?)"
      sql = [sql, user.person.faculty.study_plans.map(&:id)]
    end
    find(:all, :conditions => sql,
         :include => [:subject, [:study_plan => [:index => :student]]],
         :order => 'people.lastname')
  end

  # returns unfinished external subjects for study_plan
  def self.find_unfinished_external(study_plan)
    study_plan = study_plan.id if study_plan.is_a? StudyPlan
    sql = <<-SQL
    plan_subjects.finished_on is null and subjects.type = 'ExternalSubject' \
    and study_plans.approved_on is not null and study_plans.id = ? \
    and study_plans.actual = 1
    SQL
    find(:all, :conditions => [sql, study_plan],
         :include => [:subject, :study_plan])
  end

  # returns all unfinished plan subjects
  # got option :subjects for returning just subjects
  def self.find_unfinished_for(user, options = {})
    sql = <<-SQL
    plan_subjects.finished_on is null and subjects.id in (?)\
    and study_plans.approved_on is not null \
    and study_plans.canceled_on is null \
    and study_plans.actual = 1 \
    and indices.finished_on is null
    SQL
    subj_ids = Subject.find_for(user).map {|s| s.id}
    psubs = find(:all, :conditions => [sql, subj_ids],
                 :include => [:subject, {:study_plan => :index}],
                 :order => "subjects.label")
    options[:subjects] ? psubs.map {|ps| ps.subject}.uniq : psubs
  end

  # returns all unfinished plan subjects from approved study plans
  # got option to return indices
  def self.find_unfinished_by_subject(subject_id, options = {})
    sql = <<-SQL
    plan_subjects.subject_id = ? and \
    plan_subjects.finished_on is null \
    and study_plans.approved_on is not null \
    and study_plans.canceled_on is null \
    and indices.finished_on is null \
    and study_plans.actual = 1
    SQL
    plan_subjects = find(:all, :include => [{:study_plan => :index}],
                         :conditions => [sql, subject_id])
    if options[:indices]
      plan_subjects.map { |ps| ps.study_plan.index }.uniq.sort do |x,y|
        x.student.display_name <=> y.student.display_name
      end
    elsif options[:students]
      plan_subjects.map { |ps| ps.study_plan.index.student }.uniq.sort do |x,y|
        x.display_name <=> y.display_name
      end
    else
      plan_subjects
    end
  end

  # returns plan subject for exam
  def self.find_for_exam(exam, options = {})
    return nil unless exam
    ps = find(:first, :conditions => ['study_plan_id = ? and subject_id = ?',
                                      exam.index.study_plan.id, exam.subject_id])
    if options[:update_attributes]
      ps.update_attributes(options[:update_attributes])
    end
    ps
  end

  def hide_style
    if id == 0 || (subject_id && (subject_id == -1 ||
         (subject_id > 0 && !subject.is_a?(ExternalSubject))))
      'display: none'
    end
  end

  def hide_style_edit(id)
    if !subject.is_a?(ExternalSubject)
      'display: none'
    end
  end

  #FIXME should be moved to corresponding classes
  def self.create_for(student, type)
    case type
    when :requisite
      RequisiteSubject.for_specialization(student.specialization).map do |specialization_subject|
        PlanSubject.new(:subject_id => specialization_subject.subject.id,
                        :finishing_on => specialization_subject.requisite_on)
      end
    when :obligate
      i = 0
      ObligateSubject.for_specialization(student.specialization).map do |specialization_subject|
        (ps = PlanSubject.new(:subject_id => specialization_subject.subject.id)).id = i
        i += 1
        ps
      end
    when :seminar
      subjects = []
      2.times do |i|
        (ps = PlanSubject.new).id = i + 1
        subjects << ps
      end
      subjects
    when :language
      subjects = []
      n = [14, 15].include?(student.faculty.id) ? 1 : 2
      n.times do |i|
        (ps = PlanSubject.new).id = i + 1
        subjects << ps
      end
      subjects
    when :voluntary
      subjects = []
      student.specialization.voluntary_amount.times do |i|
        (ps = PlanSubject.new).id = i + 1
        subjects << ps
      end
      subjects.concat((-EMPTY_SUBJECT_COUNT..-1).map do |i|
        (ps = PlanSubject.new).id = i
        ps
      end)
    end
  end

  def is_external_and_invalid?
    subject && subject.is_a?(ExternalSubject) &&
      (!subject.valid? || !subject.external_subject_detail.valid?)
  end
end
