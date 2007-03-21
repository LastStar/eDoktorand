class Atestation < StudyPlanApprovement
  untranslate_all
  has_one :atestation_detail
  belongs_to :study_plan, :foreign_key => 'document_id'

  # returns date of actual atestation on faculty
  def self.next_for_faculty(faculty)
    faculty = faculty.id if faculty.is_a? Faculty
    year = Date.today.year
    if Date.today > (date = Date.civil(year, FACULTY_CFG[faculty]['atestation_month'], 
    FACULTY_CFG[faculty]['atestation_day']))
      year += 1
      return Date.civil(year, FACULTY_CFG[faculty]['atestation_month'], 
      FACULTY_CFG[faculty]['atestation_day'])
    end
    return date.to_time
  end

  # returns date of actual atestation on faculty
  def self.actual_for_faculty(faculty)
    faculty = faculty.id if faculty.is_a? Faculty
    year = Date.today.year
    if Date.today <= (date = Date.civil(year, FACULTY_CFG[faculty]['atestation_month'], 
    FACULTY_CFG[faculty]['atestation_day']))
      year -= 1
      return Date.civil(year, FACULTY_CFG[faculty]['atestation_month'], 
      FACULTY_CFG[faculty]['atestation_day'])
    end
    return date.to_time
  end

  def is_actual?
    created_on.to_date > Atestation.actual_for_faculty(study_plan.index.faculty)
  end
end
