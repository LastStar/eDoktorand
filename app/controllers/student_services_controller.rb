class StudentServicesController < ApplicationController
 
web_service_api StudentApi
web_service_dispatching_mode :direct
web_service_scaffold :invoke

  # service which returns student detail by uic
  def find_student_by_uic(uic)
    return Student.find_by_uic(uic).to_service_struct
  end

  # returns student's index detail
  def find_index_for_student_uic(uic)
    return Student.find_by_uic(uic).index.to_service_struct
  end

end

