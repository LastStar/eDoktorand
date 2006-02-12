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
    @exams = Exam.find_for(@user)
  end

  def show
    @exam = Exam.find(@params[:id])
  end

  def detail
    render_partial('detail', :exam =>
      Exam.find(@params['id']))
  end
  
  # start of the exam creating process
  # rendering the two links
  def create
    @title = _("Creating exam")
    @options = {}
    unless @user.has_secretary_role?
      @dont_render = true
      @options[:locals] = {:subjects => by_subject}
      @options[:partial] = 'subject_form'
    else
      @options[:partial] = 'choose_creation_style'
    end
  end

  # created exam object and subjects for select 
  # TODO sql finder for only subjects wich actually any student has
  def by_subject
    @exam = Exam.new
    @session['exam'] = @exam
    subjects = PlanSubject.find_unfinished_for(@user, :subjects => true)
    unless @dont_render
      render(:partial => "subject_form", :locals => {:subjects => subjects}) 
    else
      subjects
    end
  end
  
  # save subject of exam to session and adds students 
  def save_subject
    @session['exam'].subject_id = @params['subject']['id']
    study_plans = PlanSubject.find_unfinished_by_subject(\
      @params['subject']['id'], :study_plans => true)
    render(:partial => "examined_student", :locals => {:students =>\
      Student.colect_unfinished(:study_plans => study_plans)})
  end

  # save student of exam to session
  def save_student_subject
    @session['exam'].index = Student.find(@params['student']['id']).index
    plan_subject = PlanSubject.find_by_subject_id_and_study_plan_id(\
      @session['exam'].subject.id, @session['exam'].index.study_plan.id)
    render(:partial => 'main', :locals => {:plan_subject =>
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
    render(:partial => 'show', :locals => {:exam => exam,
    :plan_subject => ps})
  end

  # for creating external exams
  def external
    @plan_subjects = PlanSubject.find_unfinished_external    
    students = @plan_subjects.select {|ps| !ps.study_plan.index.finished?}.map \
      {|ps| ps.study_plan.index.student}.uniq
    render(:partial => "external_students", :locals => {:students => 
      students})
  end
  
  # saving student and selecting external subjects
  def save_external_student
    exam = Exam.new
    student = Student.find(@params['student']['id'])
    exam.index = student.index
    @session['exam'] = exam
    subjects = student.index.study_plan.external_subjects
    render(:partial => "external_exam_subjects", :locals => {:exam => exam, :subjects => subjects})
  end  
  
  # saving subject for external exam of the selected student
  def save_external_subject
    @session['exam'].subject = Subject.find(@params['subject']['id'])
    plan_subject = PlanSubject.find_by_subject_id_and_study_plan_id(\
      @params['subject']['id'], @session['exam'].index.study_plan.id)
    render(:partial => 'main_external_exam', :locals => {:exam => @session['exam'],\
      :plan_subject => plan_subject})
  end

  # saving external exam
  def save_external
    exam = @session['exam']
    exam.attributes = @params['exam']
    exam.first_examinator_id = -1
    # select the appropriate plan_subject to update the finished_on tag
    ps = PlanSubject.find_by_subject_id_and_study_plan_id(\
      exam.subject_id, exam.index.study_plan.id)
    ps.attributes = @params['plan_subject'] if exam.passed?
    ps.save
    exam.save
    redirect_to(:action => 'index', :controller => 'exams')
  end
  
  # edit exam
  def edit
    @exam = Exam.find(@params[:id])
  end

  # updates exam
  def update
    @exam = Exam.find(@params[:id])
    if @exam.update_attributes(@params[:exam])
      flash['notice'] = _("Exam was successfully updated.")
      redirect_to :action => 'list'
    else
      render_action 'edit'
    end
  end

  # destroys exam
  def destroy
    Exam.find(@params[:id]).destroy
    redirect_to :action => 'list'
  end

  # sets title of the controller
  def set_title
    @title = _('Exams')
  end

end

