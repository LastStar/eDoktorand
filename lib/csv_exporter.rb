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
          next if s.index.sident.blank? || s.index.sident.to_s == "-1"
          row = []
          row << s.display_name
          row << s.index.scholarship_claimed_at.strftime('%d.%m.%Y')
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
        file = "student_#{dep.short_name}.csv"
        outfile = File.open(file, 'wb')
        CSV::Writer.generate(outfile, ';') do |csv|
          indices = Index.find_all_by_department_id(dep.id, :include => :student, :order => 'people.lastname asc')
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
          row << index.sident if index.sident
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
        csv << ['id clovek','login', 'uic', 'title before', 'first name',
                'last name', 'title after', 'department', 'department_code',
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
          if index.student.title_before
            row << index.student.title_before.label
          else
            row << " "
          end
          row << index.student.firstname
          row << index.student.lastname
          if index.student.title_after
            row << index.student.title_after.label
          else
            row << " "
          end
          row << index.department.short_name
          row << index.department.code
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
        #cs = Candidate.find(:all, :conditions => ['invited_on is not null' +
        cs = Candidate.find(:all, :conditions => ['invited_on is not null and admited_on is not null' +
          ' and specialization_id in (?)', faculty.specializations])
        file = "candidate_evident_#{faculty.short_name}.csv"
      else
        file = 'candidates_evident.csv'
      end
      outfile = File.open(file, 'wb')
      CSV::Writer.generate(outfile, ';') do |csv|
        csv << %w(id titul jmeno prijmeni titul\ za email rc datum\ narozeni misto\ narozeni katedra obor forma ulice cislo mesto psc telefon)
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

    def export_created_candidates(students)
      outfile = File.open('created_students.csv', 'wb')
      CSV::Writer.generate(outfile, ';') do |csv|
        csv << %w(uic titul jmeno prijmeni titul\ za email rc misto\ narozeni katedra obor ulice cislo mesto psc telefon)
        @@mylog.info "There are #{students.size} students"
        students.each do |s|
          row = []
          row << s.uic
          if s.title_before
            row << s.title_before.label
          else
            row << ''
          end
          row << s.firstname
          row << s.lastname
          if s.title_after
            row << s.title_after.label
          else
            row << ''
          end
          row << s.email
          row << s.birth_number
          row << s.birth_on
          row << s.birth_place
          row << s.department.short_name
          row << s.specialization.code
          row << s.index.study.name
          row << s.street
          row << s.desc_number
          row << s.city
          row << s.zip
          if s.phone
            row << s.phone
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
              and sident is not null"
      outfile = File.open(file, 'wb')
      CSV::Writer.generate(outfile, ';') do |csv|
        indices ||= Index.find(:all,
                              :conditions => sql, :order => 'department_id',
                              :include => :student)
        @@mylog.info "There are #{indices.size} students"
        indices.each do |i|
          if i.sident.blank? || i.sident.to_s == "-1" || i.absolved? ||
            i.finished?
            next
          end
          # TODO redo with index instance method
          row = []
          row << i.sident
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
        # cs = Candidate.find(:all, :conditions => ['invited_on is not null' +
        # cs = Candidate.find(:all, :conditions => ['invited_on is not null and admited_on is not null' +
        cs = Candidate.all(:conditions =>  ['finished_on is not null' +
                   ' and specialization_id in (?)', faculty.specializations])
        file = "candidate_#{faculty.short_name}.csv"
      else
        file = 'candidates.csv'
      end
      outfile = File.open(file, 'wb')
      CSV::Writer.generate(outfile, ';') do |csv|
        @@mylog.info "There are #{cs.size} candidates"
        csv << ['id', 'title_before', 'firstname', 'lastname', 'title_after', 'email',
            'study_form', 'department', 'specialization', 'theme', 'tutor']
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
          row << c.study.name
          row << c.department.short_name
          row << c.specialization.code
          if c.admittance_theme
            row << c.admittance_theme.display_name
          elsif c.tutor
            c.tutor.display_name
          else
            ''
          end
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
            exams = Exam.count(:conditions => ["subject_id in(?) and passed_on > '2010-03-01'", subjs])
            csv << [department.name, exams]
          end
        end
        outfile.close
      end
    end

    def export_year_exams(exam_date_from, exam_date_to)
      exam_date_from = Date.parse(exam_date_from)
      exam_date_to = Date.parse(exam_date_to)
      @@mylog.info "Exporting exams list from #{exam_date_from}"
      Faculty.find(:all).each do |faculty|
        outfile = File.open("exams_list_%s.csv" % faculty.short_name, 'wb')
        CSV::Writer.generate(outfile, ';') do |csv|
          faculty.departments.each do |department|
            @@mylog.debug department.name
            subjs = department.subjects.map(&:id)
            final_exams = department.indices.select do |index|
              index.final_exam_passed? && (exam_date_from..exam_date_to).include?(index.final_exam_passed_on)
            end.size
            csv << [department.name, 'SDZ', final_exams] if final_exams > 0
            subjs.each do |subject_id|
              subject_name = Subject.find(subject_id).label
              exams = Exam.count(:conditions => ["subject_id = ? and passed_on > ? and passed_on < ?", subject_id, exam_date_from, exam_date_to])
              csv << [department.name, subject_name.strip, exams] if exams > 0
            end
          end
        end
        outfile.close
      end
    end

    def exams_by_tutors(departments, exam_date_from, exam_date_to)
      Dean.columns
      outfile = File.open("exams_tutors.csv", 'wb')
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

    def tutored_by_tutors(departments, start, finish)
      Dean.columns
      outfile = File.open("tutored_tutors.csv", 'wb')
      @@mylog.info 'Departments %s' % departments
      CSV::Writer.generate(outfile, ';') do |csv|
        tutors = Tutor.find(:all, :conditions => ["employments.unit_id in (?)",
                                              departments],
                            :include => :department_employment,
                            :order => "employments.unit_id, people.lastname")
        departments = tutors.group_by {|t| t.department}
        departments.each do |department|
          csv << [department.first.name]
          @@mylog.info 'Department %s' % department.first.name
          department.last.each do |tutor|
            @@mylog.info 'tutor %s' % tutor.display_name
            p studying = Index.count(:conditions => ["tutor_id = ? and enrolled_on < ? and (finished_on > ? or finished_on is null) and (disert_themes.defense_passed_on > ? or disert_themes.defense_passed_on is null)",
                                   tutor.id, finish, finish, start], :include => :disert_theme)
            absolved = Index.count(:conditions => ["tutor_id = ? and enrolled_on < ? and (finished_on > ? or finished_on is null) and disert_themes.defense_passed_on < ? and disert_themes.defense_passed_on > ?",
                                   tutor.id, finish, finish, finish, start], :include => :disert_theme)
            finished = Index.count(:conditions => ["tutor_id = ? and enrolled_on < ? and finished_on < ? and finished_on > ?",
                                   tutor.id, finish, finish, start], :include => :disert_theme)
            csv << [tutor.display_name, studying, absolved, finished] if studying > 0
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
    def export_study(indices = nil)
      unless indices
        indices = Index.find(:all)
      end
      outfile = File.open('indices_details.csv', 'wb')
      CSV::Writer.generate(outfile, ';') do |csv|
        csv << ['student', 'department', 'study_status', 'year', 'tutor']
        indices.each do |index|
          @@mylog.debug index.id
          row = []
          row << index.student.display_name
          row << index.department.name
          row << index.status
          row << index.year
          row << index.tutor.display_name
          csv << row
        end
      end
      outfile.close
    end

    # exports index details
    def all_students_basics
      outfile = File.open('student_details.csv', 'wb')
      CSV::Writer.generate(outfile) do |csv|
        csv << ['index id', 'student uic', 'student id', 'department id', 'study status', 'year']
        Student.all.each do |student|
          next unless index = student.index
          @@mylog.debug index.id
          row = []
          row << index.id
          row << student.uic
          row << student.id
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
      is = Index.find_for(User.find_by_login('ticha'), :unfinished => true, :not_interrupted => true)
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
          csv << ['uic', 'name', 'enrolled', 'finished/absolved', 'form', 'status',
            'department', 'specialization', 'program', 'faculty', 'tutor',
            'title', 'title_en', 'nominal_length']
          indices.each do |index|
            row = []
            @@mylog.info("Adding %s" % index.student.display_name)
            row << index.student.uic
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
            row << index.specialization.program.name
            row << index.faculty.name
            row << index.tutor.try(:display_name)
            row << index.disert_theme.try(:title)
            row << index.disert_theme.try(:title_en)
            row << index.nominal_length
            csv << row
          end
        end
      end
    end

    # exports all students for vice dean with attributes for accreditation
    # committee
    def students_for_accreditation_committee(dean_user)
      indices = Index.find_for(dean_user)
      @@mylog.info("There is %i students" % indices.size)
      File.open("students.csv", 'wb') do |outfile|
        CSV::Writer.generate(outfile, ';') do |csv|
          indices.each do |index|
            row = []
            row << index.student.display_name
              row << index.status
            if index.status == 'absolvoval'
              row << index.disert_theme.defense_passed_on
            else
              row << ''
            end
            row << index.year
            row << index.study_name
            row << index.department.short_name
            row << index.specialization.code
            row << index.enrolled_on
            row << index.final_exam_passed_on || index.study_plan.try(:status) || "nemá"
            row << index.disert_theme.try(:title)
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

    # GroupWise licencees
    def export_group_wise(indices = nil)
      unless indices
        indices = Index.find(:all)
      end
      outfile = File.open('indices.csv', 'wb')
      CSV::Writer.generate(outfile, ';') do |csv|
        csv << ['login', 'uic', 'first name', 'last name', 'faculty code', 'year','study','status']
        indices.sort {|a, b| a.status <=> b.status}.each do |i|
          row = []
          row << i.student.try(:user).try(:login) || 'NaN'
          row << i.student.uic
          row << i.student.firstname
          row << i.student.lastname
          row << i.faculty.short_name
          row << i.study.name
          row << i.status
          csv << row
        end
        outfile.close
      end
    end

    def all_by_faculty_year_study_final_exam_passed(date)
       indices = Index.all(:conditions => ["enrolled_on < ? and (finished_on is null or finished_on > ?)", date, date])
       indices.reject! {|i| i.disert_theme && i.disert_theme.defense_passed_on && i.disert_theme.defense_passed_on < date}
       indices.sort {|a, b| a.year <=> b.year}.group_by {|i|
         i.index.faculty.short_name
       }.map {|p|
         [p.first, p.last.group_by {|i| i.year}.map {|i|
           [i.first, i.last.group_by {|i| i.study.name prezenční }.map{|i| [i.first, i.last.size]}, i.last.select {|i| i.final_exam_passed?}.size]
         }]
       }
    end

    def all_for_accreditation(secretary_user)
      indices = Index.find_for(secretary_user, :unfinished => true,
                               :not_interrupted => true,
                               :not_absolved => true)
      @@mylog.info("There is %i students" % indices.size)
      File.open("accreditation.csv", 'wb') do |outfile|
        CSV::Writer.generate(outfile, ';') do |csv|
          indices.each do |index|
            row = []
            row << index.student.uic
            row << index.student.display_name
            row << index.tutor.display_name
            row << index.disert_theme.try(:title)
            row << index.specialization.name
            csv << row
          end
        end
      end
    end

    def candidates_for_post(faculty)
      cs = faculty.candidates.select {|c| c.admited? || c.rejected?}
      File.open("post_candidates_#{faculty.short_name}.csv", 'wb') do |outfile|
        CSV::Writer.generate(outfile, ';') do |csv|
          cs.each do |c|
            row = []
            row << c.display_name
            row << c.address
            csv << row
          end
        end
      end
    end

    def students_for_flegl(indices, date = Date.today)
      Dean.columns
      @@mylog.info("There are %i students" % indices.size)
      File.open("students.csv", 'wb') do |outfile|
        CSV::Writer.generate(outfile, ';') do |csv|
          csv << ['jmeno', 'stav', 'absolvoval', 'sdz', 'ukončen', 'rok', 'forma', 'katedra', 'fakulta','obor', 'program', 'prijat', 'stav SP', 'skolitel']
          indices.each do |index|
            next unless index.student
            row = []
            row << index.student.display_name
            row << index.status(date)
            if index.absolved?(date)
              row << index.disert_theme.defense_passed_on.strftime('%d/%m/%Y')
            else
              row << ''
            end
            if index.final_exam_passed?(date)
              row << index.final_exam_passed_on.strftime('%d/%m/%Y')
            else
              row << ''
            end
            if index.finished?(date)
              row << index.finished_on.strftime('%d/%m/%Y')
            else
              row << ''
            end
            row << index.year
            row << index.study_name
            row << index.department.name
            row << index.faculty.name
            row << index.specialization.code
            row << index.specialization.program.code
            row << index.enrolled_on.strftime('%d/%m/%Y')
            row << index.study_plan.try(:status)
            row << index.tutor.try(:display_name)
            @@mylog.info(row)
            csv << row
          end
        end
      end
    end

    def for_specialization_chairman(specialization)
      indices = Index.all(:conditions => {:specialization_id => Specialization.find(1).id}).reject { |i| i.absolved? || i.finished? }
      @@mylog.info("There is %i students" % indices.size)
      File.open(specialization.code +  ".csv", 'wb') do |outfile|
        CSV::Writer.generate(outfile, ';') do |csv|
          indices.each do |index|
            row = []
            row << index.status
            row << index.student.firstname
            row << index.student.lastname
            row << index.year
            row << index.study.name
            row << index.tutor.try(:display_name)
            row << index.disert_theme.try(:title)
            csv << row
          end
        end
      end
    end

    def specializations
      File.open("specializations.csv", 'wb') do |outfile|
        CSV::Writer.generate(outfile, ';') do |csv|
          csv << ["id", "obor"]
          Specialization.all.each do |specialization|
            csv << [specialization.id, specialization.name]
          end
        end
      end

    end

    def specializations_details
      File.open("specializations.csv", 'wb') do |outfile|
        CSV::Writer.generate(outfile, ';') do |csv|
          csv << ["specializace", "počet doktorandů", "počet školitelů", "průměrná délka studia", "počet absolventů"]
          Specialization.all.each do |specialization|
            row = []
            row << specialization.id
            indices = Index.all(:conditions => { :specialization_id => specialization.id })
            row << indices.reject { |index| index.absolved? || index.finished? }.count

            row << Tutorship.all(:conditions => { :specialization_id => specialization.id }).map(&:tutor).uniq.count

            if indices.empty?
              row << 0
              row << 0
            else
              row << indices.select { |index| index.absolved? }.count
              row << indices.inject(0) { |sum, index|  sum += index.year } / indices.count.to_f
            end

            puts row.join(";")

            csv << row
          end
        end
      end
    end

    def candidates_summary
      File.open("uchazeci.csv", "wb") do |outfile|
        CSV::Writer.generate(outfile, ';') do |csv|
          Faculty.all.each do |faculty|
            next unless faculty.candidates.size > 0
            csv << [faculty.short_name]
            faculty.specializations.each do |specialization|
              next unless specialization.candidates.size > 0
              ready = specialization.candidates
              invited = ready.select { |c| c.invited? }
              enrolled = invited.select { |c| c.enrolled? }
              csv << [specialization.code, ready.size, invited.size, enrolled.size]
            end
          end
        end
      end
    end

    def candidates_previous_university
      File.open("univerzity_uchazecu.csv", "wb") do |outfile|
        CSV::Writer.generate(outfile, ';') do |csv|
          Faculty.all.each do |faculty|
            next unless faculty.candidates.size > 0
            csv << [faculty.short_name]
            faculty.candidates.each do |candidate|
              next unless candidate.enrolled?
              csv << [candidate.display_name, candidate.university]
            end
          end
        end
      end
    end

    def result_word(result)
      case result
      when 1
        "schválena"
      when 2
        "schválena s výtkou"
      when 3
        "neschválena"
      end
    end

    def attestation_results(indices)
      File.open("atest.csv", "wb") do |f|
        result = indices.map do |i|
          line = [i.id, i.student.display_name, i.specialization.code, i.tutor.display_name, i.try(:disert_theme).try(:title)]
          if (statement = i.study_plan.try(:attestation).try(:tutor_or_leader_statement))
             line.concat([statement.created_on,
             result_word(statement.result),
             statement.try(:note).gsub(/[\r\n]/, ' ')])
          else
             line.concat(["neatestován"])
          end
          line.join(";")
        end.join("\n")

        f.write(result)
      end
    end

    def indices_by_tutors(faculty, date = Date.parse("2013-12-31"))
      Dean.columns
      faculty = Faculty.find(faculty) unless faculty.is_a? Faculty
      File.open("studenti.csv", "wb") do |f|
        CSV::Writer.generate(f, ';') do |csv|
          faculty.departments.each do |department|
            indices = department.indices.select { |i| !i.absolved?(date) && !i.finished?(date) && (i.studying?(date) || i.interrupted?(date)) }
            if indices.size > 0
              csv << [department.name]
              csv << ["Celkem", indices.size]
              indices.group_by(&:tutor).each_pair do |tutor, indices|
                csv << [tutor.display_name, indices.size] if indices.size > 0
              end
            end
          end
        end
      end
    end
  end
end
