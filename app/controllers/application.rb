# The filters added to this controller will be run for all controllers in the application.
# Likewise will all the methods added be available for all controllers.
class ApplicationController < ActionController::Base
  private
  # get department ids
  def department_ids(faculty_id)
    @department_ids = Department.find_all(["faculty_id = ?", faculty_id]).map { |a| [a.name , a.id] }
  end
  # get language ids
  def language_ids
    @language_ids = Language.find_all.map {|l| [l.name, l.id]}
  end
  # get study ids
  def study_ids
    @study_ids = Study.find_all.map {|s| [s.name, s.id]}
  end
end
