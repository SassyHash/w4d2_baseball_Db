class Team < ActiveRecord::Base
  set_table_name(:teams)
  set_primary_keys(:teamID, :lgID, :yearID)

  has_many :playerships, foreign_key: [:teamID, :lgID, :yearID]
  has_many :managers, foreign_key: [:teamID, :lgID, :yearID]
  has_many :players, through: :playerships, source: :person, foreign_key: [:teamID, :lgID, :yearID]

  def self.greatest_improvement
    Team.select("teams.*, second_year.W - teams.W AS improvement")
      .where("second_year.W > teams.W")
      .joins("JOIN teams AS second_year ON teams.teamID = second_year.teamID")
      .where("teams.yearID = (second_year.yearID - 1)")
      .group('teams.yearID')
      .group('teams.teamID')
      .order('improvement DESC')
      .first
  end

  def self.moved_most
    Team.select("teams.*, COUNT(DISTINCT park) AS moves")
      .group('teams.teamID')
      .order('moves DESC')
      .first
  end

  def self.ws_wins
    Team.select("teams.*, COUNT(teams.WSWin) AS winz")
      .where("WSWin IS NOT NULL")
      .group('teams.teamID')
      .group('teams.yearID')
      .order("winz DESC")
  end

  def self.lg_wins
    Team.select("teams.*, COUNT(teams.LgWin) AS winz")
      .where("LgWin != 'N'")
      .where("WSWin IS NULL")
      .group('teams.teamID')
      .group('teams.yearID')
      .order("winz DESC")
  end
end