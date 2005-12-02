class AddInteruptDuration < ActiveRecord::Migration
  def self.up
    add_column :interupts, :interupt_duration, :integer, :limit => 1
    add_column :interupts, :plan_changed, :integer, :limit => 1
    Role.find(3).permissions << Permission.create('name' =>'interupts/index')
    Role.find(3).permissions << Permission.create('name' =>'interupts/create')
    Role.find(3).permissions << Permission.create('name' =>'interupts/finish')
    Role.find(3).permissions << Permission.create('name' =>'study_plans/change')
    Role.find(3).permissions << Permission.create('name' =>'study_plans/save_full')
  end

  def self.down
    remove_column :interupts, :interupt_duration
    remove_column :interupts, :plan_changed
    Role.find(3).permissions.delete(Permission.find_by_name('interupts/index'
      ).destroy)
    Role.find(3).permissions.delete(Permission.find_by_name('interupts/create'
      ).destroy)
    Role.find(3).permissions.delete(Permission.find_by_name('study_plans/change'
      ).destroy)
    Role.find(3).permissions.delete(Permission.find_by_name('study_plans/save_full'
      ).destroy)
    Role.find(3).permissions.delete(Permission.find_by_name('interupts/finish'
      ).destroy)
  end
end
