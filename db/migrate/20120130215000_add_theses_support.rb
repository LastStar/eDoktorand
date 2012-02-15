class AddThesesSupport < ActiveRecord::Migration
  def self.up
    add_column :faculties, :theses_id, :string
    
    Faculty.find(1).update_attribute(:theses_id, 'S4121')
    Faculty.find(2).update_attribute(:theses_id, 'S419050')
    Faculty.find(3).update_attribute(:theses_id, 'S4141')
    Faculty.find(4).update_attribute(:theses_id, 'S4111')
    Faculty.find(5).update_attribute(:theses_id, 'S4131')
    Faculty.find(6).update_attribute(:theses_id, 'S4160')
    Faculty.find(14).update_attribute(:theses_id, 'S4133')
    Faculty.find(15).update_attribute(:theses_id, 'S4132')
    
    add_column :disert_themes, :theses_request, :text
    add_column :disert_themes, :theses_request_at, :datetime
    add_column :disert_themes, :theses_request_response, :text
    add_column :disert_themes, :theses_request_succesfull, :binary
    add_column :disert_themes, :theses_response, :text
    add_column :disert_themes, :theses_response_at, :datetime
    add_column :disert_themes, :theses_status, :integer
    
    create_table :theses_results do |t|
      t.integer :id
      t.integer :disert_theme_id
      t.integer :theses_score
      t.string :theses_filename
      t.string :theses_pdf

      t.timestamps
    end
  end

  def self.down
    remove_column :faculties, :theses_id
    
    remove_column :disert_themes, :theses_request
    remove_column :disert_themes, :theses_request_at
    remove_column :disert_themes, :theses_request_response
    remove_column :disert_themes, :theses_request_succesfull
    remove_column :disert_themes, :theses_response
    remove_column :disert_themes, :theses_response_at
    remove_column :disert_themes, :theses_status
    
    drop_table :theses_results
  end
end