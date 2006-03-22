require 'scholarship_calculator'

module ScholarshipsHelper

  def print_scholarship(index)
    ScholarshipCalculator.scholarship_for(index.student)
  end

  def detail_link(index)
    link_to_remote_with_loading(_("detail"), :update => "info#{index.id}",
                               :complete => "showDetail(#{index.id})",
                               :url => {:action => 'detail', :id => index.id})
  end

end
