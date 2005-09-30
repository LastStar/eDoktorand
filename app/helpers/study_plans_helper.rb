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
    if plan_subject.id == 0   
      subjects = [[_("none subject"), -1 ]].concat(subjects)  
    end
    content_tag('select', options_for_select(subjects, plan_subject.subject_id),
      {'id' => "plan_subject_#{plan_subject.id}_subject_id",
      'name' => "plan_subject[#{plan_subject.id}][subject_id]",
      'onChange' => "hide_on_internal(#{plan_subject.id})"}) +
    "&mdash; " + content_tag('select', options_for_select(1..4,
      plan_subject.finishing_on ), { 'id' => 
      "plan_subject_#{plan_subject.id}_finishing_on", 'name' => 
      "plan_subject[#{plan_subject.id}][finishing_on]"})
  end
  # print external subject tag
  def external_subject_input(plan_subject)
    tag('input', { 'type' => 'text', 'id' =>
    "external_subject_detail_#{plan_subject.id}_label", 
    'name' => "plan_subject[#{plan_subject.id}][label]", "value" =>
     plan_subject.subject.is_a?(ExternalSubject) ? plan_subject.subject.label : ''})
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
    tag('input', { 'type' => 'text', 'id' =>
      "external_subject_detail_#{plan_subject.id}_person", 
      'name' => "external_subject_detail[#{plan_subject.id}][person]", 'value' =>
      plan_subject.subject.is_a?(ExternalSubject) ?
      plan_subject.subject.external_subject_detail.person : ''})  
  end
  # return style for hiding external div
  def hide_style(plan_subject)
    'display: none' if plan_subject.id == 0 
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
 end
