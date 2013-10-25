require "soap/netHttpClient"
require 'log4r'
require 'csv'

class MassProcessor
  include Log4r

  @@mylog = Logger.new 'MassProcessor'
  @@mylog.outputters = Outputter.stdout
  @@mylog.level = 1

  SERVICE_URL = "http://193.84.33.16/axis2"
  SIDENT_SERVICE_PATH = "/services/GetSidentService/getSidentByBirthNum?rc=%s&obor=%s"
  SUBJECT_SERVICE_PATH = "/services/GetSubjectService/getSubjects"

  class << self
    #update or create subject from web service
    def update_subjects
      @@mylog.info "Starting connect to remote web service..."
      soap_client = ActionWebService::Client::Soap.new(SubjectApi, SERVICE_URL + SUBJECT_SERVICE_PATH)
      @@mylog.info "Downloading content - PLEASE WAIT A MINUTE"
      soap_response = soap_client.get_subjects
      @@mylog.info "Download is finished"
      department_exist = false
      department_count = -1
      created_subjects = 0
      updated_subjects = 0
      missing_departments = 0
      updated = false
      count = -1
      # subject means Array of subjects => s.subject is Array of subjects
      remote_subjects = soap_response.subject
      @@mylog.info "There are %i subjects to check" % remote_subjects.size
      remote_subjects.each do |remote_subject|
        #UPDATING SUBJECT
        if ls = Subject.find_by_code(remote_subject.code)
          #every time we need to check for String object because SOAP::MAPPING nil is not defined
          ls.label = remote_subject.label.to_s if remote_subject.label.is_a?(String)
          ls.label_en = remote_subject.labelEn.to_s if remote_subject.labelEn.is_a?(String)
          if ls.changed?
            updated = true
            @@mylog.debug "Updated %s" % ls.changed.join(',')
            ls.save
          end

          if remote_subject.idDepartment.is_a?(String)
            department = Department.find(:first, :conditions => ['id = ?', remote_subject.idDepartment])
            if department && !ls.departments.include?(department)
              ls.departments << Department.find(remote_subject.idDepartment.to_i)
              @@mylog.debug "Department is added to subject %s" % ls.code
              updated = true
            elsif !department
              @@mylog.debug "Department %s IS MISSING in our database!" % remote_subject.idDepartment
              missing_departments = missing_departments + 1
            end
          else
            @@mylog.debug "Department IS MISSING in remote source! for subject %s" % ls.code
            missing_departments = missing_departments + 1
          end
          department_count = -1
          department_exist = false
          if updated == true
            updated_subjects = updated_subjects + 1
            updated = false
          end
        else
          #CREATING NEW SUBJECT
          #every time we need to check for String object because SOAP::MAPPING nil is not defined
          label = remote_subject.label.is_a?(String) ? remote_subject.label : ""
          label_en = remote_subject.labelEn.is_a?(String) ? remote_subject.labelEn : ""
          code = remote_subject.code.is_a?(String) ? remote_subject.code : ""
          subject = Subject.create(:label => label, :label_en => label_en, :code => code)
          if Department.exists?(remote_subject.idDepartment)
            subject.departments << Department.find(remote_subject.idDepartment.to_i)
          else
            @@mylog.debug "Department IS MISSING in our database! for subject %s" % subject.code
            missing_departments = missing_departments + 1
          end
          @@mylog.debug "Subject %s is created" % remote_subject.code
          created_subjects = created_subjects + 1
        end
      end
      @@mylog.info "%i subjects are created" % created_subjects
      @@mylog.info "%i subjects are updated" % updated_subjects
      @@mylog.info "ERROR - %i departments ARE MISSING in our database. See log above." % missing_departments
    end

    # approve all indexes
    def mass_approve(indices)
      @@mylog.info "There are #{indices.size} indices"
      indices.each do |i|
        if i.study_plan
          app = i.study_plan.approval || StudyPlanApproval.new
          created = app.created_on = i.study_plan.approved_on = \
            i.enrolled_on + 1.month
          app.tutor_statement ||= TutorStatement.create('person_id' => i.tutor_id,
            'result' => 1, 'note' => '', 'created_on' => created)
          app.leader_statement ||= LeaderStatement.create('person_id' => i.leader.id,
            'result' => 1, 'note' => '', 'created_on' => created)
          app.dean_statement ||= DeanStatement.create('person_id' => i.dean.id,
            'result' => 1, 'note' => 'approved by machine', 'created_on' => created)
          i.study_plan.approve!
          app.save
          i.save
        else
          @@mylog.debug "Index #{i.id} does not have study plan"
        end
      end
      nil
    end

    def clean_specialization_subjects
      @count = 0
      Faculty.find(:all).each do |f|
        f.specializations.each do |c|
          @last = nil
          c.obligate_subjects.each {|cs| change_last_or_delete(cs)}
          c.voluntary_subjects.each {|cs| change_last_or_delete(cs)}
          c.language_subjects.each {|cs| change_last_or_delete(cs)}
          c.requisite_subjects.each {|cs| change_last_or_delete(cs)}
          c.seminar_subjects.each {|cs| change_last_or_delete(cs)}
        end
      end
      @@mylog.debug "count" + @count.to_s
    end

    def change_last_or_delete(vs)
      if @last == vs.subject_id
        @@mylog.debug "To delete #{vs.type} id: " + vs.id.to_s
        vs.destroy
        @count += 1
      else
        @last = vs.subject_id
      end
    end

    # fixes birth number badly transfered from candidates
    def fix_bad_birth_numbers(students = nil)
      ActiveRecord::Base.connection.execute('SET NAMES UTF8')
      notfound = []
      students ||= Student.find(:all)
      @@mylog.info "There are %i students" % students.size
      students.each do |student|
        if c = Candidate.find(:all, :conditions => ["birth_number like ?",
                                                    "%s_" % student.birth_number])
          if c.size > 0
            if c.size > 1
              @@mylog.info "More than one candidate for student %i. Getting first." % student.id
            end
            c = c.first
            @@mylog.info "Found one candidate for student %i" % student.id
            if c.birth_number =~ /\d{6}\//
              bn = c.birth_number.gsub(/\//, '')
              @@mylog.info "Got slash in birth number. Fixin student %i with %s" % [student.id, bn]
              student.update_attribute(:birth_number, bn)
            else
              @@mylog.info "No slash in birth number for %i" % student.id
            end
          else
            @@mylog.info "Candidate has't been found"
            notfound << student.id
          end
        end
      end
      return notfound
    end

    # reads sident from webservice and change it for students
    def repair_sident(indices)
      @@mylog.info "There are %i students" % indices.size
      @client = SOAP::NetHttpClient.new
      service = SERVICE_URL + SIDENT_SERVICE_PATH
      f = File.new("sident_errs.txt", "wb")
      indices.each do |index|
        @@mylog.info "Procesing index #%i" % index.id

        service_url = service % [index.student.birth_number, index.specialization.code]
        @@mylog.debug "Service url is: %s" % service_url
        begin
          sident = @client.get_content(service_url)
        rescue URI::InvalidURIError
          @@mylog.error "Bad service url %s" % service_url
          next
        end
        if sident =~ /<SIDENT>(.*)<\/SIDENT>/
          sident = $1
          @@mylog.info "Got sident %i" % sident
          if sident != "-1"
            index.update_attribute(:sident, sident)
            @@mylog.info "Updated sident"
          else
            @@mylog.error "Service returned bad code for student #%i" % index.id
            f.puts "%i, %s, %s, %s" % [index.id, index.student.display_name, index.student.birth_number, index.specialization.code]
          end
        end
      end
    ensure
      f.close
    end

    # removes , Ing from names
    def remove_ings_from_lastname
      students = Student.find(:all, :conditions => "firstname like '%, Mgr.' or firstname like '%, Ing.'")
      @@mylog.info "There are %i students" % students.size
      students.each do |student|
        new_first = student.firstname[0..-7]
        @@mylog.info "Changing student #{student.display_name}"
        student.update_attribute(:firstname, new_first)
        @@mylog.info "New first name #{student.firstname}"
      end
    end

    # creates copy of specializations with S on end of code
    def copy_old_corridors(specializations)
      specializations.map {|c|
        c.clone.save
        c.code = "%sS" % c.code
        c.accredited = false
        c.save
        c
      }
    end

    # copies corridor subject from one to another corridor
    def copy_corridor_subject(from_specialization, to_specialization)
      SpecializationSubject.find_all_by_specialization_id(from_specialization).each {|cs|
        csn = cs.clone
        csn.update_attribute(:specialization_id, to_specialization)
      }
    end

    # adds corridor subjects from type and subjects ids
    def add_corridor_subjects(specialization_id, type, *ids)
      ids.each {|i|
        type.create(:subject_id => i, :specialization_id => specialization_id)
      }
    end

    def compare_im(file)
      outfile = File.open('idm_diff.csv', 'wb')
      cnbf = 0
      File.open(file, 'rb') do |file|
        CSV::Reader.parse(file, ';') do |row|
          uic = row[5]
          if p = ImStudent.find_by_uic(uic)
            if user = p.student.try(:user)
              if user.login != row[3]
                puts "#{uic}; login; #{p.student.user.login}; #{row[3]}"
                outfile.puts "#{uic}; login; #{p.student.user.login}; #{row[3]}"
              end
            end
            {6 => 'firstname', 7 => 'lastname', 4 => 'birth_number',
             8 => 'permaddress_street', 12 => 'permaddress_housenr',
             19 => 'permaddress_city', 24 => 'permaddress_zip', 16 => 'title_before',
             28 => 'bank_code', 29 => 'bank_account', 30 => 'bank_branch',
             21 => 'phone', 19 => 'birth_place', 2 => 'student_id', 35 => 'birthname',
            }.each_pair do |num, meth|
              idm = row[num].to_s.strip
              edo = p.send(meth.to_sym).to_s.strip
              if (edo != idm)
                puts "#{uic}; #{meth.humanize}; #{edo}; #{idm}"
                outfile.puts "#{uic}; #{meth.humanize}; #{edo}; #{idm}"
              end
            end
          else
            puts "#{uic}; could not be found"
            outfile.puts "#{uic}; could not be found"
            cnbf += 1
          end
        end
      end
      outfile.close
      puts "Not found #{cnbf}"
    end

    def add_scholarship_months
      date = Date.parse('2006-05-01')
      (0..71).each do |i|
        beg = date + i.months
        fin = beg.end_of_month
        puts "Begin: #{beg}. Finish: #{fin}"
        scholarships = Scholarship.all(:conditions => ["payed_on > ? and payed_on < ?", beg, fin])
        if scholarships.present?
          payed_on = scholarships.first.read_attribute(:payed_on)
          puts "#{scholarships.size} scholarships, paid on: #{payed_on}"
          month = ScholarshipMonth.create(:opened_at => beg,
                                          :title => beg.strftime('%Y%m'),
                                          :starts_on => beg)
          puts "Adding month id: #{month.id}"
          scholarships.each {|s| s.update_attribute(:scholarship_month_id, month.id)}
          month.paid_at = payed_on
          month.closed_at = fin
          month.save!
        else
          puts "NO SHOLARSHIPS"
        end
      end
      puts 'Done'
    end

    def update_and_purge_im_tables
      @@mylog.info "Start purgin"
      i = ImIndex.all
      @@mylog.info "There are #{i.size} indices"
      is = i.reject(&:index)
      @@mylog.info "There are #{is.size} im indices without index"
      puts "Delete im indices without index? y=yes"
      if gets.strip == "y"
        @@mylog.info "Deleting"
        is.each { |ind| ind.destroy }
      end

      @@mylog.info "Updating im indices"
      (i - is).each do |ind|
        ind.index.update_im_index
        ind.index.student.update_im_student
      end


    end

    def remove_student_duplicates(uics)
      uics.each do |uic|
        a = Student.all(:conditions => ["uic = ?", uic], :order => :created_on)
        puts "#{a.size} for #{uic}"
        if a.size > 1
          real = a.first
          duplicate = a.last
          if duplicate.index
            duplicate.index.update_attribute(:student_id, real.id)
          else
            puts "no index for #{uic}"
          end
          duplicate.candidate.update_attribute(:student_id, real.id) if duplicate.candidate
          duplicate.im_student.destroy
          duplicate.destroy
        else
          puts "no duplicate for #{uic}"
        end
      end
    end

    def remove_empty_im_indices
      ImIndex.all.each do |index|
        if index.index
          begin
            index.index.update_im_index
          rescue
            puts index.id
          end
        else
          index.destroy
        end
      end
    end

    def fix_duplicates_from_yml(file)
      ys = YAML::load(File.read(file))

      ys.each do |hash|
        next unless hash
        uic = hash.first.first
        student = Student.find_by_uic(uic)
        old_index_id = hash[uic].first

        index = YAML::load(hash[uic].last).clone
        index.student_id = student.id
        index.save(false)
        puts index_id = index.id
        puts :DT
        DisertTheme.find_all_by_index_id(old_index_id).each { |i| puts i.update_attribute(:index_id, index_id) }
        puts :SC
        Scholarship.find_all_by_index_id(old_index_id).each { |i| puts i.update_attribute(:index_id, index_id) }
        puts :SP
        StudyPlan.find_all_by_index_id(old_index_id).each { |i| puts i.update_attribute(:index_id, index_id) }
        puts :FE
        FinalExamTerm.find_all_by_index_id(old_index_id).each { |i| puts i.update_attribute(:index_id, index_id) }
        puts :DE
        Defense.find_all_by_index_id(old_index_id).each { |i| puts i.update_attribute(:index_id, index_id) }
        puts :EX
        Exam.find_all_by_index_id(old_index_id).each { |i| puts i.update_attribute(:index_id, index_id) }
        puts :SI
        StudyInterrupt.find_all_by_index_id(old_index_id).each { |i| puts i.update_attribute(:index_id, index_id) }
        puts :II
        ImIndex.find_all_by_index_id(old_index_id).each { |i| puts i.update_attribute(:index_id, index_id) }
      end
    end

    def prepare_demo
      require 'faker'

      Faculty.find(1, 3, 4, 6, 14, 15).each do |faculty|
        puts 'specializations'
        faculty.specializations.each do |specialization|
          specialization.indices.each do |index|
            index.student.try(:user).try(:destroy)
            DisertTheme.find_all_by_index_id(index.id).each(&:destroy)
            StudyPlan.find_all_by_index_id(index.id).each do |study_plan|
              study_plan.approval.try(:destroy)
              study_plan.destroy
            end
            index.interrupts.each do |interrupt|
              interrupt.approval.try(:destroy)
              interrupt.destroy
            end
            index.try(:student).try(:destroy)
          end
          specialization.candidates.each(&:destroy)
          specialization.tutors.each do |tutor|
            tutor.user.try(:destroy)
            Statement.find_all_by_person_id(tutor.id).each do |statement|
              statement.destroy
            end
            tutor.tutorship.destroy
            tutor.destroy
          end
          SpecializationSubject.find_all_by_specialization_id(specialization.id).each(&:destroy)
          specialization.exam_term.try(:destroy)
          specialization.program.try(:destroy)
          specialization.destroy
        end

        puts 'departments'
        faculty.departments.each do |department|
          Leadership.find_all_by_department_id(department.id).each(&:destroy)
          DepartmentEmployment.find_all_by_unit_id(department.id).each(&:destroy)
          department.destroy
        end

        puts 'all other'
        faculty.documents.each(&:destroy)
        faculty.faculty_employments.each(&:destroy)
        faculty.deanship.try(:destroy)
        faculty.destroy
      end
      AdmittanceTheme.destroy_all
      Statement.all.each { |st| st.update_attribute(:note, '') }

      puts 'rename people'
      FacultySecretary.all.each { |fs| fs.destroy unless fs.faculty_employment }
      Tutor.all.each { |tu| tu.destroy unless tu.tutorship }
      DiplomaSupplement.all.each do |diploma|
        n = Faker::Name.name
        fn = n.split(" ").first
        ln = n.split(" ").last
        diploma.update_attributes(:given_name => fn, :family_name => ln)
      end
      Candidate.all.each do |person|
        n = Faker::Name.name
        fn = n.split(" ").first
        ln = n.split(" ").last
        person.update_attributes(:firstname => fn, :lastname => ln)
        a = Faker::Address.street_address
        s = a.split(" ")[1..-1].join(" ")
        n = a.split(" ")[0]
        person.update_attributes(:street => s, :number => n,
                                 :city => Faker::Address.city)
        s = a.split(" ")[1..-1].join(" ")
        n = a.split(" ")[0]
        person.update_attributes(:postal_street => s, :postal_number => n,
                                 :postal_city => Faker::Address.city)
        person.update_attribute(:birth_number, "9988899977")
        person.update_attribute(:email, Faker::Internet.email)
      end
      Person.all.each do |person|
        n = Faker::Name.name
        fn = n.split(" ").first
        ln = n.split(" ").last
        person.update_attributes(:firstname => fn, :lastname => ln)
        a = Faker::Address.street_address
        s = a.split(" ")[1..-1].join(" ")
        n = a.split(" ")[0]
        person.update_attributes(:street => s, :desc_number => n,
                                 :city => Faker::Address.city)
        s = a.split(" ")[1..-1].join(" ")
        n = a.split(" ")[0]
        person.update_attributes(:postal_street => s, :postal_desc_number => n,
                                 :postal_city => Faker::Address.city)
        person.update_attribute(:birth_number, "9988899977")
        person.update_attribute(:email, Faker::Internet.email)
        person.update_attribute(:phone, Faker::PhoneNumber.cell_phone)
        begin
          if u = person.user
            if u.has_role?("student")
              u.destroy
              next
            end
            u.update_attributes(:login => ln.parameterize)
            puts "%i: %s - %s " % [person.faculty.id, u.login, u.roles.map(&:name).join(", ")] if u.has_one_of_roles?(["faculty_secretary", "dean"])
          end
        rescue Exception => e
          puts e.message
          puts person.id, person.user.id
        end
      end

      return "Done"
    end
  end
end
