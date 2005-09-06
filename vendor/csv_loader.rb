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
    # loads tutors to system
  def load_tutors
    CSV::Reader.parse(File.open('dumps/tutors.csv', 'rb'), ';') do |row|
      t = Tutor.new
      s.firstname = row[2]
      s.lastname = row[2]
      s.birth_on = row[3]
      s.birth_number = row[4]
      i.coridor = Coridor.find_by_uid(row[7])
      u.login = row[9]
      s.uic = row[10]
      i.tutor_id = Tutor.find_by_uic(row[11])
      i.department = Department.find_by_uid(row[12])
    end
  end
  # loads student to system
  def load_students
    CSV::Reader.parse(File.open('dumps/students.csv', 'rb'), ';') do |row|
      s = Student.new
      i = Index.new
      u = User.new
      s.firstname = row[0]
      s.birthname = row[1]
      s.lastname = row[2]
      s.birth_on = row[3]
      s.birth_number = row[4]
      i.coridor = Coridor.find_by_uid(row[7])
      u.login = row[9]
      s.uic = row[10]
      i.tutor_id = Tutor.find_by_uic(row[11])
      i.department = Department.find_by_uid(row[12])
    end
  end
end
