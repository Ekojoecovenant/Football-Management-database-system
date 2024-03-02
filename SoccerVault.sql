-- Creating a database called SoccerVault
CREATE DATABASE SoccerVault;

-- Switching from Master database to SoccerVault database
USE SoccerVault;

-- Creating a Schema called Core Entities
CREATE SCHEMA CoreEntities;

-- Creating a schema called Trophy
CREATE SCHEMA Trophy;

-- Creating a schema called Additional Info
CREATE SCHEMA AdditionalInfo;

-- Table 1: Teams table in the Core Entities Schema/Folder
CREATE TABLE CoreEntities.Teams (
    TeamID int identity(1,1) primary key,
    TeamName varchar(35) unique NOT NULL,
    City varchar(18) NOT NULL,
    Stadium varchar(40) NOT NULL,
    EstablishedYear int NOT NULL,
    Logo varchar(150) -- To store the URL links of the team's logo
);

-- Table 2: Players table in the Core Entities Schema/Folder
CREATE TABLE CoreEntities.Players (
    PlayerID int identity(1,1) primary key,
    FirstName varchar(30) NOT NULL,
    LastName varchar(30) NOT NULL,
	PhoneNumber char(11) not null unique,
	Email varchar(40) not null unique,
    Position varchar(18) not null,
    Nationality varchar(20) not null,
    DateOfBirth date not null,
    TeamID int foreign key references CoreEntities.Teams(TeamID) not null,
    JerseyNumber int not null,
    Height decimal(5, 2) not null,
    Weight decimal(5, 2) not null
);

-- Table 3: Referees table in the CoreEntities Schema/Folder
CREATE TABLE CoreEntities.Referees (
    RefereeID int identity(1,1) primary key,
    FirstName varchar(30) not null,
    LastName varchar(30) not null,
	PhoneNumber char(11) not null unique,
	Email varchar(40) not null unique,
    Nationality varchar(20) not null,
    DateOfBirth date not null,
    MatchesOfficiated int,
    ExperienceLevel varchar(14) check(ExperienceLevel IN('Novice', 'Intermediate', 'Experienced' ,'Professional')) NOT NULL
);

-- Table 4: Matches table in the Core Entities Schema/Folder
CREATE TABLE CoreEntities.Matches (
    MatchID int identity(1,1) primary key,
    HomeTeamID int foreign key references CoreEntities.Teams(TeamID) NOT NULL,
    AwayTeamID int foreign key references CoreEntities.Teams(TeamID) NOT NULL,
    Date date NOT NULL,
    Time time not null,
    Stadium varchar(30) not null,
	HomeGoals int not null,
	AwayGoals int not null,
    RefereeID int foreign key references CoreEntities.Referees(RefereeID) not null,
    Attendance int not null
);

-- Table 5: Leagues table in the Core Entities Schema/Folder
CREATE TABLE CoreEntities.Leagues (
    LeagueID int identity(1,1) primary key,
    LeagueName varchar(30) not null,
    Country varchar(18) not null,
    SeasonStartYear int not null,
    SeasonEndYear int
);

-- Table 6: Standings table in the Core Entities Schema/Folder
CREATE TABLE CoreEntities.Standings (
    StandingID int identity(1,1) primary key,
    TeamID int foreign key references CoreEntities.Teams(TeamID) not null,
    LeagueID int foreign key references CoreEntities.Leagues(LeagueID) not null,
    Season varchar(10) not null,
    Position int,
    Played int,
    Won int,
    Drawn int,
    Lost int,
    GoalsFor int,
    GoalsAgainst int,
    GoalDifference AS (GoalsFor - GoalsAgainst),
    Points AS ((Won*3) + Drawn)
);

-- Table 7: Coaches table in the Core Entities Schema/Folder
CREATE TABLE CoreEntities.Coaches (
    CoachID int identity(1,1) primary key,
    FirstName varchar(30) not null,
    LastName varchar(30) not null,
	PhoneNumber char(11) not null unique,
	Email varchar(40) not null unique,
    Nationality varchar(20) not null,
    DateOfBirth date not null,
    TeamID int foreign key references CoreEntities.Teams(TeamID),
    YearsExperience int
);

