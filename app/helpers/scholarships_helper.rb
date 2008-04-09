require 'scholarship_calculator'

module ScholarshipsHelper

  def detail_link(index)
    link_to_remote(image_tag('open.png'), 
                   :update => "scholarship_form_#{index.id}",
                   :complete => show_scholarship_form(index),
                   :url => {:action => 'detail', :id => index.id})
  end

  def detail_links(index)
    link_to_function(image_tag('open.png')) do |page|
      page.insert_html :after, "index_#{index.id}",
      render(:partial => 'detail', :locals=>{:scholarships => scholarships = ExtraScholarship.find_all_unpayed_by_index(index.id), :index => index})
    end
  end

  def change_link(object)
    if object.is_a?(Index)
      link_to_remote(image_tag('change.png'), 
                     :update => "regular_scholarship_#{object.id}",
                     :url => {:action => 'change', :id => object.id})
    else
      link_to_remote(image_tag('change.png'), 
                     :update => "scholarship_form_#{object.index.id}",
                     :url => {:action => 'edit', :id => object.id})
    end
  end
  
  def change_extra_link(object,id)
      link_to_remote(image_tag('change.png'), 
                     :update => id,
                     :url => {:action => 'edit', :id => object.id, :scholarship_id => id, :scholarship => '1'})
  end

  def add_link(index)
    link_to_remote(image_tag('plus.png'), 
                   :update => "scholarship_form_#{index.id}",
                   :complete => show_scholarship_form(index),
                   :url => {:action => 'add', :id => index.id})
  end

  def remove_link(scholarship)
    link_to_remote(image_tag('minus.png'), 
                   :complete => evaluate_remote_response,
                   :url => {:action => 'destroy', :id => scholarship.id})
  end

  def close_class_link(element, id)
    link_to_function(image_tag('close.png'), "$$('.extra_scholarships_#{id}').each(function(value) { value.hide(); });")
  end


  def close_link(element)
    link_to_function(image_tag('close.png'), "Element.hide('#{element}')")
  end

  def pay_link
    if @user.has_role?('supervisor') && 
      (ScholarshipApprovement.all_approved? || !Scholarship.prepare_time?)
      link_to(_('pay'), {:action => 'pay'}, 
        :confirm => _('Are you sure to pay all scholarships. Operation is irreversible'))
    end
  end

  def approve_link
    confirm = _('Are you sure to approve scholarships like this. ' +
                'Operation is irreversible.')
    link_to(_('approve'), {:action => :approve}, 
            :confirm => confirm)
  end

  def control_table_link
    link_to(_('control table'), {:action => 'control_table'})
  end

  def claim_accomodation_scholarship_link
    link_to(_('claim_accomodation_scholarship'), {:action => 'claim'})
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
                    :update => "index_#{scholarship.index.id}",
                    &proc)
  end

  def show_scholarship_form(index)
    "Element.show('scholarship_form_#{index.id}')"
  end

  def recalculate_link
    link_to(_('recalculate'), {:action => :recalculate}, 
            :confirm => _('Are you sure to recalculate amounts?'))
  end
end
