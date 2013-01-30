class HallOfFame < ActiveRecord::Base
  set_table_name (:halloffame)
  set_primary_keys(:hofID, :yearID, :votedBy)
end