-- Table 8: PlayerStatistics table in the AdditionalInfo Schema/Folder
CREATE TABLE AdditionalInfo.PlayerStatistics (
    StatisticID int identity(1,1) primary key,
    PlayerID int foreign key references CoreEntities.Players(PlayerID) not null,
    TotalMatchPlayed int,
	GoalsScored int,
    Assists int,
    YellowCards int,
    RedCards int,
    ShotsOnTarget int,
    PassesCompleted int,
    Tackles int,
    Interceptions int
);

-- Table 9: Injuries table in the AdditionalInfo Schema/Folder
CREATE TABLE AdditionalInfo.Injuries (
    InjuryID int identity(1,1) primary key,
    PlayerID int foreign key references CoreEntities.Players(PlayerID) not null,
    InjuryType varchar(100) not null,
    Date date not null,
    ExpectedRecoveryDate date
);

-- Table 10: Transfers table in the AdditionalInfo Schema/Folder
CREATE TABLE AdditionalInfo.Transfers (
    TransferID int identity(1,1) primary key,
    PlayerID int foreign key references CoreEntities.Players(PlayerID) not null,
    FromTeamID int foreign key references CoreEntities.Teams(TeamID),
    ToTeamID int foreign key references CoreEntities.Teams(TeamID) not null,
    TransferFee decimal(10,2) not null,
    TransferDate date not null
);

-- Table 11: Cups table in the Trophy Schema/Folder
CREATE TABLE Trophy.Cups (
	CupID int identity(1,1) primary key,
	CupName varchar(25) not null,
	Season varchar(10) not null,
	WinnerTeamID int foreign key references CoreEntities.Teams(TeamID) not null
);

-- Table 12: LeagueTrophies table in the Trophy Schema/Folder
CREATE TABLE Trophy.LeagueTrophies (
	TrophyID int identity(1,1) primary key,
	LeagueID int foreign key references CoreEntities.Leagues(LeagueID) not null,
	Season varchar(10) not null,
	WinnerTeamID int foreign key references CoreEntities.Teams(TeamID) not null
);

-- To INSERT INTO THE SoccerVault Database Tables
USE SoccerVault;

-- Inserting records into the Teams table
USE SoccerVault
INSERT INTO CoreEntities.Teams
VALUES
	('Manchester United', 'Manchester', 'Old Trafford', 1878, 'https://pin.it/3Wf6XMMiW'),
	('Real Madrid', 'Madrid', 'Santiago Bernabeu', 1902, 'https://pin.it/2TzEu6jcE'),
	('FC Barcelona', 'Barcelona', 'Camp Nou', 1899, 'https://pin.it/5Wp0tl8QO'),
	('Bayern Munich', 'Munich', 'Allianz Arena', 1900, 'https://pin.it/469U7bRJz'),
	('Liverpool', 'Liverpool', 'Anfield', 1892, 'https://pin.it/6qRmYoZNg'),
	('Juventus', 'Turin', 'Allianz Stadium', 1897, 'https://pin.it/7m5HApZqD'),
	('Paris Saint-Germain', 'Paris', 'Parc des Princes', 1970, 'https://pin.it/cPt1qYZkg'),
	('Chelsea', 'London', 'Stamford Bridge', 1905, 'https://pin.it/5F1tdz7Qh'),
	('AC Milan', 'Milan', 'San Siro', 1899, 'https://pin.it/BkR4E13mS'),
	('Inter Milan', 'Milan', 'San Siro', 1908, 'https://pin.it/gZBzz9eeH'),
	('Manchester City', 'Manchester', 'Etihad Stadium', 1880, 'https://pin.it/2XXAdRvP6'),
	('Atletico Madrid', 'Madrid', 'Civitas Metropolitano', 1903, 'https://pin.it/49CRNgO3W'),
	('Arsenal', 'London', 'Emirates Stadium', 1886, 'https://pin.it/5lcTZqBaK'),
	('Tottenham Hotspur', 'London', 'Tottenham Hotspur Stadium', 1882, 'https://pin.it/24oS2Y2Jv'),
	('Ajax', 'Amsterdam', 'Johan Cruyff Arena', 1900, 'https://pin.it/5MeyO3kAG')
