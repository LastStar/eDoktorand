module DefensesHelper
  def create_form(&proc)
    form_remote_tag(:url => {:action => 'create'},
                    :complete => evaluate_remote_response,
                    :loading => "$('submit-button').value = '%s'" % _('working...'),
                    &proc)

  end

  def send_invitation_link(user, index)
    if user.has_role?('faculty_secretary') && !index.defense_invitation_sent?
      link_to_remote(_('send email'), 
                     :complete => evaluate_remote_response,
                     :url => {:action => 'send_invitation', 
                              :id => index})
    end
  end

  def protocol_link(term)
    link_to _('protocol'), :action => :protocol, :id => term
  end

  def announcement_link(term)
    link_to _('announcement'), :action => :announcement, :id => term
  end
end
