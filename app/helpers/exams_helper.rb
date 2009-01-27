module ExamsHelper
  # prints list links
  def list_links
    links = ''
    links << link_to(t(:message_0, :scope => [:txt, :helper, :exams]), {:action => 'create'})
    links << '&nbsp;'
    if session[:this_year]
      links << link_to(t(:message_1, :scope => [:txt, :helper, :exams]), {:this_year => 0})
    else
      links << link_to(t(:message_2, :scope => [:txt, :helper, :exams]), {:this_year => 1})
    end
    links << '&nbsp;'
    content_tag('div', links, :class => 'links')
  end

  # returns result
  def result_word(id)
    [t(:message_3, :scope => [:txt, :helper, :exams]), t(:message_4, :scope => [:txt, :helper, :exams])][id]
  end

  # prints link to exam detail
  def detail_link(exam)
      link_to_remote(t(:message_5, :scope => [:txt, :helper, :exams]), :url => {:action => 'detail',
        :id => exam.id}, :complete => evaluate_remote_response,
                    :loading => visual_effect(:pulsate, "detail_link_%i" % exam.id))
  end

  #prints form for saving external exam student
  def external_student_form(&proc)
    form_remote_tag(:url => {:action => 'save_external_student'},
                    :update => 'form',
                    :loading => "$('submit-button').value = '%s'" % t(:message_6, :scope => [:txt, :helper, :exams]),
                    &proc)
  end

  #prints form for saving external exam subject
  def external_subject_form(&proc)
    form_remote_tag(:url => {:action => 'save_external_subject'},
                    :update => 'form',
                    :loading => "$('submit-button').value = '%s'" % t(:message_7, :scope => [:txt, :helper, :exams]),
                    &proc)

  end

  #prints form for choosinf subject
  def subject_form(&proc)
    form_remote_tag(:url => {:action => 'save_subject'}, 
                    :complete => evaluate_remote_response,
                    :loading => "$('submit-button').value = '%s'" % t(:message_8, :scope => [:txt, :helper, :exams]),
                    &proc)

  end

  def student_subject_form(&proc)
    form_remote_tag(:url => {:action => 'save_student_subject'},
                    :complete => evaluate_remote_response,
                    :loading => "$('submit-button').value = '%s'" % t(:message_9, :scope => [:txt, :helper, :exams]),
                    &proc)


  end

  # prints link for creating exam by subject
  def subject_exam_link
    link_to_remote(t(:message_10, :scope => [:txt, :helper, :exams]),
                  :url => {:action => 'by_subject'},
                  :update => 'form',
                  :loading => visual_effect(:pulsate, "by_exam_line"))
  end

  def external_exam_link
    link_to_remote(t(:message_11, :scope => [:txt, :helper, :exams]),
                  :url => {:action => 'external'},
                  :update => 'form',
                  :loading => visual_effect(:pulsate, "external_line"))
  end
end
