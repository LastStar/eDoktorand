class AdmittanceTheme < ActiveRecord::Base
  belongs_to :specialization
  belongs_to :department
  belongs_to :tutor

  validates_presence_of :name

  def display_name
    "#{name} (#{self.tutor.display_name})"
  end

  def self.has_for?(specialization)
    exists?({:specialization_id => specialization.id})
  end

  def self.departments_for_specialization(specialization)
    all(:conditions => {:specialization_id => specialization.id}).map(&:department).uniq
  end
end
