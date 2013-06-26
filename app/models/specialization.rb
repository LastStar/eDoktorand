class Specialization < ActiveRecord::Base
  belongs_to :faculty
  belongs_to :program
  has_many :candidates, :conditions => "finished_on IS NOT NULL"
  has_many :approved_candidates, :class_name => 'Candidate',
           :conditions => "finished_on IS NOT NULL and ready_on IS NOT NULL"
  has_many :obligate_subjects, :order => 'subjects.label', :include => :subject
  has_many :voluntary_subjects, :order => 'subjects.label', :include => :subject
  has_many :seminar_subjects, :order => 'subjects.label', :include => :subject
  has_many :language_subjects, :order => 'subjects.label', :include => :subject
  has_many :requisite_subjects, :order => 'subjects.label', :include => :subject
  has_one :exam_term
  has_many :indices
  has_many :tutorships
  has_many :tutors, :through => :tutorships, :order => 'people.lastname'
  validates_presence_of :faculty

  # returns array structured for html select
  # FIXME remove from views/candidates/admit.rhtml move to candidates_helper
  def self.for_select(options = {})
    conditions = if options[:accredited]
                   ['accredited = 1']
                 else
                   ['']
                 end
    if options[:faculty]
      if options[:faculty] == :all
        conditions.first << ' AND' if !conditions.first.empty?
        conditions = 'NULL IS NULL'
      else
        faculty = options[:faculty].is_a?(Faculty) ? options[:faculty].id : options[:faculty]
        conditions.first << ' AND' if !conditions.first.empty?
        conditions.first << ' faculty_id = ?'
        conditions << faculty
      end
    end
    result = find(:all, :conditions => conditions,
                  :order => 'name').map {|d| [d.name, d.id]}
    if options[:include_empty]
      [['---', '0']].concat(result)
    else
      result
    end
  end

  def self.find_for(user)
    if user.has_one_of_roles?(['vicerector', 'university_secretary'])
      find(:all)
    else
      user.person.faculty.specializations
    end
  end

  def self.find(*args)
    if args.first.is_a?(Hash) && user = args.first[:user]
      if user.has_role?('vicerector')
        return super(:all)
      else
        user.person.faculty.specializations
      end
    else
      super
    end
  end

  def tutors_for_select
    tutors.map {|t| [t.display_name, t.id]}
  end

  def english_with_code
    code + ' ' + name_english.to_s
  end

  def self.accredited_for(user)
    if user.has_role?('vicerector')
      find_all_by_accredited(1)
    else
      find_all_by_faculty_id_and_accredited(user.person.faculty.id, 1)
    end
  end

  # returns set study length or 3 years
  def study_length
    read_attribute(:study_length) || 3
  end

  # returns last semester when is possible to pass exams
  def last_possible_exam_semester
    study_length * 2 - 2
  end

  # returns last semester when is possible to pass defense
  def last_possible_defense_semester
    study_length * 2
  end

  def name_with_students_count
    "#{self.name} (#{students_count})"
  end

  def students_count
    Index.count(:conditions => ["specialization_id = ? and finished_on is not null and disert_themes.defense_passed_on is null", self.id],
                :include => :disert_theme)
  end

  def accredited?
    accredited.to_s == "1"
  end
end
