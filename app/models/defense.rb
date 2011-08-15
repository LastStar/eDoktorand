class Defense < ExamTerm

  belongs_to :index
	validates_presence_of :chairman_id, :message => I18n::t(:chairman_must_be_present, :scope => [:model, :term])

  # returns formated date time
  def date_time
    "%s %s" % [date.strftime("%d. %m. %Y"), start_time]
  end

  # finds defense for given user
  def self.find_for(user, options = {})
    # TODO redo with only ids of indices
    indices = Index.find_for(user, :not_absolved => true)
    if options.delete :not_passed
      indices.reject! do |i|
        i.status == I18n::t(:absolved_l, :scope => [:model, :index]) ||
        i.status == I18n::t(:finished_l, :scope => [:model, :index])
      end
    end
    options[:conditions] = ['index_id in (?)', indices]
    if options.delete :future
      options[:conditions].first << ' and date >= ? and indices.final_exam_invitation_sent_at is not null'
      options[:conditions] << Date.today
    end
    options[:include] = :index
    options[:order] = 'date'
    find(:all, options)
  end
end
