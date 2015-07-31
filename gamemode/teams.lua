TEAM_BLUE = 50
TEAM_RED = 51
TEAM_FFA = 52

team.SetUp(TEAM_BLUE, "Blue", Color(40, 40, 230))
team.SetUp(TEAM_RED, "Red", Color(30, 40, 40))
team.SetUp(TEAM_FFA, "NONE", Color(127, 127, 127))

team.SetSpawnPoint(TEAM_BLUE, { "info_player_counterterrorist" } )
team.SetSpawnPoint(TEAM_RED, { "info_player_terrorist" } )