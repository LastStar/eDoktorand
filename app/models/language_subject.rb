class LanguageSubject < CoridorSubject 
# returns options for html select
  def self.for_select
    self.find(:all).map {|sub| [sub.subject.label, sub.subject.id]}
  end
end
