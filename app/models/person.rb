class Person < ActiveRecord::Base
  set_table_name(:master)
  set_primary_key(:lahmanID)

  has_many :playerships, foreign_key: :playerID, primary_key: :playerID
  has_many :teams, through: :playerships

  has_many :batting_lines, foreign_key: :playerID, primary_key: :playerID
  has_many :pitching_lines, foreign_key: :playerID, primary_key: :playerID
  has_many :salaries, foreign_key: :playerID, primary_key: :playerID
  has_many :managers, :through => :teams

  has_many :managerships, foreign_key: :managerID, primary_key: :managerID
  has_many :managed_teams, through: :managerships, source: :team
  has_many :managed_players, through: :managed_teams, source: :players


  def best_year
    Person.select("master.nameNick, batting.H/batting.AB AS bat_average, batting.yearID AS yearID")
      .joins(:batting_lines)
      .where('batting.playerID = (?)', self.playerID)
      .group(:yearID)
      .order('bat_average DESC')
      .first
  end

  def self.random_good_player
    Person.select("master.*, H/AB AS bat_avg, batting.AB AS at_bats")
      .joins(:batting_lines)
      .where('batting.AB > 100')
      .where('(H/AB) > 0.3')
      .group(:playerID)
      .group(:yearID)
      .limit(5)
  end

  def self.longest_experience
    Person.select("master.*, finalGame - debut AS length")
      .order('length DESC')
      .limit(10)
  end

  def self.managed_most_players
    Person.select('master.*, COUNT(DISTINCT players.playerID) AS managed_players')
      .joins(:managed_teams => :playerships)
      .joins('JOIN master AS players ON players.playerID = appearances.playerID')
      .group(:managerID)
      .order('managed_players DESC')
      .limit(5)
  end

  def self.managers_who_were_players
    Person.select('master.*')
      .where('managerID != ""')
      .where('playerID != ""')
  end

  def self.most_teams_in_a_year
    Person.select('master.*, COUNT(DISTINCT teams.teamID) AS num_teams')
      .joins(:teams)
      .group('teams.yearID')
      .group('master.playerID')
      .order('num_teams DESC')
      .limit(5)
  end

  def self.one_team_in_career
    teams_in_career = Person.select('master.*, COUNT(DISTINCT teams.teamID) AS num_teams')
      .joins(:teams)
      .group('master.playerID')

    one_team = teams_in_career.select do |team|
      team.num_teams == 1
    end

    one_team
  end

  def self.played_for_at_least_n_years(n)
    Person.select("DISTINCT master.*")
      .joins(:playerships)
      .where('experience >= (?)', n)
  end


  def self.most_teams_in_career
    Person.select('master.*, COUNT(DISTINCT teams.teamID) AS num_teams')
      .joins(:teams)
      .group('master.playerID')
      .order('num_teams DESC')
      .limit(5)
  end
end

