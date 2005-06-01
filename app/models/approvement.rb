class Approvement < ActiveRecord::Base
  belongs_to :tutor_statement
  belongs_to :leader_statement
  belongs_to :dean_statement
  belongs_to :board_statement
end
