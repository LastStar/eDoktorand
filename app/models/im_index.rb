class ImIndex < ActiveRecord::Base
  belongs_to :index

  validates_presence_of :index

  # gets attributes from index
  def get_index_attributes
    old_loc = I18n.locale
    I18n.locale = :cs
    self.student_uic = index.student.uic
    self.department_name = index.department.name
    self.department_code = index.department.code
    self.department_short_name = index.department.short_name
    self.faculty_name = index.faculty.name
    self.faculty_code = index.faculty.short_name
    self.study_year = index.year
    self.study_type = I18n.t(:doctorate, :scope => [:model, :im_index])
    self.study_type_code = 'D'
    self.study_form = index.study.name
    self.study_form_code = index.study.code
    self.study_spec = index.specialization.name
    self.study_spec_code = index.specialization.code
    self.study_spec_msmt_code = index.specialization.msmt_code
    self.study_prog = index.specialization.program.name
    self.study_prog_code = index.specialization.program.code
    self.study_status = index.status
    self.study_status_code = index.status_code
    if index.before_admit?
      self.academic_year = TermsCalculator.idm_next_year
      self.study_status_from = TermsCalculator.next_year_start.to_date
      self.study_status_to = TermsCalculator.next_year_end.to_date
    else
      self.academic_year = TermsCalculator.idm_current_year
      self.study_status_from = index.status_from
      self.study_status_to = index.status_to
    end
    self.enrollment_date = index.enrolled_on.to_date
    self.financing_type_code = index.payment_code
    self.financing_type = index.payment_type
    self.education_language = I18n.t(:czech_language, :scope => [:model, :im_index])
    self.education_language_code = 'CZ'
    self.education_place = "Praha"
    self.study_form_changed_on = index.study_form_changed_on
    self.sident = index.sident
    I18n.locale = old_loc
  end
end
