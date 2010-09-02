class Attestation < Approval
  
  has_one :attestation_detail
  belongs_to :study_plan, :foreign_key => 'document_id'

  class << self
    # returns date of actual attestation on faculty
    def next_for_faculty(faculty)
      faculty = faculty.id if faculty.is_a? Faculty
      year = Date.today.year
      if Date.today > (date = Date.civil(year, FACULTY_CFG[faculty]['attestation_month'], 
      FACULTY_CFG[faculty]['attestation_day']))
        year += 1
        return Date.civil(year, FACULTY_CFG[faculty]['attestation_month'], 
        FACULTY_CFG[faculty]['attestation_day'])
      end
      return date
    end

    # returns date of actual attestation on faculty
    def actual_for_faculty(faculty)
      faculty = faculty.id if faculty.is_a? Faculty
      year = Date.today.year
      month = FACULTY_CFG[faculty]['attestation_month']
      day = FACULTY_CFG[faculty]['attestation_day']
      if Date.today <= (date = Date.civil(year, month, day))
        year -= 1
        return Date.civil(year, month, day)
      end
      return date
    end
  end

  def is_actual?
    updated_on > Attestation.actual_for_faculty(study_plan.index.faculty).to_time
  end

  # returns index
  def index
    study_plan.index
  end

  # returns study plan
  # for approval 
  def document
    study_plan
  end
end
