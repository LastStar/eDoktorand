module CandidatesHelper
  # ready link
  def ready_link(candidate)
    if !candidate.ready? 
      link_to(_("make ready"), :action => 'ready', :id => candidate)
    end
  end
  # admit link
  def admit_link(candidate)
    if !candidate.admited? and candidate.invited? and candidate.ready?
      link_to(_('protocol'), :action => 'admittance', :id => candidate) + "&nbsp;" +
      link_to(_("admit"), :action => 'admit', :id => candidate) 
    end
  end
  # invite link
  def invite_link(candidate)
    if !candidate.invited? and candidate.ready? 
      unless candidate.coridor.exam_term  
        link_to(_("create commission"), :controller => 'exam_terms', 
        :action => 'new', :id => candidate.coridor.id )
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
      if @session['category'] == arg.first 
        link = arg.last + (@session['order'] != ' desc' ? ' &darr;' : ' &uarr;')
      else
        link = arg.last + ' &uarr;'
      end
      links << link_to(link, :action => action, :category => arg.first, 
      :prefix => @params['prefix'])
    end
    content_tag('div', options[:message] + links, :class => :links)
  end
  # prints ordered sorting tags
  def filtered_sort_tags(action, args, filtered_by, options = {})
    links = ''
    for arg in args
      links << '&nbsp;'
      if @session['category'] == arg.first 
        link = arg.last + (@session['order'] != ' desc' ? ' &darr;' : ' &uarr;')
      else
        link = arg.last + ' &uarr;'
      end
      links << link_to(link, :action => action, :filter => filtered_by, 
        :category => arg.first, :prefix => @params['prefix'])
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
    if @params['prefix']
      links << link_to(_("list"), {:prefix => nil})
      links << '&nbsp;'
      links << link_to_function(_('print this list'), 'window.print();')
    else
      links << link_to_function(_("show all contacts"), 'open_all_contacts()')
      links << '&nbsp;'
      links << link_to_function(_("hide all contacts"), 'close_all_contacts()')
      links << '&nbsp;'
      links << link_to_function(_("show all histories"),
      'open_all_histories()')
      links << '&nbsp;'
      links << link_to_function(_("hide all histories"),
      'close_all_histories()')
      links << '&nbsp;'
      links << link_to(_("table"), {:prefix => 'table_', :coridor =>
      @params['coridor'], :filter => @params['filter'], :category =>
      @params['category']})
      links << '&nbsp;'
      links << link_to(_("summary"), {:action => 'summary', :id => "department"})
      links << '&nbsp;'
      links << link_to_function(_("print this page"), 'print_details()')
    end
    if @pages and pagination_links(@pages)
      links << '&nbsp;'                           
      links << link_to(_("previous page"), 
      {:page => @pages.current.previous}) if @pages.current.previous           
      links << '&nbsp;'
      links << pagination_links(@pages)
      links << '&nbsp;'
      links << link_to(_("next page"), 
      { :page => @pages.current.next }) if @pages.current.next 
    end
    content_tag('div', links, :class => 'links')
  end

  # print summary department/coridor switcher
  def summary_links
    links = ''
    links << link_to(_(@params["id"] == "department" ||  !@params["id"] ?
    "By corridors" : "By departments"), {:action => 'summary', 
      :id => @params["id"] == "department" ||  !@params["id"] ? 'corridor' : 'department'})
    content_tag('div', links, :class => 'links')
  end
  
  # prints status of the candidate
  def status_tag(candidate)
    if candidate.enrolled?
      content_tag('span', _("enrolled"), :class => 'statusInfo')
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
    [[_("reject"), 0], [_("admit"), 1]]
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
