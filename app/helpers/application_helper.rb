# The methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  # get department ids
    def department_ids(faculty_id)
    Department.find_all(["faculty_id = ?", faculty_id]).map { |a| [a.name , a.id] }
  end
  # get language ids
    def language_ids
    Language.find_all.map {|l| [l.name, l.id]}
  end
  # get study ids
    def study_ids
    Study.find_all.map {|s| [s.name, s.id]}
  end
end
