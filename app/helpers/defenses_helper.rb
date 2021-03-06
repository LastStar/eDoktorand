module DefensesHelper
  def send_invitation_link(index, mail)
    if mail == 'mail'
    link_to(t(:message_1, :scope => [:helper, :defenses]),
           :action => 'send_invitation', :id => index, :mail => 'mail')
    else
    link_to(t(:message_2, :scope => [:helper, :defenses]),
           :action => 'send_invitation', :id => index, :mail => 'no mail')
    end
  end

  def protocol_link(term)
    link_to t(:protocol, :scope => [:helper, :defenses]), :action => :protocol, :id => term
  end

  def announcement_link(term)
    link_to t(:message_4, :scope => [:helper, :defenses]), :action => :announcement, :id => term
  end

  def status(term)
    if term.index.defense_invitation_sent?
      t(:confirmed, :scope => [:helper, :defenses])
    else
      t(:created, :scope => [:helper, :defenses])
    end
  end
end
