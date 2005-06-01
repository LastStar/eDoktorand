module ExamsHelper
	# prints list links
	def exam_list_links
	  links = ''
	  links << "<a href='new'>nový protokol</a>"
	  links << '&nbsp;'
     if @params['prefix']
       links << "<a href='list'>list</a>"
	  else
  	  	 links << "<a href='table'>table</a>"
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

	# returns result
	def result_word(id)
	        [_('not pass'), _('pass')][id]
	end
	
end
