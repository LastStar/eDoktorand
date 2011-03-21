class AccountController < ApplicationController
  include LoginSystem
  layout  'employers'
  before_filter :login_required, :except => [:login, :logout, :error, :locale, :no_permission]
  before_filter :set_title
  before_filter :prepare_user, :only => :welcome

  def login
    @title = t(:message_0, :scope => [:txt, :controller, :account])
    if request.method == :post
      if session[:user] = User.authenticate(params[:user_login], params[:user_password])
        redirect_back_or_default welcome_url
      else
        @login    = params[:user_login]
        @message  = t(:message_1, :scope => [:txt, :controller, :account])
      end
    end
    @actualities = Actuality.find(:all, :order => 'id desc')
  end
  
  def logout
    reset_session
    redirect_to login_url
  end
    
  def welcome
    if @user.has_role?('student')
      redirect_to :controller => 'study_plans'
    elsif @user.has_one_of_roles?(['tutor', 'dean',
      'department_secretary', 'faculty_secretary'])
      redirect_to  students_url
    elsif @user.has_role?('supervisor')
      redirect_to :controller => 'scholarships', :action => 'list'
    elsif @user.has_role?('examinator')
      redirect_to :controller => 'exams', :action => 'index'
    end
  end

  # error page for system
  def error 
    if !(flash && flash[:error]) && @exception
      flash[:error] = @exception.message
    end
  end

  # locale changing page
  def locale
    redirect_to request.env['HTTP_REFERER']
  end

  private
  # sets title of the controller
  def set_title
    @title = t(:edoctorand_system, :scope => [:txt, :controller, :account])
  end
end
