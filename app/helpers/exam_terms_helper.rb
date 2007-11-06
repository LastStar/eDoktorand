module ExamTermsHelper
  def final_exam_terms_link
    link_to _('final exam terms'), :action => :list, 
      :controller => :final_exam_terms
  end

  def admission_exam_terms_link
    link_to _('admission exam terms'), :action => :list, 
      :controller => :exam_terms
  end
end
