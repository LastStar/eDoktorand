class RegularScholarship < Scholarship

  def self.find_unpaid_by_index(index)
    find(:first, :conditions => ['index_id = ? and scholarship_month_id = ?',
                                 index, ScholarshipMonth.current.id],
                 :order => 'updated_on desc')
  end

  def self.prepare_for_this_month(index)
    unless rs = find_unpaid_by_index(index)
      rs = create('index_id' => index.id,
                  'amount' => ScholarshipCalculator.for(index))
    end
    return rs
  end

  def self.pay_for(index)
    return index.regular_scholarship.pay!
  end

  def code
    if index.foreigner?
      "#{short_code}DCIR"
    else
      "#{short_code}DTUR"
    end
  end

  def disponent
    if index.foreigner?
      "1301#{index.faculty.stipendia_code}1131"
    else
      "1201#{index.faculty.stipendia_code}1121"
    end
  end

  def self.create_for(index)
    index.regular_scholarship = create(:amount => ScholarshipCalculator.for(index))
  end

  def self.sum_for(user)
    ids = Index.find_for_scholarship(user, {:include => :disert_theme}).map &:id
    sum(:amount, :conditions => ["index_id in (?) and scholarship_month_id = ?", ids, ScholarshipMonth.current.id])
  end

  def self.recalculate_amount(indices)
    indices.each do |i|
      if i.has_regular_scholarship?
        rs = i.regular_scholarship_or_create
        unless (new_amount = ScholarshipCalculator.for(i)) == rs.amount
          logger.debug "DEBUG: New amount for student #{i.student.display_name}
                        from #{rs.amount} to #{new_amount}"
          i.regular_scholarship.update_attribute(:amount, new_amount)
        end
      end
    end
  end
end
