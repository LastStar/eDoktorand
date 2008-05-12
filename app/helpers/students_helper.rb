module StudentsHelper

  # prints action links on student
  def student_action_links(index)
    links = []
    study_plan = index.study_plan 
    if @user.has_one_of_roles?(['dean', 'faculty_secretary']) &&
                               index.status != _('absolved')
      links << finish_link(index)
      unless index.finished?
        links << switch_link(index)
        if index.waits_for_scholarship_confirmation?
          links << supervise_scholarship_link(index)
        end
        if study_plan
          links << study_plan_link(index)
          if study_plan.all_subjects_finished?
            if index.absolved?
              links << diploma_supplement_link(index)
            elsif index.final_exam_passed?
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
        if index.not_even_admited_interupt?
          links << interupt_link(index)
        elsif index.interupt_waits_for_confirmation?
          links << confirm_interupt_link(index) 
        elsif index.interupted?
          links << end_interupt_link(index)
        end
      end
    end
    return  links
  end
      
  #prints link to function witch show student line menu
  def link_to_show_actions(index)
    link_to_function('&uarr;' + _('actions'),
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
    link_to_function('&darr;' + _('actions'),
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
      link_to_remote(_('unfinish study'),
                    :url => {:action => 'unfinish', :controller => 'students',
                    :id => index, :day => true}, :complete => evaluate_remote_response)
    else 
      link_to_remote(_('finish study'), 
                    :url => {:action => 'time_form', :controller => 'students',
                    :form_action => 'finish', :id => index, :day => true}, 
                    :update => "index_form_#{index.id}")
    end
  end
 
  # prints link to switch study form
  def switch_link(index)
    link_to_remote(_('switch study'),
                  :url => {:action => 'time_form',
                          :controller => 'students',
                          :form_action => 'switch_study',
                          :id => index},
                  :update => "index_form_#{index.id}")
  end

  # prints interupt link
  def interupt_link(index)
    link_to(_('interrupt study'),
            {:action => 'index', 
            :controller => 'interupts',
            :id => index})
  end

  # prints confirm interupt link
  def confirm_interupt_link(index)
    link_to_remote(_('confirm interrupt'),
                   :url => {:action => 'time_form',
                           :controller => 'students',
                           :form_action => 'confirm',
                           :form_controller => 'interupts',
                           :id => index,
                           :date => index.interupt.start_on},
                   :update => "index_form_#{index.id}")
  end

  # prints end interupt link
  def end_interupt_link(index)
    link_to_remote(_('end interrupt'),
                   :url => {:action => 'time_form',
                           :controller => 'students',
                           :form_action => 'end',
                           :form_controller => 'interupts',
                           :id => index,
                           :date => index.interupt.end_on},
                   :update => "index_form_#{index.id}")
  end

  # prints link to create new study plan
  def create_link(index)
    link_to(_('create SP'),
            :action => 'create',
            :controller => 'study_plans',
            :id => index.student)
  end

  # prints link to create final exam term
  def final_exam_link(index)
    link_to_remote(_('final exam term'),
                   :url => {:action => 'new',
                           :controller => 'final_exam_terms',
                           :id => index},
                   :complete => evaluate_remote_response)
  end

  # prints lint to interupt study
  def confirm_interupt_link(index)
    link_to_remote(_('confirm interupt'),
                   {:url => {:action => 'confirm',
                             :controller => 'interupts',
                             :id => index},
                    :complete => evaluate_remote_response})
  end

  # prints link to supervise scholarship
  def supervise_scholarship_link(index)
    link_to_remote(_('supervise scholarship'),
                  :url => {:controller => 'students',
                          :action => 'supervise_scholarship_claim',
                          :id => index},
                  :complete => evaluate_remote_response)
  end

  # returns link for details fiter 
  def detail_filter_link
    link_to_function(_('Detail filter'),
                     "$('detail_info').toggle(); $('detail_search').toggle()",
                     :class => 'legend_link') 
  end

  # TODO move logic to model. Here only printing
  # TODO rename to index_tags
  def student_exception(index)
    tags = []
    if index.status == _('FE passed')
      if index.defense_claimed?
        tags <<  "<span title='" + _('claimed for defence') + "'>po</span>"
      elsif index.defense_invitation_sent?
        tags << "<span title='" + _('approved form of defence') + "'>so</span>"
      end
    else
      unless index.status == _('absolved') || index.status == _('finished')
        if index.close_to_interupt_end_or_after?
          tags << "<span title='" + _('comming end of interrupt') + "'>!</span>"
        end
        if index.waits_for_scholarship_confirmation?
          tags << "<span title='" + _('accommodation scholarship') + "'>us</span>"
        end
        unless index.status == _('final application') || index.final_exam_passed?
          if index.claimed_for_final_exam? 
            tags << "<span title='" + _('approved form of FE') + "'>sz</span>"
          elsif index.claimed_final_application? && !index.claimed_for_final_exam?
            tags << "<span title='" + _('presented form of FE') + "'>pz</span>"
          end
        end
        if index.defense_claimed?
          tags << "<span title=" + _('presented form of defence') + "> po </span>"
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
                    :loading => visual_effect(:pulsate, "index_line_#{index.id}"),
                    :complete => evaluate_remote_response)
  end

  def pass_link(what, index)
    action = 'pass_' + what.to_s
    url = {:action => 'time_form', :controller => 'students',
           :form_action => action, :id => index, :day => true}
    link_to_remote(_(action.gsub('_', ' ')),
                   :update => "index_form_#{index.id}",
                   :url => url)
  end

  # prints select for departments
  def department_select(options = {:include_empty => true})
    ops = Department.find(:user => @user).map {|d| [d.name, d.id]}
    ops = [['-- ' + _('department') + ' --', '0']].concat(ops) if options[:include_empty]
    content_tag('select', options_for_select(ops),
                {:id => "department-srch", :name => "department"})
  end

  # prints select for coridor
  def coridor_select(options = {:include_empty => true})
    ops = Coridor.find(:user => @user).map {|c| [c.name, c.id]}
    ops = [['-- ' + _('coridor') + ' --', '0']].concat(ops) if options[:include_empty]
    content_tag('select', options_for_select(ops),
                {:id => "coridor-srch", :name => "coridor"})
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
    ops = [['-- ' + _('study plan') + ' --', '0'], [_("SP not admited"), 1],\
        [_("SP admited"), 2], [_("SP approved by tutor"), 3],\
        [_("SP approved by leader"), 4], [_('SP approved by dean'), 5]]
    content_tag('select', options_for_select(ops), 
                {:id => "status-srch", :name => "status"})
  end

  # prints select for statuses
  def study_status_select(options = {})
    ops = [['-- ' + _('study') + ' --', '0'], [_("studying"), 1], [_("finished"), 2],
            [_("interupted"), 3], [_('absolved'), 4], [_('continue'), 5], [_('FE passed'), 6]]
    content_tag('select', options_for_select(ops), 
                {:id => "study_status-srch", :name => "study_status"})
  end

  # prints select for statuses
  def form_select(options = {})
    ops = [['-- ' + _('study form') + ' --', '0'], [_("present"), 1], [_("combined"), 2]]
    content_tag('select', options_for_select(ops), 
                {'id' => "form", 'name' => "form"})
  end

  # prints select for years
  def year_select
    ops = [['-- ' + _('year') + ' --', '0'], [_("1. year"), 1], [_("2. year"), 2], 
            [_("3. year"), 3], [_('x'), 4]]
    content_tag('select', options_for_select(ops), 
      {'id' => "year", 'name' => "year"})
  end

  def interupt_to_info(index)
    "#{_('to')} #{index.interupt.end_on.strftime('%d.%m.%Y')}"
  end
  
  def back_to_list(index)
    link_to_function(_("back"),
                    update_page do |page|
                      page.show 'students_list', 'search'
                      page.remove 'student_detail'
                      page["index_line_%i" % index.id].scrollTo.highlight :duration => 5
                    end,
                    :id => 'back_link')

  end

  def back_and_remove_from_list(index)
    link_to_function(_("back and remove from list"), 
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
    link_to(_('diploma supplement'),
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
                    :loading => "$('search_submit').value = '%s'" % _('working...'),
                    :complete => evaluate_remote_response,
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
    link_to_remote(_('study plan'),
                   :url => {:action => :show,
                           :controller => :study_plans,
                           :id => index},
                   :update => "index_detail_#{index.id}_tr")
  end

  def filter_links(filters) 
    loader = content_tag('div', image_tag('big_loader.gif'), :class => 'centered')
    filters.map do |filter|
      link_to_remote(filter.first,
                    :url => {:action => :filter,
                            :id => filter.last},
                    :update => 'students_list',
                    :loading => "$('students_list').innerHTML = '%s'" % loader)
    end.join('&nbsp;')
  end
end
