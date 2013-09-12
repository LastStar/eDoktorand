class Defense < ExamTerm

  belongs_to :index
  belongs_to :chairman, :class_name => 'Person'
	validates_presence_of :chairman_id, :message => I18n::t(:chairman_must_be_present, :scope => [:model, :term])

  def validate
    unless chairman
      unless chairman_name
        errors.add(:chairman_name, I18n::t(:missing_chairman, :scope => [:model, :defense]))
      end
    end
  end

  # returns formated date time
  def date_time
    "%s %s" % [date.strftime("%d. %m. %Y"), start_time]
  end

  # finds defense for given user
  def self.find_for(user, options = {})
    # TODO redo with only ids of indices
    indices = Index.find_for(user, :not_absolved => true, :unfinished => true)
    options = { :conditions => ['index_id in (?) and not_passed_on is null',
                                indices],
                :include => :index,
                :order => 'date'}
    find(:all, options)
  end
end
