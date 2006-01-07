class LanguageSubject < CoridorSubject 
# returns options for html select
  def self.for_select
    self.find(:all, :order => 'subjects.label', :include => :subject).map {|sub| [sub.subject.label, sub.subject.id]}
  end
end
