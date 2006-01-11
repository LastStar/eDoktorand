class CSVExporter
  def self.export_stipendia(file = 'stipendia.csv', faculty = nil)
    outfile = File.open(file, 'wb')
    students = Student.find(:all, :conditions => 'scholarship_claim_date is not null')
    students.delete_if {|s| s.faculty.id != faculty} if faculty 
    CSV::Writer.generate(outfile, ';') do |csv|
      students.each do |s|
        row = []
        row << s.uic
        row << s.scholarship_claim_date.strftime('%d.%m.%Y')
        row << s.scholarship_supervised_date.strftime('%d.%m.%Y')
        row << s.index.account_bank_number
        row << s.index.full_account_number
        csv << row
      end
    end
    outfile.close
  end
end