;

-- Inserting records into the Players table
USE SoccerVault

INSERT INTO CoreEntities.Players
VALUES
	('Robert', 'Lewandowski', '08061234567', 'robertlewandowski1988@gmail.com', 'Forward', 'Poland', '1988-8-21',3,9,185,81),
	('Kevin', 'De Bruyne', '09099887766', 'kevindebruyne1991@gmail.com', 'Midfielder', 'Belgium', '1991-6-28',11,17,181,70),
	('Kylian', 'Mbappe', '08123456789', 'kylianmbappe1998@gmail.com', 'Forward', 'France', '1998-12-20',7,7,178,75),
	('Luka', 'Modric', '07055443322', 'lukamodric1985@gmail.com', 'Midfielder', 'Croatia', '1985-9-9',2,10,172,66),
	('Erling', 'Haaland', '08098765432', 'erlinghaaland2000@gmail.com', 'Forward', 'Norway', '2000-7-21',11,9,195,88),
	('Harry', 'Kane', '09011223344', 'harrykane1993@gmail.com', 'Forward', 'England', '1993-7-28',4,9,188,66),
	('Virgil', 'Van Dijk', '08187654321', 'virgilvandijk1991@gmail', 'Defender', 'Netherlands', '1991-7-8',5,4,195,92),
	('Paul', 'Pogba', '07033445566', 'paulpogba1993@gmail.com', 'Midfielder', 'France', '1993-3-15',6,10,191,84),
	('Jude', 'Bellingham', '08022334455', 'judebellingham2003@gmail.com', 'Midfielder', 'England', '2003-06-29',2,5,186,75),
	('Vinicius', 'Junior', '09066778899', 'viniciusjunior2000@gmail.com', 'Forward', 'Brazil', '2000-7-12',2,7,176,73),
	('Thibaut', 'Courtois', '08134567890', 'thibautcourtois1992@gmail.com', 'GoalKeeper', 'Belgium', '1992-5-11',2,1,200,96),
	('Gabriel', 'Martinelli', '07099887766', 'gabrielmartinelli2001@gmail.com', 'Forward', 'Brazil', '2001-6-18',13,11,178,75),
	('Gabriel', 'Jesus', '08044332211', 'gabrieljesus1997@gmail.com', 'Forward', 'Brazil', '1997-4-3',13,9,175,73),
	('Harry', 'Maguire', '09055667788', 'harrymaguire1993@gmail.com', 'Defender', 'England', '1993-3-5',1,5,194,90),
	('Luke', 'Shaw', '08111002233', 'lukeshaw1995@gmail.com', 'Defender', 'England', '1995-7-12',1,23,185,75),
	('Marcus', 'Rashford', '07088990011', 'marcusrashford1997@gmail.com', 'Forward', 'England', '1997-10-31',1,10,180,70)
;

-- Inserting records into the Referees table
INSERT INTO CoreEntities.Referees
VALUES 
	('Marcus', 'Johnson', '08077665544', 'marcusjohnson1978@gmail.com', 'Brazil', '1978-3-18',187, 'Experienced'),
	('Miguel', 'Sanchez', '09023456789', 'miguelsanchex1972@gmail.com', 'Belgium', '1972-10-28',208, 'Professional'),
	('Jamal', 'Wright', '08199887766', 'jamalwright1963@gmail.com', 'Croatia', '1963-9-1', 201, 'Professional'),
	('Kevin', 'Lee', '07011223344', 'kevinlee1980@gmail.com', 'China', '1980-7-17', 163, 'Intermediate'),
	('Gavin', 'Evans', '08033445566', 'gavinevans1989@gmail.com', 'USA', '1989-1-31',83, 'Novice')
;

