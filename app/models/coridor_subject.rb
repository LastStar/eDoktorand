class CoridorSubject < ActiveRecord::Base
  belongs_to :coridor
  belongs_to :subject
  validates_presence_of :subject

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
