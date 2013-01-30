class PitchingLine < ActiveRecord::Base
  set_table_name(:pitching)
  set_primary_keys(:playerID, :yearID, :stint)

  belongs_to :person, foreign_key: :playerID, primary_key: :playerID
end