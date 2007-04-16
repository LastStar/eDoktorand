class AddBoardChairmanToRoles < ActiveRecord::Migration
  def self.up
    Role.create(:name => "board_chairman")
    Role.find_by_name("board_chairman").permissions << Permission.find_by_name("candidates/index")
    Role.find_by_name("board_chairman").permissions << Permission.find_by_name("candidates/list")
    Role.find_by_name("board_chairman").permissions << Permission.find_by_name("candidates/list_admission_ready")
    Role.find_by_name("board_chairman").permissions << Permission.find_by_name("candidates/show")
  end

  def self.down
    Role.find_by_name("board_chairman").destroy
  end
end
