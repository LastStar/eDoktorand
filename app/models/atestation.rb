class Atestation < StudyPlanApprovement
  has_one :atestation_detail
  # returns date of next atestation on faculty
  def self.next_for_faculty(faculty)
    faculty = faculty.id if faculty.is_a? Faculty
    year = Date.today.year
    if Date.today > (date = Date.civil(year, FACULTY_CFG[faculty]['atestation_month'], 
    FACULTY_CFG[faculty]['atestation_day']))
      year += 1
      return Date.civil(year, FACULTY_CFG[faculty]['atestation_month'], 
      FACULTY_CFG[faculty]['atestation_day'])
    end
    return date
  end
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
    return date
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
    return date
  end
end
