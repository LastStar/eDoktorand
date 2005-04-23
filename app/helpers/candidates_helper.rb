module CandidatesHelper
  # ready link
  def ready_link(candidate)
    if !candidate.ready? 
      link_to 'v pořádku', :action => 'ready', :id => candidate.id 
    end
  end
  # admit link
  def admit_link(candidate)
    if !candidate.admited? and candidate.ready?
      link_to 'příjmout', :action => 'admit', :id => candidate.id 
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
  # prints list links
  def list_links
    links = ''
    links << "<a href='javascript:open_all_details()'>ukázat všechny kontakty</a>"
    links << '&nbsp;'
    links << "<a href='javascript:close_all_details()'>skrýt všechny kontakty</a>"
    links << '&nbsp;'
    links << "<a href='javascript:print_details()'>vytisknout tento seznam</a>"
    links << '&nbsp;'
    links << link_to("předchozí stránka", { :page => @pages.current.previous }) if @pages.current.previous
    links << '&nbsp;'
    links << pagination_links(@pages)
    links << '&nbsp;'
    links << link_to("následující stránka", { :page => @pages.current.next }) if @pages.current.next 
    content_tag('div', links, :class => 'links')
  end
end
