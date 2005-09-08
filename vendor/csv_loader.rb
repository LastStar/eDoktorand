require 'csv'
# class for loading objects to database from csv
# import plan:
#   faculty
#   department
#   coridors
#   tutors
class CSVLoader
  # loads faculties to system
  def self.load_faculties
    CSV::Reader.parse(File.open('dumps/csv/faculties.csv', 'rb'), ';') do |row|
      f = Faculty.new('name' => row[1], 'name_english' =>
      row[2], 'short_name' => row[3], 'ldap_context' => row[4])
      f.id = row[0]
      f.save
    end
  end
  # loads departments to system
  def self.load_departments
    CSV::Reader.parse(File.open('dumps/csv/departments.csv', 'rb'), ';') do |row|
      f = Department.new('name' => row[1], 'name_english' =>
      row[2], 'short_name' => row[3], 'faculty_id' => row[4])
      f.id = row[0]
      f.save
    end
  end
  # loads coridors to system
  def self.load_coridors
    CSV::Reader.parse(File.open('dumps/csv/coridors.csv', 'rb'), ';') do |row|
      f = Coridor.new('name' => row[2], 'faculty_id' =>
      row[1], 'code' => row[4])
      f.id = row[0]
      f.save
    end
  end
  # loads coridors to system
  def self.load_subjects
    CSV::Reader.parse(File.open('dumps/csv/subjects.csv', 'rb'), ';') do |row|
      s = Subject.new('label' => row[2], 'code' =>
      row[3])
      s.id = row[1]
      s.departments << Department.find(row[4])
      s.save
    end
  end
    # loads tutors to system
  def self.load_tutors
    prefixes = [nil, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 20,
    17, 21, 18, 22, nil, 23, 19, nil, 24, nil, 27, 26, 28, 43, 29, 30, 31, 32,
    33, 34, 35, 36, 37, 38, 39, 40, 41, 42]
    suffixes = [nil, 44, 45, 46, 47, 48, 49, 51]
    CSV::Reader.parse(File.open('dumps/csv/tutors.csv', 'rb'), ';') do |row|
      t = Tutor.new
      t.firstname = row[4]
      t.lastname = row[3]
      t.uic = row[7]
      if row[10] && !row[10].empty?
        Title.find(prefixes[row[10].to_i])
        t.title_before = Title.find(prefixes[row[10].to_i])
      end
      if row[11] && !row[11].empty?
        t.title_after = Title.find(suffixes[row[11].to_i])
      end
      if row[8] && !row[8].empty?
        ts = Tutorship.new  
        t.tutorship = ts
        ts.department = Department.find(row[8])
        ts.save
      end
      t.id = row[0]
      p t 
      t.save
    end
  end
  # loads student to system
  def self.load_students
    CSV::Reader.parse(File.open('dumps/csv/students.csv', 'rb'), ';') do |row|
      s = Student.new
      i = Index.new
      u = User.new
      s.firstname = row[0]
      s.birthname = row[1]
      s.lastname = row[2]
      s.birth_on = row[3]
      s.birth_number = row[4]
      i.coridor = Coridor.find(row[7])
      u.password = u.password_confirmation = u.login = row[9]
      
      s.uic = row[10]
      i.tutor_id = Tutor.find_by_uic(row[11])
      if row[13] && !row[13].empty?
        i.department = Department.find(row[13])
      end
      s.index = i
      s.save
      u.person = s
      u.save
      i.save
    end
  end
end
