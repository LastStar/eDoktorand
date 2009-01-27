module DefensesHelper
  def create_form(&proc)
    form_remote_tag(:url => {:action => 'create'},
                    :complete => evaluate_remote_response,
                    :loading => "$('submit-button').value = '%s'" % t(:message_0, :scope => [:txt, :helper, :defenses]),
                    &proc)

  end

  def send_invitation_link(user, index, mail)
    if user.has_role?('faculty_secretary') && !index.defense_invitation_sent?
      if mail == 'mail'
      link_to_remote(t(:message_1, :scope => [:txt, :helper, :defenses]), 
                     :complete => evaluate_remote_response,
                     :url => {:action => 'send_invitation', 
                              :id => index, :mail => 'mail'})
      else
      link_to_remote(t(:message_2, :scope => [:txt, :helper, :defenses]), 
                     :complete => evaluate_remote_response,
                     :url => {:action => 'send_invitation', 
                              :id => index, :mail => 'no mail'})
      end
    end
  end

  def protocol_link(term)
    link_to t(:message_3, :scope => [:txt, :helper, :defenses]), :action => :protocol, :id => term
  end

  def announcement_link(term)
    link_to t(:message_4, :scope => [:txt, :helper, :defenses]), :action => :announcement, :id => term
  end
end
