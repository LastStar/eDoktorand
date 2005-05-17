# The filters added to this controller will be run for all controllers in the application.
# Likewise will all the methods added be available for all controllers.
require_dependency "login_system"
class ApplicationController < ActionController::Base
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
end
