# The filters added to this controller will be run for all controllers in the application.
# Likewise will all the methods added be available for all controllers.
require_dependency "login_system"
class ApplicationController < ActionController::Base
  before_filter :localize
  include LoginSystem
  model :user
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
      flash['error'] = 'K přístupu na požadovanou stránku nemáte dostačující práva'
      redirect_to :controller => 'account', :action => 'error'
    end
  end
  # prints errors for object
	helper_method :errors_for
  def errors_for(object)
    unless object.errors.empty?
      tb = "<div id='error'>Chyba:&nbsp;ve vašem vstupu se vyskytly následující chyby:<ul>"
      object.errors.each do |attr, message|
        tb << '<li>' + message + '</li>'
      end
      tb << '</ul></div>'
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
    @language = language.nil? ? 'en' : language.downcase # default is en
    # If there is no dialect use the language code ('en' becomes 'en_EN').
    @dialect  = dialect.nil? ? @language : dialect
    # The complete locale string consists of
    # language_DIALECT (en_EN, en_GB, de_DE, ...)
    @locale = "#{@language}_#{@dialect.upcase}"
    @htmllang = @language == @dialect ? @language : "#{@language}-#{@dialect}"
    # Finally, bind the textdomain to the locale. From now on every used
    # _('String') will get translated into the right language. (Provided
    # that we have a corresponding mo file in the right place).
    bindtextdomain('messages', "#{RAILS_ROOT}/locale", @locale, @charset)
  end
		
end
