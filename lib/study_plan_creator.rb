# TODO redone with more generality, don't use class variables and so....
module StudyPlanCreator
  # adds requisite subjects to study plan
  def create_requisite
    @student.index.coridor.requisite_subjects.each do |sub|
      @session['plan_subjects'] << PlanSubject.new('subject_id' => 
      sub.subject.id, 'finishing_on' => sub.requisite_on)
    end
  end

  # prepares obligate subjects
  def create_obligate
    @type = 'obligate'
    @plan_subjects = []
    @session['study_plan'].index.coridor.obligate_subjects.each do |sub|
      ps = PlanSubject.new
      ps.id = sub.subject.id
      ps.subject = sub.subject
      @plan_subjects << ps
    end
    create_seminar if @plan_subjects.empty?
  end

  # prepares seminar subjects
  def create_seminar
    @type = 'seminar'
    @plan_subjects = []
    @session['study_plan'].index.coridor.seminar_subjects.each do |sub|
      (ps = PlanSubject.new('subject_id' => sub.subject.id)).id = sub.subject.id
      @plan_subjects << ps
    end
    create_voluntary if @plan_subjects.empty?
  end

  # prepares language  subject
  def create_language
    @type = 'language'
    @plan_subjects = []
    (1..2).each do |index|
      ps = PlanSubject.new
      ps.id = index
      @plan_subjects << ps
    end
  end

  # prepares voluntary subject 
  def create_voluntary
    @type = 'voluntary'
    @plan_subjects = []
    count = FACULTY_CFG[@student.faculty.id]['subjects_count'] -
      @session['plan_subjects'].size
    count.times do |index|
      (ps = PlanSubject.new).id = index + 1
      @plan_subjects << ps
    end
    unless @plan_subjects.empty? 
      (-3..-1).each do |i|
        (ps = PlanSubject.new).id = i
        @plan_subjects << ps
      end
    else
      create_language
    end
  end

  # extracts voluntary subjects from request
  def extract_voluntary(remap_id = false)
    external = 0
    @plan_subjects = []
    @params['plan_subject'].each do |id, ps|
      next if ps['subject_id'] == '-1'
      if ps['subject_id'] == '0' 
        external += 1
        subject = ExternalSubject.new
        subject.label = ps['label']
        unless subject.valid?
          @errors << _("title for external subject cannot be empty")
        end
        esd = subject.build_external_subject_detail(@params['external_subject_detail'][id])
        unless esd.valid?
          @errors << _("university for external subject cannot be empty")
        else
          subject.external_subject_detail = esd
        end
      else
        subject = Subject.find(ps['subject_id'])
      end
      plan_subject = PlanSubject.new
      plan_subject.finishing_on = ps['finishing_on']
      plan_subject.subject = subject
      plan_subject.id = id if remap_id
      @plan_subjects << plan_subject
    end
    # BLOODY HACK
    unless external == 0
      return external - 1
    else
      return 0
    end
  end
  # extracts language subjects from request
  def extract_language(remap_id = false)
    @plan_subjects = []
    @params['plan_subject'].each do |id, ps|
      plan_subject = PlanSubject.new(ps)
      plan_subject.id = id if remap_id
      last_semester(ps['finishing_on'])
      @plan_subjects << plan_subject
    end
  end
  # controls last semester
  def last_semester(semester)
    @session['last_semester'] ||= 0
    if @session['last_semester'] < semester.to_i
      @session['last_semester'] = semester.to_i   
    end
  end
  # resets variables used in creation form
  def prepare_plan_session
    @session['study_plan'] = @study_plan = @student.index.build_study_plan
    @session['plan_subjects'] = []
    @session['disert_theme'] = nil
    @session['last_semester'] = nil
  end
end
