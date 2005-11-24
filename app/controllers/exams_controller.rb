class ExamsController < ApplicationController
  include LoginSystem
  layout "employers"
  before_filter :set_title
  before_filter :login_required
  before_filter :prepare_user
  def index
    list
    render_action 'list'
  end

  def list
    if @user.has_one_of_roles?(['faculty_secretary', 'dean'])
      subjects = @user.person.faculty.departments.map {|d| d.subjects}.flatten
      conditions = "subject_id IN (#{subjects.map {|s| s.id}.join(',')})"
    elsif @user.has_one_of_roles?(['leader', 'department_secretary'])
      subjects = @user.person.department.subjects
      conditions = "subject_id IN (#{subjects.map {|s| s.id}.join(',')})"
    elsif @user.has_role?('tutor') 
      conditions = ['first_examinator_id = ?', @user.person.id]
    end
    @exams = Exam.find(:all, :conditions => conditions)
  end

  def show
    @exam = Exam.find(@params[:id])
  end

  def detail
    render_partial('detail', :exam =>
      Exam.find(@params['id']))
  end
  
  def new
    @exam = Exam.new
    @exam.creator = @user.person
  end

  # start of the exam creating process
  # rendering the two links
  def create
    @title = _("Creating exam")
  end

  # created exam object and subjects for select 
  # TODO sql finder for only subjects wich actually any student has
  def exam_by_subject
    @exam = Exam.new('created_by_id' => @user.person.id)
    @session['exam'] = @exam
    if @user.has_role?('admin')
      subjects  = Subject.find_all()
    elsif @user.has_one_of_roles?(['faculty_secretary', 'dean'])
      faculty = @user.person.faculty 
      subjects = faculty.departments.inject([]) {|arr, dep| arr.concat(dep.subjects)}
    elsif @user.has_one_of_roles?(['department_secretary', 'leader'])
      subjects = @user.person.department.subjects
    end
    # viz TODO
    # subjects = subjects.select {|sub| !sub.plan_subjects.empty?}
    subjects = subjects.select do |sub|
      not_finished = sub.plan_subjects.select do 
        |ps| !ps.finished? && ps.study_plan.approved?
      end
      not_finished.size > 0
    end
    render(:partial => "subjects", :locals => {:subjects => subjects}) 
  end
  
  # created exam object and subjects for select 
  # TODO sql finder for only subjects wich actually any student has
  # TODO sql finder for the students, that actually have the subjects
  # this person teaches (maybe the department)
  def exam_by_student
    @exam = Exam.new('created_by_id' => @user.person.id)
    @session['exam'] = @exam
    @conditions = ['indices.finished_on IS NULL AND study_plans.approved_on 
    IS NOT NULL']
    students = Index.find(:all, :conditions => @conditions, :include => [:student,
    :study_plan]).map {|i| i.student}
    render(:partial => "students", :locals => {:students => students}) 
  end
  
  # save subject of exam to session and adds students 
  def save_exam_subject
    exam = @session['exam']
    exam.subject_id = @params['subject']['id']
    @session['exam'] = exam
    @plan_subjects = PlanSubject.find(:all, :conditions => ['subject_id = ? and
    finished_on is null', @params['subject']['id']])
    @plan_subjects = @plan_subjects.select {|ps| ps.study_plan.approved?}
    students = []
    @plan_subjects.each {|plan| students << plan.study_plan.index.student}
    students = students.select {|stud| !stud.index.finished?}
    render(:partial => "examined_student", :locals => {:exam => exam, 
      :students => students})
  end
  
  # save the examined subject for the examined student
  def save_exam_student_subject
    exam = @session['exam']
    exam.subject_id = @params['subject']['id']
    @session['exam'] = exam
    @plan_subjects = PlanSubject.find_all_by_subject_id(@params['subject']['id'])
    plan_subject = PlanSubject.find(:all, :conditions => ['subject_id = ? and
    study_plan_id = ?', @params['subject']['id'], exam.index.study_plan.id])
    render(:partial => 'main_exam', :locals => {:exam => exam, :plan_subject =>
  plan_subject})
  end

  # save the examindex student to session
  def save_exam_student
    exam = @session['exam']
    index = Index.find_by_student_id(@params['student']['id'])
    exam.index = index 
    study_plan = StudyPlan.find_by_index_id(index.id)
    @session['exam'] = exam
    
    plan_subjects = PlanSubject.find(:all, :conditions => ['study_plan_id = ? and
    finished_on is null', study_plan.id])
    
    subjects = []
    
    if @user.has_role?(Role.find_by_name('admin'))
      plan_subjects.each{|plan| @subjects << plan.subject}
    elsif (@user.person.is_a? Dean) ||
      (@user.person.is_a? FacultySecretary)
      plan_subjects.each{|plan| subjects << plan.subject} 
    elsif (@user.person.is_a? Leader) ||
      (@user.person.is_a? DepartmentSecretary) ||
      (@user.person.is_a? Tutor)
      department = @user.person.tutorship.department
      plan_subjects.each do |plan| 
          subjects << plan.subject if plan.subject.departments.include? department
      end
    end

    #@subjects = @subjects.select {|sub| !sub.plan_subjects.empty?}
    render(:partial => "student_subjects", :locals => {:exam => exam, :subjects => subjects}) 
  end
  
  # save student of exam to session
  def save_student_subject
    exam = @session['exam']
    exam.index = Student.find(@params['student']['id']).index
    @session['exam'] = exam
    plan_subject = PlanSubject.find(:all, :conditions => ['subject_id = ? and
    study_plan_id = ?', exam.subject.id, exam.index.study_plan.id])
    render(:partial => 'main_exam', :locals => {:exam => exam, :plan_subject =>
  plan_subject})
  end
  
  # saves exam 
  def save
    exam = @session['exam']
    exam.attributes = @params['exam']
    # select the appropriate plan_subject to update the finished_on tag
    ps = PlanSubject.find(:first, :conditions => ["subject_id = ? and
    study_plan_id = ?", exam.subject_id, exam.index.study_plan.id])
    ps.attributes = @params['plan_subject'] if exam.passed?
    ps.save
    exam.save
    #redirect_to :action => 'index'
    render(:partial => 'show', :locals => {:exam => exam,
    :plan_subject => ps})
  end
  def edit
    @exam = Exam.find(@params[:id])
  end

  def update
    @exam = Exam.find(@params[:id])
    if @exam.update_attributes(@params[:exam])
      flash['notice'] = _("Exam was successfully updated.")
      redirect_to :action => 'list'
    else
      render_action 'edit'
    end
  end

  def destroy
    Exam.find(@params[:id]).destroy
    redirect_to :action => 'list'
  end
  # searches in exam list for students with desired lastname
  def search
    @conditions.first <<  ' AND lastname like ?'
    @conditions << "#{@params['search_field']}%"
    @indexes = Student.find(:all, :conditions => @conditions, :include =>
      :index).map {|s| s.index}
    @indexes = @indexes.select {|ind| !ind.exams.empty?}
    @exams = []
    @indexes.each {|ind| @exams.concat(ind.exams)}
    # @exams = Student.find(:all, :conditions => @conditions, :include =>
    #  :exam).map {|s| s.index.exams}
    render_partial @params['prefix'] ? @params['prefix'] + 'list' : 'list'
  end

  # searches in exam list for subject with desired lastname
  def search_exam
    @conditions_exam = "null is not null"
    @conditions_exam.first << ' label like ?'
    @conditions_exam << "#{@params['search_exam_field']}%"
    @subjects = Subject.find(:all, :conditions => @conditions_exam)
    @subjects = @subjects.select {|sub| !sub.exams.empty?}
    @exams = []
    @subjects.each {|sub| @exams.concat(sub.exams)}
    # @exams = Student.find(:all, :conditions => @conditions, :include =>
    #  :exam).map {|s| s.index.exams}
    render_partial @params['prefix'] ? @params['prefix'] + 'list' : 'list'
  end

  # sets title of the controller
  def set_title
    @title = _('Exams')
  end

end

