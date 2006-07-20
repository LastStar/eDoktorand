module FinalExamTermsHelper
  def send_invitation_link(user, index)
    if user.has_role?('faculty_secretary') && !index.final_exam_invitation_sent?
      link_to_remote(_('send email'), 
                     :update => 'mail_link',
                     :url => {:action => 'send_invitation', 
                              :id => index})
    end
  end
end
