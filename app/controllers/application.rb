# The filters added to this controller will be run for all controllers in the application.
# Likewise will all the methods added be available for all controllers.
require_dependency 'dean'
require_dependency 'user'
require_dependency 'obligate_subject'
require_dependency 'plan_subject'
require_dependency 'study_plan'
require_dependency 'disert_theme'

class ApplicationController < ActionController::Base
  before_filter :localize
  include LoginSystem
  # get department ids
  helper_method :language_ids
  def department_ids(faculty_id)
    Department.find_all(["faculty_id = ?", faculty_id]).map { |a| [a.name , a.id] }
  end
  # get language ids
  helper_method :language_ids
  def language_ids
    Language.find_all.map {|l| [l.name, l.id]}
  end
  # get study ids
  helper_method :study_ids
  def study_ids
    Study.find_all.map {|s| [s.name, s.id]}
  end
  # authorizes user
  def authorize?(user)
    if user.has_permission?("%s/%s" % [ @params["controller"], @params["action"] ])
      return true
    else
      flash['error'] = _("you don't have rights to do this")
      redirect_to :controller => 'account', :action => 'error'
    end
  end
	# returns array of the time by quarter from start time to end time
	helper_method :str_time_select
	def str_time_select(start_time = 8, stop_time = 16)
		items = []
		(start_time..stop_time-1).each do |hour|
			['00', '15', '30', '45'].each {|minute| items << ("#{hour.to_s}:#{minute}")}
		end
		items << "#{stop_time.to_s}:00"
		return items
	end
  private
  def localize
    # We will use instance vars for the locale so we can make use of them in
    # the templates.
    @charset  = 'utf-8'
    @headers['Content-Type'] = "text/html; charset=#{@charset}"
    # Here is a very simplified approach to extract the prefered language
    # from the request. If all fails, just use 'en_EN' as the default.
    if @request.env['HTTP_ACCEPT_LANGUAGE'].nil?
      temp = []
    else
      temp = @request.env['HTTP_ACCEPT_LANGUAGE'].split(',').first.split('-') rescue []
    end
    language = temp.slice(0)
    dialect  = temp.slice(1)
    @language = language.nil? ? 'cs' : language.downcase # default is en
    # If there is no dialect use the language code ('en' becomes 'en_EN').
    @dialect  = dialect.nil? ? 'CZ' : dialect
    # The complete locale string consists of
    # language_DIALECT (en_EN, en_GB, de_DE, ...)
    @locale = "#{@language}_#{@dialect.upcase}"
    @htmllang = @language == @dialect ? @language : "#{@language}-#{@dialect}"
    # Finally, bind the textdomain to the locale. From now on every used
    # _('String') will get translated into the right language. (Provided
    # that we have a corresponding mo file in the right place).
    bindtextdomain('messages', "#{RAILS_ROOT}/locale", @locale, @charset)
  end
  # checks if user is student. 
  # if true creates @student variable with current student
  def prepare_student
    if @session['user'].person.kind_of?(Student)
      @student = @session['user'].person 
    end
  end
  # prepares user class variable
  def prepare_user
    @user = ActiveRecord::Acts::Audited.current_user = @session['user']
  end
  # prepares conditions for various queries
  def prepare_conditions
    @conditions = ["null is not null"]
    if @session['user'].has_one_of_roles?(['admin', 'vicerector'])
      @conditions  = ['null is null']
    elsif @session['user'].has_one_of_roles?(['dean', 'faculty_secretary'])
      @conditions = ["department_id IN (" +  @session['user'].person.faculty.departments.map {|dep|
        dep.id}.join(', ') + ")"]
    elsif @session['user'].has_one_of_roles?(['leader', 'department_secretary'])
      department_id = @session['user'].person.leadership.department_id if  @session['user'].has_role?('leader')
      department_id = @session['user'].person.department_employment.unit_id if @session['user'].has_role?('department_secretary')
      @conditions = ['department_id = ?', department_id]
    elsif @session['user'].has_role?('tutor')
      @conditions = ['tutor_id = ?', @session['user'].person.id]
    end
  end
end