-- Inserting records into the Matches table
INSERT INTO CoreEntities.Matches
VALUES
	(2,1,'2024-1-20', '18:00:00', 'Santiago Bernabeu', 4, 2, 2, 142090),
	(8,5,'2024-1-23', '12:00:00', 'Stamford Bridge', 0, 1, 1, 89023),
	(7,4,'2024-1-23', '15:00:00', 'Parc des Princes', 2, 2, 5, 92034),
	(11,13,'2024-1-23', '18:30:00', 'Etihad Stadium', 4, 3, 3, 122901),
	(10,12, '2024-2-1', '12:00:00', 'San Siro', 1, 3, 4, 73934),
	(2,3, '2024-2-17', '20:00:00', 'Santiago Bernabeu', 8, 7, 3, 169283)
;

-- Inserting records into the Leagues table
INSERT INTO CoreEntities.Leagues
VALUES
	('Premier League', 'England', 1992, null),
	('La Liga', 'Spain', 1929, null),
	('Bundesliga', 'Germany', 1963, null),
	('Serie A', 'Italy', 1898, null),
	('Ligue 1', 'France', 1932 , null)
;

-- Inserting records into the Standings table
INSERT INTO CoreEntities.Standings
(TeamID, LeagueID, Season, Position, Played, Won, Drawn, Lost, GoalsFor, GoalsAgainst)
VALUES
	(1,1,'2022/23',3,38,23,6,9,58,43),
	(2,2,'2022/23',1,38,28,4,6,70,20),
	(3,2,'2022/23',2,38,24,6,8,75,36),
	(5,1,'2022/23',5,38,19,10,9,75,47),
	(6,4,'2022/23',7,38,22,6,10,56,33),
	(8,1,'2022/23',12,38,11,11,16,38,47)
;

-- Inserting records into the Coaches
INSERT INTO CoreEntities.Coaches
VALUES
	('Erik', 'ten Hag', '08122334455', 'eriktenhag1971@gmail.com', 'Brazil', '1971-5-3', 1, 10),
	('Carlo', 'Ancelotti', '07066778899', 'carloancelotti@gmail.com', 'Spain', '1963-11-21', 2, 17),
	('Reven', 'Whythe', '08055667788', 'revenwhythe1969@gmail.com', 'England', '1969-10-5', 3,13),
	('Shaun', 'Wright', '09099887766', 'shaunwright1970@gmail.com', 'Spain', '1970-6-14', 4, 11),
	('David', 'Lester', '08144332211', 'davidlester1962@gmail.com', 'England', '1962-7-20', 5, 15)
;

-- Inserting into the PlayerStatistics table
INSERT INTO AdditionalInfo.PlayerStatistics
VALUES
	(4, 1, 1, 2, null, null, 4, 87, 13, 28),
	(16, 1, 2, null, 1, null, 7, 21, 3, 7),
	(5, 4, 3, null, null, null, 5, 15, 2, 6),
	(2, 4, 1, 3, null, null, 3, 88, 19, 32),
	(13, 4, 2, 1, null, 1, 7, 28, 4, 18),
	(9, 6, 4, 3, null, null, 6, 74, 21, 33)
;

-- Inserting values into the Injuries table
INSERT INTO AdditionalInfo.Injuries
VALUES
	(6, 'Hamstring', '2024-1-11', '2024-03-02'),
	(8, 'Ankle Sprain', '2024-1-13', '2024-02-28'),
	(14, 'Knee Injury', '2024-01-16', '2024-03-21'),
	(12, 'Concussion', '2024-01-23', '2024-03-02'),
	(3, 'Groin Strain', '2024-02-01', '2024-04-08')
;

-- Inserting values into the Transfers table
INSERT INTO AdditionalInfo.Transfers
VALUES
	(1, 4, 3, 98000, '2023-11-22'),
	(6, 14, 4, 83000, '2023-12-01'),
	(8, 1, 6, 60300, '2023-12-08'),
	(13, 11, 13, 65000, '2023-12-11'),
	(11, 8, 2, 79000, '2023-12-20')
