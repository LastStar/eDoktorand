module ExamsHelper
	# prints list links
	def exam_list_links
	  links = ''
	  links << link_to(_("new exam"), {:action => 'create'})
	  links << '&nbsp;'
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

	# returns result
	def result_word(id)
	        [_('not pass'), _('pass')][id]
	end
	
  def exam_by_subject_link()
      content_tag('li', link_to_remote(_("exam by subject"), {:url => {:action =>
      'examBySubject', :controller => 'exams'}, :loading => 
      visual_effect(:appear, 'loading'), :interactive => visual_effect(:fade, 
      "loading"), :complete => evaluate_remote_response}))
  end
  
  def exam_by_person_link()
      content_tag('li', link_to_remote(_("exam by person"), {:url => {:action =>
      'examByPerson', :controller => 'exams'}, :loading => 
      visual_effect(:appear, 'loading'), :interactive => visual_effect(:fade, 
      "loading"), :complete => evaluate_remote_response}))
  end
end
