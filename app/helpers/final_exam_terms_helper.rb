module FinalExamTermsHelper
  # renders final exam terms link
    def final_exam_terms_link
    link_to t(:message_0, :scope => [:txt, :helper, :terms]), :action => :list, 
      :controller => :final_exam_terms, :future => 1
  end
  
  def send_invitation_link(user, index, mail)
    if user.has_role?('faculty_secretary') && !index.final_exam_invitation_sent?
      if mail =='mail'
      link_to_remote(t(:message_0, :scope => [:txt, :helper, :terms]), 
                     :complete => evaluate_remote_response,
                     :url => {:action => 'send_invitation', 
                              :id => index, :mail => 'mail'})
      else
            link_to_remote(t(:message_1, :scope => [:txt, :helper, :terms]), 
                     :complete => evaluate_remote_response,
                     :url => {:action => 'send_invitation', 
                              :id => index, :mail => 'no mail'})

      end
    end
  end

  def protocol_link(term)
    link_to t(:message_17, :scope => [:txt, :helper, :terms]), :action => :protocol, :id => term
  end

  def create_form(&proc)
    form_remote_tag(:url => {:action => 'create'},
                    :complete => evaluate_remote_response,
                    :loading => "$('submit-button').value = '%s'" % t(:message_3, :scope => [:txt, :helper, :terms]),
                    &proc)

  end
end
