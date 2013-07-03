module ServiceTools
  module Programs
    # repairs all programs from programs service
    # based on response from CentralRegister::Program
    def self.repair_all_by_code(response)
      response.each do |hash|
        if program = Program.find_by_code(hash[:code])
          program.name = hash[:name]
          program.name_english = hash[:name_english]
          program.save
        else
          program = Program.create(hash)
        end
      end
    end
  end
end
