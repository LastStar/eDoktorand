class CoridorSubject < ActiveRecord::Base
  untranslate_all
  belongs_to :coridor
  belongs_to :subject
  validates_presence_of :subject

  # returns options for html select
  # there is only one option :coridor which is obligate
  def self.for_select(options = {})
    if options[:coridor]
      if options[:coridor].is_a?(Coridor)
        options[:coridor] = options[:coridor].id 
      end
      sql = ["coridor_id = ?", options[:coridor]]
    end
    self.find(:all, :conditions => sql, :order => 'subjects.label', 
             :include => :subject).map do |sub|
      [sub.subject.select_label, sub.subject.id]
    end
  end

  # return subjects suitable for html select
  # there is only one option :coridor which is obligate
  def self.subjects_for_html_select(options)
    coridor = if options[:coridor].is_a? Coridor
                options[:coridor].id
              else
                options[:coridor]
              end
    sql = ['coridor_id = ?', coridor]
    find(:all, :conditions => sql, :include => :subject).map {|cs| 
      [cs.subject.label, cs.subject.id]}
  end
end
