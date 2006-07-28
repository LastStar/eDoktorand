class Scholarship < ActiveRecord::Base
  belongs_to :index
  validates_presence_of :index, :amount
  acts_as_audited

  def self.find_unpayed_by_index(index)
    index = index.id if index.is_a? Index
    find(:first, :conditions => ['index_id = ? and payed_on is null', index])
  end

  def pay!
    update_attribute('payed_on', Time.now)
    return csv_row
  end

  def csv_row
    [index.student.sident, code, disponent, amount, nil, nil, nil, 
      (Time.now - 1.month).strftime('%Y%m')]
  end

  def self.pay_and_generate_for(user)
    indices = Index.find_studying_for(user)
    outfile = ''
    CSV::Writer.generate(outfile, ';') do |csv|
      indices.each do |i|
        if i.has_extra_scholarships?
          i.extra_scholarships.each {|es| csv << es.pay!}
        end
        if i.has_regular_scholarship? 
          if i.regular_scholarship.amount > 0
            csv << i.regular_scholarship.pay!
          end
        end
      end
    end
    outfile
  end
end
