module ServiceTools
  module FacultyRepairer
    # repairs all departments from departments service
    # based on response from CentralRegister::Department
    def self.repair_all_by_short_name(response)
      puts response
      response.each do |hash|
        fac = OpenStruct.new(hash)
        if faculty = Faculty.find_by_short_name(fac.short_name)
          faculty.name = fac.name
          faculty.name_english = fac.name_english
          faculty.code = fac.code
          faculty.ldap_context = fac.ldap_context
          faculty.save
        end
      end
    end
  end
end

