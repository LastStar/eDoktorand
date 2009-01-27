class VoluntarySubject < CoridorSubject 
  untranslate_all
  belongs_to :coridor
  belongs_to :subject

  validates_presence_of :coridor

  def self.for_select(options = {})
    if options.delete :with_external 
      arr = [[t(:message_0, :scope => [:txt, :model, :subject]), 0]]
    else
      arr = []
    end
    arr.concat(super(options))
  end 

end
