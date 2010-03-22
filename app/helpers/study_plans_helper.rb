module StudyPlansHelper
  # prints select tags for obligate subject 
  def obligate_select(plan_subject)
    content_tag('select', options_for_select((1..(@student.specialization.study_length*2-2)), plan_subject.finishing_on), { 'id' => 
      "plan_subject_#{plan_subject.id}",'name' =>
      "plan_subject[#{plan_subject.id}][finishing_on]"}) + 
    ". " + t(:message_0, :scope => [:txt, :helper, :plans]) + 
    tag('input', {'type' => 'hidden', 'value' => plan_subject.subject_id, 'id' => 
      "plan_subject_#{plan_subject.id}_subject_id", 'name' =>
      "plan_subject[#{plan_subject.id}][subject_id]"})
  end

  def seminar_select(subjects, plan_subject)
    result = ''
    result << content_tag('select', 
      options_for_select(subjects, plan_subject.subject_id),
      {'id' => "plan_subject_#{plan_subject.id}_subject_id",
      'name' => "plan_subject[#{plan_subject.id}][subject_id]"})
    result << "&mdash; "
    result << content_tag('select', options_for_select(1..(@student.specialization.study_length*2-2),
      plan_subject.finishing_on ), { 'id' => 
      "plan_subject_#{plan_subject.id}_finishing_on", 'name' => 
      "plan_subject[#{plan_subject.id}][finishing_on]"})
    return result
  end

  # prints select tags for voluntary subject
  # returns style for external div 
  def voluntary_select(subjects, plan_subject)
    select = ''
    if plan_subject.id && plan_subject.id < 0
      subjects[0] = [t(:message_1, :scope => [:txt, :helper, :plans]), -1]
    end
    select << content_tag('select', options_for_select(subjects, plan_subject.subject_id),
      {'id' => "plan_subject_#{plan_subject.id}_subject_id",
      'name' => "plan_subject[#{plan_subject.id}][subject_id]",
      'onChange' => "hide_on_internal(#{plan_subject.id})"})
    select << "&mdash; "
    select << content_tag('select', options_for_select(1..(@student.specialization.study_length*2-2),
      plan_subject.finishing_on ), { 'id' => 
      "plan_subject_#{plan_subject.id}_finishing_on", 'name' => 
      "plan_subject[#{plan_subject.id}][finishing_on]"})
    return select
  end

  # prints select tags for voluntary subject
  # returns style for external div 
  def subject_select(subjects, plan_subject)
    select = ''
    subjects = [[t(:message_2, :scope => [:txt, :helper, :plans]), -1]].concat(subjects)
    subjects = [[t(:message_3, :scope => [:txt, :helper, :plans]), 0]].concat(subjects)
    plan_subject.subject_id = 0 if plan_subject.subject.is_a?(ExternalSubject)
    select << content_tag('select', options_for_select(subjects, plan_subject.subject_id),
      {'id' => "plan_subject_#{plan_subject.id}_subject_id",
      'name' => "plan_subject[#{plan_subject.id}][subject_id]",
      'onChange' => "hide_on_internal(#{plan_subject.id}); return(false);"})
    select << "&mdash; "
    select << content_tag('select', options_for_select(1..5,
      plan_subject.finishing_on ), { 'id' => 
      "plan_subject_#{plan_subject.id}_finishing_on", 'name' => 
      "plan_subject[#{plan_subject.id}][finishing_on]"})
    return select
  end

  def empty_subject_select(subjects)
    select = ''
    subjects = [[t(:message_4, :scope => [:txt, :helper, :plans]), -1]].concat(subjects)
    subjects = [[t(:message_5, :scope => [:txt, :helper, :plans]), 0]].concat(subjects)
    #plan_subject.subject_id = 0 if plan_subject.subject.is_a?(ExternalSubject)
    select << content_tag('select', options_for_select(subjects, -1),
      {'id' => "plan_subject_new_subject_id",
      'name' => "plan_subject[-1][subject_id]",
      'onChange' => "hide_new_internal(); return(false);"})
    select << "&mdash; "
    select << content_tag('select', options_for_select(1..5,
      1), { 'id' => 
      "plan_subject_new_finishing_on", 'name' => 
      "plan_subject[-1][finishing_on]"})
    return select
  end
  
  def input_external_empty(value)
    tag('input', { 'type' => 'text', 'id' =>
      "external_subject_detail_-1_"+value, 
      'name' => "plan_subject[-1]["+value+"]"})
  end
  
  def input_external_empty_detail(value)
        tag('input', { 'type' => 'text', 'id' =>
      "external_subject_detail_-1_"+value, 
      'name' => "external_subject_detail[-1]["+value+"]"
        })
  end

  # print external subject tag
  def external_subject_input(plan_subject)
     value = if plan_subject.subject.is_a?(ExternalSubject) || plan_subject.subject_id == 0 
               plan_subject.subject[:label]
             else 
               ''
             end
    tag('input', { 'type' => 'text', 'id' =>
      "external_subject_detail_#{plan_subject.id}_label", 
      'name' => "plan_subject[#{plan_subject.id}][label]", "value" => value})
  end

  # prints external university tag
  def external_university_input(plan_subject)
    tag('input', { 'type' => 'text', 'id' =>
      "external_subject_detail_#{plan_subject.id}_university", 
      'name' => "external_subject_detail[#{plan_subject.id}][university]", 'value' =>
      plan_subject.subject.is_a?(ExternalSubject) ?
      plan_subject.subject.external_subject_detail.university : ''})
  end
  
  def external_subject_en_input(plan_subject)
    tag('input', { 'type' => 'text', 'id' =>
      "external_subject_detail_#{plan_subject.id}_label_en", 
      'name' => "plan_subject[#{plan_subject.id}][label_en]", "value" =>
       plan_subject.subject.is_a?(ExternalSubject) ?
       plan_subject.subject.label_en : plan_subject.subject_id == 0 ? plan_subject.subject.label_en : ''})
  end
  # prints external person tag
  def external_person_input(plan_subject)
    tag('input', 
       {:type => 'text', 
        :id => "external_subject_detail_#{plan_subject.id}_person", 
        :name => "external_subject_detail[#{plan_subject.id}][person]",
        :value => plan_subject.subject.is_a?(ExternalSubject) ?
          plan_subject.subject.external_subject_detail.person : ''})  
  end

  # return style for hiding external div
  def hide_style(plan_subject)
    if plan_subject.id == 0 || plan_subject.subject_id == -1 || \
      (plan_subject.subject_id > 0 && \
       !plan_subject.subject.is_a?(ExternalSubject))
      'display: none'  
    end
  end

  # prints select tags for language subject
  def language_select(plan_subject, subjects)
    content_tag('select', options_for_select(subjects,
      plan_subject.subject_id), {'id' => 
      "plan_subject_#{plan_subject.id}_subject_id",'name' =>
      "plan_subject[#{plan_subject.id}][subject_id]"}) + 
    "&mdash;" + content_tag('select', options_for_select(1..(@student.specialization.study_length*2-2), 
      plan_subject.finishing_on), {'id' => 
      "plan_subject_#{plan_subject.id}_finishing_on",'name' =>
      "plan_subject[#{plan_subject.id}][finishing_on]"}) +
      ". " + t(:message_6, :scope => [:txt, :helper, :plans])  
  end

  def study_plan_menu(student)
    links = []
    links << link_to_unless_current(t(:message_7, :scope => [:txt, :helper, :plans]), 
                                     {:controller => 'students', 
                                      :action => 'end_study'},
                                      :confirm =>  t(:message_8, :scope => [:txt, :helper, :plans]) + 
                                      ' ' + t(:message_9, :scope => [:txt, :helper, :plans]) + '?'){} 

    links << link_to_unless_current(t(:message_10, :scope => [:txt, :helper, :plans]),
                                     {:controller => 'students',
                                      :action => 'change_tutor'},
                                      :confirm => t(:message_11, :scope => [:txt, :helper, :plans]) + 
                                      ' ' + t(:message_12, :scope => [:txt, :helper, :plans]) + '?'){}
    if student.study_plan.approved? || student.study_plan.canceled?
      links << change_link(student)
    end
    unless student.index.interrupted?
      links << link_to_unless_current(t(:message_13, :scope => [:txt, :helper, :plans]), :controller => 'interrupts'){}
    end
    return links.join('&nbsp;')
  end

  def create_study_plan_link(student)
    link_to(t(:message_14, :scope => [:txt, :helper, :plans]), {:action => 'create', :id => student}, 
      :confirm => t(:message_15, :scope => [:txt, :helper, :plans])) 
  end

#  def final_exam_link(index)
#    link_to(t(:message_16, :scope => [:txt, :helper, :plans]), :action => 'final_application')
#  end

  def render_requisite
    render(:partial => "shared/subjects", 
           :locals => {:subjects => session[:requisite_subjects],
           :title => t(:message_17, :scope => [:txt, :helper, :plans])})
  end

  def voluntary_link
    link_to_function(t(:message_18, :scope => [:txt, :helper, :plans]), "$('voluntarys').toggle()")
  end

  def change_link(student)
    unless student.index.claimed_for_final_exam?
      link_to(t(:message_19, :scope => [:txt, :helper, :plans]), {:action => 'change', 
                                       :controller => 'study_plans',
                                       :id => student})
    end
  end

  def return_to_link
    link_to_remote("<<< " + t(:message_20, :scope => [:txt, :helper, :plans]), 
                    {:url => {:action => "edit_create", :type => @return_to}, 
                    :complete => evaluate_remote_response}, 
                    {:class => 'details_link'})
  end
end