;

-- Inserting values into the Cups table
INSERT INTO Trophy.Cups
VALUES
	('English FA Cup', '2021/22', 1),
	('Carabao Cup', '2022/23', 11),
	('Copa de Rey', '2022/23', 2),
	('Coupe de France', '2022/23', 7),
	('Coppa Italia', '2022/23', 6)
;

-- Inserting values into the LeagueTrophy table
INSERT INTO Trophy.LeagueTrophies
VALUES
	(2, '2021/22', 2),
	(1, '2021/22', 5),
	(1, '2022/23', 11),
	(2, '2022/23', 2),
	(4, '2022/23', 6)
;

USE SoccerVault
SELECT * FROM CoreEntities.Teams;
SELECT * FROM CoreEntities.Players;
SELECT * FROM CoreEntities.Referees;
SELECT * FROM CoreEntities.Matches;
SELECT * FROM CoreEntities.Leagues;
SELECT * FROM CoreEntities.Standings;
SELECT * FROM CoreEntities.Coaches;
SELECT * FROM AdditionalInfo.PlayerStatistics;
SELECT * FROM AdditionalInfo.Injuries;
SELECT * FROM AdditionalInfo.Transfers;
SELECT * FROM Trophy.Cups;
SELECT * FROM Trophy.LeagueTrophies;


-- CREATING VIEWS FOR THE DATABASE

-- Team Roster View
CREATE VIEW VwTeamRoster AS
SELECT
	T.TeamID,
	T.TeamName,
	P.PlayerID,
	P.FirstName,
	P.LastName,
	P.Position,
	P.JerseyNumber
FROM CoreEntities.Teams T
INNER JOIN CoreEntities.Players P ON T.TeamID = P.TeamID
;

-- Match Results View
CREATE VIEW VwMatchResults AS
SELECT
	M.MatchID,
	M.Date,
	M.HomeTeamID,
	TH.TeamName AS 'Home Team',
	TA.TeamName AS 'Away Team',
	M.HomeGoals,
	M.AwayGoals
FROM CoreEntities.Matches M
INNER JOIN CoreEntities.Teams TH ON TH.TeamID = M.HomeTeamID
INNER JOIN CoreEntities.Teams TA ON TA.TeamID = M.AwayTeamID
;

-- Player Stats View
CREATE VIEW VwPlayerStats AS
SELECT
	P.PlayerID,
	P.FirstName,
	P.LastName,
	P.Position,
	SUM(PS.GoalsScored) AS 'Total Goals',
	SUM(PS.Assists) AS 'Total Assists',
	SUM(PS.YellowCards) AS 'Total Yellow Cards',
	SUM(PS.RedCards) AS 'Total Red Cards'
FROM CoreEntities.Players P
LEFT JOIN AdditionalInfo.PlayerStatistics PS ON P.PlayerID = PS.PlayerID
GROUP BY
	P.PlayerID,
	P.FirstName,
	P.LastName,
	P.Position
;

-- League Standings View
CREATE VIEW VwLeagueStandings AS
SELECT
	L.LeagueID,
	L.LeagueName,
	S.Season,
	S.TeamID,
	T.TeamName,
	SUM(S.Points) AS 'Total Points',
	SUM(S.Won) AS 'Total Wins',
	SUM(S.Drawn) AS 'Total Draws',
	SUM(S.Lost) AS 'Total Losses',
	SUM(S.GoalsFor) AS 'Total Goal Scored',
	SUM(S.GoalsAgainst) AS 'Total Goal Conceded'
FROM CoreEntities.Standings S
INNER JOIN CoreEntities.Leagues L ON L.LeagueID = S.LeagueID
INNER JOIN CoreEntities.Teams T ON T.TeamID = S.TeamID
GROUP BY
	L.LeagueID,
	L.LeagueName,
	s.Season,
	s.TeamID,
	t.TeamName
;

-- Injury Report View
CREATE VIEW VwInjuryReport AS
SELECT
	I.InjuryID,
	I.PlayerID,
	P.FirstName,
	P.LastName,
	I.InjuryType,
	I.Date,
	I.ExpectedRecoveryDate
