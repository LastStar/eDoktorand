class FinalExamTerm < ExamTerm
  untranslate_all
  belongs_to :index
  validates_presence_of :index_id, :message => _("Final exam term have to belong to student")


  # returns formated date time
  def date_time
    "%s %s" % [date.strftime("%d. %m. %Y"), start_time]
  end

  # finds final exam terms for given user
  def self.find_for(user, options = {})
    # TODO redo with only ids of indices
    options[:conditions] = ['index_id in (?)', Index.find_for(user)]
    if options.delete :future
      options[:conditions].first << ' and date >= ? and indices.final_exam_invitation_sent_at is not null'
      options[:conditions] << Date.today
    end
    options[:include] = :index
    options[:order] = 'date'
    find(:all, options)
  end
end

