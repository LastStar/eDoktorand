class ProbationTerm < ActiveRecord::Base
  
  belongs_to :subject
  belongs_to :creator, :class_name => "Person", :foreign_key => "created_by"
  belongs_to :first_examinator, :class_name => "Person", :foreign_key => "first_examinator_id"
  belongs_to :second_examinator, :class_name => "Person", :foreign_key => "second_examinator_id"
  has_and_belongs_to_many :students

  validates_presence_of :subject
  validates_presence_of :creator
  validates_presence_of :room
  validates_format_of :start_time, :with => /^[0-9]{1,2}[:][0-9]{1,2}$/, :on => :create, :message => I18n::t(:message_0, :scope => [:txt, :model, :term])
  validates_inclusion_of :max_students, :in => 1..500, :message => I18n::t(:message_1, :scope => [:txt, :model, :term])
  
  def validate

    if !(buffer = start_time).empty? && buffer =~ /[0-9]{1,2}:[0-9]{1,2}/
      hours = (buffer.at(0) + buffer.at(1)).to_i
      minutes = (buffer.at(3) + buffer.at(4)).to_i
      if hours > 23 || minutes > 59
        errors.add(:start_time, t(:message_2, :scope => [:txt, :model, :term]))
      end
    else
      errors.add(:start_time, I18n.t(:message_3, :scope => [:txt, :model, :term]))
    end
  end

  def self.find_for(user, option = nil)
    if user.has_role?('student') && user.person.has_study_plan?
      subjects = user.person.study_plan.unfinished_subjects(:subjects)
    else
      subjects = Subject.find_for(user)
    end
    if subjects.empty?
      []
    else
      find_by(subjects, option.to_sym)
    end
  end

  def self.find_by(subjects, option = nil)
    s_ids = subjects.map &:id
    options = {:conditions => ["subject_id in (?)", s_ids]}
    if option 
      if option == :history
        options[:conditions].first << ' and date <= ?'
        options[:limit] = 30
        options[:order] = 'date desc'
      else
        options[:conditions].first << ' and date >= ?'
        options[:order] = :date
      end
      options[:conditions] << Time.now.beginning_of_day
    end
    find(:all, options)
  end

  def has_enrolled?(student)
    students.include?(student)
  end

  def empty_note?
    !note || note.empty?
  end

  def enrolled_ratio
    "#{max_students}&nbsp;/&nbsp;#{students.size}"
  end
end
