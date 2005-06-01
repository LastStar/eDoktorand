class Approvement < ActiveRecord::Base
  belongs_to :tutor_statement
  belongs_to :leader_statement, :class_name => "Statement", :foreign_key => "leader_statement_id"
  belongs_to :dean_statement, :class_name => "Statement", :foreign_key => "dean_statement_id"
  belongs_to :board_statement, :class_name => "Statement", :foreign_key => "board_statement_id"
end
