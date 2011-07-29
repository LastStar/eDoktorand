module ServiceTools
  module Specializations
    # repairs all specializations from specializations service
    # based on response from CentralRegister::Specialization
    def self.repair_all_by_code(response)
      response.each do |hash|
        if specialization = Specialization.find_by_code(hash[:code])
          specialization.name = hash[:name]
          specialization.name_english = hash[:name_english]
          specialization.save
        end
      end
    end
  end
end
