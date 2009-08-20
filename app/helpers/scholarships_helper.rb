require 'scholarship_calculator'

module ScholarshipsHelper

  def describe_error(index)
    message = ""
    if index.account_number == nil
              message = message + t(:message_13, :scope => [:txt, :helper, :scholarships]) + " "
    end
    if index.account_bank_number == nil
              message = message + t(:message_14, :scope => [:txt, :helper, :scholarships]) + " "
    end
    if index.student.uic == nil
          message = message + t(:message_15, :scope => [:txt, :helper, :scholarships]) + " "
    end
    if index.student.sident == -666
          message = message + t(:message_16, :scope => [:txt, :helper, :scholarships]) + " "
    end
    if index.student.sident == nil
          message = message + t(:message_17, :scope => [:txt, :helper, :scholarships]) + " "    
    end
    return message
  end

  def detail_link(index)
    link_to_remote(image_tag('open.png'), 
                   :update => "scholarship_form_#{index.id}",
                   :complete => show_scholarship_form(index),
                   :url => {:action => 'detail', :id => index.id})
  end

  def detail_links(index)
    scholarships = ExtraScholarship.find_all_unpayed_by_index(index.id)
    link_to_function(image_tag('open.png')) do |page|
      page.insert_html :after, "index_#{index.id}",
        render(:partial => 'detail', :locals => {:scholarships => scholarships, :index => index})
    end
  end

  def change_link(object)
    if object.is_a?(Index)
      link_to_remote(image_tag('change.png', :title=>t(:message_0, :scope => [:txt, :helper, :scholarships])), 
                     :update => "regular_scholarship_#{object.id}",
                     :url => {:action => 'change', :id => object.id})
    else
      link_to_remote(image_tag('change.png'), 
                     :update => "scholarship_form_#{object.index.id}",
                     :url => {:action => 'edit', :id => object.id})
    end
  end
  
  def change_extra_link(object,id)
      link_to_remote(image_tag('change.png', :title=>t(:message_1, :scope => [:txt, :helper, :scholarships])), 
                     :update => id,
                     :url => {:action => 'edit', :id => object.id, :scholarship_id => id, :scholarship => '1'})
  end

  def add_link(index)
    link_to_remote(image_tag('plus.png', :title=>t(:message_2, :scope => [:txt, :helper, :scholarships])), 
                   :update => "scholarship_form_#{index.id}",
                   :complete => show_scholarship_form(index),
                   :url => {:action => 'add', :id => index.id})
  end

  def remove_link(scholarship)
    link_to_remote(image_tag('minus.png', :title=>t(:message_3, :scope => [:txt, :helper, :scholarships])), 
                   :complete => evaluate_remote_response,
                   :url => {:action => 'destroy', :id => scholarship.id})
  end

  def close_class_link(element, id)
    link_to_function(image_tag('close.png', :title=>t(:message_4, :scope => [:txt, :helper, :scholarships])), "$$('.extra_scholarships_#{id}').each(function(value) { value.hide(); });")
  end


  def close_link(element)
    link_to_function(image_tag('close.png'), "Element.hide('#{element}')")
  end

  def pay_link
    if @user.has_role?('supervisor') && 
      (ScholarshipApprovement.all_approved?)
      link_to(t(:message_5, :scope => [:txt, :helper, :scholarships]), {:action => 'pay'}, 
        :confirm => t(:message_6, :scope => [:txt, :helper, :scholarships]))
    end
  end

  def approve_link
    confirm = t(:message_7, :scope => [:txt, :helper, :scholarships])
    link_to(t(:message_8, :scope => [:txt, :helper, :scholarships]), {:action => :approve}, 
            :confirm => confirm)
  end

  def control_table_link
    link_to(t(:message_9, :scope => [:txt, :helper, :scholarships]), {:action => 'control_table'})
  end

  def claim_accomodation_scholarship_link
    link_to(t(:message_10, :scope => [:txt, :helper, :scholarships]), {:action => 'claim'})
  end

  def scholarship_field
    text_field('scholarship', 'amount', :size => 5)
  end

  def change_form(scholarship, &proc)
    form_remote_tag(:url => {:action => 'save', :id => scholarship}, 
                    :update => "regular_scholarship_#{scholarship.index.id}",
                    &proc)
  end

  def save_form(scholarship, &proc)
    form_remote_tag(:url => {:action => 'save', :id => scholarship}, 
                    #:update => "index_#{scholarship.index.id}",
                    &proc)
  end

  def show_scholarship_form(index)
    "Element.show('scholarship_form_#{index.id}')"
  end

  def recalculate_link
    link_to(t(:message_11, :scope => [:txt, :helper, :scholarships]), {:action => :recalculate}, 
            :confirm => t(:message_12, :scope => [:txt, :helper, :scholarships]))
  end
end
