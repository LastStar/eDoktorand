class FinalExamTerm < ExamTerm
  
  belongs_to :index
  validates_presence_of :index_id, :message => I18n::t(:message_0, :scope => [:txt, :model, :term])
  I18n::t(:message_1, :scope => [:txt, :model, :term])

  # returns formated date time
  def date_time
    "%s %s" % [date.strftime("%d. %m. %Y"), start_time]
  end

  # finds final exam terms for given user
  def self.find_for(user, options = {})
    # TODO redo with only ids of indices
    indices = Index.find_for(user)
    if options.delete :not_passed
      indices.reject! {|i| i.status == t(:message_2, :scope => [:txt, :model, :term])}
    end
    options[:conditions] = ['index_id in (?)', indices]
    if options.delete :future
      options[:conditions].first << ' and date >= ? and indices.final_exam_invitation_sent_at is not null'
      options[:conditions] << Date.today
    end
    options[:include] = :index
    options[:order] = 'date desc'
    final_exams = find(:all, options)
    return final_exams
  end
end

