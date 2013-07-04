module ServiceTools
  module Specializations
    # repairs all specializations from specializations service
    # based on response from CentralRegister::Specialization
    def self.repair_all_by_code(response, not_found = false)
      ss = Specialization.all
      banned = ["XEKOLO3", "XOCHL"].freeze
      response.each do |hash|
        hash[:msmtCode] = hash[:msmtCode].gsub(/x/, "V")
        hash[:language] = "CZE" unless hash[:language].present?
        next if banned.include?(hash[:shortName])
        if (specializations = Specialization.all(:conditions => ["msmt_code = ? and locale = ?", hash[:msmtCode], hash[:language][0..-2].downcase] )).present?
          specializations.each do |specialization|
            specialization.name = hash[:nameCz]
            specialization.name_english = hash[:nameEn]
            specialization.code = hash[:shortName]
            specialization.save
            ss.delete specialization
          end
        else
          puts "#{hash[:msmtCode]} is not found"
          puts hash.map {|k, v| v }.join(" ")
        end
      end
      puts  ss.map {|s| [s.id, s.name, s.msmt_code,  s.code].join(";") } if not_found
    end
  end
end
