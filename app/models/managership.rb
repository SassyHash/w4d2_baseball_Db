class Managership < ActiveRecord::Base
  set_table_name(:managers)
  set_primary_keys(:managerID, :yearID, :teamID, :inseason)

  belongs_to :team, foreign_key: [:teamID, :lgID, :yearID]
  belongs_to :person, foreign_key: :managerID, primary_key: :managerID
end