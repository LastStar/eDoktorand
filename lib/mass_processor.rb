require 'log4r'
class MassProcessor
  include Log4r

  @@mylog = Logger.new 'MassProcessor'
  @@mylog.outputters = Outputter.stdout
  @@mylog.level = 1

  #update or create subject from web service
  def self.update_subjects
    @@mylog.info "Starting connect to remote web service..."
    soap_client = ActionWebService::Client::Soap.new(SubjectApi, "http://193.84.34.6/axis2/services/GetSubjectService/getSubjects")
    @@mylog.info "Downloading content - PLEASE WAIT A MINUTE"
    s = soap_client.get_subjects
    @@mylog.info "Download is finished"
    department_exist = false
    department_count = -1
    created_subjects = 0
    updated_subjects = 0
    missing_departments = 0
    updated = false
    count = -1
    # subject means Array of subjects => s.subject is Array of subjects
    remote_subjects = s.subject
    @@mylog.info "There are %i subjects to check" % remote_subjects.size
    #while is better because Array with SOAP::MAPPING with 'each cycle' is peace of hell!
    while count < (remote_subjects.size - 1) do
      count = count + 1
      #UPDATING SUBJECT
      if ls = Subject.find_by_code(remote_subjects[count].code)
        #every time we need to check for String object because SOAP::MAPPING nil is not defined
        if ls.label != remote_subjects[count].label && remote_subjects[count].label.is_a?(String)
          ls.update_attribute(:label,remote_subjects[count].label)
          @@mylog.debug "Label of subject %s  is updated" % ls.code
          updated = true
        end
        if ls.label_en != remote_subjects[count].labelEn && remote_subjects[count].labelEn.is_a?(String)
          ls.update_attribute(:label_en,remote_subjects[count].labelEn.to_s)          
          @@mylog.debug "Label EN of subject %s  is updated" % ls.code
          updated = true
        end
#         Future implementation of Person's subject
#        if ls.person_id != remote_subjects[count].idPerson
#          ls.update_attribute(:person_id,remote_subjects[count].idPerson)
#          updated = true
#        end
        if remote_subjects[count].idDepartment.is_a?(String)
          ls.departments.each do |department|
              department_count = department_count + 1
            if department.id == remote_subjects[count].idDepartment.to_i
              department_exist = true
            end
          end
          if department_exist != true && Department.find(:first, :conditions => ["id = ?", remote_subjects[count].idDepartment])
            ls.departments << Department.find(remote_subjects[count].idDepartment.to_i)
               @@mylog.debug "Department is added to subject %s" % ls.code
               updated = true
          elsif department_exist != true
            @@mylog.debug "Department IS MISSING in our database! for subject %s" % ls.code
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
        (remote_subjects[count].label.is_a?(String))? label = remote_subjects[count].label : label = ""
        (remote_subjects[count].labelEn.is_a?(String))? label_en = remote_subjects[count].labelEn : label_en = ""
        (remote_subjects[count].code.is_a?(String))? code = remote_subjects[count].code : label = ""
        #(remote_subjects[count].idDepartment.is_a?(String))? department_id = remote_subjects[count].idDepartment : department_id =  ""        
        subject = Subject.create(:label => label, :label_en => label_en, :code => code)
        if Department.find(:first, :conditions => ["id = ?", remote_subjects[count].idDepartment])
          subject.departments << Department.find(remote_subjects[count].idDepartment.to_i)
        else
          @@mylog.debug "Department IS MISSING in our database! for subject %s" % subject.code
          missing_departments = missing_departments + 1          
        end
        @@mylog.debug "Subject %s is created" % remote_subjects[count].code
        created_subjects = created_subjects + 1
      end
    end
    @@mylog.info "%i subjects are created" % created_subjects
    @@mylog.info "%i subjects are updated" % updated_subjects
    @@mylog.info "ERROR - %i departments ARE MISSING in our database. See log above." % missing_departments    
  end

  # approve all indexes 
  def self.mass_approve(indices)
    @@mylog.info "There are #{indices.size} indices"
    indices.each do |i|
      if i.study_plan
        app = i.study_plan.approvement || StudyPlanApprovement.new
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

  def self.clean_coridor_subjects
    @count = 0
    Faculty.find(:all).each do |f|
      f.coridors.each do |c|
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

  def self.change_last_or_delete(vs)
    if @last == vs.subject_id
      @@mylog.debug "To delete #{vs.type} id: " + vs.id.to_s
      vs.destroy
      @count += 1
    else
      @last = vs.subject_id
    end
  end

  # fixes birth number badly transfered from candidates
  def self.fix_bad_birth_numbers(students = nil)
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
  def self.repair_sident(students)
    @@mylog.info "There are %i students" % students.size
    @client = SOAP::NetHttpClient.new
    #TODO change URL to params in config
    service = "http://193.84.34.34:8081/axis2/rest/GetSidentService/getSidentByBirthNum?rc=%s"
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
end
