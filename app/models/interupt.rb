require 'approvable'
class Interupt < ActiveRecord::Base

  include Approvable

  belongs_to :index
  has_one :approvement,
          :class_name => 'InteruptApprovement',
          :foreign_key => 'document_id'

  validates_presence_of :index

  before_validation :normalize_start_on

  # computes date it end from duration
  def end_on
    start_on.advance(:months => (duration - 1)).end_of_month
  end

  # returns current duration of interrupt
  def current_duration
    if finished?
      (finished_on - start_on).ceil
    elsif end_on.past?
      duration.months
    else
      (Time.current - start_on).ceil
    end
  end

  # returns true if interrupt is finished
  def finished?
    !finished_on.nil?
  end

  # finishes interrupt
  def finish!
    update_attribute(:finished_on, Time.now.end_of_month)
  end

  private
  # normalizes start on to beginning of the month
  # if start on set only!
  def normalize_start_on
    self.start_on = start_on.beginning_of_month if start_on
  end
end
