-- Таблица команд
CREATE TABLE Teams (
    TeamID SERIAL PRIMARY KEY,
    TeamName VARCHAR(100) NOT NULL
);

-- Таблица игроков
CREATE TABLE Players (
    PlayerID SERIAL PRIMARY KEY,
    TeamID INT REFERENCES Teams(TeamID) ON DELETE SET NULL,
    Name VARCHAR(100) NOT NULL
);

-- Таблица матчей
CREATE TABLE Matches (
    MatchID SERIAL PRIMARY KEY,
    Team1ID INT REFERENCES Teams(TeamID) ON DELETE CASCADE,
    Team2ID INT REFERENCES Teams(TeamID) ON DELETE CASCADE,
    MatchDate DATE NOT NULL,
    Duration INTERVAL NOT NULL,
    ScoreTeam1 INT NOT NULL,
    ScoreTeam2 INT NOT NULL,
    Winner INT REFERENCES Teams(TeamID),
    Map VARCHAR(100) NOT NULL
);

-- Таблица оружия
CREATE TABLE Weapons (
    WeaponID SERIAL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Type VARCHAR(50) NOT NULL
);

-- Таблица агентов
CREATE TABLE Agents (
    AgentID SERIAL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Role VARCHAR(50) NOT NULL,
    Ability1 VARCHAR(100),
    Ability2 VARCHAR(100),
    Ability3 VARCHAR(100),
    Ultimate VARCHAR(100)
);

-- Таблица статистики игроков за матч
CREATE TABLE PlayerStats (
    PlayerStatID SERIAL PRIMARY KEY,
    PlayerID INT REFERENCES Players(PlayerID) ON DELETE CASCADE,
    MatchID INT REFERENCES Matches(MatchID) ON DELETE CASCADE,
    WeaponUsed INT REFERENCES Weapons(WeaponID),
    AgentUsed INT REFERENCES Agents(AgentID),
    PlayerName VARCHAR(100) NOT NULL,
    Kills INT NOT NULL DEFAULT 0,
    Deaths INT NOT NULL DEFAULT 0,
    Assists INT NOT NULL DEFAULT 0,
    HeadShots INT NOT NULL DEFAULT 0
);

-- Таблица общей статистики игроков
CREATE TABLE OverallPlayerStats (
    OverallStatID SERIAL PRIMARY KEY,
    PlayerID INT REFERENCES Players(PlayerID) ON DELETE CASCADE,
    FavoriteAgent INT REFERENCES Agents(AgentID),
    TotalMatches INT NOT NULL DEFAULT 0,
    TotalKills INT NOT NULL DEFAULT 0,
    TotalDeaths INT NOT NULL DEFAULT 0,
    TotalAssists INT NOT NULL DEFAULT 0,
    TotalHeadShots INT NOT NULL DEFAULT 0,
    TotalWins INT NOT NULL DEFAULT 0,
    TotalLosses INT NOT NULL DEFAULT 0,
    FavoriteRole VARCHAR(50)
);

INSERT INTO Matches (MatchID, Team1ID, Team2ID, MatchDate, Duration, ScoreTeam1, ScoreTeam2, Winner, Map)
VALUES
    (1, 1, 2, '2024-12-01', INTERVAL '45 minutes', 13, 9, 1, 'Ascent'),
    (2, 3, 4, '2024-12-02', INTERVAL '50 minutes', 13, 7, 3, 'Haven');

SELECT
    P.Name AS PlayerName,
    OPS.TotalMatches,
    OPS.TotalKills,
    OPS.TotalDeaths,
    OPS.TotalAssists,
    OPS.TotalHeadShots,
    OPS.TotalWins,
    OPS.TotalLosses,
    A.Name AS FavoriteAgent,
    OPS.FavoriteRole
FROM
    OverallPlayerStats OPS
JOIN
    Player P ON OPS.PlayerID = P.PlayerID
JOIN
    Agents A ON OPS.FavoriteAgent = A.AgentID;


SELECT
    P.Name AS PlayerName,
    M.MatchID,
    M.MatchDate,
    PS.Kills,
    PS.Deaths,
    PS.Assists,
    PS.HeadShots,
    A.Name AS AgentUsed,
    W.Name AS WeaponUsed
FROM
    PlayerStats PS
JOIN
    Player P ON PS.PlayerID = P.PlayerID
JOIN
    Matches M ON PS.MatchID = M.MatchID
JOIN
    Agents A ON PS.AgentUsed = A.AgentID
JOIN
    Weapons W ON PS.WeaponUsed = W.WeaponID
ORDER BY
    M.MatchDate DESC;


BEGIN;

-- Добавляем новый матч
INSERT INTO Matches (Team1ID, Team2ID, MatchDate, Duration, ScoreTeam1, ScoreTeam2, Winner, Map)
VALUES (1, 2, '2024-12-15', '01:30:00', 10, 8, 'Team1', 'Map1')
RETURNING MatchID INTO new_match_id;

-- Добавляем статистику для всех 10 игроков
INSERT INTO PlayerStats (PlayerID, MatchID, WeaponUsed, AgentUsed, Kills, Deaths, Assists, HeadShots)
VALUES
(1, new_match_id, 1, 1, 5, 2, 3, 1),
(2, new_match_id, 2, 2, 3, 1, 2, 0),
(3, new_match_id, 3, 3, 4, 3, 1, 2),
(4, new_match_id, 4, 1, 2, 4, 0, 1),
(5, new_match_id, 5, 2, 1, 1, 1, 0),
(6, new_match_id, 6, 1, 6, 3, 2, 2),
(7, new_match_id, 7, 2, 2, 2, 1, 0),
(8, new_match_id, 8, 3, 3, 4, 3, 3),
(9, new_match_id, 9, 1, 0, 5, 0, 0),
(10, new_match_id, 10, 2, 1, 1, 1, 0);

-- Обновляем общую статистику игроков
WITH updated_stats AS (
    SELECT
        PlayerID,
        SUM(Kills) AS NewKills,
        SUM(Deaths) AS NewDeaths,
        SUM(Assists) AS NewAssists,
        SUM(HeadShots) AS NewHeadShots
    FROM PlayerStats
    WHERE MatchID = new_match_id
    GROUP BY PlayerID
)
UPDATE OverallPlayerStats
SET
    TotalMatches = TotalMatches + 1,
    TotalKills = TotalKills + us.NewKills,
    TotalDeaths = TotalDeaths + us.NewDeaths,
    TotalAssists = TotalAssists + us.NewAssists,
    TotalHeadShots = TotalHeadShots + us.NewHeadShots,
    TotalWins = TotalWins + CASE WHEN Winner = OverallPlayerStats.PlayerID THEN 1 ELSE 0 END,
    TotalLosses = TotalLosses + CASE WHEN Winner != OverallPlayerStats.PlayerID THEN 1 ELSE 0 END
FROM updated_stats us
WHERE OverallPlayerStats.PlayerID = us.PlayerID;

COMMIT;
