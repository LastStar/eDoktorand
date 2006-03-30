module ProbationTermsHelper

  # prints list links
	def probation_term_list_links
	  links = ''
    if (!@user.person.is_a?(Student))
	    links << link_to(_("new term"), {:action => 'create'})
	    links << '&nbsp;'
    end
     if @params['prefix']
     	 links << link_to(_("list"), {:prefix => nil})
	  else
 	  	 links << link_to(_("table"), {:prefix => 'table_'})
     end
	  links << '&nbsp;'
	  links << "<a href='javascript:window.print();'>vytisknout tento seznam</a>"
	  if @pages and pagination_links(@pages)
		    links << '&nbsp;'                           
		    links << link_to("předchozí stránka", { :page => @pages.current.previous }) if @pages.current.previous           
		    links << '&nbsp;'
		    links << pagination_links(@pages)
		    links << '&nbsp;'
		    links << link_to("následující stránka", { :page => @pages.current.next }) if @pages.current.next 
	  end
	  content_tag('div', links, :class => 'links')
	end
end
