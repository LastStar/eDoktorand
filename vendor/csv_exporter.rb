require 'log4r'
class CSVExporter
  include Log4r

  @@mylog = Logger.new 'exporter'
  @@mylog.outputters = Outputter.stdout
  @@mylog.level = 1

  def self.export_stipendia(user, file = 'stipendia.csv')
    outfile = File.open(file, 'wb')
    @indices = Index.find_studying_for(user, 
                                       :order => 'studies.id, people.lastname')
    CSV::Writer.generate(outfile, ';') do |csv|
      @indices.each do |index|
        row = []
        row << index.student.display_name
        row << index.account_bank_number
        row << index.full_account_number
        row << index.current_regular_scholarship.amount
        if index.current_extra_scholarship 
          row << index.current_extra_scholarship_sum 
        end
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
      outfile.close
    end
  end

  def self.export_students_without_user
    file = "no_user.csv"
    outfile = File.open(file, 'wb')
    CSV::Writer.generate(outfile, ';') do |csv|
      ss = Student.find(:all).delete_if {|s| s.user}
      @@mylog.info "There are #{ss.size} students without user"
      ss.each do |student|
        row = []
        row << student.id
        row << student.uic
        row << student.display_name
        @@mylog.debug "Adding #{row}"
        csv << row
      end
    end
    outfile.close
  end
end
