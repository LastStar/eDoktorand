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
        @@mylog.info "Exporting stipendia for #{index.student.display_name}"
        row = []
        row << index.student.display_name
        row << index.account_bank_number
        row << index.full_account_number
        if index.has_regular_scholarship?
          row << index.regular_scholarship.amount
        end
        unless index.extra_scholarships.empty?
          row << index.extra_scholarship_sum 
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

  def self.export_tutors_without_user
    file = "no_user.csv"
    outfile = File.open(file, 'wb')
    CSV::Writer.generate(outfile, ';') do |csv|
      ss = Tutor.find(:all).delete_if {|s| s.user}
      @@mylog.info "There are #{ss.size} tutors without user"
      ss.each do |tutor|
        row = []
        row << tutor.id
        row << tutor.uic
        row << tutor.display_name
        @@mylog.debug "Adding #{row}"
        csv << row
      end
    end
    outfile.close
  end

  def self.export_candidates_for_kj
    file = "candidate_languages.csv"
    outfile = File.open(file, 'wb')
    CSV::Writer.generate(outfile, ';') do |csv|
      cs = Candidate.find(:all, :conditions => ['invited_on is not null and department_id in (?)', Faculty.find(4).departments_ids])
      @@mylog.info "There are #{cs.size} candidates"
      cs.each do |candidate|
        row = []
        row << candidate.display_name
        row << candidate.language1.label
        row << candidate.language2.label
        @@mylog.debug "Adding #{row}"
        csv << row
      end
    end
    outfile.close

  end

  def self.export_students_uic
    file = "students_uic.csv"
    outfile = File.open(file, 'wb')
    CSV::Writer.generate(outfile, ';') do |csv|
      is = Index.find(:all, :conditions => 'finished_on is null')
      @@mylog.info "There are #{is.size} students"
      is.each do |index|
        row = []
        row << index.student.uic
        row << index.student.display_name
        @@mylog.debug "Adding #{row}"
        csv << row
      end
    end
    outfile.close
  end

  def self.export_students_uic_sident
    file = "students_uic_sident.csv"
    outfile = File.open(file, 'wb')
    CSV::Writer.generate(outfile, ';') do |csv|
      is = Index.find(:all, :conditions => 'finished_on is null')
      @@mylog.info "There are #{is.size} students"
      is.each do |index|
        row = []
        row << index.student.uic
        row << index.student.sident
        row << index.student.account
        @@mylog.debug "Adding #{row}"
        csv << row
      end
    end
    outfile.close
  end
end
