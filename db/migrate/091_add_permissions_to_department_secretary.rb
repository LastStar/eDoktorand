class AddPermissionsToDepartmentSecretary < ActiveRecord::Migration
  def self.up
    Role.find_by_name("department_secretary").permissions << Permission.find_by_name('scholarships/list')
    Role.find_by_name("department_secretary").permissions << Permission.find_by_name('scholarships/index')
    Role.find_by_name("department_secretary").permissions << Permission.find_by_name('scholarships/prepare')
    Role.find_by_name("department_secretary").permissions << Permission.find_by_name('scholarships/save_scholarship')
    Role.find_by_name("department_secretary").permissions << Permission.find_by_name('scholarships/add')
    Role.find_by_name("department_secretary").permissions << Permission.find_by_name('scholarships/save')
    Role.find_by_name("department_secretary").permissions << Permission.find_by_name('scholarships/detail')
    Role.find_by_name("department_secretary").permissions << Permission.find_by_name('scholarships/sum')
  end

  def self.down
    Role.find_by_name("department_secretary").permissions.delete(Permission.find_by_name('scholarships/list'))
    Role.find_by_name("department_secretary").permissions.delete(Permission.find_by_name('scholarships/index'))
    Role.find_by_name("department_secretary").permissions.delete(Permission.find_by_name('scholarships/prepare'))
    Role.find_by_name("department_secretary").permissions.delete(Permission.find_by_name('scholarships/save_scholarship'))
    Role.find_by_name("department_secretary").permissions.delete(Permission.find_by_name('scholarships/add'))
    Role.find_by_name("department_secretary").permissions.delete(Permission.find_by_name('scholarships/save'))
    Role.find_by_name("department_secretary").permissions.delete(Permission.find_by_name('scholarships/sum'))
    
  end
end
