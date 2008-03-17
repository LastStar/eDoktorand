class DiplomaSupplement < ActiveRecord::Base

  validates_presence_of :diploma_no, :message => _("Diploma Number can't be blank")
  validates_presence_of :family_name, :message => _("Family name can't be blank")
  validates_presence_of :given_name, :message => _("Given name can't be blank")
  validates_presence_of :date_of_birth, :message => _(" Date of birth can't be blank")
  validates_presence_of :study_programme, :message => _("Study programme can't be blank")
  validates_presence_of :study_specialization, :message => _("Study specialization can't be blank")
  validates_presence_of :faculty_name_en, :message => _("English faculty name can't be blank")
  validates_presence_of :faculty_name, :message => _("Faculty name can't be blank")
  validates_presence_of :study_mode, :message => _("Study mode can't be blank")
  validates_presence_of :disert_theme_title, :message => _(" Title of disert theme can't be blank")
  validates_presence_of :defense_passed_on, :message => _("Defence passed on can't be blank")
  validates_presence_of :final_areas, :message => _("Final areas can't be blank")
  validates_presence_of :final_exam_passed_on, :message => _("Final exam passed on can't be blank")
  validates_presence_of :plan_subjects, :message => _("Plan subjects can't be blank")
  validates_presence_of :faculty_www, :message => _("Faculty www can't be blank")
  validates_presence_of :printed_on, :message => _("Printed on can't be blank")
  validates_presence_of :dean_display_name, :message => _("Display name can't be blank")
  validates_presence_of :dean_title, :message => _("Dean title can't be blank")

  def self.new_from_index(index)
    index =  Index.find(index) unless index.is_a? Index
    new = self.new
    new.diploma_no = index.student.sident
    new.family_name = index.student.lastname
    new.given_name = index.student.firstname
    new.date_of_birth = index.student.birth_on
    new.study_programme = index.coridor.program.label_en if index.coridor.program
    new.study_specialization = index.coridor.name_english
    new.faculty_name_en = index.faculty.name_english
    new.faculty_name = index.faculty.name
    new.study_mode = index.study.name_en
    new.disert_theme_title = index.disert_theme.title_en
    new.defense_passed_on = index.disert_theme.defense_passed_on.strftime('%B %d, %Y')
    new.final_areas = index.study_plan.final_areas['en'].map {|fa| fa.last}.join(';') if index.study_plan.final_areas
    new.final_exam_passed_on = index.final_exam_passed_on.strftime('%B %d, %Y')
    new.plan_subjects = index.study_plan.plan_subjects.map {|ps| ps.subject.label_en}.join(';')
    new.faculty_www = index.faculty.www
    new.printed_on = Date.today.strftime('%B %d, %Y')
    new.dean_display_name = index.faculty.dean.display_name
    new.dean_title = index.faculty.dean_label_en
    return new
  end

  def self.new_for(faculty)
    new(:faculty_name_en => faculty.name_english,
        :faculty_name => faculty.name,
        :faculty_www => faculty.www,
        :dean_display_name => faculty.dean.display_name,
        :dean_title => faculty.dean_label_en)
  end

  def self.find_for(user)
    find(:all, :conditions => ["faculty_name = ?", user.person.faculty.name])
  end
end
