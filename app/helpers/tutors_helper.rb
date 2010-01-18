module TutorsHelper

  def edit_link(tutorship)
    link_to_remote(image_tag('change.png'),
                   {:url => {:action => 'edit', :id => tutorship.id},
                   :update => "coridor_%i" % tutorship.id},
                   {:class => 'nobg'})
  end

end

