module StudyPlansHelper
  # prints select tags for obligate subject 
  def obligate_select(plan_subject)
    content_tag('select', options_for_select((1..4), plan_subject.finishing_on), { 'id' => 
      "plan_subject_#{plan_subject.id}",'name' =>
      "plan_subject[#{plan_subject.id}][finishing_on]"}) + 
    ". " + _("semester") + 
    tag('input', {'type' => 'hidden', 'value' => plan_subject.subject_id, 'id' => 
      "plan_subject_#{plan_subject.id}_subject_id", 'name' =>
      "plan_subject[#{plan_subject.id}][subject_id]"})
  end

  # prints select tags for voluntary subject
  # returns style for external div 
  def voluntary_select(subjects, plan_subject)
    select = ''
    if plan_subject.id < 0   
      subjects[0] = [_("none subject"), -1]
    end
    select << content_tag('select', options_for_select(subjects, plan_subject.subject_id),
      {'id' => "plan_subject_#{plan_subject.id}_subject_id",
      'name' => "plan_subject[#{plan_subject.id}][subject_id]",
      'onChange' => "hide_on_internal(#{plan_subject.id})"})
    select << "&mdash; "
    select << content_tag('select', options_for_select(1..4,
      plan_subject.finishing_on ), { 'id' => 
      "plan_subject_#{plan_subject.id}_finishing_on", 'name' => 
      "plan_subject[#{plan_subject.id}][finishing_on]"})
    return select
  end

  # prints select tags for voluntary subject
  # returns style for external div 
  def subject_select(subjects, plan_subject)
    select = ''
    subjects = [[_("none subject"), -1]].concat(subjects)
    subjects = [[_("external subject"), 0]].concat(subjects)
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

  # print external subject tag
  def external_subject_input(plan_subject)
    tag('input', { 'type' => 'text', 'id' =>
      "external_subject_detail_#{plan_subject.id}_label", 
      'name' => "plan_subject[#{plan_subject.id}][label]", "value" =>
       plan_subject.subject.is_a?(ExternalSubject) ?
       plan_subject.subject.label : plan_subject.subject_id == 0 ? plan_subject.subject.label : ''})
  end

  # prints external university tag
  def external_university_input(plan_subject)
    tag('input', { 'type' => 'text', 'id' =>
      "external_subject_detail_#{plan_subject.id}_university", 
      'name' => "external_subject_detail[#{plan_subject.id}][university]", 'value' =>
      plan_subject.subject.is_a?(ExternalSubject) ?
      plan_subject.subject.external_subject_detail.university : ''})
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
      (plan_subject.subject_id.id > 0 && \
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
    "&mdash;" + content_tag('select', options_for_select(1..4, 
      plan_subject.finishing_on), {'id' => 
      "plan_subject_#{plan_subject.id}_finishing_on",'name' =>
      "plan_subject[#{plan_subject.id}][finishing_on]"}) +
      ". " + _("semester")  
  end

  def study_plan_menu(student)
    links = []
    links << link_to_unless_current(_("end study"), 
                                     {:controller => 'students', 
                                      :action => 'end_study'},
                                      :confirm =>  _("Are you sure to") + 
                                      ' ' + _("end study") + '?'){} 

    if student.study_plan.approved?
      links << change_link(student)
    end
    unless student.index.interupted?
      links << link_to_unless_current(_('interupt'), :controller => 'interupts'){}
    end
    return links.join('&nbsp;')
  end

  def create_study_plan_link(student)
    link_to(_("create study plan"), {:action => 'create', :id => student}, 
      :confirm => _("Have you consulted your study plan with tutor. It is highly recomended")) 
  end

  def final_exam_link(index)
    link_to(_('final exam application'), :action => 'final_application')
  end

  def render_requisite
    render(:partial => "shared/subjects", 
           :locals => {:subjects => @session['plan_subjects'],
           :title => _("requisite subjects")})
  end

  def voluntary_link
    link_to_function(_('voluntary subjects'), "$('voluntarys').toggle()")
  end

  def change_link(student)
    link_to(_("change study plan"), {:action => 'change', 
                                     :controller => 'study_plans',
                                     :id => student})
  end
 end
