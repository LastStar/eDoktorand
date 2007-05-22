class ProbationTermsController < ApplicationController
  include LoginSystem
  layout "employers", :except => [:enroll_student]

  model :probation_term

  before_filter :set_title
  before_filter :login_required
  before_filter :prepare_student
  before_filter :prepare_user

  def index
    list
    render :action => 'list'
  end
  
  def list
    @probation_terms = ProbationTerm.find_for(@user, params[:period] || :future)
  end
  
  # enrolls student for a probation term
  def enroll
    if (@user.person.is_a?(Student))
      @user.person.probation_terms << ProbationTerm.find(params[:id])
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

  #TODO render only message when students empty
  def detail
    @probation_term = ProbationTerm.find(params[:id])
    @students = Student.find_to_enroll(@probation_term, :sort)
#TODO redone with rjs
    render_partial('detail', :probation_term => @probation_term, :students => @students)
  end
 
  # enroll student for probation term
  def enroll_student
    @probation_term = ProbationTerm.find(params[:probation_term][:id])
    @student = Student.find(params[:student][:id])
    @probation_term.students << @student
    @probation_term.save
    @students = Student.find_to_enroll(@probation_term, :sort)
    render(:partial => "detail", :locals => {:probation_term => @probation_term,
           :students => @students})
  end
  
  # sign off the desired student
  def sign_off_student
    @probation_term = ProbationTerm.find(params[:id])
    @student = Student.find(params[:student_id])
    @probation_term.students.delete(@student)
    @students = Student.find_to_enroll(@probation_term, :sort)
    if @user.has_role?('student')
      redirect_to :action => 'list'
    else
      render(:partial => "detail", :locals => {:probation_term => @probation_term,
           :students => @students})
    end
  end
  
  # created exam object and subjects for select 
  def create
    @probation_term = ProbationTerm.new
    @subjects = Subject.find_for(@user, :not_finished)
  end

  # saves the subject of probation term to session and adds students 
  def save_subject
    probation_term = session[:probation_term]
    probation_term.subject_id = params[:subject][:id]
    session[:probation_term] = probation_term
    render(:partial => "probation_term_details", :locals => {:probation_term => probation_term})
  end
  
  # saves the details of the probation term and prepares the examinators
  # selection
  def save_details
    probation_term = session[:probation_term]
    probation_term.attributes = params[:probation_term]
    session[:probation_term] = probation_term
    render(:partial => 'examinators', :locals => {:probation_term =>
    probation_term})
  end
  
  # saves probation term 
  def save
    params[:probation_term][:created_by] = @user.person.id
    @probation_term = ProbationTerm.create(params[:probation_term])
    if @probation_term.save
      flash[:notice] = _('Probation term saved')
      redirect_to :action => 'index'
    else
      @subjects = Subject.find_for(@user, :not_finished)
      render :action => 'create'
    end
  end
  
  def edit
    @probation_term = ProbationTerm.find(params[:id])
    @subjects = Subject.find_for(@user, :not_finished)
  end

  def update
    @probation_term = ProbationTerm.find(params[:probation_term][:id])
    if @probation_term.update_attributes(params[:probation_term])
      flash[:notice] = _('Probation term saved')
      redirect_to :action => 'index'
    else
      @subjects = Subject.find_for(@user, :not_finished)
      render :action => 'edit'
    end
  end

  def destroy
    ProbationTerm.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  # enroll exam for student from probation term
  def enroll_exam
    @probation_term = ProbationTerm.find(params[:id])
    student = Student.find(params[:student_id])
    @exam = Exam.from_probation_term(@probation_term, student)
    session[:probation_term] = @probation_term
    session[:exam] = @exam
    @container = "info_#{session[:probation_term].id}"
    @plan_subject = PlanSubject.find_for_exam(@exam)
  end
  
  # saves exam 
  def save_exam
    exam = session[:exam]
    exam.attributes = params[:exam]
    exam.save
    @probation_term = session[:probation_term]
    session[:exam] = session[:probation_term] = nil
    @students = Student.find_to_enroll(@probation_term, :sort)
    render(:partial => 'detail', :locals => {:students => @students,
                                 :probation_term => @probation_term})
  end

  # sets title of the controller
  def set_title
    @title = _("Probation terms")
  end
end
