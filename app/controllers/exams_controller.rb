class ExamsController < ApplicationController
  model :user
  include LoginSystem
  layout "employers"
  before_filter :set_title
  before_filter :login_required
  before_filter :prepare_conditions

  def index
    list
    render_action 'list'
  end

  def list
    @exam_pages, @exams = paginate :exam, :per_page => 10
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
    @exam.creator = @session['user'].person
  end

  # start of the exam creating process
  # rendering the two links
  def create
    @title = _("Creating exam")
  end

  # created exam object and subjects for select 
  # TODO sql finder for only subjects wich actually any student has
  def exam_by_subject
    @exam = Exam.new('created_by' => @session['user'].person.id)
    @session['exam'] = @exam
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
    subjects = subjects.select {|sub| !sub.plan_subjects.empty?}
    render(:partial => "subjects", :locals => {:subjects => subjects}) 
  end
  
  # save subject of exam to session
  def save_exam_subject
    exam = @session['exam']
    exam.subject_id = @params['subject']['id']
    @session['exam'] = exam
    @plan_subjects = PlanSubject.find_all_by_subject_id(@params['subject']['id'])
    students = []
    @plan_subjects.each {|plan| students << plan.study_plan.index.student}
    render(:partial => "examined_student", :locals => {:exam => exam, 
    :students => students})
  end

  # save student of exam to session
  def save_student_subject
    exam = @session['exam']
    exam.index = Student.find(@params['student']['id']).index
    @session['exam'] = exam
    render(:partial => 'main_exam', :locals => {:exam => exam})
  end
  
  # saves exam 
  def save
    exam = @session['exam']
    exam.attributes = @params['exam']
    exam.created_by
    breakpoint 
    exam.save
    redirect_to :action => 'index'
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
  # searches in students lastname
  def search
    @conditions.first <<  ' AND lastname like ?'
    @conditions << "#{@params['search_field']}%"
    @exams = Student.find(:all, :conditions => @conditions, :include =>
      :exam).map {|s| s.exam}
    render_partial @params['prefix'] ? @params['prefix'] + 'list' : 'list'
  end
  # sets title of the controller
  def set_title
    @title = _('Exams')
  end

end