FROM AdditionalInfo.Injuries I
INNER JOIN CoreEntities.Players P ON I.PlayerID = P.PlayerID
;

-- Transfer History View
USE SoccerVault
GO
CREATE VIEW VwTransferHistory AS
SELECT
	T.TransferID,
	T.PlayerID,
	P.FirstName,
	P.LastName,
	T.FromTeamID,
	FT.TeamName AS 'Source Team',
	T.ToTeamID,
	TT.TeamName AS 'Destination Team',
	T.TransferDate,
	T.TransferFee
FROM AdditionalInfo.Transfers T
INNER JOIN CoreEntities.Players P ON T.PlayerID = P.PlayerID
INNER JOIN CoreEntities.Teams FT ON T.FromTeamID = FT.TeamID
INNER JOIN CoreEntities.Teams TT ON T.ToTeamID = TT.TeamID
;

SELECT * FROM VwTeamRoster;
SELECT * FROM VwMatchResults;
SELECT * FROM VwPlayerStats;
SELECT * FROM VwLeagueStandings;
SELECT * FROM VwInjuryReport;
SELECT * FROM VwTransferHistory;

-- CREATING PROCEDURES FOR THE DATABASE

-- A Procedure to insert a new player record into the database
CREATE PROCEDURE ProInsertPlayer
	@FirstName varchar(50),
	@Lastname varchar(50),
	@PhoneNumber char(11),
	@Email varchar(40),
	@Position varchar(18),
	@Nationality varchar(30),
	@DateOfBirth date,
	@TeamID int,
	@JerseyNumber int,
    @Height decimal(5, 2),
    @Weight decimal(5, 2)
AS
BEGIN
	INSERT INTO CoreEntities.Players
	VALUES (
		@FirstName,
		@Lastname,
		@PhoneNumber,
		@Email,
		@Position,
		@Nationality,
		@DateOfBirth,
		@TeamID,
		@JerseyNumber,
		@Height,
		@Weight
	);
END;

EXEC ProInsertPlayer
	@FirstName = 'Ekojoe',
	@Lastname = 'Covenant',
	@PhoneNumber = '08116754009',
	@Email = 'covenantekojoe01@gmail.com',
	@Position = 'Midfielder',
	@Nationality = 'Nigeria',
	@DateOfBirth = '2007-03-01',
	@TeamID = 2,
	@JerseyNumber = 17,
	@Height = 177,
	@Weight = 65

-- A Procedure to Update an existing player's information in the database
CREATE PROCEDURE ProUpdatePlayer
	@PlayerID int,
	@Position varchar(50),
	@JerseyNumber int
AS
BEGIN
	UPDATE CoreEntities.Players
	SET
		Position = @Position,
		JerseyNumber = @JerseyNumber
	WHERE PlayerID = @PlayerID;
END;

-- A Procedure to get a Player Statistics
CREATE PROCEDURE ProPlayerStats
	@PlayerID int
AS
BEGIN
	SELECT
		PS.PlayerID,
		P.FirstName,
		P.LastName,
		SUM(PS.GoalsScored) AS 'Total Goals',
		SUM(PS.Assists) AS 'Total Assists',
		SUM(PS.YellowCards) AS 'Total Yellow Card',
		SUM(PS.RedCards) AS 'Total Red Card'
	FROM AdditionalInfo.PlayerStatistics PS
	JOIN CoreEntities.Players P ON P.PlayerID = PS.PlayerID
	WHERE PS.PlayerID = @PlayerID
	GROUP BY PS.PlayerID, P.FirstName, P.LastName;
END;

-- TO CREATE A TRIGGER

-- Creating a trigger to automatically update or delete related records in other tables
CREATE TRIGGER TriDeletePlayer
ON CoreEntities.Players
AFTER DELETE
AS
BEGIN
	DELETE FROM AdditionalInfo.PlayerStatistics
	WHERE PlayerID IN(SELECT PlayerID FROM deleted);
END;