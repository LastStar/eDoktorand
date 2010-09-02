class AddCodeToStudy < ActiveRecord::Migration
  def self.up
    add_column :studies, :code, :string
    Study.reset_column_information
    Study.find_by_name_en('full time').update_attribute(:code, 'D')
    Study.find_by_name_en('combined').update_attribute(:code, 'E')
  end

  def self.down
    remove_column :studies, :code
  end
end
