class FinalExamTerm < ExamTerm

  belongs_to :index
  validates_presence_of :index_id, :message => I18n::t(:wrong_time_format, :scope => [:model, :term])

  # returns formated date time
  def date_time
    "%s %s" % [date.strftime("%d. %m. %Y"), start_time]
  end

  # Public: sets that final exam has not been passed
  #
  def not_passed!(date)
    self.update_attribute(:not_passed_on, date)
  end

  # finds final exam terms for given user
  def self.find_for(user, options = {})
    # TODO redo with only ids of indices
    indices = Index.find_for(user, :not_absolved => true, :unfinished => true)
    if options.delete :not_passed
      indices.reject! {|i|
        i.final_exam_passed?
      }
    end
    options[:conditions] = ['index_id in (?) and not_passed_on is null', indices.map(&:id)]

    if options.delete :future
      options[:conditions].first << ' and date >= ? and indices.final_exam_invitation_sent_at is not null'
      options[:conditions] << Date.today
    end
    options[:include] = :index
    options[:order] = 'date asc'
    final_exams = find(:all, options)
    return final_exams
  end
end
