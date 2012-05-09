class CreateScholarshipMonths < ActiveRecord::Migration
  def self.up
    create_table :scholarship_months do |t|
      t.datetime :opened_at
      t.datetime :closed_at
      t.datetime :paid_at
      t.date :starts_on
      t.string :title

      t.timestamps
    end

    remove_column :scholarships, :label
    remove_column :scholarships, :content
    add_column :scholarships, :scholarship_month_id, :integer
    month = ScholarshipMonth.open
    puts 'Adding schoalrship month to scholarships ...'
    Scholarship.all(:conditions => {:payed_on => nil}).each {|s| s.scholarship_month = month;s.save}
    puts 'Done'
    %w(scholarships/unpay scholarships/close).each {|perm| Role.find_by_name('supervisor').permissions << Permission.create(:name => perm)}
  end

  def self.down
    drop_table :scholarship_months
    add_column :scholarships, :label, :string
    add_column :scholarships, :content, :string
    remove_column :scholarships, :scholarship_month_id
    %w(scholarships/unpay scholarships/close).each {|perm| Permission.find_by_name(perm).destroy}
  end
end
