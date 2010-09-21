module ExamTermsHelper
  def defense_terms_link
    link_to t(:message_1, :scope => [:txt, :helper, :terms]), :action => :list, 
      :controller => :defenses
  end
end
