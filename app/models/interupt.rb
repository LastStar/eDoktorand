require 'approvable'
class Interupt < ActiveRecord::Base
  include Approvable
  belongs_to :index
  has_one :approvement, :class_name => 'InteruptApprovement', :foreign_key =>
    'document_id'
  validates_presence_of :index
  def end_on
    (start_on + duration.month).end_of_month
  end
  # returns current duration of interrupt in months
  def current_duration
    if end_on < Time.now
      duration.months
    else
      Time.now - start_on
    end
  end
  # returns true if interupt is finished
  def finished?
    !finished_on.nil?
  end
end
