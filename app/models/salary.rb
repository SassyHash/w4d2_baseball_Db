class Salary < ActiveRecord::Base
  set_table_name(:salaries)
  set_primary_keys(:yearID, :teamID, :lgID, :playerID)
  belongs_to :person, foreign_key: :playerID, primary_key: :playerID
end