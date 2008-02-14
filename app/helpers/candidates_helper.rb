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
  # prints sorting tags
  def sort_tags(action, args, options = {})
    links = ''
    for arg in args
      links << '&nbsp;'
      if session[:category] == arg.first 
        link = arg.last + (session[:order] != ' desc' ? ' &darr;' : ' &uarr;')
      else
        link = arg.last + ' &uarr;'
      end
      links << link_to(link, :action => action, :category => arg.first, 
      :prefix => params[:prefix])
    end
    content_tag('div', options[:message] + links, :class => :links)
  end
  # prints ordered sorting tags
  def filtered_sort_tags(action, args, filtered_by, options = {})
    links = ''
    for arg in args
      links << '&nbsp;'
      if session[:category] == arg.first 
        link = arg.last + (session[:order] != ' desc' ? ' &darr;' : ' &uarr;')
      else
        link = arg.last + ' &uarr;'
      end
      links << link_to(link, :action => action, :filter => filtered_by, 
        :category => arg.first, :prefix => params[:prefix])
    end
    content_tag('div', options[:message] + links, :class => :links)
  end
  # prints sorting tags
  def filter_tags(action, args, options)
    links = '&nbsp;' + link_to(_("all"), :action => '')
    for arg in args
      links << '&nbsp;'
      links << link_to(_("only " + arg), :action => action, :filter => arg)
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
      links << link_to(_("table"), {:prefix => 'table_', :coridor =>
      params[:coridor], :filter => params[:filter], :category =>
      params[:category]})
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
