class BattingLine < ActiveRecord::Base
  set_table_name(:batting)
  set_primary_keys(:playerID, :yearID, :stint)

  belongs_to :person, foreign_key: :playerID, primary_key: :playerID
end