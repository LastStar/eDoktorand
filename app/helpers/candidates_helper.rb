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
    	link_to('protokol', :action => 'admittance', :id => candidate) +
    	link_to('příjmout', :action => 'admit', :id => candidate) 
    end
  end
  # invite link
  def invite_link(candidate)
    if !candidate.invited? and candidate.ready? 
      unless candidate.coridor.exam_term  
      	link_to('vytvořit termín', :controller => 'exam_terms', 
      	:action => 'new', :id => candidate.coridor.id )
			else
	      link_to 'pozvat', :action => 'invite', :id => candidate.id 
			end
    end
  end
  # prints sorting tags
  def sort_tags(action, args, options = {})
    links = ''
    for arg in args
      links << '&nbsp;'
      if @session['category'] == arg.first 
        arg.last << (@session['order'] != ' desc' ? ' &darr;' : ' &uarr;')
      else
        arg.last << ' &uarr;'
      end
      links << link_to(arg.last, :action => action, :category => arg.first)
    end
    content_tag('div', options[:message] + links, :class => :links)
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
	# prints status of the candidate
	def status_tag(candidate)
		if candidate.ready? and !candidate.invited?
			content_tag('span', 'připraven', :class => 'smallInfo')
		elsif candidate.invited? and !candidate.admited?
			content_tag('span', 'pozván', :class => 'smallInfo')
		elsif candidate.admited?
			content_tag('span', 'příjmut', :class => 'smallInfo')
		end
	end			
	# returns admit ids array
  def admit_ids
          [['nepřijmout', 0], ['přijmout', 1]]
  end
  # return pass ids        array  
  def pass_ids
          [['neprospěl', 0], ['prospěl', 1]]
  end
  # returns pass word
  def pass_word(id)
          ['neprospěl', 'prospěl'][id]
  end
  # returns admit word
  def admit_word(id)      
          ['nepřijmout', 'přijmout'][id]
  end

end
