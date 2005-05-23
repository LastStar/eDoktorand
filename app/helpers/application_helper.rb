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
  # get coridor ids
  def coridor_ids
    Coridor.find_all.map {|s| [s.name, s.id]}
  end
  # get title_before ids
  def title_before_ids
    arr = [['---', '0']]
    arr.concat(Title.find_all(['before = ?', '1']).map {|s| [s.name, s.id]})
    return arr
  end
  # get title_before ids
  def title_after_ids
    arr = [['---', '0']]
    arr.concat(Title.find_all(['before = ?', '0']).map {|s| [s.name, s.id]})
    return arr
  end
  # get role ids
  def role_ids(collection)
    collection.map {|s| [s.name, s.id]}
  end
  # prints notice from flash
  def print_notice
    if @flash['notice']
      content_tag('div', @flash['notice'], :class => 'notice')
    end 
  end
	# get tutor ids
	def tutor_ids
		Tutorship.find(:all).map {|ts| [ts.tutor.display_name, ts.tutor.id]}
	end
end
