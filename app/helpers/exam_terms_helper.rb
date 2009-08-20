module ExamTermsHelper
  def defense_terms_link
    link_to t(:message_1, :scope => [:txt, :helper, :terms]), :action => :list, 
      :controller => :defenses
  end

  def admission_exam_terms_link
    link_to t(:message_2, :scope => [:txt, :helper, :terms]), :action => :list, 
      :controller => :exam_terms
  end
end
