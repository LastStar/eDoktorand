# TODO atomize!
require 'csv'
require 'log4r'

# class for loading objects to database from csv
class CSVLoader
  include Log4r

  # create a logger named 'mylog' that logs to stdout
  @@mylog = Logger.new 'Importer'
  @@mylog.outputters = Outputter.stdout
  @@mylog.level = 1
  @@prefixes = [nil, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 20,
    17, 21, 18, 22, nil, 23, 19, nil, 24, nil, 27, 26, 28, 43, 29, 30, 31, 32,
    33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 52]
  @@suffixes = [nil, 44, 45, 46, 47, 48, 49, 51]
  @@prefixes[53] = 59
  # loads all to database
  def self.load_all
    self.load_faculties('dumps/csv/faculties.csv', :destroy => true)
    self.load_departments('dumps/csv/departments.csv', :destroy => true)
    self.load_coridors('dumps/csv/coridors.csv', :destroy => true)
    self.load_subjects('dumps/csv/subjects.csv', :destroy => true)
    self.load_tutors({:tutor => 'dumps/csv/tutors.csv', :tutorship => 'dumps/csv/tutorship.csv'}, :destroy => true)
    self.load_leaders({:leader => 'dumps/csv/leaders.csv',:leadership =>
      'dumps/csv/leadership.csv'}, :destroy => true)
    self.load_deans({:dean => 'dumps/csv/deans.csv', :deanship =>
      'dumps/csv/deanship.csv'}, :destroy => true)
  end
  # loads data for enrollment
  def self.load_for_enrollment
    self.load_faculties('dumps/csv/faculties.csv', :destroy => true)
    self.load_departments('dumps/csv/departments.csv', :destroy => true)
    self.load_coridors('dumps/csv/coridors.csv', :destroy => true)
    self.load_subjects('dumps/csv/subjects.csv', :destroy => true)
    self.load_tutors({:tutor => 'dumps/csv/tutors.csv', :tutorship => 'dumps/csv/tutorship.csv'}, :destroy => true)
    self.load_leaders({:leader => 'dumps/csv/leaders.csv',:leadership =>
    'dumps/csv/leadership.csv'}, :destroy => true)
    self.load_deans({:dean => 'dumps/csv/deans.csv', :deanship =>
    'dumps/csv/deanship.csv'}, :destroy => true)
    CoridorSubject.destroy_all
    self.load_fle_subjects_coridors('dumps/csv/Corridors_Subjects_FLE.csv')
    self.load_pef_subject_coridors('dumps/csv/subjects_corridors.csv')
    Student.destroy_all
    Index.destroy_all
    self.load_enrolled_students("dumps/csv/enrolled.csv")
    self.load_tutor_logins("dumps/csv/tutors_login.csv")
  end
  # loads faculties to system
  def self.load_faculties(file, options = {} )
    Faculty.destroy_all if options[:destroy]
    @@mylog.info "Loading faculties..."
    CSV::Reader.parse(File.open(file, 'rb'), ';') do |row|
      f = Faculty.new('name' => row[1], 'name_english' =>
      row[2], 'short_name' => row[3], 'ldap_context' => row[4])
      f.id = row[0]
      f.save
    end
  end
  # loads departments to system
  def self.load_departments(file, options = {} )
    Department.destroy_all if options[:destroy]
    @@mylog.info "Loading departments..."
    CSV::Reader.parse(File.open(file, 'rb'), ';') do |row|
      f = Department.new('name' => row[1], 'name_english' =>
      row[2], 'short_name' => row[3], 'faculty_id' => row[4])
      f.id = row[0]
      f.save
    end
  end
  # loads coridors to system
  def self.load_coridors(file, options = {} )
    Coridor.destroy_all if options[:destroy]
    @@mylog.info "Loading coridors..."
    CSV::Reader.parse(File.open(file, 'rb'), ';') do |row|
      f = Coridor.new('name' => row[2], 'faculty_id' =>
      row[1], 'code' => row[4])
      f.id = row[0]
      f.save
    end
  end
  # loads subjects to system
  def self.load_subjects(file, options = {} )
      Subject.destroy_all if options[:destroy]
      @@mylog.info "Loading subjects..."
      CSV::Reader.parse(File.open(file, 'rb'), ';') do |row|
        s = Subject.new('label' => row[2], 'code' => row[3])
        s.id = row[1]
        s.departments << Department.find(row[4])
        s.save
      end
    end

  # loads tutors
  def self.load_tutors(files, options = {})
    if options[:destroy]
      Tutor.destroy_all 
      Tutorship.destroy_all
    end
    @@mylog.info "Loading tutors..."
    CSV::Reader.parse(File.open(files[:tutor], 'rb'), ';') do |row|
      t = Tutor.new
      t.firstname = row[4]
      t.lastname = row[3]
      if row[10] && !row[10].empty?
        t.title_before = Title.find(@@prefixes[row[10].to_i])
      end
      if row[11] && !row[11].empty?
        t.title_after = Title.find(@@suffixes[row[11].to_i])
      end
      t.uic = row[7]
      t.id = row[6]
      @@mylog.debug "Tutor: #{t.id} " if t.save
      if row[8] && !row[8].empty?
        ts = Tutorship.new  
        t.tutorship = ts
        ts.department = Department.find(row[8])
        ts.save(false)
      end
    end
    @@mylog.info "Loading tutorships..."
    CSV::Reader.parse(File.open(files[:tutorship], 'rb'), ';') do |row|
      @@mylog.info row[0]
      if t = Tutor.find_by_uic(row[1]).tutorship
        t.coridor = Coridor.find(row[2])
        t.save
      end
    end
  end

  # loads leaders
  def self.load_leaders(files, options = {})
    if options[:destroy]
      Dean.destroy_all 
      Deanship.destroy_all
    end
    @@mylog.info "Loading leaders..."
    CSV::Reader.parse(File.open(files[:leader], 'rb'), ';') do |row|
      if Person.exists?(row[0])
        Person.find(row[0]).update_attribute('type', 'Leader')
        @@mylog.debug "Leader id: #{row[0]} found in persons"
      else
        l = Leader.new('firstname' => row[1], 'lastname' => row[2])
        if row[5] && !row[5].empty?
          l.title_before = Title.find(@@prefixes[row[5].to_i])
        end
        if row[6] && !row[6].empty?
          l.title_after = Title.find(@@suffixes[row[6].to_i])
        end
        l.id = row[0]
        @@mylog.debug "Leader: #{l.display_name} created" if l.save
      end
    end
    @@mylog.info "Loading leaderships..."
    CSV::Reader.parse(File.open(files[:leadership], 'rb'), ';') do |row|
      l = Person.find(row[0])
      ls = Leadership.new
      ls.leader = l
      ls.department = Department.find(row[1])
      ls.save
      l.leadership = ls
      l.save
    end
  end

  # loads tutors to system
  def self.load_deans(files, options = {})
    if options[:destroy]
      Dean.destroy_all 
      Deanship.destroy_all
    end
    Deanship.destroy_all  
    @@mylog.info "Loading deans..."
    CSV::Reader.parse(File.open(files[:dean], 'rb'), ';') do |row|
      if Person.exists?(row[0])
        Person.find(row[0]).update_attribute('type', 'Dean')
      else
        d = Dean.new('firstname' => row[0], 'lastname' => row[1])
        if row[5] && !row[5].empty?
          d.title_before = Title.find(@@prefixes[row[5].to_i])
        end
        if row[6] && !row[6].empty?
          d.title_after = Title.find(@@suffixes[row[6].to_i])
        end
        d.id = row[0]
        @@mylog.info "Dean: #{l.display_name} created" if d.save
      end
    end
    @@mylog.info "Loading deanships..."
    CSV::Reader.parse(File.open(files[:deanship], 'rb'), ';') do |row|
      d = Person.find(row[0])
      ds = Deanship.new
      ds.dean = d
      ds.faculty = Faculty.find(row[1])
      ds.save
      d.deanship = ds
      d.save
    end
  end

  # loads tutors logins
  def self.load_tutor_logins(file)
    CSV::Reader.parse(File.open(file, 'rb'), ';') do |row|
      if t = Tutor.find_by_uic(row[0])
        u = User.new
        u.login = u.password_confirmation = u.password = row[1]
        u.person = t
        u.roles << Role.find(4)
        u.save
      else
        @@mylog.error "Tutor uic: #{row[0]} not found"
      end
    end
  end

  # loads student to system
  def self.load_students(file, options = {} )
    if options[:destroy]
      Student.destroy_all
      Index.destroy_all
    end
    @@mylog.info "Loading students..."
    CSV::Reader.parse(File.open(file, 'rb'), ';') do |row|
      s = Student.new
      i = Index.new
      s.firstname = row[1]
      s.birthname = row[2]
      s.lastname = row[3]
      s.birth_on = row[4]
      s.birth_number = row[5]
      i.coridor = Coridor.find(row[6])
      s.uic = row[10]
      i.tutor = Tutor.find_by_uic(row[8])
      if row[11] && !row[11].empty?
        i.department = Department.find(row[11])
      end
      s.id = row[9]
      s.index = i
      s.save
      u.person = s
      u.save
      i.save
    end
  end

  # loads study plans to system
  def self.load_study_plans(file, options = {} )
    if options[:destroy]
      StudyPlan.destroy_all
      DisertTheme.destroy_all
    end
    @@mylog.info "Loading study plans..."
    CSV::Reader.parse(File.open(file, 'rb'), ';') do |row|
      if (row[3].to_i > 0)
        @@mylog.info row[0]
        if s = Student.find_by_uic(row[1].to_i)
          if i = s.index
            i.enrolled_on = Time.mktime(2006 - row[2].to_i, 9,30)
            i.study = Study.find(row[3].to_i)
            i.payment_id = row[4].to_i
            i.save
            sp = StudyPlan.new('index_id' => s.index.id)
            sp.finishing_to = row[6].to_i
            dt = DisertTheme.new('index_id' => s.index.id)
            dt.title = row[7]
            dt.finishing_to = row[9].to_i
            dt.save
            sp.admited_on = Time.now 
            sp.id = row[11]
            sp.save
            u = User.new
            u.login = u.password = u.password_confirmation = row[13]
            u.person = s
            u.save
            s.save
          end
        else
          @@mylog.debug "uic #{row[1]} not found" 
        end
      end
    end
  end

  # loads plans subjects
  def self.load_plan_subjects(file, options = {} )
    PlanSubject.destroy_all if options[:destroy]
    arr = File.open('conv_table.yml') {|out| YAML.load(out)}
    @@mylog.info "Loading plan subjects..."
    CSV::Reader.parse(File.open(file, 'rb'), ';') do |row|
      @@mylog.info row[4]
      s = Student.find_by_uic(row[0])
      if s.index
        if sp = s.index.study_plan
          if row[4] == 'false' && sub = Subject.exists?(row[3])
            PlanSubject.create('study_plan_id' => sp.id, 'subject_id' => row[3], 'finishing_on' => row[5])
          else
           PlanSubject.create('study_plan_id' => sp.id, 'subject_id' =>
             arr[row[3].to_i], 'finishing_on' => row[5])
          end
        else 
          @@mylog.debug "student uic: #{s.display_name} doesn't have study plan" 
        end
      else
        @@mylog.debug "student uic: #{s.display_name} doesn't have index" 
      end
    end
  end

  # loads fle subjects coridors 
  def self.load_fle_subjects_coridors(file)
    CSV::Reader.parse(File.open(file, 'rb'), ';') do |row|
      cs = CoridorSubject.new
      cs.coridor = Coridor.find_by_code(row[3])
      cs.subject = Subject.find_by_code(row[0])
      case row[2]
      when "P"
        cs.type = 'ObligateSubject'
      when "V"
        cs.type = 'VoluntarySubject'
      end
      cs.save
    end
  end

  # loads pef subject coridors
  def self.load_pef_subject_coridors(file)
    CSV::Reader.parse(File.open(file, 'rb'), ';') do |row|
      cs = CoridorSubject.new
      cs.coridor = Coridor.find(row[0])
      cs.subject = Subject.find(row[1])
      if row[2] =='true'
        cs.type = 'ObligateSubject'
        cs.save
      elsif row[3] == 'true'
        cs.type = 'VoluntarySubject'
        cs.save
      end
    end
  end

  # sets voluntary subjects for agro
  def self.set_subjects_coridors(faculty_id)
    faculty = Faculty.find(faculty_id)
    faculty.coridors.each do |c|
      faculty.subjects.each do |s| 
        unless  VoluntarySubject.find_by_subject_id_and_coridor_id(s.id, c.id)
          @@mylog.debug "Voluntary subject created"
          VoluntarySubject.create(:subject => s, :coridor => c)
        else
          @@mylog.debug "Voluntary subject found"
        end
      end
    end
  end

  # loads student to system
  def self.load_enrolled_students(file)
    @@mylog.info "Loading enrolled students..."
    CSV::Reader.parse(File.open(file, 'rb'), ';') do |row|
      s = Student.new
      i = Index.new
      u = User.new
      s.firstname = row[2]
      s.lastname = row[1]
      i.department = Department.find(row[3])
      i.coridor = Coridor.find(row[4])
      i.study = Study.find(row[5])
      i.tutor = Tutor.find_by_uic(row[6])
      u.password = u.password_confirmation = u.login = row[7]
      s.index = i
      s.id = row[0]
      @@mylog.debug "Student #{s.display_name}" if s.save
      u.person = s
      u.roles << Role.find(3)
      u.save(false)
      @@mylog.debug "User #{u.login}" 
      i.save
    end
  end

  # loads student to system
  def self.load_enrolled_students_fle(file)
    @@mylog.info "Loading enrolled students..."
    CSV::Reader.parse(File.open(file, 'rb'), ';') do |row|
      puts row
      s = Student.new
      i = Index.new
      u = User.new
      s.firstname = row[2]
      s.lastname = row[1]
      i.department = Department.find(row[3])
      i.coridor = Coridor.find(row[4])
      i.study = Study.find(row[5])
      i.tutor = Tutor.find(row[6])
      u.password = u.password_confirmation = u.login = row[7]
      s.index = i
      s.id = row[0]
      @@mylog.debug "Student #{s.display_name}" if s.save
      u.person = s
      u.roles << Role.find(3)
      u.save(false)
      @@mylog.debug "User #{u.login}" 
      i.save
    end
  end

  # loads student to system
  def self.load_enrolled_students_its(file)
    @@mylog.info "Loading enrolled students..."
    CSV::Reader.parse(File.open(file, 'rb'), ';') do |row|
      s = Student.new
      i = Index.new
      u = User.new
      s.firstname = row[2]
      s.lastname = row[1]
      s.birthname = row[9]
      i.department = Department.find(row[3])
      i.coridor = Coridor.find(row[4])
      i.study = Study.find(row[5])
      i.tutor = Tutor.find_by_uic(row[6])
      i.payment_id = row[10]
      u.password = u.password_confirmation = u.login = row[7]
      s.index = i
      s.id = row[0]
      @@mylog.debug "Student #{s.display_name}" if s.save
      u.person = s
      u.roles << Role.find(3)
      u.save(false)
      @@mylog.debug "User #{u.login}" 
      i.save
    end
  end

  # loads external subjects
  def self.load_external_subjects(file)
    @@mylog.info "Loading external subjects..."
    arr = [] 
    CSV::Reader.parse(File.open(file, 'rb'), ';') do |row|
      es = ExternalSubject.new
      es.label = row[2]
      esd = ExternalSubjectDetail.new
      esd.university = row[1] 
      es.save
      esd.external_subject = es
      esd.save
      arr[row[0].to_i] = es.id
    end
    @@mylog.debug arr
    File.open('conv_table.yml', 'w') {|out| YAML.dump(arr, out)}
  end

  # loads examinators
  def self.load_examinators(file, department_id = nil)
    p = nil
    ActiveRecord::Base.connection.execute('SET NAMES UTF8')
    @@mylog.info "Loading examinators..."
    CSV::Reader.parse(File.open(file, 'rb'), ';') do |row|
      @@mylog.debug row
      unless Person.exists?(row[0])
        p = Examinator.new(:firstname => row[2], :lastname => row[3],
                           :uic => row[5])
        p.title_before = Title.find(@@prefixes[row[1].to_i]) if row[1] && !row[1].empty?
        p.title_after = Title.find(@@suffixes[row[4].to_i]) if row[4] && !row[4].empty?
        p.id = row[0]
        p.department_employment = DepartmentEmployment.create('unit_id' => (department_id || row[6]))
        @@mylog.info "Saving #{p.type} #{p.lastname}"
        p.save
      else
        @@mylog.info "person found"
      end
      unless User.find_by_login(row[6])
        u = User.new(:login => row[6], :password => row[6], :person_id => row[0])
        u.password_confirmation = u.password
        u.save
        @@mylog.info "Saving user #{u.login}"
      else
        @@mylog.info "user found"
      end
    end
  end

  # loads exams
  def self.load_exams(file)
    @@mylog.info "Loading exams..."
    CSV::Reader.parse(File.open(file, 'rb'), ';') do |row|
      if Student.exists?(row[4]) && Subject.exists?(row[1])
        e = Exam.new
        e.subject = Subject.find(row[1])
        e.result = 1 
        e.questions = row[3]
        e.index_id = Student.find(row[4]).index.id
        e.created_on = row[6]
        e.first_examinator = Person.find(row[9]) unless row[9].to_i == -1
        e.second_examinator = Person.find(row[10]) unless row[10].to_i == -1
        e.save
      else
        @@mylog.debug "Student #{row[4]} or subject #{row[1]}"
      end
    end
  end

  # loads exams
  def self.load_exams_kj(file)
    @@mylog.info "Loading exams..."
    CSV::Reader.parse(File.open(file, 'rb'), ';') do |row|
      @@mylog.debug row
      if Student.exists?(row[0]) && Subject.exists?(row[2])
        st = Student.find(row[0])
        if st.index && st.index.study_plan
          sub = Subject.find(row[2])
          e = Exam.new
          e.subject = sub
          e.result = 1 
          e.index = st.index
          e.created_on = Time.now
          e.first_examinator = Examinator.find(row[3])
          ps = PlanSubject.find_for_exam(e)
          e.save
        else
          @@mylog.warning "Student #{st.display_name}[#{row[0]}] doesn't have index or study plan"
        end
      else
        @@mylog.warning "Student #{row[4]} or subject #{row[1]} not found"
      end
    end
  end

  # loads exams
  def self.load_exams_faapz(file)
    @@mylog.info "Loading exams..."
    CSV::Reader.parse(File.open(file, 'rb'), ';') do |row|
      if Student.exists?(row[3]) && Subject.exists?(row[0])
        s = Student.find(row[3])
        sub = Subject.find(row[0])
        e = Exam.new
        ps = PlanSubject.new 
        e.subject = sub
        ps.subject = sub
        ps.finishing_on = row[10] 
        case row[1]
        when 'S'
          e.result = 1 
          ps.finished_on = row[5]
        when 'N'
          e.result = 0
        end
        e.questions = row[2]
        e.index_id = s.index.id
        e.created_on = row[5]
        ps.study_plan = s.index.study_plan
        e.save
        ps.save
      else
        @@mylog.debug "Student #{row[3]} or subject #{row[0]} not found"
      end
    end
  end

  def self.load_study_starts(file)
    @@mylog.info "Loading study starts..."
    CSV::Reader.parse(File.open(file, 'rb'), ';') do |row|
      if Student.exists?(row[0]) && i = Student.find(row[0]).index
        i.enrolled_on = row[1]
        i.study_plan = StudyPlan.create('admited_on' => row[1])
        i.save
      else
        @@mylog.debug "Student #{row[0]} or his index not found"
      end
    end
  end

  # loads logins and study
  def self.load_logins(file)
    @@mylog.info "Loading logins..."
    CSV::Reader.parse(File.open(file, 'rb'), ';') do |row|
      if Student.exists?(row[0])
        u = Student.find(row[0]).user
        u.login = u.password = u.password_confirmation = row[1] if u
        u.save if u
        i = Student.find(row[0]).index 
        i.study = Study.find(row[2]) if i
        i.save if i
      end
    end   
  end

  # loads fle logins and study
  def self.load_logins_tf(file)
    @@mylog.info "Loading tf logins..."
    CSV::Reader.parse(File.open(file, 'rb'), ';') do |row|
      if Student.exists?(row[0])
        u = User.new
        u.login = u.password = u.password_confirmation = row[1] if u
        u.person = Student.find(row[0])
        u.save if u
        i = Student.find(row[0]).index 
        i.study = Study.find(row[2]) if i
        i.save if i
      end
    end   
  end

  # loads tutors
  def self.load_secretaries(file, options = {})
    if options[:destroy]
      DepartmentSecretary.destroy_all 
      DepartmentEmployment.destroy_all
    end
    @@mylog.info "Loading department secretaries..."
    CSV::Reader.parse(File.open(file, 'rb'), ';') do |row|
      ds = DepartmentSecretary.new
      ds.firstname = row[1]
      ds.lastname = row[2]
      if row[3] && !row[3].empty? && row[3].to_i !=0
        ds.title_before = Title.find(@@prefixes[row[3].to_i])
      end
      if row[4] && !row[4].empty? && row[4].to_i !=0
        ds.title_after = Title.find(@@suffixes[row[4].to_i])
      end
      ds.uic = row[0]
      ds.id = row[6]
      @@mylog.debug "Secretary: #{ds.id} " if ds.save
      de = DepartmentEmployment.new  
      de.person = ds
      de.department = Department.find(row[5])
      @@mylog.debug "department #{de.department.name}"
      de.save(false)
      u = User.new
      u.login = u.password = u.password_confirmation = row[7]
      u.person = ds
      u.roles << Role.find(7)
      u.save
    end
  end

  # loads student's birth days to system
  def self.load_birthdays(file)
    @@mylog.info "Loading birthdays..."
    CSV::Reader.parse(File.open(file, 'rb'), ';') do |row|
      if s = Student.find_by_uic(row[4])
        puts s
        s.birthname = row[2]
        s.birth_on = row[3]
        s.save
      end
    end
  end

  # loads student's new informations to system
  def self.load_new_students(file, options = {} )
    count = 0
    if options[:destroy]
      Student.destroy_all
      Index.destroy_all
    end
    @@mylog.info "Loading students..."
    CSV::Reader.parse(File.open(file, 'rb'), ';') do |row|
      if s = Student.find_by_uic(row[13])
        if s.index && !row[8].empty? && row[8] =~ /(\d\d?)[.](\d\d?)[.](\d\d\d\d).*/
          date = Date.civil($3.to_i, $2.to_i, $1.to_i)
          s.index.update_attribute('enrolled_on', date)
        else
          @@mylog.info "Student with uic #{row[13]} has not index"
        end
      else
        @@mylog.info "Student with uic #{row[13]} has not been found"
        count += 1
      end
    end
    @@mylog.info "Totaly #{count} student's have not been found"
  end

  # loads interupted students to system
  def self.load_interrupted(file)
    ActiveRecord::Base.connection.execute('SET NAMES UTF8')
    @@mylog.info "Loading students..."
    CSV::Reader.parse(File.open(file, 'rb'), ';') do |row|
      if !Person.exists?(row[14])
        s = Student.new
        i = Index.new
        u = User.new
        s.lastname = row[1]
        s.birthname = row[2]
        s.firstname = row[3]
        s.birth_on = row[4]
        s.birth_number = row[5]
        i.study = Study.find(row[6])
        i.coridor = Coridor.find(row[7])
        row[8] =~ /(\d\d?)[.](\d\d?)[.](\d\d\d\d).*/
        i.enrolled_on = Date.civil($3.to_i, $2.to_i, $1.to_i)
        i.tutor = Tutor.find_by_uic(row[9])
        i.department = Department.find(row[11])
        s.uic = row[13]
        s.id = row[14]
        u.login = u.password = u.password_confirmation = row[15]
        s.index = i
        s.save
        u.person = s
        u.save
        i.save
      elsif p = Person.find(row[14])
        p.update_attribute('type', 'Student')
        @@mylog.info "Student id #{row[14]} changed to student"
      else
        @@mylog.info "Student id #{row[14]} exists"
      end
    end
  end

  # loads birth places to system
  def self.load_birth_places(file)
    @@mylog.info "Loading birth places..."
    CSV::Reader.parse(File.open(file, 'rb'), ';') do |row|
      if s = Student.find_by_uic(row[4])
        s.birth_place = row[1]
        s.save
      end
    end
  end

  def self.load_name_fix(file)
    @@mylog.info "Loading name fix..."
    CSV::Reader.parse(File.open(file, 'rb'), ';') do |row|
      if s = Student.find_by_uic(row[3])
        s.lastname = row[1]
        s.firstname = row[2]
        s.save
      end
    end
  end

  def self.load_titles(prefixes, suffixes)
    @@mylog.info "Loading name fix..."
    CSV::Reader.parse(File.open(prefixes, 'rb'), ';') do |row|
      @@mylog.debug row[0]
      if Title.exists?(@@prefixes[row[0].to_i])
        @@mylog.debug "updating #{row[1]}"
        Title.find(@@prefixes[row[0].to_i]).update_attribute('label', row[1])
      else
        @@mylog.debug "creating #{row[1]}"
        Title.create(:label => row[1], :prefix => 1)
      end
    end
    CSV::Reader.parse(File.open(suffixes, 'rb'), ';') do |row|
      if Title.exists?(@@suffixes[row[0].to_i])
        @@mylog.debug "updating #{row[1]}"
        Title.find(@@suffixes[row[0].to_i]).update_attribute('label', row[1])
      else
        @@mylog.debug "creating #{row[1]}"
        Title.create(:label => row[1], :prefix => 1)
      end
    end
  end

  def self.load_no_user(file)
    @@mylog.info "Loading user fix..."
    CSV::Reader.parse(File.open(file, 'rb'), ';') do |row|
      @@mylog.info "Processing user #{row[3]}"
      u = User.new
      u.login = row[3]
      pass = row[3]
      if row[3].size < 5
        pass << 'ik'
        @@mylog.debug "Users pass #{row[3]} is too short. Using #{pass}."
      end
      u.password = u.password_confirmation = pass
      u.roles << Role.find(3)
      u.person = Student.find(row[0])
      u.save
    end
  end

  def self.load_no_user_tutors(file)
    @@mylog.info "Loading user fix..."
    CSV::Reader.parse(File.open(file, 'rb'), ';') do |row|
      @@mylog.info "Processing user #{row[3]}"
      u = User.new
      u.login = row[3]
      pass = row[3]
      if row[3].size < 5
        pass << 'ik'
        @@mylog.debug "Users pass #{row[3]} is too short. Using #{pass}."
      end
      u.password = u.password_confirmation = pass
      u.roles << Role.find(4)
      u.person = Tutor.find(row[0])
      u.save
    end
  end

  def self.load_sident(file)
    @@mylog.info "Loading students sident ..."
    CSV::Reader.parse(File.open(file, 'rb'), ';') do |row|
      if Student.exists?(row[0])
        Student.find(row[0]).update_attribute(:sident, row[1])
        @@mylog.info "Student with id #{row[0]} is updated"
      else
        @@mylog.debug "Student with id  #{row[1]} has not been found"
      end
    end
  end

  def self.load_tutors_its(file)
    @@mylog.info "Loading its tutors..."
    CSV::Reader.parse(File.open(file, 'rb'), ';') do |row|
      t = Tutor.new
      t.firstname = row[0]
      t.lastname = row[1]
      if row[5] && !row[5].empty?
        t.title_before = Title.find(@@prefixes[row[5].to_i])
      end
      if row[6] && !row[6].empty?
        t.title_after = Title.find(@@suffixes[row[6].to_i])
      end
      t.uic = row[3]
      t.id = row[2]
      @@mylog.debug "Tutor: #{t.id} " if t.save
      if row[4] && !row[4].empty?
        ts = Tutorship.new  
        t.tutorship = ts
        ts.department = Department.find(row[4])
        ts.coridor = Coridor.find(110)
        t.tutorship = ts
        ts.save
      end
    end
  end

  def self.load_accounts_for_candidates(file, enrolled_on)
    @@mylog.info "Loading candidate account"
    CSV::Reader.parse(File.open(file, 'rb'), ';') do |row|
      @@mylog.info row
      c = Candidate.find(row[0])
      s = c.enroll!(row[1], row[2])
      s.update_attribute(:uic, row[3]) if row[3]
    end
  end

  def self.repair_subjects(file, by_code = true)
    @@mylog.info "Repairing subjects"
    CSV::Reader.parse(File.open(file, 'rb'), ';') do |row|
      @@mylog.debug row[3]
      if by_code
        s = Subject.find_by_code(row[3])
      elsif Subject.exists?(row[1])
        s = Subject.find(row[1])
      end
      if s
        @@mylog.info "repairing"
        s.update_attributes(:label => row[2], :code => row[3])
        s.departments = [Department.find(row[4])]
        s.id = row[1]
        s.save
      else
        @@mylog.info "creating"
        s = Subject.new('label' => row[2], 'code' => row[3])
        s.id = row[1]
        s.departments = [Department.find(row[4])]
        s.save
      end
    end
  end

  def self.load_or_repair_subjects(file)
    @@mylog.info "Loading subjects..."
    CSV::Reader.parse(File.open(file, 'rb'), ';') do |row|
      if Subject.exists?(row[0])
        s = Subject.find(row[0])
        @@mylog.info "Repairing subject with code #{row[1]}"
        s.update_attribute(:label, row[2])
      else
        @@mylog.info "Creating subject with code #{row[1]}"
        s = Subject.new('label' => row[2], 'code' => row[1])
        s.id = row[0]
      end
      s.departments = [Department.find(row[4])]
      s.save
    end
  end

  def self.repair_ids(file)
    @@mylog.info "Loading fixes..."
    CSV::Reader.parse(File.open(file, 'rb'), ';') do |row|
      if Student.exists?(row[0])
        s = Student.find(row[0], :include => [:index, :user, :probation_terms])
        s.id = row[1]
        s.index.update_attribute(:student_id, row[1])
        s.address.update_attribute(:student_id, row[1])
        s.postal_address.update_attribute(:student_id, row[1])
        s.user.update_attribute(:person_id, row[1])
        s.phone.update_attribute(:person_id, row[1])
        s.email.update_attribute(:person_id, row[1])
      end
    end
  end

  def self.add_english_labels(file)
    @@mylog.info "Adding eng labels..."
    not_found = []
    CSV::Reader.parse(File.open(file, 'rb'), ';') do |row|
      if sub = Subject.find_by_code(row[1])
        @@mylog.debug "adding label to #{row[1]}"
        sub.update_attribute(:label_en, row[2])
      else
        @@mylog.debug "#{row[1]} has not been found"
        not_found << row[1]
      end
    end
    puts not_found
  end
end
