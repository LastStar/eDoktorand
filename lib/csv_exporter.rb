require 'log4r'
require 'terms_calculator'
require 'csv'
class CSVExporter
  include Log4r

  @@mylog = Logger.new 'exporter'
  @@mylog.outputters = Outputter.stdout
  @@mylog.level = 1

  class << self
    def export_social_stipendia(start = TermsCalculator.this_year_start,  file = 'stipendia.csv', faculty = nil)
      outfile = File.open(file, 'wb')
      students = Student.find(:all, 
                              :conditions => ['indices.scholarship_claimed_at > ?', start],
                              :include => :index)
      students.delete_if {|s| s.faculty.id != faculty} if faculty 
      CSV::Writer.generate(outfile, ';') do |csv|
        csv << ['sident', 'claimed_at', 'supervised_at'] 
        students.each do |s|
          row = []
          row << s.sident
          row << s.index.scholarship_claimed_at.strftime('%d.%m.%Y')
          if s.index.scholarship_approved_at && 
            s.index.scholarship_approved_at > TermsCalculator.this_year_start
            row << s.index.scholarship_approved_at.strftime('%d.%m.%Y') 
          else
            row << ''
          end
          csv << row
        end
      end
      outfile.close
    end

    def export_stipendia(user, file = 'stipendia.csv')
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

    def export_students(faculty, format = [:student_name])
      faculty = faculty.is_a?(Faculty) ? faculty  : Faculty.find(faculty)
      faculty.departments.each do |dep|
        file = "student_#{dep.id}.csv"
        outfile = File.open(file, 'wb')
        CSV::Writer.generate(outfile, ';') do |csv|
          indices = Index.find_studying_on_department(dep)
          @@mylog.info "On #{dep.name} are #{indices.size} indices."
          indices.each do |ind|
            row = []
            format.each do |meth|
              if ind.respond_to? meth
                row << ind.send(meth)
              elsif ind.student.respond_to? meth
                row << ind.student.send(meth)
              else
                if ind.student.user
                  row << ind.student.user.send(meth)
                else
                  row << 'no user'
                end
              end
            end
            csv << row
          end
        end
        outfile.close
      end
    end

    def export_students_without_user
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

    def export_tutors_without_user
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

    def export_candidates_for_kj(faculty)
      file = "candidate_languages.csv"
      outfile = File.open(file, 'wb')
      CSV::Writer.generate(outfile, ';') do |csv|
        cs = Candidate.find(:all, :conditions => ['invited_on is not null and department_id in (?)', faculty.departments])
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

    def export_students_uic
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

    def export_students_uic_login_faculty_department
      file = "students_uic_big.csv"
      outfile = File.open(file, 'wb')
      CSV::Writer.generate(outfile, ';') do |csv|
        is = Index.find(:all, :conditions => 'finished_on is null')
        @@mylog.info "There are #{is.size} students"
        is.each do |index|
          row = []
          row << index.student.display_name
          row << index.student.uic
          if index.student.user
            row << index.student.user.login
          else
            row << ""
          end
          row << index.student.faculty.short_name
          row << index.student.department.short_name        
          @@mylog.debug "Adding #{row}"
          csv << row
        end
      end
      outfile.close
    end

    def export_students_uic_sident(indices = nil)
      file = "students_uic_sident.csv"
      outfile = File.open(file, 'wb')
      CSV::Writer.generate(outfile, ';') do |csv|
        csv << ['id clovek', 'uic', 'sident', 'login', 'display name', 'department',
                'faculty']
        indices ||= Index.find(:all, :conditions => 'finished_on is null')
        @@mylog.info "There are #{indices.size} students"
        indices.each do |index|
          student = index.student
          row = []
          row << student.id
          row << student.uic
          row << (student.user ? student.user.login : 'NO LOGIN!!!')
          row << student.sident if index.student.sident
          row << student.display_name
          row << index.department.name
          row << index.faculty.name
          @@mylog.debug "Adding #{row}"
          csv << row
        end
      end
      outfile.close
    end

    def export_students_edir(indices = nil)
      file = "students_edir_uic.csv"
      outfile = File.open(file, 'wb')
      CSV::Writer.generate(outfile, ';') do |csv|
        csv << ['id clovek','login', 'uic', 'sident','title before', 'display name', 'title after', 'department',
                'faculty']
        indices ||= Index.find(:all, :conditions => 'finished_on is null')
        @@mylog.info "There are #{indices.size} students"
        indices.each do |index|
          row = []
          row << index.student.id
          if index.student.user
            row << index.student.user.login
          else
            row << " "
          end
          row << index.student.uic
          row << index.student.sident if index.student.sident
          if index.student.title_before
            row << index.student.title_before.label
          else
            row << " "          
          end        
          row << index.student.display_name
          if index.student.title_after
            row << index.student.title_after.label
          else
            row << " "          
          end        
          row << index.department.name
          row << index.faculty.name
          @@mylog.debug "Adding #{row}"
          csv << row
        end
      end
      outfile.close
    end

    def export_candidates_evident_card(options = {})
      unless cs = options[:candidates]
        faculty = options[:faculty].is_a?(Faculty) ? options[:faculty] : Faculty.find(options[:faculty])
        cs = Candidate.find(:all, :conditions => ['invited_on is not null' + 
        #cs = Candidate.find(:all, :conditions => ['invited_on is not null and admited_on is not null' + 
          ' and specialization_id in (?)', faculty.specializations])
        file = "candidate_evident_#{faculty.short_name}.csv"
      else
        file = 'candidates_evident.csv'
      end
      outfile = File.open(file, 'wb')
      CSV::Writer.generate(outfile, ';') do |csv|
        @@mylog.info "There are #{cs.size} candidates"
        cs.each do |c|
          row = []
          row << c.id
          if c.title_before
            row << c.title_before.label 
          else
            row << ''
          end
          row << c.firstname
          row << c.lastname
          if c.title_after
            row << c.title_after.label 
          else
            row << ''
          end
          row << c.email
          row << c.birth_number
          row << c.birth_on
          row << c.birth_at
          row << c.department.short_name
          row << c.specialization.code
          row << c.study.name
          row << c.street
          row << c.number
          row << c.city
          row << c.zip
          if c.phone
            row << c.phone
          else
            row << ''
          end
          
          @@mylog.debug "Adding #{row}"
          csv << row
        end
      end
      outfile.close
    end

    def export_students_with_bad_account
      file = "bad_account.csv"
      outfile = File.open(file, 'wb')
      CSV::Writer.generate(outfile, ';') do |csv|
        is = Index.find(:all, 
                        :conditions => "account_number is not 
                                        null and account_number <> ''",
                       :order => 'department_id')
        is.reject! {|i| i.valid?}
        @@mylog.info "There are #{is.size} students"
        is.each do |index|
          row = []
          row << index.student.uic
          row << index.student.faculty
          row << index.student.display_name
          row << index.student.errors.full_messages
          @@mylog.debug "Adding #{row}"
          csv << row
        end
      end

      outfile.close
    end

    def export_sident_with_account(indices = nil)
      file = "sident_account.csv"
      sql = "account_number is not null and account_number <> '' \
              and people.sident is not null"
      outfile = File.open(file, 'wb')
      CSV::Writer.generate(outfile, ';') do |csv|
        indices ||= Index.find(:all, 
                              :conditions => sql, :order => 'department_id',
                              :include => :student)
        @@mylog.info "There are #{indices.size} students"
        indices.each do |i|
          # TODO redo with index instance method
          row = []
          row << i.student.sident
          row << i.full_account_number
          row << i.account_bank_number
          @@mylog.debug "Adding #{row}"
          csv << row
        end
      end
      outfile.close
    end

    def export_candidates_for(options = {})
      unless cs = options[:candidates]
        faculty = options[:faculty].is_a?(Faculty) ? options[:faculty] : Faculty.find(options[:faculty])
        cs = Candidate.find(:all, :conditions => ['invited_on is not null' + 
        #cs = Candidate.find(:all, :conditions => ['invited_on is not null and admited_on is not null' + 
          ' and specialization_id in (?)', faculty.specializations])
        file = "candidate_#{faculty.short_name}.csv"
      else
        file = 'candidates.csv'
      end
      outfile = File.open(file, 'wb')
      CSV::Writer.generate(outfile, ';') do |csv|
        @@mylog.info "There are #{cs.size} candidates"
        cs.each do |c|
          row = []
          row << c.id
          if c.title_before
            row << c.title_before.label 
          else
            row << ''
          end
          row << c.firstname
          row << c.lastname
          if c.title_after
            row << c.title_after.label 
          else
            row << ''
          end
          row << c.email
          row << c.department.short_name
          row << c.specialization.code
          row << c.study.name
          @@mylog.debug "Adding #{row}"
          csv << row
        end
      end
      outfile.close
    end

    def export_basic(students)
      outfile = File.open('students.csv', 'wb')
      CSV::Writer.generate(outfile, ';') do |csv|
        csv << ['id', 'first name', 'last name', 'birth number', 'specialization id', 'faculty id', 'email']
        students.each do |s|
          row = []
          row << s.id
          row << s.firstname
          row << s.lastname
          row << s.birth_number
          row << s.index.specialization.name
          row << s.index.faculty.name
          row << s.email.try(:name)
          csv << row
        end
        outfile.close
      end
    end

    def export_basic_by_index(indices)
      outfile = File.open('indices.csv', 'wb')
      CSV::Writer.generate(outfile, ';') do |csv|
        csv << ['id', 'first name', 'last name', 'specialization name', 'faculty name', 'year','study','status']
        indices.each do |i|
          row = []
          row << i.student.id
          row << i.student.firstname
          row << i.student.lastname
          row << i.specialization.name
          row << i.faculty.name
          row << i.year
          row << i.study.name
          row << i.status
          csv << row
        end
        outfile.close
      end
    end

    def export_address(students)
      outfile = File.open('students_address.csv', 'wb')
      CSV::Writer.generate(outfile, ';') do |csv|
        csv << ['id', 'first name', 'last name', 'birth number', 'specialization id', 'faculty id', 'email', 'street', 'desc_number', 'orient_number', 'city', 'zip', 'state']
        students.each do |s|
          row = []
          row << s.id
          row << s.firstname
          row << s.lastname
          row << s.birth_number
          row << s.index.specialization.name
          row << s.index.faculty.name
          row << s.email.try(:name)
          if s.address
            row << s.address.street
            row << s.address.desc_number
            row << s.address.orient_number
            row << s.address.city
            row << s.address.zip
            row << s.address.state      
          end
          csv << row
        end
        outfile.close
      end
    end

    def export_tutors_per_specialization
      outfile = File.open('tutors_per_specialization.csv', 'wb')
      CSV::Writer.generate(outfile, ';') do |csv|
        csv << ['specialization id', 'specialization name', 'amount']
        Specialization.find(:all).each do |c|
          csv << [c.id, c.name, c.tutors.size]
        end
      end
      outfile.close
    end

    def export_students_with_disert_themes(user)
      outfile = File.open('students_with_disert_theme.csv', 'wb')
      CSV::Writer.generate(outfile, ';') do |csv|
        Index.find_for(user, :studying => true).each do |i|
          row = [i.student.lastname, i.student.firstname, i.specialization.name, 
                  i.year]
          if i.disert_theme
            row << [i.disert_theme.title, i.disert_theme.title_en]
          else
            row << ['----', '----']
          end
          csv << row
        end
      end
      outfile.close
    end
    
    def export_students_without_sident
      outfile = File.open('students.csv', 'wb')
      students = Student.find(:all, :conditions => "sident is null and indices.finished_on is null and indices.study_id = 1", :include => :index)
      CSV::Writer.generate(outfile, ';') do |csv|
        csv << ['id', 'display name']
        students.each do |s|
          row = []
          row << s.id
          row << s.display_name
          csv << row
        end
        outfile.close
      end
    end

    def export_exams
      @@mylog.info 'Exporting exams'
      Faculty.find(:all).each do |faculty|
        outfile = File.open("exams_%i.csv" % faculty.id, 'wb')
        CSV::Writer.generate(outfile, ';') do |csv|
          faculty.departments.each do |department|
            @@mylog.debug department.name
            subjs = department.subjects.map(&:id)
            @@mylog.debug subjs
            exams = Exam.count(:conditions => ["subject_id in(?) and passed_on > '2007-03-01'", subjs])
            csv << [department.name, exams]
          end
        end
        outfile.close
      end
    end
    
    def export_year_exams(exam_date_from,exam_date_to)
      @@mylog.info 'Exporting exams list from %s' %exam_date_from
      Faculty.find(:all).each do |faculty|
        outfile = File.open("exams_list_%s.csv" % faculty.short_name, 'wb')
        CSV::Writer.generate(outfile, ';') do |csv|
          faculty.departments.each do |department|
            @@mylog.debug department.name
            subjs = department.subjects.map(&:id)
            @@mylog.debug subjs          
            subjs.each do |subject_id|
              subject_name = Subject.find(subject_id).label
              exams = Exam.count(:conditions => ["subject_id = ? and passed_on > ? and passed_on < ?", subject_id, exam_date_from, exam_date_to])  
            csv << [department.name, subject_name, exams]
            end
          end
        end
        outfile.close
      end
    end

    def exams_by_tutors(faculty, exam_date_from, exam_date_to)
      @@mylog.info 'Exporting exams list by tutor from %s' % faculty.name
      outfile = File.open("exams_tutors.csv", 'wb')
      departments = Department.find_all_by_faculty_id(faculty.id)
      @@mylog.info 'Departments %s' % departments
      CSV::Writer.generate(outfile, ';') do |csv|
        examinators = Examinator.find(:all,
                            :conditions => ["employments.unit_id in (?)",
                                              departments],
                            :include => :department_employment,
                            :order => "employments.unit_id, people.lastname")
        departments = examinators.group_by {|t| t.department}
        departments.each do |department|
          csv << [department.first.name]
          @@mylog.info 'Department %s' % department.first.name
          department.last.each do |examinator|
            @@mylog.info 'examinator %s' % examinator.display_name
            exams = Exam.count(:conditions => ["passed_on > ? and passed_on < ? and (first_examinator_id = ? or second_examinator_id = ? or third_examinator_id = ? or fourth_examinator_id = ? )",
                                             exam_date_from, exam_date_to, examinator.id, examinator.id, examinator.id, examinator.id])          
            csv << [examinator.display_name, exams] if exams > 0
          end
        end
        outfile.close
      end
    end

    def export_for_board(department)
      department = department.id if department.is_a? Department
      filename = "students_%i.csv" % department
      outfile = File.open(filename, 'wb')
      indices = Index.find(:all, :conditions => ['finished_on is null and department_id = ?', department])
      indices.sort {|x,y| x.year <=> y.year}
      CSV::Writer.generate(outfile) do |csv|
        indices.each do |i| 
          @@mylog.debug i.id
          row = []
          row << i.year
          row << i.student.display_name
          row << i.tutor.display_name
          if i.disert_theme
            row << i.disert_theme.title
          else
            row << ''
          end
          row << i.status
          csv << row
        end
      end
      outfile.close
    end

    # exports index details
    def export_study_basics(indices = nil)
      unless indices
        indices = Index.find(:all)
      end
      outfile = File.open('indices_details.csv', 'wb')
      CSV::Writer.generate(outfile) do |csv|
        csv << ['index id', 'student_uic', 'faculty_id', 'department_id', 'study_status', 'year']
        indices.each do |index| 
          @@mylog.debug index.id
          row = []
          row << index.id
          row << index.student.uic
          row << index.faculty.id
          row << index.department_id
          row << index.status
          row << index.year
          csv << row
        end
      end
      outfile.close
    end

    # exports scholarship sum
    def bad_and_remove_export_scholarship
      indices = {}
      Faculty.find(:all, :conditions => 'id <> 3').each do |faculty|
        indices[faculty.id] = Index.find_for(faculty.secretary.user).map(&:id)
      end
      @@mylog.debug 'All indices in'
      sql = 'payed_on > ? and payed_on < ? and index_id in(?)'
      File.open('regulars.csv', 'wb') do |outfile|
        CSV::Writer.generate(outfile, ';') do |csv|
          csv << ['from', 'to', 'fappz', 'its', 'pef', 'tf', 'fzp', 'fld']
          beg = Date.parse(TermsCalculator.starting_in(2008))
          fin = beg + 1.month
          (1..12).each do |month|
            fappz = RegularScholarship.find(:all,
                                      :conditions => [sql, beg, fin, indices[1]])
            its = RegularScholarship.find(:all,
                                      :conditions => [sql, beg, fin, indices[2]])
            pef = RegularScholarship.find(:all,
                                      :conditions => [sql, beg, fin, indices[4]])
            tf = RegularScholarship.find(:all,
                                      :conditions => [sql, beg, fin, indices[5]])
            fld = RegularScholarship.find(:all,
                                      :conditions => [sql, beg, fin, indices[14]])
            fzp = RegularScholarship.find(:all,
                                      :conditions => [sql, beg, fin, indices[15]])
            csv << [beg, fin, fappz.to_i, its.to_i, pef.to_i, tf.to_i, fld.to_i,
              fzp.to_i]
            beg += 1.month
            fin += 1.month
          end
        end
      end
    end

    # exports scholarships by corridor and month
    def export_scholarship(specialization)
      beg = Date.parse(TermsCalculator.starting_in(2008)) - 1.month
      fin = beg + 1.month
      sql = 'payed_on > ? and payed_on < ? and index_id = ?'
      indices = Index.find_for_scholarship(User.find_by_login('ticha'),
                  :conditions => ["specialization_id = ?", specialization],
                  :paying_date => fin)
      unless indices.empty?
        (1..13).each do |month|
          filename = '%s_%s.csv' % [specialization.code, fin.strftime('%m_%y')]
          File.open(filename, 'wb') do |outfile|
            CSV::Writer.generate(outfile, ';') do |csv|
              csv << [specialization.name, beg.strftime('%Y-%m-%d'),
                fin.strftime('%Y-%m-%d'), '', '']
              csv << ['name', 'type', 'amount', 'disponent', 'payed_on']
              indices.each do |index|
                if scholarships = Scholarship.find(:all, :conditions =>
                                                          [sql, beg, fin, index.id])
                  scholarships.each do |scholarship|
                    csv << [scholarship.index.student.display_name,
                      scholarship.type.to_s[0, 1], scholarship.amount, scholarship.disponent,
                      scholarship.payed_on.strftime('%Y-%m-%d')]
                  end
                end
              end
            end
          end
          @@mylog.debug 'Exported' + filename
          system 'iconv -f utf-8 -t cp1250 %s > %s' % [filename, filename.gsub(/\.csv/, '.win.csv')]
          system 'rm %s' % filename
          beg += 1.month
          fin = beg + 1.month
        end
      end
    end

    def students_by_corridor_year
      is = Index.find_for(User.find_by_login('ticha'), :unfinished => true, :not_interupted => true)
      isd = is.sort {|i,j| i.year <=> j.year}.group_by(&:faculty)
      isd.each {|f|
        File.open("po_rocnicich_%s.csv" % f.first.short_name, 'wb') {|outfile|
          CSV::Writer.generate(outfile, ';') {|csv|
            f.last.group_by(&:specialization).each {|c|
              csv << [c.first.code, c.first.name]
              c.last.group_by(&:year).map {|cyi|
                csv << [cyi.first, cyi.last.select(&:present_study?).size, cyi.last.reject(&:present_study?).size]
              }
            }
          }
        }
      }
    end

    # exports all students for vice dean
    def students_for_dean(dean_user)
      indices = Index.find_for(dean_user)
      @@mylog.info("There is %i students" % indices.size)
      File.open("students.csv", 'wb') do |outfile|
        CSV::Writer.generate(outfile, ';') do |csv|
          indices.each do |index|
            row = []
            row << index.student.display_name
            row << index.enrolled_on.strftime('%d. %m. %Y')
            if index.finished?
              row << index.finished_on.strftime('%d. %m. %Y')
            elsif index.absolved?
              row << index.disert_theme.defense_passed_on.strftime('%d. %m. %Y')
            else
              row << ''
            end
            row << index.study.name
            row << index.status
            row << index.department.name
            row << index.specialization.name
            row << index.tutor.try(:display_name)
            csv << row
          end
        end
      end
    end

    # exports absolved students by faculties with study times
    def absolved_students_with_years
      is = Index.find_for(User.find_by_login('ticha'))
      is = is.select {|i| i.absolved?}.sort {|i, j| i.semester <=> j.semester}
      isd = is.group_by(&:faculty)
      isd.each do |faculty|
        File.open("absolved_%s.csv" % faculty.first.short_name, 'wb') do |outfile|
          CSV::Writer.generate(outfile, ';') do |csv|
            csv << ['student', 'semestr', 'start', 'konec']
            faculty.last.each do |index|
              csv << [index.student.display_name, index.semester, index.enrolled_on.to_date, index.disert_theme.defense_passed_on.to_date]
            end
          end
        end
      end
    end

    # exports absolved students by faculties with study times
    def absolved_students_with_address
      is = Index.find_for(User.find_by_login('ticha'))
      is = is.select {|i| i.absolved?}.sort {|i, j| i.semester <=> j.semester}
      File.open('absolved_with_address.csv', 'wb') do |outfile|
        CSV::Writer.generate(outfile, ';') do |csv|
          csv << ['absolvoval', 'titul pred', 'jmeno', 'prijmeni', 'titul za', 'ulice', 'mesto', 'psc']
          is.each do |index|
            s = index.student
            if a = s.address and a.street
              csv << [index.disert_theme.defense_passed_on.to_date,
                s.title_before ? s.title_before.label : 'Ing.', s.firstname, s.lastname,
                s.title_after ? s.title_after.label : '', a.street + " " + (a.desc_number or a.orient_number or ''), a.city, a.zip]
            end
          end
        end
      end
    end
  end
end
