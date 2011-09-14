module ServiceTools
  module Programs
    # repairs all departments from departments service
    # based on response from CentralRegister::Program
    def self.repair_all_by_code(response)
      response.each do |hash|
        if department = Program.find_by_code(hash[:code])
          department.name = hash[:name]
          department.name_english = hash[:name_english]
          department.save
        end
      end
    end
  end
end
