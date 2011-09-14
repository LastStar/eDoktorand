module ServiceTools
  module DepartmentRepairer
    # repairs all departments from departments service
    # based on response from CentralRegister::Department
    def self.repair_all_by_short_name(response)
      response.each do |hash|
        if hash[:type_id] == '1' && department = Department.find_by_short_name(hash[:short_name])
          department.name = hash[:name]
          department.name_english = hash[:name_english]
          department.code = hash[:code]
          department.save
        end
      end
    end
  end
end
