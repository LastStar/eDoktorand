class SpecializationSubject < ActiveRecord::Base
  
  belongs_to :specialization
  belongs_to :subject
  validates_presence_of :subject

  # returns options for html select
  # there is only one option :specialization which is obligate
  def self.for_select(options = {})
    if options[:specialization]
      if options[:specialization].is_a?(Specialization)
        options[:specialization] = options[:specialization].id 
      end
      sql = ["specialization_id = ?", options[:specialization]]
    end
    self.find(:all, :conditions => sql, :order => 'subjects.label', 
             :include => :subject).sort do |x, y|
                                     x.subject.label <=> y.subject.label
                                   end.map do |sub|
      [sub.subject.select_label, sub.subject.id]
    end
  end

  # return subjects suitable for html select
  # there is only one option :specialization which is obligate
  def self.subjects_for_html_select(options)
    specialization = if options[:specialization].is_a? Specialization
                options[:specialization].id
              else
                options[:specialization]
              end
    sql = ['specialization_id = ?', specialization]
    find(:all, :conditions => sql, :include => :subject).map {|cs| 
      [cs.subject.label, cs.subject.id]}
  end

  # finds all specialization subjects for specialization
  def self.for_specialization(specialization)
    specialization = specialization.id if specialization.is_a?(Specialization)
    self.find_all_by_specialization_id(specialization)
  end

  # returns true if has requisite subject
  def self.has_for_specialization?(specialization)
    specialization = specialization.id if specialization.is_a?(Specialization)
    self.count(:conditions => ["specialization_id = ?", specialization]) > 0
  end
end
