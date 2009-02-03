
class ApplicationController < ActionController::Base
  include LoginSystem
  include ExceptionNotifiable

  filter_parameter_logging :password
  protect_from_forgery 

  before_filter :utf8_locale
  # enable or disable enroll candidates in application
  $enroll = 'disable'

  # sets utf8 for db and locale to cs_CZ
  def utf8_locale
    if params[:lang]
      cookies[:lang] = params[:lang]
    elsif cookies[:lang] 
      params[:lang] = cookies[:lang]
    end
    I18n.locale = params[:lang]
    # TODO remove blood with Dean
    Dean.columns
  end

  # authorizes user
  def authorize?(user)
    if user.has_permission?("%s/%s" % [params[:controller], params[:action]])
      return true
    else
      redirect_to :action => :no_permission, :controller => :account
    end
  end

  def csv_headers(file = 'atachment.csv')
    headers['Content-Type'] = "application/vnd.ms-excel" 
    headers['Content-Disposition'] = 'attachment; filename="' + file + '"'
    headers['Cache-Control'] = ''
  end

  private
  # checks if user is student. 
  # if true creates @student variable with current student
  def prepare_student
    if @user.person.kind_of?(Student)
      @student = @user.person 
    end
  end

  # prepares user class variable
  def prepare_user
    @user = ActiveRecord::Acts::Audited.current_user = User.find(session[:user])
  end

  # prepares faculty class variable
  def prepare_faculty
    @faculty = @user.person.faculty
  end

  # prepares conditions for various queries
  def prepare_conditions
    @conditions = ["null is not null"]
    if @user.has_one_of_roles?(['admin', 'vicerector'])
      @conditions  = ['null is null']
    elsif @user.has_one_of_roles?(['dean', 'faculty_secretary'])
      @conditions = ["department_id IN (" +  @user.person.faculty.departments.map {|dep|
        dep.id}.join(', ') + ")"]
    elsif @user.has_one_of_roles?(['leader', 'department_secretary'])
      department_id = @user.person.department.id
      @conditions = ['department_id = ?', department_id]
    elsif @user.has_role?('tutor')
      @conditions = ['tutor_id = ?', @user.person.id]
    end
  end

  # choses what to do on browsers
  def good_browser?(agent = /Firefox/)
    request.env['HTTP_USER_AGENT'] =~ agent
  end
 
end
