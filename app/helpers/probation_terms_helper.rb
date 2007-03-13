module ProbationTermsHelper

  # prints list links
	def list_links(user)
	  links = ''
    if (!user.person.is_a?(Student))
	    links << link_to(_("new term"), {:action => 'create'})
	    links << '&nbsp;'
    end
    if params[:period] == "history"
      links << link_to(_('future_terms'), {:period => :future})
    else
      links << link_to(_('history_terms'), {:period => :history})
    end
    links << '&nbsp;'
	  links << print_link(_('print this list'))
	  content_tag('div', links, :class => 'links')
	end

  def link(user, probation_term)
       if user.has_role?('student') 
         student = @user.person
         if ((student.has_enrolled?(probation_term.subject))) 
           if(probation_term.has_enrolled?(student)) 
             _("You are already enrolled for this term") + '&nbsp;' + 
	     link_to(_("Sign off student"), {:action => 'sign_off_student', :id => probation_term,
                                         :student_id => student.id})
           else 
             _("You are already enrolled for an exam from this subject") 
           end 
         else 
          link_to(_("enroll"), {:action => 'enroll', 
                                :id => probation_term.id}, 
                                :confirm => _("Really enroll to this term?")) 
         end 
       else 
         link = ''
         link << detail_link(probation_term) + '&nbsp;' +
         link_to(_("edit"), {:action => 'edit', :id => probation_term.id})
         if probation_term.students.size == 0
           link << '&nbsp;' + link_to(_("delete"), {:action => 'destroy', :id => probation_term.id}) 	 
	 end
	 link
      end 
  end

  def detail_link(pt)
    link_to_remote_with_loading(_("students"), 
                               :url => {:action => 'detail', 
                                        :id => pt.id}, 
                               :update => "info_#{pt.id}", 
                               :complete => "Element.show('info_#{pt.id}')")
  end

  def enroll_link(probation_term, student)
    link_to_remote_with_loading(_("Enroll student"), :evaluate => true,
                                :url => {:action => 'enroll_exam', 
                                         :id => probation_term,
                                         :student_id => student.id})

  end

  def signoff_link(probation_term, student)
    link_to_remote_with_loading(_("Sign off student"), :update => "info_#{probation_term.id}",
                                :url => {:action => 'sign_off_student', 
                                         :id => probation_term,
                                         :student_id => student.id})
  end
end
