module FinalExamTermsHelper
  def send_invitation_link(user, index, mail)
    if user.has_role?('faculty_secretary') && !index.final_exam_invitation_sent?
      if mail =='mail'
      link_to_remote(_('send email'), 
                     :complete => evaluate_remote_response,
                     :url => {:action => 'send_invitation', 
                              :id => index, :mail => 'mail'})
      else
            link_to_remote(_('accept without mail'), 
                     :complete => evaluate_remote_response,
                     :url => {:action => 'send_invitation', 
                              :id => index, :mail => 'no mail'})

      end
    end
  end

  def protocol_link(term)
    link_to _('protocol'), :action => :protocol, :id => term
  end

  def create_form(&proc)
    form_remote_tag(:url => {:action => 'create'},
                    :complete => evaluate_remote_response,
                    :loading => "$('submit-button').value = '%s'" % _('working...'),
                    &proc)

  end
end
