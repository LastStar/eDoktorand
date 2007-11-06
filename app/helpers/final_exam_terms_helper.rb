module FinalExamTermsHelper
  def send_invitation_link(user, index)
    if user.has_role?('faculty_secretary') && !index.final_exam_invitation_sent?
      link_to_remote(_('send email'), 
                     :complete => evaluate_remote_response,
                     :url => {:action => 'send_invitation', 
                              :id => index})
    end
  end

  def protocol_link(term)
    link_to _('protocol'), :action => :protocol, :id => term
  end
end
