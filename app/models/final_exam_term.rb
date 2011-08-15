class FinalExamTerm < ExamTerm

  belongs_to :index
  validates_presence_of :index_id, :message => I18n::t(:wrong_time_format, :scope => [:model, :term])

  # returns formated date time
  def date_time
    "%s %s" % [date.strftime("%d. %m. %Y"), start_time]
  end

  # finds final exam terms for given user
  def self.find_for(user, options = {})
    # TODO redo with only ids of indices
    indices = Index.find_for(user, :not_absolved => true)
    if options.delete :not_passed
      indices.reject! {|i|
        i.status == I18n::t(:passed_sdz_l, :scope => [:model, :index]) ||
        i.status == I18n::t(:absolved_l, :scope => [:model, :index]) ||
        i.status == I18n::t(:finished_l, :scope => [:model, :index])
      }
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
