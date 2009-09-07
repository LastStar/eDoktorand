module CandidatesHelper
  # ready link
  def ready_link(candidate)
    if !candidate.ready? 
      link_to(t(:message_0, :scope => [:txt, :helper, :candidates]), :action => 'ready', :id => candidate)
    end
  end

  # admit link
  def admit_link(candidate)
    links = ''
    if !candidate.admited? && !candidate.rejected? && candidate.invited? && candidate.ready?
      unless candidate.coridor.exam_term
        links << link_to(t(:message_1, :scope => [:txt, :helper, :candidates]), :controller => 'exam_terms', 
        :action => 'new', :id => candidate.coridor.id ,:from => 'candidate', :backward => @backward )
      else
        links << link_to(t(:message_2, :scope => [:txt, :helper, :candidates]), :action => 'admittance', :id => candidate) + "&nbsp;" +
        link_to(t(:message_3, :scope => [:txt, :helper, :candidates]), :action => 'admit', :id => candidate)  
      end
    end
  end

  # invite link
  def invite_link(candidate)
    if !candidate.invited? and candidate.ready? 
      unless candidate.coridor.exam_term  
        link_to(t(:message_4, :scope => [:txt, :helper, :candidates]), :controller => 'exam_terms', 
        :action => 'new', :id => candidate.coridor.id,:from => 'candidate',:backward => @backward)
      else
        link_to(t(:message_5, :scope => [:txt, :helper, :candidates]), :action => 'invite', :id => candidate.id)
      end
    end
  end

  # enroll link
  def enroll_link(candidate)
    if !candidate.enrolled? and candidate.admited?
      link_to(t(:message_6, :scope => [:txt, :helper, :candidates]), :action => 'enroll', :id => candidate) 
    end
  end

  def switch_button_all(message)
    link_to_function(message, "Element.show('list_all'); Element.hide('list')")
  end

  def switch_button(message)
    link_to_function(message, "Element.show('list'); Element.hide('list_all')")
  end

  def view_filter_settings(div_id)
    
      filter_set = t(:message_7, :scope => [:txt, :helper, :candidates])
      category = ''
      if session[:category] == 'lastname'
        category = t(:message_8, :scope => [:txt, :helper, :candidates])
      end
      if session[:category] == 'lastname desc'
        category = t(:message_9, :scope => [:txt, :helper, :candidates])
      end
      if session[:category] == 'coridor_id'
        category = t(:message_10, :scope => [:txt, :helper, :candidates])
      end
      if session[:category] == 'coridor_id desc'
        category = t(:message_11, :scope => [:txt, :helper, :candidates])
      end
      if session[:category] == 'updated_on'
        category = t(:message_12, :scope => [:txt, :helper, :candidates])
      end
      if session[:category] == 'updated_on desc'
        category = t(:message_13, :scope => [:txt, :helper, :candidates])
      end
    if session[:list_mode] == 'list'
      filter_set = t(:message_14, :scope => [:txt, :helper, :candidates]) + ', ' + category
    end
    if session[:list_mode] == 'list_all'
      filter_set = t(:message_15, :scope => [:txt, :helper, :candidates]) + ', ' + category
    end
    
    '<div id ="' + div_id + '" class="links">' +
     t(:message_16, :scope => [:txt, :helper, :candidates]) + ' ' + filter_set +
    '</div>'
    
  end

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
    content_tag('div', options[:message] + links, :class => :links, :id=> 'list_all_links')
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
    content_tag('div', options[:message] + links, :class => :links, :id=> 'list_links')
  end

  # prints sorting tags
  def filter_tags(action, args, titles, options)
    links = '&nbsp;' + link_to("<span title='"+t(:message_17, :scope => [:txt, :helper, :candidates])+"'>"+t(:message_18, :scope => [:txt, :helper, :candidates])+"</span>", :action => '')
    
    i = 0
    for arg in args
      links << '&nbsp;'
      if arg == "unready"
        message = t(:message_19, :scope => [:txt, :helper, :candidates])
      end
      if arg == "ready"
        message = t(:message_45, :scope => [:txt, :helper, :candidates])
      end
      if arg == "invited"
        message = t(:message_46, :scope => [:txt, :helper, :candidates])
      end
      if arg == "admited"
        message = t(:message_47, :scope => [:txt, :helper, :candidates])
      end
      if arg == "enrolled"
        message = t(:message_48, :scope => [:txt, :helper, :candidates])
      end
      links << link_to("<span title='"+ titles[i] +"'>" + message + "</span>", :action => action, :filter => arg)
      i = i+1;
    end
    content_tag('div', options[:message] + links, :class => :links)
  end

  # prints list links
  def list_links
    links = ''
    if params[:prefix]
      if @user.has_role?('board_chairman')
        links << link_to(t(:message_20, :scope => [:txt, :helper, :candidates]), {:action => 'index',:prefix => nil})
        links << '&nbsp;'
      else
        links << link_to(t(:message_21, :scope => [:txt, :helper, :candidates]), {:prefix => nil})
        links << '&nbsp;'
      end
    else
      links << link_to_function(t(:message_22, :scope => [:txt, :helper, :candidates]), 'open_all_contacts()')
      links << '&nbsp;'
      links << link_to_function(t(:message_23, :scope => [:txt, :helper, :candidates]), 'close_all_contacts()')
      links << '&nbsp;'
      unless @user.has_role?('board_chairman')
        links << link_to_function(t(:message_24, :scope => [:txt, :helper, :candidates]),
                                  'open_all_histories()')
        links << '&nbsp;'
        links << link_to_function(t(:message_25, :scope => [:txt, :helper, :candidates]),
                                  'close_all_histories()')
        links << '&nbsp;'
      end
      links << '&nbsp;'
      unless @user.has_one_of_roles?(['board_chairman','department_secretary'])
        links << link_to(t(:message_26, :scope => [:txt, :helper, :candidates]), {:action => 'summary', :id => "department"})
        links << '&nbsp;'
      end
    end
  end

  # print summary department/coridor switcher
  def summary_links
    links = ''
    link_name = params[:id]=="department" ? t(:message_27, :scope => [:txt, :helper, :candidates]) : t(:message_49, :scope => [:txt, :helper, :candidates])
    links << link_to( link_name, {:action => 'summary', 
      :id => params[:id] == "department" ||  !params[:id] ? 'corridor' : 'department'})
    content_tag('div', links, :class => 'links')
  end
  
  def admit_for_revocation_tag(candidate)
    if candidate.rejected?
      link_to t(:message_28, :scope => [:txt, :helper, :candidates]), {:action => 'admit_for_revocation', :id => candidate.id}
    end
  end

  def contact_toggle_link(candidate)
        link_to_function(t(:message_29, :scope => [:txt, :helper, :candidates]),
                     "Element.toggle('contact#{candidate.id}')") 
  end

  def history_toggle_link(candidate)
        link_to_function(t(:message_30, :scope => [:txt, :helper, :candidates]),
                     "Element.toggle('history#{candidate.id}')") 
  end


  # prints status of the candidate
  def status_tag(candidate)
    if candidate.enrolled?
      content_tag('span', t(:message_31, :scope => [:txt, :helper, :candidates]), :class => 'statusInfo')
    elsif candidate.rejected?
      content_tag('span', t(:message_32, :scope => [:txt, :helper, :candidates]), :class => 'statusInfo')
    elsif candidate.admited?
      content_tag('span', t(:message_33, :scope => [:txt, :helper, :candidates]), :class => 'statusInfo')
    elsif candidate.invited?
      content_tag('span', t(:message_34, :scope => [:txt, :helper, :candidates]), :class => 'statusInfo')
    elsif candidate.ready?
      content_tag('span', t(:message_35, :scope => [:txt, :helper, :candidates]), :class => 'statusInfo')
    end
  end			
  # returns admit ids array
  def admit_ids
    [[t(:message_36, :scope => [:txt, :helper, :candidates]), 1], [t(:message_37, :scope => [:txt, :helper, :candidates]), 2], [t(:message_38, :scope => [:txt, :helper, :candidates]), 0]]
  end
  # return pass ids array  
  def pass_ids
    [[t(:message_39, :scope => [:txt, :helper, :candidates]), 0], [t(:message_40, :scope => [:txt, :helper, :candidates]), 1]]
  end
  # returns pass word
  def pass_word(id)
    [t(:message_41, :scope => [:txt, :helper, :candidates]), t(:message_42, :scope => [:txt, :helper, :candidates])][id]
  end
  # returns admit word
  def admit_word(id)      
    [t(:message_43, :scope => [:txt, :helper, :candidates]), t(:message_44, :scope => [:txt, :helper, :candidates])][id]
  end
end

  def del_date_select
    date_select 'candidate', 'created_on', :start_year => Date.today.year,  :end_year => Date.today.year - 60,
    :order => [:day, :month, :year], :use_month_numbers => true
  end
