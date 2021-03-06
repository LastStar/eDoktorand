module CandidatesHelper
  # ready link
  def ready_link(candidate)
    if !candidate.ready?
      link_to(t(:message_0, :scope => [:helper, :candidates]), :action => 'ready', :id => candidate)
    end
  end

  # admit link
  def admit_link(candidate)
    links = ''
    if !candidate.admited? && !candidate.rejected? && candidate.invited? && candidate.ready?
      unless candidate.specialization.exam_term
        links << link_to(t(:message_1, :scope => [:helper, :candidates]), :controller => 'exam_terms',
        :action => 'new', :id => candidate.specialization.id ,:from => 'candidate', :backward => @backward )
      else
        links << link_to(t(:message_2, :scope => [:helper, :candidates]), :action => 'admittance', :id => candidate)
        links << "&nbsp;"
        links << link_to(t(:message_3, :scope => [:helper, :candidates]), :action => 'admit', :id => candidate)
      end
    end
  end

  # invite link
  def invite_link(candidate)
    if !candidate.invited? and candidate.ready?
      unless candidate.specialization.exam_term
        link_to(t(:message_4, :scope => [:helper, :candidates]), :controller => 'exam_terms',
        :action => 'new', :id => candidate.specialization.id,:from => 'candidate',:backward => @backward)
      else
        link_to(t(:message_5, :scope => [:helper, :candidates]), :action => 'invite', :id => candidate.id)
      end
    end
  end

  # enroll link
  def enroll_link(candidate)
    if !candidate.enrolled? and candidate.admited?
      link_to(t(:message_6, :scope => [:helper, :candidates]), :action => 'enroll', :id => candidate)
    end
  end

  def switch_button_all(message)
    link_to_function(message, "Element.show('list_all'); Element.hide('list')")
  end

  def switch_button(message)
    link_to_function(message, "Element.show('list'); Element.hide('list_all')")
  end

  def view_filter_settings(div_id)

      filter_set = t(:message_7, :scope => [:helper, :candidates])
      category = ''
      if session[:category] == 'lastname'
        category = t(:message_8, :scope => [:helper, :candidates])
      end
      if session[:category] == 'lastname desc'
        category = t(:message_9, :scope => [:helper, :candidates])
      end
      if session[:category] == 'specialization_id'
        category = t(:message_10, :scope => [:helper, :candidates])
      end
      if session[:category] == 'specialization_id desc'
        category = t(:message_11, :scope => [:helper, :candidates])
      end
      if session[:category] == 'updated_on'
        category = t(:message_12, :scope => [:helper, :candidates])
      end
      if session[:category] == 'updated_on desc'
        category = t(:message_13, :scope => [:helper, :candidates])
      end
    if session[:list_mode] == 'list'
      filter_set = t(:message_14, :scope => [:helper, :candidates]) + ', ' + category
    end
    if session[:list_mode] == 'list_all'
      filter_set = t(:message_15, :scope => [:helper, :candidates]) + ', ' + category
    end

    '<div id ="' + div_id + '">' +
     t(:message_16, :scope => [:helper, :candidates]) + ' ' + filter_set +
    '</div>'

  end

  # FIXME clean this mess vvvvvvv
  # prints sorting tags
  def sort_tags(action, args, titles, options = {})
    links = ''
    i = 0
    for arg in args
      links << '&nbsp;'
      if session[:category] == arg.first
        link = "<span title='"+titles[i] +"'>" + arg.last + (session[:order] != " desc" ? " &darr;" : " &uarr;") + "</span>"
      else
        link = "<span title='"+titles[i] +"'>" + arg.last + " &uarr;" + "</span>"
      end
      i = i + 1
      links << link_to(link, :action => action, :category => arg.first,
      :prefix => params[:prefix])
    end
    content_tag('div', options[:message] + links, :class => :links, :id=> 'list_all_links', :style => 'clear: both')
  end

  # prints ordered sorting tags
  def filtered_sort_tags(action, args, filtered_by, titles, options = {})
    links = ''
    i = 0
    for arg in args
      links << '&nbsp;'
      if session[:category] == arg.first
        link = "<span title='"+titles[i] +"'>" + arg.last + (session[:order] != " desc" ? " &darr;" : " &uarr;") + "</span>"
      else
        link = "<span title='"+titles[i] +"'>" +arg.last + " &uarr;" + "</span>"
      end
      i = i + 1
      links << link_to(link, :action => action, :filter => filtered_by,
        :category => arg.first, :prefix => params[:prefix])
    end
    content_tag('div', options[:message] + links, :class => :links, :id => 'list_links', :style => 'clear: both')
  end

  # prints sorting tags
  def filter_tags(action, args, titles, options)
    links = '&nbsp;' + link_to("<span title='"+t(:message_17, :scope => [:helper, :candidates])+"'>"+t(:message_18, :scope => [:helper, :candidates])+"</span>", :action => '')

    i = 0
    for arg in args
      links << '&nbsp;'
      if arg == "unready"
        message = t(:message_19, :scope => [:helper, :candidates])
      end
      if arg == "ready"
        message = t(:message_45, :scope => [:helper, :candidates])
      end
      if arg == "invited"
        message = t(:message_46, :scope => [:helper, :candidates])
      end
      if arg == "admited"
        message = t(:message_47, :scope => [:helper, :candidates])
      end
      if arg == "enrolled"
        message = t(:message_48, :scope => [:helper, :candidates])
      end
      links << link_to("<span title='"+ titles[i] +"'>" + message + "</span>", :action => action, :filter => arg)
      i = i+1;
    end
    content_tag('div', options[:message] + links, :class => :links, :style => 'clear: both')
  end

  # prints list links
  def list_links
    links = ''
    if params[:prefix]
      if @user.has_role?('board_chairman')
        links << link_to(t(:message_20, :scope => [:helper, :candidates]), {:action => 'index',:prefix => nil})
        links << '&nbsp;'
      else
        links << link_to(t(:message_21, :scope => [:helper, :candidates]), {:prefix => nil})
        links << '&nbsp;'
      end
    else
      links << link_to_function(t(:message_22, :scope => [:helper, :candidates]), 'open_all_contacts()')
      links << '&nbsp;'
      links << link_to_function(t(:message_23, :scope => [:helper, :candidates]), 'close_all_contacts()')
      links << '&nbsp;'
      unless @user.has_role?('board_chairman')
        links << link_to_function(t(:message_24, :scope => [:helper, :candidates]),
                                  'open_all_histories()')
        links << '&nbsp;'
        links << link_to_function(t(:message_25, :scope => [:helper, :candidates]),
                                  'close_all_histories()')
        links << '&nbsp;'
      end
      links << '&nbsp;'
      unless @user.has_one_of_roles?(['board_chairman','department_secretary'])
        links << link_to(t(:message_26, :scope => [:helper, :candidates]), {:action => 'summary', :id => "department"})
        links << '&nbsp;'
      end
    end
  end

  # print summary department/specialization switcher
  def summary_links
    links = ''
    link_name = params[:id]=="department" ? t(:message_27, :scope => [:helper, :candidates]) : t(:message_49, :scope => [:helper, :candidates])
    links << link_to( link_name, {:action => 'summary',
      :id => params[:id] == "department" ||  !params[:id] ? 'corridor' : 'department'})
    content_tag('div', links, :class => 'links')
  end

  def admit_for_revocation_tag(candidate)
    if candidate.rejected?
      link_to t(:message_28, :scope => [:helper, :candidates]), {:action => 'admit_for_revocation', :id => candidate.id}
    end
  end

  def contact_toggle_link(candidate)
        link_to_function(t(:message_29, :scope => [:helper, :candidates]),
                     "Element.toggle('contact#{candidate.id}')")
  end

  def history_toggle_link(candidate)
        link_to_function(t(:message_30, :scope => [:helper, :candidates]),
                     "Element.toggle('history#{candidate.id}')")
  end

  # prints status of the candidate
  def status_tag(candidate)
    if candidate.enrolled?
      content_tag('span', t(:message_31, :scope => [:helper, :candidates]), :class => 'statusInfo')
    elsif candidate.rejected?
      content_tag('span', t(:message_32, :scope => [:helper, :candidates]), :class => 'statusInfo')
    elsif candidate.admited?
      content_tag('span', t(:message_33, :scope => [:helper, :candidates]), :class => 'statusInfo')
    elsif candidate.invited?
      content_tag('span', t(:message_34, :scope => [:helper, :candidates]), :class => 'statusInfo')
    elsif candidate.ready?
      content_tag('span', t(:message_35, :scope => [:helper, :candidates]), :class => 'statusInfo')
    end
  end

  # returns admit ids array
  def admit_ids
    [[t(:message_36, :scope => [:helper, :candidates]), 1], [t(:message_37, :scope => [:helper, :candidates]), 2], [t(:message_38, :scope => [:helper, :candidates]), 0]]
  end

  # return pass ids array
  def pass_ids
    [[t(:message_39, :scope => [:helper, :candidates]), 0], [t(:message_40, :scope => [:helper, :candidates]), 1]]
  end

  # returns pass word
  def pass_word(id)
    [t(:message_41, :scope => [:helper, :candidates]), t(:message_42, :scope => [:helper, :candidates])][id]
  end

  # returns admit word
  def admit_word(id)
    [t(:message_43, :scope => [:helper, :candidates]), t(:message_44, :scope => [:helper, :candidates])][id]
  end

  # returns date select defaulting to start of this school year
  def start_date_select
    select_date TermsCalculator.this_year_start,
      :order => [:day, :month, :year],
      :use_month_numbers => true
  end

  # foreign payer link
  def foreign_pay_link(candidate)
    if candidate.foreign_pay?
      link_to_remote(t(:unset_foreign_pay, :scope => [:view, :candidates, :_list]),
                     :url => { :action => 'set_foreign_payer', :id => candidate.id},
                     :method => :get,
                     :update => dom_id(candidate))
    else
      link_to_remote(t(:set_foreign_pay, :scope => [:view, :candidates, :_list]),
                     :url => { :action => 'set_foreign_payer', :id => candidate.id},
                     :method => :get,
                     :update => dom_id(candidate))
    end
  end
end

