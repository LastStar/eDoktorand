
class ApplicationController < ActionController::Base
  include LoginSystem
  include ExceptionNotifiable

  init_gettext "phdstudy", "UTF-8", "text/html"

  before_filter :utf8_locale

  # sets utf8 for db and locale to cs_CZ
  def utf8_locale
    if params[:lang] == "en"
      setlocale('en_EN')
    else
      setlocale('cs_CZ') # TODO hard coded locale
    end
    @charset = 'utf-8'
    headers['Content-Type'] = "text/html; charset=#{@charset}"
    ActiveRecord::Base.connection.execute('SET NAMES UTF8')
  end

  filter_parameter_logging "password"

  model :dean # solving deep STI 

  # authorizes user
  def authorize?(user)
    if user.has_permission?("%s/%s" % [params[:controller], params[:action]])
      return true
    else
      flash['error'] = _("you don't have rights to do this")
      redirect_to error_url
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
    prepare_user
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
 
end

