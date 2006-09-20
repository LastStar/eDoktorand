class ApplicationController < ActionController::Base
  include LoginSystem
  include ExceptionNotifiable

  filter_parameter_logging "password"

  model :dean # solving deep STI 
  before_filter :localize

  # authorizes user
  def authorize?(user)
    if user.has_permission?("%s/%s" % [@params["controller"], @params["action"]])
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
  def localize
    # We will use instance vars for the locale so we can make use of them in
    # the templates.
    @charset  = 'utf-8'
    @headers['Content-Type'] = "text/html; charset=#{@charset}"
    @session['locale'] = @params['new_locale'] if @params['new_locale']
    if @session['locale']
      @locale = @session['locale']
      @language, @dialect = @locale.split('_')
    else
      # Here is a very simplified approach to extract the prefered language
      # from the request. If all fails, just use 'en_EN' as the default.
      if @request.env['HTTP_ACCEPT_LANGUAGE'].nil?
        temp = []
      else
        temp = @request.env['HTTP_ACCEPT_LANGUAGE'].split(',').first.split('-') rescue []
      end
      language = temp.slice(0)
      dialect  = temp.slice(1)
      @language = language.nil? ? 'cs' : language.downcase 
      @dialect  = dialect.nil? ? 'CZ' : dialect
      # The complete locale string consists of
      # language_DIALECT (en_EN, en_GB, de_DE, ...)
      @locale = "#{@language}_#{@dialect.upcase}"
    end
    @htmllang = @language == @dialect ? @language : "#{@language}-#{@dialect}"
    # Finally, bind the textdomain to the locale. From now on every used
    # _('String') will get translated into the right language. (Provided
    # that we have a corresponding mo file in the right place).
    bindtextdomain('messages', "#{RAILS_ROOT}/locale", @locale, @charset)
    ActiveRecord::Base.connection.execute('SET NAMES UTF8')
  end

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
    @user = ActiveRecord::Acts::Audited.current_user = User.find(@session['user'])
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

