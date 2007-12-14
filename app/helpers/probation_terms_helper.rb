module ProbationTermsHelper

  # prints list links
  def list_links(user)
    links = ''
    if (!user.person.is_a?(Student))
      links << link_to(_("new term"), {:action => 'create'})
      links << '&nbsp;'
    end
    if params[:period] == "history"
      links << link_to(_('future_terms'), {:period => :future})
    else
      links << link_to(_('history_terms'), {:period => :history})
    end
    links << '&nbsp;'
    content_tag('div', links, :class => 'links')
  end

  def link(user, probation_term)
    if user.has_role?('student') 
      student = @user.person
      if ((student.has_enrolled?(probation_term.subject))) 
        if(probation_term.has_enrolled?(student)) 
          _("You are already enrolled for this term") + '&nbsp;' + 
    link_to(_("Sign off student"), {:action => 'sign_off_student', :id => probation_term,
                                      :student_id => student.id})
        else 
          _("You are already enrolled for an exam from this subject") 
        end 
      elsif probation_term.date >= Date.today 
       link_to(_("enroll"), {:action => 'enroll', 
                             :id => probation_term.id}, 
                             :confirm => _("Really enroll to this term?")) 
      end 
    else 
      link = ''
      link << detail_link(probation_term) + '&nbsp;' +
      link_to(_("edit"), {:action => 'edit', :id => probation_term.id})
      if probation_term.students.size == 0
        link << '&nbsp;' + link_to(_("delete"), {:action => 'destroy', 
                                                 :id => probation_term.id},
                                   :confirm => _('Sure to delete?')) 	 
      end
      link
    end 
  end

  def detail_link(pt)
    link_to_remote(_("students"), 
                   {:url => {:action => 'detail', :id => pt.id},
                   :update => "info_#{pt.id}", 
                   :loading => visual_effect(:pulsate, "link_#{pt.id}", {:duration => 2.0, :from => 0.3}),
                   :complete => "Element.show('info_#{pt.id}')"},
                   {:id => "link_#{pt.id}"})
  end

  def enroll_link(probation_term, student)
    link_to_remote(_("Enroll student"), 
                  {:url => {:action => 'enroll_exam', 
                           :id => probation_term,
                           :student_id => student.id},
                  :complete => evaluate_remote_response,
                  :loading => "$('enroll_link').innerHTML = '%s'" % \
                                                      _('working...')},
                  :id => 'enroll_link')

  end

  def signoff_link(probation_term, student)
    link_to_remote(_("Sign off student"),
                  :update => "info_#{probation_term.id}",
                  :url => {:action => 'sign_off_student', 
                           :id => probation_term,
                           :student_id => student.id})
  end

  def enroll_form(probation_term, &proc)
    form_remote_tag(:url => {:action => 'enroll_student'},
                    :update => "info_#{probation_term.id}",
                    :loading => "$('submit-button').value = '%s'" % _('working...'),
                    &proc)

  end

  def save_details_form(&proc)
    form_remote_tag(:url => {:action => 'save_probation_term_details'},
                    :loading => "$('submit-button').value = '%s'" % _('working...'),
                    :complete => evaluate_remote_response,
                    &proc)

  end

  def term_date_select
    date_select :probation_term, :date,
                :start_year => 2005,
                :order => [:day, :month, :year],
                :use_month_numbers => true
  end
end
