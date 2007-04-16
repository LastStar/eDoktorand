module TutorsHelper

def show_displayname(tutor)
  if tutor.title_before != nil
    before_title = tutor.title_before.label
  else
    before_title = ''
  end
  if tutor.title_after != nil
    after_title = tutor.title_after.label
  else
    after_title = ''
  end
  displayname = before_title + '&nbsp;' + tutor.lastname + '&nbsp;' + tutor.firstname + '&nbsp;' + after_title
end

def link_edit(tutor)
   link_to_remote(image_tag('change.png'),
                   :url => {:controller => 'tutors',:action => 'edit', :id => tutor.id},
                   :update => 'tutor_form_' + tutor.id.to_s)
   end

end

def name_coridor_link(tutor)
   link_edit(tutor) + show_displayname(tutor)
end
