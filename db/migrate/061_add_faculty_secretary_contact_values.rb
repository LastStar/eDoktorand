class AddFacultySecretaryContactValues < ActiveRecord::Migration
  def self.up
    f = FacultySecretary.find(:first, :include => 'faculty_employment',
        :conditions => ["unit_id = ?", 1])
    f.phone = '+420224384586'
    f.email = 'malanova@af.czu.cz'
    f = FacultySecretary.find(:first, :include => 'faculty_employment',
        :conditions => ["unit_id = ?", 2])
    f.phone = '+420224382164'
    f.email = 'spirkova@itsz.czu.cz'
    f = FacultySecretary.find(:first, :include => 'faculty_employment',
        :conditions => ["unit_id = ?", 3])
    f.phone = '+420224382877'
    f.email = 'peskova@lf.czu.cz'
    f = FacultySecretary.find(:first, :include => 'faculty_employment',
        :conditions => ["unit_id = ?", 4])
    f.phone = '+420224382325'
    f.email = 'husakova@pef.czu.cz'
    f = FacultySecretary.find(:first, :include => 'faculty_employment',
        :conditions => ["unit_id = ?", 5])
    f.phone = '+420224384220'
    f.email = 'jirickova@tf.czu.cz'
  end

  def self.down
    FacultySecretary.find(:all).each do |s|
      s.email.destroy
      s.phone.destroy
    end
  end
end
