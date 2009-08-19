module DocumentsHelper
  #prints links
  def link_employer
    links =[]
    links << link_to_unless_current(t(:message_2, :scope => [:txt, :view, :documents, :diploma_supplement, :rhtml]), :action => :diploma_supplement, :id => @diploma_supplement.id){}
    links << link_to_unless_current(t(:message_1, :scope => [:txt, :view, :documents, :diploma_supplement, :rhtml]), :action => :diploma_supplement_for_employer, :id => @diploma_supplement.id){}
    links << link_to("PDF", {:action => :diploma_supplement, :format => 'pdf'}, :class => "pdf_link") 
  end
end
