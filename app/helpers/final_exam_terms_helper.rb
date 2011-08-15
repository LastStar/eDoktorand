module FinalExamTermsHelper
  # renders final exam terms link
  def final_exam_terms_link
    link_to t(:message_0, :scope => [:helper, :terms]), :action => :list,
      :controller => :final_exam_terms, :future => 1
  end

  def send_invitation_link(index, mail)
    if mail =='mail'
      link_to(t(:confirm_mail, :scope => [:helper, :final_exam_terms]),
                     :action => 'send_invitation', :id => index, :mail => true)
    else
      link_to(t(:confirm_no_mail, :scope => [:helper, :final_exam_terms]),
                     :action => 'send_invitation', :id => index, :mail => false)

    end
  end

  def protocol_link(term)
    link_to t(:message_17, :scope => [:helper, :terms]), :action => :protocol, :id => term
  end

  def status(term)
    if term.index.final_exam_invitation_sent?
      t(:confirmed, :scope => [:helper, :final_exam_terms])
    else
      t(:created, :scope => [:helper, :final_exam_terms])
    end
  end
end
