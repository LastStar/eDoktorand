class ScholarshipMonth < ActiveRecord::Base
  has_many :scholarships

  def opened?
    opened_at.present?
  end

  def closed?
    closed_at.present?
  end

  def paid?
    paid_at.present?
  end

  def close!
    if paid?
      self.closed_at = Time.now
      save
      to_clone = RegularScholarship.all(:conditions => {:scholarship_month_id => self.id},
                                 :include => {:index => :student})
      month = ScholarshipMonth.open
      to_clone.each do |s|
        if s.index.studying?
          ns = s.clone
          ns.created_on = ns.updated_on = Time.now
          ns.scholarship_month = month
          ns.save
        end
      end
      return true
    else
      return false
    end
  end

  def pay!
    self.paid_at = Time.now
    save
  end

  def unpay!
    self.paid_at = nil
    save
  end

  class << self
    def open(datetime = Time.now)
      first(:conditions => {:closed_at => nil}) || create(:opened_at => datetime,
                        :title => datetime.strftime('%Y%m'),
                        :starts_on => datetime.beginning_of_month)
    end

    def current
      first(:conditions => {:closed_at => nil})
    end
  end
end
