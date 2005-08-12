class ProbationTermsController < ApplicationController
  model :user
  include LoginSystem
  layout "employers"
  before_filter :set_title
  before_filter :login_required
  before_filter :student_required
  before_filter :prepare_person

  def index
    list
    render :action => 'list'
  end
  
  def list
    @subjects = []
    if (@session['user'].person.is_a?(Student) &&
      !@session['user'].person.index.study_plan.nil?)
      @plan_subjects = @session['user'].person.index.study_plan.plan_subjects
      @plan_subjects.each{|plan| @subjects << plan.subject}
    elsif (@session['user'].person.is_a? Dean) ||
      (@session['user'].person.is_a? FacultySecretary)
      faculty = @session['user'].person.department.faculty 
      faculty.departments.each {|dep| @subjects << dep.subjects}
    elsif (@session['user'].person.is_a? Leader) ||
      (@session['user'].person.is_a? DepartmentSecretary) ||
      (@session['user'].person.is_a? Tutor)
      @subjects = @session['user'].person.tutorship.department.subjects
    else
      @subjects = Subject.find_all()
    end
    @subjects.select {|sub| !sub.probation_terms.empty?}
    @probation_terms = []
    @subjects.each {|sub| @probation_terms.concat(sub.probation_terms)}
  end
  
  # enrolls student for a probation term
  def enroll
    if (@session['user'].person.is_a?(Student))
      @session['user'].person.probation_terms << ProbationTerm.find(@params['id'])
    end
    redirect_to :action => 'index'
  end
  
  def show
    @probation_term = ProbationTerm.find(params[:id])
  end

  def new
    @probation_term = ProbationTerm.new
    @probation_term.creator = @session['user'].person
  end

  def detail
    render_partial('detail', :probation_term =>
      ProbationTerm.find(@params['id']))
  end
  
  # created exam object and subjects for select 
  # TODO sql finder for only subjects wich actually any student has
  def create
    @probation_term = ProbationTerm.new('created_by' => @session['user'].person.id)
    @session['probation_term'] = @probation_term
    if @session['user'].has_role?(Role.find_by_name('admin'))
      subjects  = Subject.find_all()
    elsif (@session['user'].person.is_a? Dean) ||
      (@session['user'].person.is_a? FacultySecretary)
      faculty = @session['user'].person.department.faculty 
      subjects = []
      faculty.departments.each {|dep| subjects << dep.subjects}
    elsif (@session['user'].person.is_a? Leader) ||
      (@session['user'].person.is_a? DepartmentSecretary) ||
      (@session['user'].person.is_a? Tutor)
      subjects = @session['user'].person.tutorship.department.subjects
    end
    # viz TODO
    # subjects = subjects.select {|sub| !sub.plan_subjects.empty?}
    subjects = subjects.select do |sub|
      not_finished = sub.plan_subjects.select do 
        |ps| !ps.finished? && ps.study_plan.approved?
      end
      not_finished.size > 0
    end
    @subjects = subjects
  end

  # saves the subject of probation term to session and adds students 
  def save_probation_term_subject
    probation_term = @session['probation_term']
    probation_term.subject_id = @params['subject']['id']
    @session['probation_term'] = probation_term
    render(:partial => "probation_term_details", :locals => {:probation_term => probation_term})
  end
  
  # saves the details of the probation term and prepares the examinators
  # selection
  def save_probation_term_details
    probation_term = @session['probation_term']
    probation_term.attributes = @params['probation_term']
    # probation_term.room = @params['room']
    # probation_term.start_time = @params['start_time']
    # probation_term.date = @params['date']
    # probation_term.max_students = @params['max_students']
    # probation_term.note = @params['note']
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

  # sets title of the controller
  def set_title
    @title = _('Probation terms')
  end

  # searches the probation terms in the list
  def search
    if (!@session['user'].person.nil?) 
      person = @session['user']
      @subjects = Subject.for_person(person)
      @probation_terms = []
      @subjects.each {|sub| @probation_terms.concat(sub.probation_terms)}
      render_partial @params['prefix'] ? @params['prefix'] + 'list' : 'list'
    end
  end
end
