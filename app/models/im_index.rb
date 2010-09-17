# encoding:utf-8
class ImIndex < ActiveRecord::Base
  belongs_to :index

  validates_presence_of :index

  before_save :get_index_attributes
  after_create :create_logevent
  after_update :update_logevent

  # creates update logevent
  def update_logevent
    Logevent.create(:table_key => "id=#{self.id}",
                    :status => 'N',
                    :event_type => 6,
                    :event_time => Time.now,
                    :perpetrator => "IDM",
                    :table_name => self.class.table_name)
  end

  # creates log event with creation
  def create_logevent
    Logevent.create(:table_key => "id=#{self.id}",
                    :status => 'N',
                    :event_type => 5,
                    :event_time => Time.now,
                    :perpetrator => "IDM",
                    :table_name => self.class.table_name)
  end

  # gets attributes from index
  def get_index_attributes
    index.reload
    self.student_uic = index.student.uic   
    self.department_name = index.department.name
    self.department_code = index.department.short_name
    self.faculty_name = index.faculty.name
    self.faculty_code = index.faculty.short_name
    self.study_year = index.year
    self.academic_year = TermsCalculator.current_school_year
    self.study_type = 'doktorský'
    self.study_type_code = 'D'
    self.study_form = index.study.name
    self.study_form_code = index.study.code
    self.study_spec = index.specialization.name
    self.study_spec_code = index.specialization.code
    self.study_spec_msmt_code = index.specialization.msmt_code
    self.study_prog = index.specialization.program.label
    self.study_prog_code = index.specialization.program.code
    self.study_status = index.translated_status
    self.study_status_code = index.status_code
    self.study_status_from = index.status_from
    self.study_status_to = index.status_to
    self.enrollment_date = index.enrolled_on
    self.financing_type_code = index.payment_code
    self.financing_type = index.payment_type
    self.education_language = 'český jazyk'
    self.education_language_code = 'CZ'
    self.education_place = "Praha"
    self.study_form_changed_on = index.study_form_changed_on
    self.sident = index.student.sident
  end
end
