require 'ostruct'
module ServiceTools
  module Employee
    def self.prepare_employee(response, person)
      response = OpenStruct.new(response)
      title_before = Title.find_by_label_and_prefix(response.title_before, 1)
      title_after = Title.find_by_label_and_prefix(response.title_after, 0)
      person.attributes = {:uic => response.uic,
                          :firstname => response.first_name,
                          :lastname => response.last_name,
                          :birthname => response.birth_name,
                          :email => response.mail,
                          :phone => response.phone_line,
                          :title_before => title_before,
                          :title_after => title_after}
      if response.department_code &&
        department = Department.find_by_code(response.department_code)
        person.department_employment = DepartmentEmployment.new(:unit_id => department.id)
      end

      return person
    end
  end
end

