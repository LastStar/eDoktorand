require 'abstract_unit'

ActiveRecord::Base.connection.drop_table :audited_users rescue nil
ActiveRecord::Base.connection.drop_table :audited_models rescue nil

ActiveRecord::Base.connection.create_table :audited_users do |t|
  t.column :login, :string
  t.column :created_by_id, :integer, :limit => 11
  t.column :created_at, :timestamp
end
    
ActiveRecord::Base.connection.create_table :audited_models do |t|
  t.column :data, :string
  t.column :created_by_id, :integer
  t.column :created_at, :timestamp
  t.column :updated_by_user_id, :integer
  t.column :updated_at, :timestamp
end

class AuditedUser < ActiveRecord::Base
  acts_as_audited :user_model => :audited_user
end

class AuditedModel < ActiveRecord::Base
  acts_as_audited :updated_by_column => 'updated_by_user_id', :user_model => :audited_user
end


class ActAsAuditedTest < Test::Unit::TestCase

  def setup
    @current_user = AuditedUser.create(:login => 'admin')    
    ActiveRecord::Acts::Audited.current_user = @current_user
  end

  def teardown
    @current_user.destroy    
    ActiveRecord::Acts::Audited.current_user = nil
  end

  def test_create
    u1 = AuditedUser.create(:login => 'user1')
    assert_equal(u1.created_by, @current_user)

    m = AuditedModel.create(:data => 'xyz')
    assert_equal(m.created_by, @current_user)
    assert_equal(m.updated_by, @current_user)
  end

  def test_update
    m = AuditedModel.new(:data => 'abc')
    m.save
      
    assert_equal(m.created_by, @current_user)
    assert_equal(m.updated_by, @current_user)
    
    user = AuditedUser.create(:login => 'other_user')
    ActiveRecord::Acts::Audited.current_user = user
    
    m.save
    assert_equal(m.created_by, @current_user)
    assert_equal(m.updated_by, user)
  end  
  
end

