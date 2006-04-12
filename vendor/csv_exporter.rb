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

  def self.export_students(faculty)
    faculty = faculty.is_a?(Faculty) ? faculty  : Faculty.find(faculty)
    faculty.departments.each do |dep|
      file = "student_#{dep.id}.csv"
      outfile = File.open(file, 'wb')
      CSV::Writer.generate(outfile, ';') do |csv|
        indices = Index.find_studying_on_department(dep)
        puts indices.size
        indices.each do |ind|
          row = []
          row << ind.student.display_name
          if ind.disert_theme
            row << ind.disert_theme.title 
          else
            row << ''
          end
          row << ind.tutor.display_name
          csv << row
        end
      end
    end
  end
end
