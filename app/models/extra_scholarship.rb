class ExtraScholarship < Scholarship

  def self.find_all_unpayed_by_index(index_id)
    find(:all, :conditions => ['index_id = ? and payed_on is null', index_id])
  end

  def self.pay_for(index)
    find_all_unpayed_by_index(index).each do |es|
      es.pay!
    end
  end

  def print_commission
    [commission_head, commission_body, commission_tail].join('/')
  end
end
