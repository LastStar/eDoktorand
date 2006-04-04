class RegularScholarship < Scholarship
  def self.prepare_for_this_month(index_id)
    unless rs = find_unpayed_by_index(index_id)
      rs = create('index_id' => index_id,
                  'amount' => ScholarshipCalculator.for(index_id))
    end
    return rs
  end

  def self.pay_for(index)
    index.current_regular_scholarship.pay!
  end
end
