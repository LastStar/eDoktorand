class ProbationTermsController < ApplicationController
  include LoginSystem
  layout "employers"
  before_filter :set_title
  before_filter :login_required
  before_filter :prepare_student
  before_filter :prepare_user

  def index
    list
    render :action => 'list'
  end
  
  def list
     []
    if (@user.person.is_a?(Student) &&
      !@user.person.index.study_plan.nil?)
      @plan_subjects = @user.person.index.study_plan.plan_subjects
      @subjects = @plan_subjects.inject([]) {|subjects, plan| subjects << plan.subject}
    elsif (@user.person.is_a? Dean) ||
      (@user.person.is_a? FacultySecretary)
      faculty = @user.person.faculty 
      @subjects = faculty.departments.inject([]) {|subjects, dep|
        subjects.concat(dep.subjects)}
    elsif (@user.person.is_a? Leader) ||
      (@user.person.is_a? DepartmentSecretary) ||
      (@user.person.is_a? Tutor)
      if (@user.person.is_a? Leader)
        department = @user.person.leadership.department
      elsif (@user.person.is_a? Tutor)
        department = @user.person.tutorship.department
      else
        department = @user.person.department
      end
      @subjects = department.subjects
    else
      @subjects = Subject.find_all()
    end
    #@subjects.select {|sub| !sub.probation_terms.empty?}
    @probation_terms = []
    @subjects.each {|sub| !sub.probation_terms.empty? && @probation_terms.concat(sub.probation_terms)}
  end
  
  # enrolls student for a probation term
  def enroll
    if (@user.person.is_a?(Student))
      @user.person.probation_terms << ProbationTerm.find(@params['id'])
    end
    redirect_to :action => 'index'
  end
  
  def show
    @probation_term = ProbationTerm.find(params[:id])
  end

  def new
    @probation_term = ProbationTerm.new
    @probation_term.creator = @user.person
  end

  def detail
    render_partial('detail', :probation_term =>
      ProbationTerm.find(@params['id']))
  end
  
  # created exam object and subjects for select 
  def create
    @probation_term = ProbationTerm.new('created_by' => @user.person.id)
    @session['probation_term'] = @probation_term
    if @user.has_role?(Role.find_by_name('admin'))
      subjects  = Subject.find_all()
    elsif (@user.person.is_a? Dean) ||
      (@user.person.is_a? FacultySecretary)
      faculty = @user.person.faculty 
      subjects = faculty.departments.inject([]) {|subjs, dep|
        subjs.concat(dep.subjects)}
    elsif (@user.person.is_a? Leader) ||
      (@user.person.is_a? DepartmentSecretary) ||
      (@user.person.is_a? Tutor)
      if(@user.person.is_a? Leader)
        department = @user.person.leadership.department
      elsif (@user.person.is_a? Tutor)
        department = @user.person.tutorship.department
      else
        department = @user.person.department
      end
      subjects = department.subjects
    end
    subjects = subjects.select do |sub|
      not_finished = sub.plan_subjects.select do |ps|
        ps.study_plan.approved? && !ps.finished?  
      end
      not_finished.size > 0
    end
    @subjects = subjects
  end

  # saves the subject of probation term to session and adds students 
  def save_subject
    probation_term = @session['probation_term']
    probation_term.subject_id = @params['subject']['id']
    @session['probation_term'] = probation_term
    render(:partial => "probation_term_details", :locals => {:probation_term => probation_term})
  end
  
  # saves the details of the probation term and prepares the examinators
  # selection
  def save_details
    probation_term = @session['probation_term']
    probation_term.attributes = @params['probation_term']
    @session['probation_term'] = probation_term
    render(:partial => 'examinators', :locals => {:probation_term =>
    probation_term})
  end
  
  # saves probation term 
  def save
    probation_term = @session['probation_term']
    probation_term.attributes = @params['probation_term']
    probation_term.save
    redirect_to :action => 'index'
  end
  
  def edit
    @probation_term = ProbationTerm.find(@params['id'])
    @session["probation_term"] = @probation_term
  end

  def update
    @probation_term = ProbationTerm.find(params[:id])
    if @probation_term.update_attributes(params[:probation_term])
      flash[:notice] = 'ProbationTerm was successfully updated.'
      redirect_to :action => 'show', :id => @probation_term
    else
      render :action => 'edit'
    end
  end

  def destroy
    ProbationTerm.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  # enroll exam for student from probation term
  def enroll_exam
    exam = Exam.new('created_by_id' => @session['user'].person.id)
    pt = ProbationTerm.find(@params['id'])
    student = Student.find(@params['student_id'])
    exam.index = student.index
    exam.subject_id = pt.subject.id
    exam.first_examinator_id = pt.first_examinator_id
    exam.second_examinator_id = pt.second_examinator_id
    @session['exam'] = exam

    plan_subject = PlanSubject.find(:all, :conditions => ['subject_id = ? and
    study_plan_id = ?', exam.subject.id, exam.index.study_plan.id])
    render(:partial => 'main_exam', :locals => {:exam => exam, :plan_subject =>
  plan_subject, :probation_term => pt})
  end
  
  # saves exam 
  def save_exam
    exam = @session['exam']
    exam.attributes = @params['exam']
    # select the appropriate plan_subject to update the finished_on tag
    ps = PlanSubject.find(:first, :conditions => ["subject_id = ? and
    study_plan_id = ?", exam.subject_id, exam.index.study_plan.id])
    ps.attributes = @params['plan_subject'] if exam.passed?
    ps.save
    exam.save
    render_partial('render_detail', :probation_term =>
      ProbationTerm.find(@params['probation_term']))
    #redirect_to :action => 'list'
  end

  # sets title of the controller
  def set_title
    @title = _("Probation terms")
  end

  # searches the probation terms in the list
  def search
    if (!@user.person.nil?) 
      person = @user.person
      @subjects = Subject.for_person(person)
      if (@params['search_field'].length > 0)
        @subjects_new = []
        @subjects.each do |sub| 
            label = sub.label
           search_field = @params['search_field']
           if ((label.length) <= (search_field.length))
             search_string = @params['search_field'][0..(label.length - 1)]
           else
             search_string = @params['search_field']
           end
           label_cutted = label[0..(search_string.length - 1)]
           if (search_string.eql?(label_cutted))
             @subjects_new << sub
           end
          end
      else
        @subjects_new = @subjects
      end
      @probation_terms = []
      @subjects_new.each {|sub| @probation_terms.concat(sub.probation_terms)}
      render_partial @params['prefix'] ? @params['prefix'] + 'list' : 'list'
    end
  end
end
