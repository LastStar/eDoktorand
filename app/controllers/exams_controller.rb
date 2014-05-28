class ExamsController < ApplicationController
  include LoginSystem
  layout "employers", :except => ['external', 'by_subject',
    'save_external_student', 'save_external_subject']
  before_filter :set_title
  before_filter :login_required
  before_filter :prepare_user

  def index
    list
    render(:action => 'list')
  end

  def list_for_vicerector
    if @user.has_role?('vicerector') && params[:vicerector] == "1"
      @exams = Exam.find_for_univerzity(@user,:this_year => 1)
    end
    render(:action => 'list')
  end

  def list
    session[:this_year] = params[:this_year] == "0" ? false : true
    @partial = params[:prefix] ? params[:prefix] + 'list' : 'list'
    @exams = Exam.find_for(@user, :this_year => session[:this_year])
  end

  def show
    @exam = Exam.find(params[:id])
  end

  def detail
    @exam = Exam.find(params[:id])
    @plan_subject = PlanSubject.find_for_exam(@exam)
  end

  # start of the exam creating process
  # rendering the two links
  def create
    @title = t(:message_0, :scope => [:controller, :exams])
    unless @user.has_role? 'faculty_secretary'
      by_subject
      render :action => :by_subject
    else
      session[:exam] = nil
    end
  end

  # created exam object and subjects for select
  def by_subject
    @exam = Exam.new
    session[:exam] = @exam
    @subjects = PlanSubject.find_unfinished_for(@user, :subjects => true)
  end

  # save subject of exam to session, add student, exam indications
  def save_subject
    @exam = session[:exam]
    if session[:exam].subject_id == nil
      session[:exam].subject_id = params[:subject][:id]
    end
    @indices = PlanSubject.find_unfinished_by_subject(\
      session[:exam].subject_id, :indices => true)
  end

  # save student of exam to session and view protocol
  def save_student_subject
    session[:exam].index = Index.find(params[:index][:id])
    session[:exam].attributes = params[:exam]
    @exam = session[:exam]
  end

  # saves exam to DB
  def save
    session[:exam].save
    redirect_to :action => 'create'
  end

  # for creating external exams
  def external
    @plan_subjects = PlanSubject.find_unfinished_external_for(@user)
    @students = @plan_subjects.map {|ps| ps.study_plan.index.student}.uniq
  end

  # saving student and selecting external subjects
  def save_external_student
    @index = Index.find_all_by_student_id(params[:index][:id])
    if @index.size > 1
      @index = @index.detect { |i| i.status == 'studuje' && i.faculty == @user.person.faculty }
    end
    exam = Exam.new
    exam.index = @index
    session[:exam] = exam
    @subjects = @index.study_plan.unfinished_external_subjects
  end

  # saving subject for external exam of the selected student
  def save_external_subject
    session[:exam].subject = @subject = Subject.find(params['subject']['id'])
    @exam = session[:exam]
    @plan_subject = PlanSubject.find_for_exam(@exam)
  end

  # saving external exam
  def save_external
    exam = session[:exam]
    exam.update_attributes(params[:exam])
    session[:exam] = nil
    redirect_to(:action => 'create', :controller => 'exams')
  end

  # updates exam
  def update
    @exam = Exam.find(params[:id])
    if @exam.update_attributes(params[:exam])
      #flash['notice'] = t(:message_1, :scope => [:controller, :exams])

    else
      render(:action => :edit)
    end
  end

  # edits exam
  def edit
     @exam = Exam.find(params[:id])
     @subjects = PlanSubject.find_unfinished_for(@user, :subjects => true)
  end

  # destroys exam
  def destroy
    @exam = Exam.find(params[:id])
    study_plan = @exam.index.study_plan
    plan_subject = study_plan.plan_subjects.detect { |x| x.subject.id == @exam.subject_id }
    plan_subject.update_attribute(:finished_on,nil)
    @exam.destroy
  end

  # sets title of the controller
  def set_title
    @title = t(:message_2, :scope => [:controller, :exams])
  end



end

