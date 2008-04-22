module CandidatesHelper
  # ready link
  def ready_link(candidate)
    if !candidate.ready? 
      link_to(_("make ready"), :action => 'ready', :id => candidate)
    end
  end

  # admit link
  def admit_link(candidate)
    links = ''
    if !candidate.admited? && !candidate.rejected? && candidate.invited? && candidate.ready?
      unless candidate.coridor.exam_term
        links << link_to(_("create commission"), :controller => 'exam_terms', 
        :action => 'new', :id => candidate.coridor.id ,:from => 'candidate', :backward => @backward )
      else
        links << link_to(_('protocol'), :action => 'admittance', :id => candidate) + "&nbsp;" +
        link_to(_("gain"), :action => 'admit', :id => candidate)  
      end
    end
  end

  # invite link
  def invite_link(candidate)
    if !candidate.invited? and candidate.ready? 
      unless candidate.coridor.exam_term  
        link_to(_("create commission"), :controller => 'exam_terms', 
        :action => 'new', :id => candidate.coridor.id,:from => 'candidate',:backward => @backward)
      else
        link_to(_("invite"), :action => 'invite', :id => candidate.id)
      end
    end
  end

  # enroll link
  def enroll_link(candidate)
    if !candidate.enrolled? and candidate.admited?
      link_to(_("enroll"), :action => 'enroll', :id => candidate) 
    end
  end

  def switch_button_all(message)
    link_to_function(message, "Element.show('list_all'); Element.hide('list')")
  end

  def switch_button(message)
    link_to_function(message, "Element.show('list'); Element.hide('list_all')")
  end

  def view_filter_settings(div_id)
    
      filter_set = _('not set')
      category = ''
      if session[:category] == 'lastname'
        category = _('by lastname up')
      end
      if session[:category] == 'lastname desc'
        category = _('by lastname down')
      end
      if session[:category] == 'coridor_id'
        category = _('by coridor up')
      end
      if session[:category] == 'coridor_id desc'
        category = _('by coridor down')
      end
      if session[:category] == 'updated_on'
        category = _('by updated on up')
      end
      if session[:category] == 'updated_on desc'
        category = _('by updated on down')
      end
    if session[:list_mode] == 'list'
      filter_set = _('view paginated') + ', ' + category
    end
    if session[:list_mode] == 'list_all'
      filter_set = _('view all') + ', ' + category
    end
    
    '<div id ="' + div_id + '" class="links">' +
     _('Filter is set to:') + ' ' + filter_set +
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
    links = '&nbsp;' + link_to("<span title='"+_('paginated list of all candidates is displayed after click')+"'>"+_("all")+"</span>", :action => '')
    i = 0
    for arg in args
      links << '&nbsp;'
      links << link_to("<span title='"+ titles[i] +"'>" + _("only " + arg) + "</span>", :action => action, :filter => arg)
      i = i+1;
    end
    content_tag('div', options[:message] + links, :class => :links)
  end

  # prints list links
  def list_links
    links = ''
    if params[:prefix]
      if @user.has_role?('board_chairman')
        links << link_to(_("list"), {:action => 'index',:prefix => nil})
        links << '&nbsp;'
      else
        links << link_to(_("list"), {:prefix => nil})
        links << '&nbsp;'
      end
    else
      links << link_to_function(_("show all contacts"), 'open_all_contacts()')
      links << '&nbsp;'
      links << link_to_function(_("hide all contacts"), 'close_all_contacts()')
      links << '&nbsp;'
      unless @user.has_role?('board_chairman')
        links << link_to_function(_("show all histories"),
                                  'open_all_histories()')
        links << '&nbsp;'
        links << link_to_function(_("hide all histories"),
                                  'close_all_histories()')
        links << '&nbsp;'
      end
      links << '&nbsp;'
      unless @user.has_one_of_roles?(['board_chairman','department_secretary'])
        links << link_to(_("summary"), {:action => 'summary', :id => "department"})
        links << '&nbsp;'
      end
    end
  end

  # print summary department/coridor switcher
  def summary_links
    links = ''
    links << link_to(_(params[:id] == "department" ||  !params[:id] ?
    _("By corridors") : _("By departments")), {:action => 'summary', 
      :id => params[:id] == "department" ||  !params[:id] ? 'corridor' : 'department'})
    content_tag('div', links, :class => 'links')
  end
  
  def admit_for_revocation_tag(candidate)
    if candidate.rejected?
      link_to _("admit_for_revocation"), {:action => 'admit_for_revocation', :id => candidate.id}
    end
  end

  def contact_toggle_link(candidate)
        link_to_function(_("contact"),
                     "Element.toggle('contact#{candidate.id}')") 
  end

  def history_toggle_link(candidate)
        link_to_function(_("history"),
                     "Element.toggle('history#{candidate.id}')") 
  end


  # prints status of the candidate
  def status_tag(candidate)
    if candidate.enrolled?
      content_tag('span', _("enrolled"), :class => 'statusInfo')
    elsif candidate.rejected?
      content_tag('span', _("not admitted"), :class => 'statusInfo')
    elsif candidate.admited?
      content_tag('span', _("admitted"), :class => 'statusInfo')
    elsif candidate.invited?
      content_tag('span', _("invited"), :class => 'statusInfo')
    elsif candidate.ready?
      content_tag('span', _("ready"), :class => 'statusInfo')
    end
  end			
  # returns admit ids array
  def admit_ids
    [[_("admit"), 1], [_("conditional admit"), 2], [_("not admit"), 0]]
  end
  # return pass ids array  
  def pass_ids
    [[_("not pass"), 0], [_("pass"), 1]]
  end
  # returns pass word
  def pass_word(id)
    [_("not pass"), _("pass")][id]
  end
  # returns admit word
  def admit_word(id)      
    [_("reject"), _("admit")][id]
  end
end
