module ExamsHelper
  # prints list links
  def list_links
    links = ''
    links << link_to(_("new exam"), {:action => 'create'})
    links << '&nbsp;'
    if params[:prefix]
      links << link_to(_("list"), {:prefix => nil})
    else
      links << link_to(_("table"), {:prefix => 'table_'})
    end
    links << '&nbsp;'
    if session[:this_year]
      links << link_to(_('all exams (slow)'), {:this_year => 0})
    else
      links << link_to(_('this year only'), {:this_year => 1})
    end
    links << '&nbsp;'
    content_tag('div', links, :class => 'links')
  end

  # returns result
  def result_word(id)
    [_('not pass'), _('pass')][id]
  end

  # prints link to exam detail
  def detail_link(exam)
      link_to_remote(_("detail"), :url => {:action => 'detail',
        :id => exam.id}, :complete => evaluate_remote_response,
                    :loading => visual_effect(:pulsate, "detail_link_%i" % exam.id))
  end

  #prints form for saving external exam student
  def external_student_form(&proc)
    form_remote_tag(:url => {:action => 'save_external_student'},
                    :update => 'form',
                    :loading => "$('submit-button').value = '%s'" % _('working...'),
                    &proc)
  end

  #prints form for saving external exam subject
  def external_subject_form(&proc)
    form_remote_tag(:url => {:action => 'save_external_subject'},
                    :update => 'form',
                    :loading => "$('submit-button').value = '%s'" % _('working...'),
                    &proc)

  end

  def subject_form(&proc)
    form_remote_tag(:url => {:action => 'save_subject'}, 
                    :complete => evaluate_remote_response,
                    :loading => "$('submit-button').value = '%s'" % _('working...'),
                    &proc)

  end

  def student_subject_form(&proc)
    form_remote_tag(:url => {:action => 'save_student_subject'},
                    :complete => evaluate_remote_response,
                    :loading => "$('submit-button').value = '%s'" % _('working...'),
                    &proc)


  end
end
