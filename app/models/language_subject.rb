class LanguageSubject < CoridorSubject 
# returns options for html select
  def self.for_select(options = {})
    if options[:coridor]
      sql = ["coridor_id = ?", options[:coridor]]
    end
    self.find(:all, :conditions => sql, :order => 'subjects.label', :include => :subject).map {|sub| [sub.subject.label, sub.subject.id]}
  end
end
