require 'log4r'
require 'csv'
class MassProcessor
  include Log4r

  @@mylog = Logger.new 'MassProcessor'
  @@mylog.outputters = Outputter.stdout
  @@mylog.level = 1

  SERVICE_URL = "http://193.84.33.16/axis2"
  SIDENT_SERVICE_PATH = "/services/GetSidentService/getSidentByBirthNum?rc=%s"
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
    def repair_sident(students)
      @@mylog.info "There are %i students" % students.size
      @client = SOAP::NetHttpClient.new
      service = SERVICE_URL + SIDENT_SERVICE_PATH
      students.each do |student|
        @@mylog.info "Procesing student #%i" % student.id

        service_url = service % student.birth_number
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

          if sident != -1
            student.update_attribute(:sident, sident)
            @@mylog.info "Updated sident"
          else
            @@mylog.error "Service returned bad code for student #%i" % student.id
          end
        end
      end
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
             8 => 'contact_street', 12 => 'contact_housenr',
             13 => 'contact_city', 16 => 'title_before',
             28 => 'bank_code', 29 => 'bank_account', 30 => 'bank_branch',
             21 => 'phone', 19 => 'birth_place'
            }.each_pair do |num, meth|
              idm = row[num].try(:strip)
              edo = p.send(meth.to_sym).try(:strip)
              if edo != idm
                puts "#{uic}; #{meth.humanize}; #{edo}; #{idm}"
                outfile.puts "#{uic}; #{meth.humanize}; #{edo}; #{idm}"
              end
            end
          else
            puts "#{uic}; could not be found"
            outfile.puts "#{uic}; could not be found"
          end
        end
      end
      outfile.close
    end
  end
end
