require 'approvable'
class StudyInterrupt < ActiveRecord::Base

  include Approvable

  belongs_to :index
  has_one :approval,
          :class_name => 'InterruptApproval',
          :foreign_key => 'document_id'

  validates_presence_of :index

  before_validation :normalize_start_on

  # computes date it end from duration
  def end_on
    return unless duration
    if duration_in_days
      start_on.advance(:days => (duration - 1))
    else
      start_on.advance(:months => (duration - 1)).end_of_month
    end
  end

  # returns current duration of interrupt
  def current_duration
    return 0 unless duration
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
    unless duration_in_days
      self.start_on = start_on.beginning_of_month if start_on
    end
  end
end
