class StudentHash < ActionWebService::Struct
  member :uic, :int
  member :student_id, :int
  member :firstname, :string
  member :lastname, :string
  member :birthname, :string
  member :birth_on, :string
  member :citizenship, :string
  member :birth_number, :string
  member :birth_place, :string
  member :sex, :string
  member :created_on, :string
  member :updated_on, :string
  member :title_before, :string
  member :title_after, :string
  member :email, :string
  member :phone, :string
end

class AddressHash < ActionWebService::Struct
  member :street, :string
  member :desc_number, :string
  member :orient_number, :string
  member :city, :string
  member :zip, :string
  member :state, :string
end

class IndexHash < ActionWebService::Struct
  member :index_id, :int
  member :student_uic, :int
  member :faculty_id, :int
  member :faculty_name, :string
  member :department_id, :int
  member :department_name, :string
  member :study_status, :string
  member :status_from, :string
  member :status_to, :string
end

class StudentApi < ActionWebService::API::Base
  api_method :find_student_by_uic,
             :expects => [:int],
             :returns => [StudentHash]

  api_method :find_index_for_student_uic,
             :expects => [:int],
             :returns => [IndexHash]

  api_method :update_student_with_uic,
             :expects => [StudentHash],
             :returns => [:string]

  api_method :update_index_with_student_uic,
             :expects => [IndexHash],
             :returns => [:string]

  # do not implement here
  api_method :get_uic_by_birth_num,
             :expects => [:string],
             :returns => [:int]

  api_method :get_sident_by_birth_num,
             :expects => [:string],
             :returns => [:int]
end
