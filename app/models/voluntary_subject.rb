class VoluntarySubject < SpecializationSubject 
  
  belongs_to :specialization
  belongs_to :subject

  validates_presence_of :specialization

  def self.for_select(options = {})
    if options.delete :with_external 
      arr = [[I18n::t(:external_subject, :scope => [:txt, :model, :subject]), 0]]
    else
      arr = []
    end
    arr.concat(super(options))
  end 

end
