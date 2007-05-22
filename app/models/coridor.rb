class Coridor < ActiveRecord::Base
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
  has_many :tutors, :through => :tutorships
  validates_presence_of :faculty

  # returns array structured for html select
  def self.for_select(options = {})
    conditions = if options[:accredited]
                   ['accredited = 1']
                 else
                   ['']
                 end
    if options[:faculty]
      if options[:faculty] == :all
        conditions.first << ' AND' if !conditions.first.empty?
        conditions = '1=1' 
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

  def self.for_html_select(user)
    if user.has_role?('faculty_secretary')
      self.for_select(:faculty => user.person.faculty, :accredited => true)
    end
  end

  def tutors_for_select
    tutors.sort.map {|t| [t.display_name, t.id]}
  end

  def english_with_code
    code + ' ' + name_english.to_s
  end

  def self.accredited_for(user)
    find_all_by_faculty_id_and_accredited(user.person.faculty.id, 1)
  end
end
