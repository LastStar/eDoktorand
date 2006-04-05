class Scholarship < ActiveRecord::Base
  belongs_to :index
  validates_presence_of :index, :amount
  acts_as_audited

  def self.find_unpayed_by_index(index_id)
    find(:first, :conditions => ['index_id = ? and payed_on is null', index_id])
  end

  def pay!
    update_attribute('payed_on', Time.now)
  end
end
