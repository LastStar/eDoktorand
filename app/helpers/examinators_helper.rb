module ExaminatorsHelper
  
  def edit_link(examinator)
    link_to_remote(image_tag('change.png'),{
                   :url => {:action => 'edit', :id => examinator.department_employment.id},
                   :update => dom_id(examinator)},
                   {:class => 'nobg'})
  end
  
end
