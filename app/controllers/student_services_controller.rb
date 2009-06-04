class StudentServicesController < ApplicationController
 
web_service_api StudentApi
web_service_dispatching_mode :direct
web_service_scaffold :invoke

  #update or create user
  def update_user_with_uic(login_hash)
    if student = Student.find_by_uic(login_hash.uic)
      if student.user
        student.user.update_with_hash(login_hash)
      else
        User.create_with_hash(login_hash, student.id)
      end
    else
    return "Failed! No student"
    end
  end

  # service which returns student detail by uic
  def find_student_by_uic(uic)
    return Student.find_by_uic(uic).to_service_struct
  end

  # returns student's index detail
  def find_index_for_student_uic(uic)
    return Student.find_by_uic(uic).index.to_service_struct
  end

  # updates student with student hash content
  def update_student_with_uic(student_hash)
    student = Student.find_by_uic(student_hash.uic)
    return student.update_with_hash(student_hash)
  end

  # updates index with index hash content
  def update_index_with_uic(index_hash)
    index = Student.find_by_uic(index_hash.uic).index
    return index.update_with_hash(index_hash)
  end

  # creates student from student hash content
  def create_student(student_hash)
    return 'success'
  end

  # creates index from index hash content
  def create_index(index_hash)
    return 'success'
  end


end
