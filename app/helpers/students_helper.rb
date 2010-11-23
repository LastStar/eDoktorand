module StudentsHelper

  def admin_edit_mail_link(index)
    link_to_remote(image_tag('change.png'),
                   :url => {:action => 'admin_edit_mail', :id => index.id},
                   :update => "index_%i" % index.id)
  end

  # prints action links on student
  def student_action_links(index)
    links = []
    study_plan = index.study_plan 
    if @user.has_one_of_roles?(['dean', 'faculty_secretary'])
      if index.absolved?
        links << diploma_supplement_link(index)
      else
        links << finish_link(index)
        unless index.finished?
          links << switch_link(index)
          if index.waits_for_scholarship_confirmation?
            links << approve_scholarship_link(index)
            links << cancel_scholarship_link(index)
          end
          if study_plan
            if study_plan.all_subjects_finished?
              if index.final_exam_passed?
                links << pass_link(:defense, index)
              else
                links << change_link(index.student)
                links << pass_link(:final_exam, index)
              end
            else
              links << change_link(index.student)
            end
          else
            links << create_link(index)
          end
          if index.not_even_admited_interrupt?
            links << interrupt_link(index)
          elsif index.interrupt_waits_for_confirmation?
            links << confirm_interrupt_link(index) 
          elsif index.interrupted?
            links << end_interrupt_link(index)
          end
        end
      end
    end
    return  links
  end
      
  #prints link to function witch show student line menu
  def link_to_show_actions(index)
    link_to_function('&uarr; ' + t(:message_1, :scope => [:txt, :helper, :students]),
      update_page do |page|
        page.show "index_menu_#{index.id}_tr"
        page.show "index_form_#{index.id}_tr"
        page.show "hide_action_#{index.id}"
        page.hide "show_action_#{index.id}"
        page["index_line_#{index.id}"].addClassName('selected')
        page["index_line_#{index.id}"].addClassName('once-selected')
      end, :id => "show_action_#{index.id}")
  end
      
  #prints link to function witch hide student line menu
  def link_to_hide_actions(index)
    link_to_function('&darr; ' + t(:message_2, :scope => [:txt, :helper, :students]),
      update_page do |page|
        page.hide "index_menu_#{index.id}_tr"
        page.hide "index_form_#{index.id}_tr"
        page.hide "hide_action_#{index.id}"
        page.show "show_action_#{index.id}"
        page["index_line_#{index.id}"].removeClassName('selected')
      end,
      :id => "hide_action_#{index.id}",
      :style => 'display: none')
  end

  # prints students scholarship
  def print_scholarship(index)
    ScholarshipCalculator.scholarship_for(index.student)
  end

  # prints finish link
  def finish_link(index)
    if index.finished? 
      link_to_remote(t(:message_3, :scope => [:txt, :helper, :students]),
                    :url => {:action => 'unfinish', :controller => 'students',
                    :id => index, :day => true}, :complete => evaluate_remote_response)
    else 
      link_to_remote(t(:message_4, :scope => [:txt, :helper, :students]), 
                    :url => {:action => 'time_form', :controller => 'students',
                    :form_action => 'finish', :id => index, :day => true}, 
                    :update => "index_form_#{index.id}")
    end
  end
 
  # prints link to switch study form
  def switch_link(index)
    link_to_remote(t(:message_5, :scope => [:txt, :helper, :students]),
                  :url => {:action => 'time_form',
                          :controller => 'students',
                          :form_action => 'switch_study',
                          :id => index},
                  :update => "index_form_#{index.id}")
  end

  # prints interrupt link
  def interrupt_link(index)
    link_to(t(:message_6, :scope => [:txt, :helper, :students]),
            {:action => 'index', 
            :controller => 'study_interrupts',
            :id => index})
  end

  # prints confirm interrupt link
  def confirm_interrupt_link(index)
    link_to_remote(t(:message_7, :scope => [:txt, :helper, :students]),
                   :url => {:action => 'time_form',
                           :controller => 'students',
                           :form_action => 'confirm',
                           :form_controller => 'study_interrupts',
                           :id => index,
                           :date => index.interrupt.start_on},
                   :update => "index_form_#{index.id}")
  end

  # prints end interrupt link
  def end_interrupt_link(index)
    link_to_remote(t(:message_8, :scope => [:txt, :helper, :students]),
                   :url => {:action => 'time_form',
                           :controller => 'students',
                           :form_action => 'end',
                           :form_controller => 'study_interrupts',
                           :id => index,
                           :date => index.interrupt.end_on},
                   :update => "index_form_#{index.id}")
  end

  # prints link to create new study plan
  def create_link(index)
    link_to(t(:message_9, :scope => [:txt, :helper, :students]),
            :action => 'create_by_other',
            :controller => 'study_plans',
            :id => index.student)
  end

  # prints link to create final exam term
  def final_exam_link(index)
    link_to_remote(t(:message_10, :scope => [:txt, :helper, :students]),
                   :url => {:action => 'new',
                           :controller => 'final_exam_terms',
                           :id => index},
                   :complete => evaluate_remote_response)
  end

  # prints lint to interrupt study
  def confirm_interupt_link(index)
    link_to_remote(t(:message_11, :scope => [:txt, :helper, :students]),
                   {:url => {:action => 'confirm',
                             :controller => 'study_interrupts',
                             :id => index},
                   :complete => evaluate_remote_response})
  end

  # prints link to approve scholarship
  def approve_scholarship_link(index)
    link_to_remote(t(:message_12, :scope => [:txt, :helper, :students]),
                  :url => {:controller => 'students',
                          :action => 'approve_scholarship_claim',
                          :id => index},
                  :complete => evaluate_remote_response)
  end

  # prints link to cancel scholarship
  def cancel_scholarship_link(index)
    link_to_remote(t(:message_13, :scope => [:txt, :helper, :students]),
                  :url => {:controller => 'students',
                          :action => 'cancel_scholarship_claim',
                          :id => index},
                  :complete => evaluate_remote_response)
  end

  # returns link for details fiter 
  def detail_filter_link
    link_to_function(t(:message_14, :scope => [:txt, :helper, :students]),
                     "$('detail_info').toggle(); $('detail_search').toggle()",
                     :class => 'legend_link') 
  end

  # TODO move logic to model. Here only printing
  # TODO rename to index_tags
  def student_exception(index)
    tags = []
    if index.final_exam_passed?
      if index.defense_claimed?
        tags <<  "<span title='" + t(:message_25, :scope => [:txt, :helper, :students]) + "'>po</span>"
      elsif index.defense_invitation_sent?
        tags << "<span title='" + t(:message_17, :scope => [:txt, :helper, :students]) + "'>so</span>"
      end
    else
      unless index.absolved? || index.finished?
        if index.close_to_interrupt_end_or_after?
          tags << "<span title='" + t(:message_20, :scope => [:txt, :helper, :students]) + "'>!</span>"
        end
        if index.waits_for_scholarship_confirmation?
          tags << "<span title='" + t(:sholarship_claimed, :scope => [:txt, :helper, :students]) + "'>us</span>"
        elsif index.scholarship_approved?
          tags << "<span title='" + t(:sholarship_approved, :scope => [:txt, :helper, :students]) + "'>uss</span>"
        elsif index.scholarship_canceled?
          tags << "<span title='" + t(:sholarship_canceled, :scope => [:txt, :helper, :students]) + "'>usn</span>"
        end
        #TODO create method for SDZ and fix this
        unless index.status == t(:message_22, :scope => [:txt, :helper, :students]) || index.final_exam_passed?
          if index.claimed_for_final_exam? 
            tags << "<span title='" + t(:message_23, :scope => [:txt, :helper, :students]) + "'>sz</span>"
          elsif index.claimed_final_application? && !index.claimed_for_final_exam?
            tags << "<span title='" + t(:message_24, :scope => [:txt, :helper, :students]) + "'>pz</span>"
          end
        end
        if index.defense_claimed?
          tags << "<span title=" + t(:message_25, :scope => [:txt, :helper, :students]) + "> po </span>"
        end
      end
      if tags.size > 1
        tags.join('&nbsp;') 
      else
        tags.first
      end
    end
  end

  # prints link to student detail
  def student_link(index)
    link_to_remote(index.student.display_name,
                    :url => {:action => 'show',
                            :controller => 'students',
                            :id => index}, 
                    :loading => visual_effect(:pulsate, "index_line_#{index.id}"))
  end

  def pass_link(what, index)
    action = 'pass_' + what.to_s
    url = {:action => 'time_form', :controller => 'students',
           :form_action => action, :id => index, :day => true}
    sentence = ""
    if what.to_s == "final_exam"
      sentence = t(:message_15, :scope => [:txt, :helper, :students])
    elsif what.to_s == "defense"
      sentence = t(:message_26, :scope => [:txt, :helper, :students])
    else
      sentence = what.to_s
    end
    link_to_remote(sentence,
                   :update => "index_form_#{index.id}",
                   :url => url)
  end

  # prints select for departments
  def department_select(options = {:include_empty => true})
    ops = Department.find(:user => @user).map {|d| [d.name, d.id]}
    ops = [['-- ' + t(:message_27, :scope => [:txt, :helper, :students]) + ' --', '0']].concat(ops) if options[:include_empty]
    content_tag('select', options_for_select(ops),
                {:id => "department-srch", :name => "department"})
  end

  # prints select for specialization
  def specialization_select(options = {:include_empty => true})
    ops = Specialization.find(:user => @user).map {|c| [c.name, c.id]}
    ops = [['-- ' + t(:message_28, :scope => [:txt, :helper, :students]) + ' --', '0']].concat(ops) if options[:include_empty]
    content_tag('select', options_for_select(ops),
                {:id => "specialization-srch", :name => "specialization"})
  end

  # prints select for faculty
  def faculty_select(options = {:include_empty => true})
    ops = Faculty.find(:all).map {|f| [f.name, f.id]}
    ops = [['---', '0']].concat(ops) if options[:include_empty]
    content_tag('select', options_for_select(ops),
                {'id' => "faculty-srch", 'name' => "faculty"})
  end

  # prints select for statuses
  def status_select(options = {})
    ops = [['-- ' + t(:message_29, :scope => [:txt, :helper, :students]) + ' --', '0'], [t(:message_30, :scope => [:txt, :helper, :students]), 1],\
        [t(:message_31, :scope => [:txt, :helper, :students]), 2], [t(:message_32, :scope => [:txt, :helper, :students]), 3],\
        [t(:message_33, :scope => [:txt, :helper, :students]), 4], [t(:message_34, :scope => [:txt, :helper, :students]), 5]]
    content_tag('select', options_for_select(ops), 
                {:id => "status-srch", :name => "status"})
  end

  # prints select for statuses
  def study_status_select(options = {})
    ops = [['-- ' + t(:message_35, :scope => [:txt, :helper, :students]) + ' --', '0'], [t(:message_36, :scope => [:txt, :helper, :students]), 1], [t(:message_37, :scope => [:txt, :helper, :students]), 2],
            [t(:message_38, :scope => [:txt, :helper, :students]), 3], [t(:message_39, :scope => [:txt, :helper, :students]), 4], [t(:message_40, :scope => [:txt, :helper, :students]), 5], [t(:message_41, :scope => [:txt, :helper, :students]), 6]]
    content_tag('select', options_for_select(ops), 
                {:id => "study_status-srch", :name => "study_status"})
  end

  # prints select for statuses
  def form_select(options = {})
    ops = [['-- ' + t(:message_42, :scope => [:txt, :helper, :students]) + ' --', '0'], [t(:message_43, :scope => [:txt, :helper, :students]), 1], [t(:message_44, :scope => [:txt, :helper, :students]), 2]]
    content_tag('select', options_for_select(ops), 
                {'id' => "form", 'name' => "form"})
  end

  # prints select for years
  def year_select
    ops = [['-- ' + t(:message_45, :scope => [:txt, :helper, :students]) + ' --', '0'], [t(:message_46, :scope => [:txt, :helper, :students]), 1], [t(:message_47, :scope => [:txt, :helper, :students]), 2], 
            [t(:message_48, :scope => [:txt, :helper, :students]), 3], [t(:message_49, :scope => [:txt, :helper, :students]), 4]]
    content_tag('select', options_for_select(ops), 
      {'id' => "year", 'name' => "year"})
  end

  def interrupt_to_info(index)
    "#{t(:message_50, :scope => [:txt, :helper, :students])} #{index.interrupt.end_on.strftime('%d.%m.%Y')}"
  end
  
  def back_to_list(index)
    link_to_function(t(:message_51, :scope => [:txt, :helper, :students]),
                    update_page do |page|
                      page.show 'students_list', 'search'
                      page.remove 'student_detail'
                      page["index_line_%i" % index.id].scrollTo.highlight :duration => 5
                    end,
                    :id => 'back_link')

  end

  def back_and_remove_from_list(index)
    link_to_function(t(:message_52, :scope => [:txt, :helper, :students]), 
                    update_page do |page|
                      page.remove "index_line_#{index.id}",
                                  "index_menu_#{index.id}_tr",
                                  "index_form_#{index.id}_tr",
                                  'student_detail'
                      page.show 'students_list', 'search'
                    end,
                    :id => 'back_remove_link')
  end

  def diploma_supplement_link(index)
    link_to(t(:message_53, :scope => [:txt, :helper, :students]),
            :controller => :diploma_supplements, 
            :action => :new,
            :id => index)
  end

  # returns form for changing tutor
  def change_tutor_form(&proc)
    form_tag({:action => "change_tutor_confirm"}, &proc)
  end

  # returns form for ending study
  def end_study_form(&proc)
    form_tag({:action => "end_study_confirm"}, &proc)
  end

  def name_search_form(&proc)
    form_remote_tag(:url => {:action => 'search'},
                    :loading => "$('search_submit').value = '%s'" % t(:message_54, :scope => [:txt, :helper, :students]),
                    &proc)
  end

  def detail_filter_form(&proc)
    form_remote_tag(:url => {:action => 'multiple_filter'},
                    :loading => "$('spinner').show()",
                    :complete => "$('spinner').hide()",
                    :update => 'students_list',
                    &proc)
  end

  def study_plan_link(index)
    if params[:controller] == 'students' && params[:action] == 'show'
    " <a href='#shortcut_study_plan'>" + t(:message_55, :scope => [:txt, :helper, :students]) + "</a>"
    else
      link_to_remote(t(:message_56, :scope => [:txt, :helper, :students]),
                     :url => {:action => :show,
                             :controller => :study_plans,
                             :id => index},
                     :update => "index_detail_#{index.id}_tr")
    end
  end

  def filter_links(filters) 
    loader = content_tag('div', image_tag('big_loader.gif'), :id => 'filter-loader')
    filters.map do |filter|
      link_to_remote(filter.first,
                    :url => {:action => :filter,
                            :id => filter.last},
                    :update => 'students_list',
                    :loading => "$('students_list').innerHTML = '%s'" % loader)
    end.join('&nbsp;')
  end
end
