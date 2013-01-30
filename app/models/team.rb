class Team < ActiveRecord::Base
  set_table_name(:teams)
  set_primary_keys(:teamID, :lgID, :yearID)

  has_many :playerships, foreign_key: [:teamID, :lgID, :yearID]
  has_many :managers, foreign_key: [:teamID, :lgID, :yearID]
  has_many :players, through: :playerships, source: :person, foreign_key: [:teamID, :lgID, :yearID]
end