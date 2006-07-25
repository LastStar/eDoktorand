require 'scholarship_calculator'

module ScholarshipsHelper

  def detail_link(index)
    link_to_remote(image_tag('open.png'), 
                   :update => "scholarship_form_#{index.id}",
                   :complete => show_scholarship_form(index),
                   :url => {:action => 'detail', :id => index.id})
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

  def close_link(element)
    link_to_function(image_tag('close.png'), "Element.hide('#{element}')")
  end

  def pay_link
    link_to(_('pay'), {:action => 'pay'}, :confirm => _('are_you_sure_to_pay'))
  end

  def sum_link
    link_to_remote(_('sum'), :url => {:action => 'sum'}, 
                   :evaluate_remote_response => true, :update => 'sum',
                   :complete => "$('sum').show()")
  end

  def scholarship_field
    text_field('scholarship', 'amount', :size => 5)
  end

  def change_form(scholarship)
    form_remote_tag(:url => {:action => 'save', :id => scholarship}, 
                    :update => "regular_scholarship_#{scholarship.index.id}")
  end

  def save_form(scholarship)
    form_remote_tag(:url => {:action => 'save', :id => scholarship}, 
                    :update => "index_#{scholarship.index.id}")
  end

  def show_scholarship_form(index)
    "Element.show('scholarship_form_#{index.id}')"
  end
end
