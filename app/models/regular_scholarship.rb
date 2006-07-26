class RegularScholarship < Scholarship
  def self.prepare_for_this_month(index_id)
    unless rs = find_unpayed_by_index(index_id)
      rs = create('index_id' => index_id,
                  'amount' => ScholarshipCalculator.for(index_id))
    end
    return rs
  end

  def self.pay_for(index)
    return index.regular_scholarship.pay!
  end

  def code
    if index.payment_id == 3
      "#{index.faculty.stipendia_code}DCIR"
    else
      "#{index.faculty.stipendia_code}DTUR"
    end
  end

  def disponent
    if index.payment_id == 3
      "1301#{index.faculty.stipendia_code}9001131"
    else
      "1201#{index.faculty.stipendia_code}9001121"
    end
  end

  def self.create_for(index)
    create(:amount => ScholarshipCalculator.for(index), :index_id => index.id)
  end

  def self.sum_for(user)
    ids = Index.find_for_scholarship(user, :include => []).map &:id
    sum(:amount, :conditions => ["index_id in (?) and payed_on is null", ids]) 
  end
end
