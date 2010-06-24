module CandidatesHelper
  SPACER = '&nbsp;'.html_safe.freeze
  SCOPE = [:txt, :helper, :candidates].freeze


  # ready link
  def ready_link(candidate)
    if !candidate.ready? 
      link_to(t(:message_0, :scope => [:txt, :helper, :candidates]), :action => 'ready', :id => candidate)
    end
  end

  # admit link
  def admit_link(candidate)
    if !candidate.admitted? && !candidate.rejected? && candidate.invited?
      unless candidate.specialization.exam_term
        link_to(t(:message_1, :scope => [:txt, :helper, :candidates]),
                :controller => 'exam_terms', :action => 'new',
                :id => candidate.specialization.id,
                :from => 'candidate', :backward => @backward )
      else
        [link_to(t(:message_2, :scope => [:txt, :helper, :candidates]),
                :action => 'admittance', :id => candidate),
        link_to(t(:message_3, :scope => [:txt, :helper, :candidates]),
                :action => 'admit', :id => candidate)].join(SPACER)
      end
    end
  end

  # invite link
  def invite_link(candidate)
    if !candidate.invited? and candidate.ready? 
      unless candidate.specialization.exam_term  
        link_to(t(:message_4, :scope => [:txt, :helper, :candidates]), :controller => 'exam_terms', 
        :action => 'new', :id => candidate.specialization.id,:from => 'candidate',:backward => @backward)
      else
        link_to(t(:message_5, :scope => [:txt, :helper, :candidates]), :action => 'invite', :id => candidate.id)
      end
    end
  end

  # enroll link
  def enroll_link(candidate)
    if !candidate.enrolled? and candidate.admitted?
      link_to(t(:message_6, :scope => [:txt, :helper, :candidates]), :action => 'enroll', :id => candidate) 
    end
  end

  def switch_button_all(message)
    link_to_function(message, "Element.show('list_all'); Element.hide('list')")
  end

  def switch_button(message)
    link_to_function(message, "Element.show('list'); Element.hide('list_all')")
  end

  # prints current filter settings
  def view_filter
   if !params[:filter] or params[:filter] == 'all'
     t(:filter_not_set, :scope => [:txt, :helper, :candidates]) 
   else
     t(:filter_set_on, :scope => [:txt, :helper, :candidates]) + ': ' +
       t(:"only_#{params[:filter]}", :scope => [:txt, :helper, :candidates])
   end

  end

  # prints sorting tags
  def filter_tags
    if params[:action] != 'list_admission_ready'
      links = [link_to(content_tag('span', t(:all, :scope => SCOPE),
                         :title => t(:all_title, :scope => SCOPE)))]
      ['unready', 'ready', 'invited', 'admitted', 'enrolled'].each do |filter|
        span = content_tag('span', t(:"only_#{filter}", :scope => SCOPE),
                           :title => t(:"only_#{filter}_title", :scope => SCOPE))
        links << link_to(span, :action => :list, :filter => filter) 
      end
      links = links.join(SPACER).html_safe
      content_tag('div', links, :class => :links, :style => 'clear: both')
    end
  end

  # print summary department/specialization switcher
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
    t(:"status_#{candidate.status}", :scope => SCOPE)
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

  # returns date select defaulting to start of this school year
  def start_date_select
    select_date TermsCalculator.this_year_start,
      :order => [:day, :month, :year],
      :use_month_numbers => true
  end

  # foreign payer link
  def foreign_pay_link(candidate)
    if candidate.foreign_pay?
      link_to(t(:unset_foreign_pay, :scope => [:txt, :view, :candidates, :_list, :rhtml]),
                     :url => { :action => 'set_foreign_payer', :id => candidate.id},
                     :method => :get,
                     :update => dom_id(candidate),
                     :remote => true) 
    else
      link_to_remote(t(:set_foreign_pay, :scope => [:txt, :view, :candidates, :_list, :rhtml]),
                     :url => { :action => 'set_foreign_payer', :id => candidate.id},
                     :method => :get,
                     :update => dom_id(candidate),
                     :remote => true) 
    end
  end
end

