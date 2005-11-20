class AccountController < ApplicationController
  include LoginSystem
  layout  'employers'
  before_filter :login_required, :except => [:login, :logout, :error]
  before_filter :set_title
  before_filter :prepare_user, :only => [:welcome, :logout]

  def login
    case @request.method
    when :post
      if @session['user'] = User.authenticate(@params['user_login'], @params['user_password'])
        flash['notice']  = _("Login was succesful")
        redirect_back_or_default :action => "welcome"
      else
        @login    = @params['user_login']
        @message  = _('Login was unsuccesful')
      end
    end
    @actualities = Actuality.find(:all)
  end
  
  def signup
    case @request.method
      when :post
        @user = User.new(@params['user'])
        if @user.save      
          @session['user'] = User.authenticate(@user.login, @params['user']['password'])
          flash['notice']  = "Signup successful"
          redirect_back_or_default :action => "welcome"          
        end
      when :get
        @user = User.new
    end      
  end  
  
  def delete
    if @params['id']
      @user = User.find(@params['id'])
      @user.destroy
    end
    redirect_back_or_default :action => "welcome"
  end  
    
  def logout
    reset_session
    redirect_to :action => 'login'
  end
    
  def welcome
    if @user.has_role?('student')
      redirect_to :controller => 'study_plans'
    elsif @user.has_one_of_roles?(['tutor', 'dean',
      'department_secretary', 'faculty_secretary'])
      redirect_to :controller => 'students'
    end
  end
  # error page for system
  def error
  end

  def user_roles
    @user = User.find(@params['id'])
    @unassigned_roles = Role.find(:all) - @user.roles
    @user_roles = @user.roles
  end

  def user_roles_update
    @user = User.find(@params['id'])
    @roles_up   = Role.find(@params['addedRight'].split(',')) unless @params['addedRight'].empty?
    @roles_down = Role.find(@params['addedLeft'].split(',')) unless @params['addedLeft'].empty?

    # adding and removing
    @user.roles.delete(@roles_down) if @roles_down
    @user.roles << @roles_up if @roles_up
  end

  private
  # sets title of the controller
  def set_title
    @title = 'Systém e-doktorand'
  end
end
