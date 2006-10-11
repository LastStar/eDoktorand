class DisertTheme < ActiveRecord::Base
  belongs_to :index
  validates_presence_of :title
  validates_presence_of :finishing_to
  acts_as_audited

  def validate
    if defense_passed_on && !index.final_exam_passed?
      errors.add(:defense_passed_on, _('not_passed_final_exam'))
    end
  end

  def self.save(disert_theme)
    File.open("#{RAILS_ROOT}/public/pdf/methodology#{disert_theme['id']}.pdf", "w") do |f|
      f.write(disert_theme['methodology_file'].read) 
    end
  end

  # return true if methodology added
  def has_methodology?
    return true if self.methodology_added_on
  end

  # return true if methodology summary added
  def has_methodology_summary?
    return true if methodology_summary && !methodology_summary.empty?
  end

  # resets disert theme
  def reset
    self.methodology_summary = nil
    self.methodology_summary_added_on = nil
    self.methodology_added_on = nil
    self.save
  end

  def defense_passed?
    !defense_passed_on.nil?
  end

  def defense_passed!(date = Date.today)
    update_attribute(:defense_passed_on, date)
  end
end
