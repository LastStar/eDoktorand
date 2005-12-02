require 'approvable'
class Interupt < ActiveRecord::Base
  include Approvable
  belongs_to :index
  validates_presence_of :index
  has_one :approvement, :class_name => 'InteruptApprovement', :foreign_key =>
    'document_id'
  def end_on
    start_on + duration.month
  end
end
