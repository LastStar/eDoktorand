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

  def get_account_by_uic(uic)
    student = Student.find_by_uic(uic)
    account = ""
    account << student.index.full_account_number + "/" if student.index.account_number
    account << student.index.account_bank_number if student.index.account_bank_number
    if account == ""
      account = "Nil account number"
    end
    return account
  end

  #return array of uic and bank account
  def get_account_uic_array
    uic_accounts = []
    sql = "account_number is not null and account_number <> '' \
      and people.sident is not null"
    indices ||= Index.find(:all, 
                           :conditions => sql, :order => 'department_id',
                           :include => :student)
    indices.each do |i|
      service_struct = UicAccount.new
      service_struct.uic = i.student.uic
      service_struct.account = i.full_account_number + "/" +i.account_bank_number
      uic_accounts << (service_struct)
    end
    return uic_accounts
  end
