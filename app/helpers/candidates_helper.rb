module CandidatesHelper
  # ready link
  def ready_link(candidate)
    if !candidate.ready? 
      link_to 'v pořádku', :action => 'ready', :id => candidate.id 
    end
  end
  # admit link
  def admit_link(candidate)
    if !candidate.admited? and candidate.invited? and candidate.ready?
      link_to 'příjmout', :action => 'admit', :id => candidate.id 
    end
  end
  # invite link
  def invite_link(candidate)
    if !candidate.invited? and candidate.ready?
      link_to 'pozvat', :action => 'invite', :id => candidate.id 
    end
  end
  # prints sorting tags
  def sort_tags(action, args)
    links = ''
    for arg in args
      links << '&nbsp;'
      if @session['category'] == arg.first 
        arg.last << (@session['order'] != ' desc' ? ' &darr;' : ' &uarr;')
        links << link_to(arg.last, {:action => action, :category => arg.first}, :class => 'choosen')
      else
        arg.last << ' &uarr;'
        links << link_to(arg.last, :action => action, :category => arg.first)
      end
    end
    content_tag('div', 'setřidit podle:' + links, :class => :links)
  end
  # prints sorting tags
  def filter_tags(action, args)
    links = ''
    for arg in args
      links << '&nbsp;'
      links << link_to(arg.last, :action => action, :filter => arg.first)
    end
    content_tag('div', 'zobrazit jen:' + links, :class => :links)
  end
  # prints list links
  def list_links
    links = ''
    links << "<a href='javascript:open_all_details()'>ukázat všechny kontakty</a>"
    links << '&nbsp;'
    links << "<a href='javascript:close_all_details()'>skrýt všechny kontakty</a>"
    links << '&nbsp;'
    links << "<a href='javascript:print_details()'>vytisknout tento seznam</a>"
    if pagination_links(@pages)
	    links << '&nbsp;'                           
	    links << link_to("předchozí stránka", { :page => @pages.current.previous }) if @pages.current.previous           
	    links << '&nbsp;'
	    links << pagination_links(@pages)
	    links << '&nbsp;'
	    links << link_to("následující stránka", { :page => @pages.current.next }) if @pages.current.next 
    end
    content_tag('div', links, :class => 'links')
  end
	# prints status of the candidate
	def status_tag(candidate)
		if candidate.ready? and !candidate.invited?
			content_tag('span', 'připraven', :class => 'smallInfo')
		elsif candidate.invited?
			content_tag('span', 'pozván', :class => 'smallInfo')
		end			
	end
end
