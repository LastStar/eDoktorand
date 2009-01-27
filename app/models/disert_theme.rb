class DisertTheme < ActiveRecord::Base
  untranslate_all
  belongs_to :index
  validates_presence_of :title, :message => t(:message_0, :scope => [:txt, :model, :theme])
  validates_presence_of :finishing_to
  acts_as_audited

  before_create :set_actual
  after_create :copy_methodology

  def validate
    if defense_passed_on && !index.final_exam_passed?
      errors.add(:defense_passed_on, t(:message_1, :scope => [:txt, :model, :theme]))
    end
  end

  def self.save_methodology(disert_theme, file)
    File.open("#{RAILS_ROOT}/public/pdf/methodology/#{disert_theme.id}.pdf", "w") do |f|
      f.write(file.read) 
    end
    disert_theme.update_attribute('methodology_added_on', Time.now)
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

  def defense_passed?(date = Date.today)
    true if defense_passed_on && defense_passed_on < date
  end

  def defense_passed!(date = Date.today)
    update_attribute(:defense_passed_on, date)
  end

  def save_literature_review(file)
    File.open("#{RAILS_ROOT}/public/pdf/literature_review/#{self.id}.pdf", "w") do |f|
      f.write(file.read)
    end
  end

  def save_self_report_file(file)
    File.open("#{RAILS_ROOT}/public/pdf/self_report/#{self.id}.pdf", "w") do |f|
      f.write(file.read)
    end
  end

  def save_theme_file(file)
    File.open("#{RAILS_ROOT}/public/pdf/disert_theme/#{self.id}.pdf", "w") do |f|
      f.write(file.read)
    end
  end

  private
  def set_actual
    if old_actual = DisertTheme.find_by_index_id_and_actual(self.index.id, 1)
      if has_methodology?
        FileUtils.cp("#{RAILS_ROOT}/public/pdf/methodology/#{old_actual.id}.pdf",
                     "#{RAILS_ROOT}/public/pdf/methodology/temp_#{self.index.id}.pdf")
      end
      old_actual.update_attribute(:actual, 0)
    end
    self.actual = 1
  end

  def copy_methodology
    if has_methodology?
      FileUtils.mv("#{RAILS_ROOT}/public/pdf/methodology/temp_#{self.index.id}.pdf",
                   "#{RAILS_ROOT}/public/pdf/methodology/#{self.id}.pdf")
    end

  end
end
