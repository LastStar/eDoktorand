class DisertTheme < ActiveRecord::Base

  belongs_to :index
  validates_presence_of :title, :message => I18n::t(:title_must_be_present, :scope => [:model, :theme])
  validates_presence_of :finishing_to

  before_create :set_actual
  after_create :copy_methodology
  has_many :theses_results

  def validate
    if defense_passed_on && !index.final_exam_passed?
      errors.add(:defense_passed_on, t(:did_not_passed_final_exam, :scope => [:model, :theme]))
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
    true if defense_passed_on && defense_passed_on <= date
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

  def save_disert_theme_file(file)
    File.open("#{RAILS_ROOT}/public/pdf/disert_theme/#{self.id}.pdf", "w") do |f|
      f.write(file.read)
    end
  end

  def save_review_file(file)
    File.open("#{RAILS_ROOT}/public/pdf/review/#{self.id}.pdf", "w") do |f|
      f.write(file.read)
    end
  end

  def save_signed_protocol_file(file)
    File.open("#{RAILS_ROOT}/public/pdf/signed_protocol/#{self.id}.pdf", "w") do |f|
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

  # select disert themes ready for theses_periodical_check
  def self.ready_for_theses_check(ago = 2.days.ago)
    DisertTheme.all(:conditions => ["theses_response_at IS NULL AND theses_request_succesfull = 1 AND theses_request_at <=  ?", ago])
  end

  def self.ready_to_send_to_theses_check(remaining = 10.days.since)
    ids = Defense.all(:conditions => ["date <= ?", remaining], :select => 'index_id').map(&:index_id)
    DisertTheme.all(:conditions => ["index_id in (?)", ids])
  end
end
