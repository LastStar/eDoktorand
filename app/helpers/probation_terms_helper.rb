module ProbationTermsHelper

  # prints list links
  def list_links(user)
    links = ''
    if (!user.person.is_a?(Student))
      links << link_to(t(:message_19, :scope => [:txt, :helper, :terms]), {:action => 'create'})
      links << '&nbsp;'
    end
    if params[:period] == "history"
      links << link_to(t(:message_20, :scope => [:txt, :helper, :terms]), {:period => :future})
    else
      links << link_to(t(:message_18, :scope => [:txt, :helper, :terms]), {:period => :history})
    end
    links << '&nbsp;'
    content_tag('div', links, :class => 'links')
  end

  def link(user, probation_term)
    if user.has_role?('student') 
      student = @user.person
      if ((student.has_enrolled?(probation_term.subject))) 
        if(probation_term.has_enrolled?(student)) 
          t(:message_3, :scope => [:txt, :helper, :terms]) + '&nbsp;' + 
    link_to(t(:message_4, :scope => [:txt, :helper, :terms]), {:action => 'sign_off_student', :id => probation_term,
                                      :student_id => student.id})
        else 
          t(:message_5, :scope => [:txt, :helper, :terms]) 
        end 
      elsif probation_term.date >= Date.today 
       link_to(t(:message_6, :scope => [:txt, :helper, :terms]), {:action => 'enroll', 
                             :id => probation_term.id}, 
                             :confirm => t(:message_7, :scope => [:txt, :helper, :terms])) 
      end 
    else 
      link = ''
      link << detail_link(probation_term) 
      link << '&nbsp;' 
      link << link_to(t(:message_8, :scope => [:txt, :helper, :terms]), {:action => 'edit', :id => probation_term.id})
      if probation_term.students.empty?
        link << '&nbsp;' 
        link << link_to(t(:message_9, :scope => [:txt, :helper, :terms]), {:action => 'destroy', 
                                                                         :id => probation_term.id},
                         :confirm => t(:message_10, :scope => [:txt, :helper, :terms])) 	 
      end
      link
    end 
  end

  def detail_link(pt)
    link_to_remote(t(:message_11, :scope => [:txt, :helper, :terms]), 
                   {:url => {:action => 'detail', :id => pt.id},
                   :update => "info_#{pt.id}", 
                   :loading => visual_effect(:pulsate, "link_#{pt.id}", {:duration => 2.0, :from => 0.3}),
                   :complete => "Element.show('info_#{pt.id}')"},
                   {:id => "link_#{pt.id}"})
  end

  def sign_up_link(probation_term, student)
    link_to_remote(t(:message_12, :scope => [:txt, :helper, :terms]), 
                  {:url => {:action => 'enroll_exam', 
                           :id => probation_term,
                           :student_id => student.id},
                  :complete => evaluate_remote_response,
                  :loading => "$('enroll_link').innerHTML = '%s'" % \
                                                      t(:message_13, :scope => [:txt, :helper, :terms])},
                  :id => 'enroll_link')

  end

  def signoff_link(probation_term, student)
    link_to_remote(t(:message_14, :scope => [:txt, :helper, :terms]),
                  :update => "info_#{probation_term.id}",
                  :url => {:action => 'sign_off_student', 
                           :id => probation_term,
                           :student_id => student.id})
  end

  def enroll_form(probation_term, &proc)
    form_remote_tag(:url => {:action => 'enroll_student'},
                    :update => "info_#{probation_term.id}",
                    :loading => "$('submit-button').value = '%s'" % t(:message_15, :scope => [:txt, :helper, :terms]),
                    &proc)

  end
end
