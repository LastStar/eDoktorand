require 'tutor'
class AccountController < ApplicationController
  model :user
  model :tutor
  model :student
  include LoginSystem
  layout  'employers'
  before_filter :login_required, :except => [:login, :logout, :error]
  before_filter :set_title

  def login
    case @request.method
      when :post
        if @session['user'] = User.authenticate(@params['user_login'], @params['user_password'])

          flash['notice']  = _("Login was succesful")
          redirect_back_or_default :action => "welcome"
        else
          @login    = @params['user_login']
          @message  = "Přihlášení se nepodařilo"
      end
    end
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
    @session['user'] = nil
  end
    
  def welcome
    if @session['user'].person.is_a? Student
      redirect_to :controller => 'study_plans'
    elsif @session['user'].person.is_a? Tutor
      redirect_to :controller => 'students'
    elsif @session['user'].person.is_a? DepartmentSecretary
      redirect_to :controller => 'students'
    elsif @session['user'].person.is_a? FacultySecretary
      redirect_to :controller => 'candidates'
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
