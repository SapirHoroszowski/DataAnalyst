﻿/*
Name: Sapir Horoszowski
Project Subject: Formula 1 2024 Season
Main data source: Formula 1 website & App, Forbes (Salary Data)
*/
USE MASTER
GO

IF EXISTS (SELECT*
			FROM sys.databases
			WHERE name='Formula_1 _2024_Season')
DROP DATABASE "Formula_1 _2024_Season"

CREATE DATABASE "Formula_1 _2024_Season"
GO

USE "Formula_1 _2024_Season"
GO

--Table 1
----------There are 20 drivers participating in a season, they have a racing number, different origins and salaries($). This table includes a MUST HAVE columns and content that necessary for having a connection with other important tables.
CREATE TABLE "F1_Drivers"
	(
	Racing_Driver_Number INT NOT NULL 
	, Last_Name VARCHAR(25) CONSTRAINT F1Driv_Lname_NN NOT NULL 
	, First_Name VARCHAR(25) CONSTRAINT F1Driv_Fname_NN NOT NULL
	, Racing_Team VARCHAR (30) CONSTRAINT F1Driv_Rteam_NN NOT NULL  
	, Country_Of_Origin VARCHAR(30) CONSTRAINT F1Driv_Country_NN NOT NULL 
	, Birth_Date DATETIME CONSTRAINT F1Driv_Bdate_NN NOT NULL 
	, Salary MONEY NOT NULL

	, CONSTRAINT F1Driv_RDriveNum_PK PRIMARY KEY(Racing_Driver_Number)
	, CONSTRAINT F1Driv_Sal_CK CHECK (Salary>=1000000)
	)
GO

INSERT INTO F1_Drivers (Racing_Driver_Number, Last_Name, First_Name, Racing_Team, Country_Of_Origin, Birth_Date, Salary)
VALUES (1, 'Verstappen', 'Max', 'Red Bull Racing', 'Netherlands', '1997-09-30', 45000000)
	, (11, 'Perez', 'Sergio', 'Red Bull Racing', 'Mexico', '1990-01-26', 10000000)
	, (44, 'Hamilton', 'Lewis', 'Mercedes', 'United Kingdom', '1985-01-07', 55000000)
	, (63, 'Russell', 'George', 'Mercedes', 'United Kingdom', '1998-02-15', 4000000)
	, (16, 'Leclerc', 'Charles', 'Ferrari', 'Monaco', '1997-10-16', 14000000)
	, (55, 'Sainz', 'Carlos', 'Ferrari', 'Spain', '1994-09-01', 8000000)
	, (4, 'Norris', 'Lando', 'McLaren', 'United Kingdom', '1999-11-13', 5000000)
	, (81, 'Piastri', 'Oscar', 'McLaren', 'Australia', '2001-04-06', 3000000)
	, (14, 'Alonso', 'Fernando', 'Aston Martin', 'Spain', '1981-07-29', 24000000)
	, (18, 'Stroll', 'Lance', 'Aston Martin', 'Canada', '1998-10-29', 2000000)
	, (10, 'Gasly', 'Pierre', 'Alpine', 'France', '1996-02-07', 5000000)
	, (31, 'Ocon', 'Esteban', 'Alpine', 'France', '1996-09-17', 6000000)
	, (77, 'Bottas', 'Valtteri', 'Alfa Romeo', 'Finland', '1989-08-28', 10000000)
	, (24, 'Guanyu', 'Zhou', 'Alfa Romeo', 'China', '1999-05-30', 2000000)
	, (20, 'Magnussen', 'Kevin', 'Haas', 'Denmark', '1992-10-05', 5000000)
	, (27, 'Hulkenberg', 'Nico', 'Haas', 'Germany', '1987-08-19', 2000000)
	, (22, 'Tsunoda', 'Yuki', 'AlphaTauri', 'Japan', '2000-05-11', 1000000)
	, (3, 'Ricciardo', 'Daniel', 'AlphaTauri', 'Australia', '1989-07-01', 2000000)
	, (23, 'Albon', 'Alex','Williams', 'Thailand', '1996-03-23', 3000000)
	, (2, 'Sargeant', 'Logan', 'Williams', 'United States', '2000-12-31', 1000000)
GO

--Table 2
----------There are 20 teams participating in a season, they have different names, team principles and date of establishment.
CREATE TABLE "F1_Teams"
	(
	Team_ID INT IDENTITY(1,1)
	, Team_Name VARCHAR(30) CONSTRAINT F1Tms_Tname_NN NOT NULL
	, Year_Of_Establishment DATE
	, Team_Principal VARCHAR(40) CONSTRAINT F1Tms_Tprncpl_NN NOT NULL

	, CONSTRAINT F1Tms_TeamID_PK PRIMARY KEY (Team_ID)
	, CONSTRAINT F1Tms_Tname_UK UNIQUE (Team_Name)
	, CONSTRAINT F1Tms_YearOE_CK CHECK (Year_Of_Establishment>'1800-01-01')
	)
GO

INSERT INTO F1_Teams (Team_Name, Year_Of_Establishment, Team_Principal)
VALUES ('Red Bull Racing', '2005','Christian Horner')
	, ('Mercedes', '2010','Toto Wolff')
	, ('Ferrari', '1929','Frédéric Vasseur')
	, ('McLaren', '1963','Andrea Stella')
	, ('Aston Martin', '1959','Mike Krack')
	, ('Alpine', '1976','Bruno Famin')
	, ('Alfa Romeo', '1950','Alessandro Alunni Bravi')
	, ('Haas', '2016','Guenther Steiner')
	, ('AlphaTauri', '2020','Franz Tost')
	, ('Williams', '1977','James Vowles')
GO

--Table 3
----------Connecting Table 1 and Table 2 through a mid-table: F1_Drivers and F1_Teams tables. Each team (10 teams) are connected to two drivers (20 drivers) - it's a 1:2 ratio, and it's necessary to connect them through a mid table.
CREATE TABLE F1_Drivers_And_Teams
	(
	Connection_ID INT IDENTITY(1,1)
	, Racing_Driver_ID INT CONSTRAINT F1DrvrsTms_RceDrivNum_NN NOT NULL
	, Team_ID INT CONSTRAINT F1DrvrsTms_TeamNum_NN NOT NULL

	, CONSTRAINT F1DrvrsTms_CnctnID_PK PRIMARY KEY(Connection_ID)
	)
GO

INSERT INTO F1_Drivers_And_Teams
(Racing_Driver_ID, Team_ID)
VALUES (1, 1)
	, (2, 10)
	, (3, 9)
	, (4, 4)
	, (10, 6)
	, (11, 1)
	, (14, 5)
	, (16, 3)
	, (18, 5)
	, (20, 8)
	, (22, 9)
	, (23, 10)
	, (24, 7)
	, (27, 8)
	, (31, 6)
	, (44, 2)
	, (55, 3)
	, (63, 2)
	, (77, 7)
	, (81, 4)
GO

---------------The actual connection between the first and the second table with the third one as a middle table. Team_ID and Racing_Driver_Number are FKs to the third table.
ALTER TABLE F1_Drivers_And_Teams
ADD CONSTRAINT F1DrvrsTms_RacingDrvrID_FK FOREIGN KEY (Racing_Driver_ID) REFERENCES F1_Drivers (Racing_Driver_Number)
GO

ALTER TABLE F1_Drivers_And_Teams
ADD CONSTRAINT F1DrvrsTms_TeamID_FK FOREIGN KEY (Team_ID) REFERENCES F1_Teams (Team_ID)
GO

--Table 4
----------There are 24 circuits, (hence there are 24 races - which will be relevant to the next tables), each one of the circuits are at different country, city, having different lengths.
----------The First_Grand_Prix column shows the first year that a F1 race happened there.
CREATE TABLE "Circuits"
	(
	Circuit_ID INT IDENTITY(10,10)
	, Circuit_Name VARCHAR(50) CONSTRAINT Circuits_Crctname_NN NOT NULL
	, Country VARCHAR(25) CONSTRAINT Circuits_Cntry_NN NOT NULL
	, City VARCHAR(25) CONSTRAINT Circuits_City_NN NOT NULL
	, First_Grand_Prix DATE CONSTRAINT Circuits_DfltYear_N DEFAULT NULL
	, Circuit_Length_km DECIMAL(6,3) CONSTRAINT Circuits_LenKM_NN NOT NULL

	, CONSTRAINT Circuits_CrctID_PK PRIMARY KEY(Circuit_ID)
	, CONSTRAINT Circuits_LenKM_CK CHECK(Circuit_Length_km BETWEEN 3 AND 50)
	)
GO

INSERT INTO Circuits 
(Circuit_Name, Country, City, First_Grand_Prix, Circuit_Length_km)
VALUES ('Bahrain International Circuit', 'Bahrain', 'Sakhir', '2004-01-01', 5.412)
	,  ('Jeddah Corniche Circuit', 'Saudi Arabia', 'Jeddah', '2021-01-01', 6.174)
	, ('Albert Park Grand Prix Circuit', 'Australia', ' Melbourne', '1996-01-01', 5.278)
	, ('Suzuka Circuit', 'Japan', 'Suzuka', '1987-01-01', 5.807)
	, ('Shanghai International Circuit', 'China', 'Shanghai', '2004-01-01', 5.451)
	, ('Miami International Autodrome', 'United States', 'Miami', '2022-01-01', 5.412)
	, ('Autodromo Internazionale Enzo e Dino Ferrari', 'Italy', 'Emilia-Romagna', '1980-01-01', 4.909)
	, ('Circuit de Monaco', 'Monaco', 'Monte Carlo', '1950-01-01', 3.337)
	, ('Circuit Gilles Villeneuve', 'Canada', 'Montreal', '1978-01-01', 4.361)
	, ('Circuit de Barcelona-Catalunya', 'Spain', 'Barcelona', '1991-01-01', 4.657)
	, ('Red Bull Ring', 'Austria', 'Spielberg', '1970-01-01', 4.318)
	, ('Silverstone Circuit', 'United Kingdom', 'Silverstone', '1950-01-01', 5.891)
	, ('Hungaroring', 'Hungary', 'Budapest', '1986-01-01', 4.381)
	, ('Circuit de Spa-Francorchamps', 'Belgium', 'Stavelot', '1950-01-01', 7.004)
	, ('Circuit Zandvoort', 'Netherlands', 'Zandvoort', '1952-01-01', 4.259)
	, ('Autodromo Nazionale Monza', 'Italy', 'Monza', '1950-01-01', 5.793)
	, ('Baku City Circuit', 'Azerbaijan', 'Baku', '2016-01-01', 6.003)
	, ('Marina Bay Street Circuit', 'Singapore', 'Singapore', '2008-01-01', 4.94)
	, ('Circuit of the Americas', 'United States', 'Austin', '2012-01-01', 5.513)
	, ('Autódromo Hermanos Rodríguez', 'Mexico', 'Mexico City', '1963-01-01', 4.304)
	, ('Autódromo José Carlos Pace', 'Brazil', 'São Paulo', '1973-01-01', 4.309)
	, ('Las Vegas Strip Circuit', 'United States', 'Las Vegas', '2023-01-01', 6.201)
	, ('Lusail International Circuit', 'Qatar', 'Lusail', '2021-01-01', 5.419)
	, ('Yas Marina Circuit', 'United Arab Emirates', 'Abu Dhabi', '2009-01-01', 5.281)
GO

--Table 5
----------There are 24 races (Race_ID), connected with Circuit_ID as FK. Each Race has its own amount of laps, different distances.
----------It will be interesting to compare the column "Race_Distance_Km" from this table, with the general "Circuit_Length_km" column from the circuits table
CREATE TABLE F1_Races
	(Race_ID INT IDENTITY(1,1)
	, Circuit_ID INT 
	, Race_Distance_Km DECIMAL(6,3) CONSTRAINT Circuits_DisKM_NN NOT NULL
	, Laps_Number INT CONSTRAINT Circuits_DfltTurns_N DEFAULT NULL

	, CONSTRAINT F1Races_RaceID_PK PRIMARY KEY(Race_ID)
	, CONSTRAINT F1races_CrctID_FK FOREIGN KEY (Circuit_ID) REFERENCES Circuits (Circuit_ID)
	)
GO

INSERT INTO F1_Races
(Circuit_ID, Race_Distance_Km, Laps_Number)
VALUES (10, 308.238, 57),
(20, 308.45, 50),
(30, 306.124, 58),
(40, 471.124, 53),
(50, 305.066, 56),
(60, 308.326, 57),
(70, 309.049, 63),
(80, 260.286, 78),
(90, 305.27, 70),
(100, 307.236, 66),
(110, 306.452, 71),
(120, 306.198, 52),
(130, 306.63, 70),
(140, 308.052, 44),
(150, 306.587, 72),
(160, 306.72, 53),
(170, 306.049, 51),
(180, 306.143, 62),
(190, 308.405, 56),
(200, 305.354, 71),
(210, 305.879, 71),
(220, 309.958, 50),
(230, 308.611, 57),
(240, 306.183, 58)
GO

--Table 6
----------This is the most interesting table that this project shows in my opinion, it combines different columns from different tables to this table.
----------This table shows the Position of the drivers, from the 1st place to the 20th place, for each race (with a race_ID, Circuit_ID, date, and Driver_ID). 
CREATE TABLE F1_Results
	(Result_ID INT IDENTITY (1,1)
	, Race_Date DATETIME
	, Circuit_ID INT
	, Race_ID INT
	, Driver_ID INT
	, Position INT

	, CONSTRAINT F1Results_RsltID_PK PRIMARY KEY(Result_ID)
	, CONSTRAINT F1races_RaceDate_CK CHECK (Race_Date BETWEEN '2024-01-01' AND '2024-12-31')
	)
GO

INSERT INTO F1_Results
(Race_Date, Circuit_ID, Race_ID, Driver_ID, Position)
VALUES ('2024-03-02 00:00:00', 10, 1, 1, 1)
, ('2024-03-02 00:00:00', 10, 1, 2, 20)
, ('2024-03-02 00:00:00', 10, 1, 3, 13)
, ('2024-03-02 00:00:00', 10, 1, 4, 6)
, ('2024-03-02 00:00:00', 10, 1, 10, 18)
, ('2024-03-02 00:00:00', 10, 1, 11, 2)
, ('2024-03-02 00:00:00', 10, 1, 14, 9)
, ('2024-03-02 00:00:00', 10, 1, 16, 4)
, ('2024-03-02 00:00:00', 10, 1, 18, 10)
, ('2024-03-02 00:00:00', 10, 1, 20, 12)
, ('2024-03-02 00:00:00', 10, 1, 22, 14)
, ('2024-03-02 00:00:00', 10, 1, 23, 15)
, ('2024-03-02 00:00:00', 10, 1, 24, 11)
, ('2024-03-02 00:00:00', 10, 1, 27, 16)
, ('2024-03-02 00:00:00', 10, 1, 31, 17)
, ('2024-03-02 00:00:00', 10, 1, 44, 7)
, ('2024-03-02 00:00:00', 10, 1, 55, 3)
, ('2024-03-02 00:00:00', 10, 1, 63, 5)
, ('2024-03-02 00:00:00', 10, 1, 77, 19)
, ('2024-03-02 00:00:00', 10, 1, 81, 8)

, ('2024-03-9 00:00:00', 20, 2, 1, 1)
, ('2024-03-9 00:00:00', 20, 2, 2, 14)
, ('2024-03-9 00:00:00', 20, 2, 3, 16)
, ('2024-03-9 00:00:00', 20, 2, 4, 8)
, ('2024-03-9 00:00:00', 20, 2, 10, 0)
, ('2024-03-9 00:00:00', 20, 2, 11, 2)
, ('2024-03-9 00:00:00', 20, 2, 14, 5)
, ('2024-03-9 00:00:00', 20, 2, 16, 3)
, ('2024-03-9 00:00:00', 20, 2, 18, 0)
, ('2024-03-9 00:00:00', 20, 2, 20, 12)
, ('2024-03-9 00:00:00', 20, 2, 22, 15)
, ('2024-03-9 00:00:00', 20, 2, 23, 11)
, ('2024-03-9 00:00:00', 20, 2, 24, 18)
, ('2024-03-9 00:00:00', 20, 2, 27, 10)
, ('2024-03-9 00:00:00', 20, 2, 31, 13)
, ('2024-03-9 00:00:00', 20, 2, 44, 9)
, ('2024-03-9 00:00:00', 20, 2, 55, 7)
, ('2024-03-9 00:00:00', 20, 2, 63, 6)
, ('2024-03-9 00:00:00', 20, 2, 77, 17)
, ('2024-03-9 00:00:00', 20, 2, 81, 4)

, ('2024-03-24 00:00:00', 30, 3, 1, 0)
, ('2024-03-24 00:00:00', 30, 3, 2, 0)
, ('2024-03-24 00:00:00', 30, 3, 3, 12)
, ('2024-03-24 00:00:00', 30, 3, 4, 3)
, ('2024-03-24 00:00:00', 30, 3, 10, 13)
, ('2024-03-24 00:00:00', 30, 3, 11, 5)
, ('2024-03-24 00:00:00', 30, 3, 14, 8)
, ('2024-03-24 00:00:00', 30, 3, 16, 2)
, ('2024-03-24 00:00:00', 30, 3, 18, 6)
, ('2024-03-24 00:00:00', 30, 3, 20, 10)
, ('2024-03-24 00:00:00', 30, 3, 22, 7)
, ('2024-03-24 00:00:00', 30, 3, 23, 11)
, ('2024-03-24 00:00:00', 30, 3, 24, 15)
, ('2024-03-24 00:00:00', 30, 3, 27, 9)
, ('2024-03-24 00:00:00', 30, 3, 31, 16)
, ('2024-03-24 00:00:00', 30, 3, 44, 0)
, ('2024-03-24 00:00:00', 30, 3, 55, 1)
, ('2024-03-24 00:00:00', 30, 3, 63, 17)
, ('2024-03-24 00:00:00', 30, 3, 77, 14)
, ('2024-03-24 00:00:00', 30, 3, 81, 4)

, ('2024-04-10 00:00:00', 40, 4, 1, 1)
, ('2024-04-10 00:00:00', 40, 4, 2, 17)
, ('2024-04-10 00:00:00', 40, 4, 3, 0)
, ('2024-04-10 00:00:00', 40, 4, 4, 5)
, ('2024-04-10 00:00:00', 40, 4, 10, 16)
, ('2024-04-10 00:00:00', 40, 4, 11, 2)
, ('2024-04-10 00:00:00', 40, 4, 14, 6)
, ('2024-04-10 00:00:00', 40, 4, 16, 4)
, ('2024-04-10 00:00:00', 40, 4, 18, 12)
, ('2024-04-10 00:00:00', 40, 4, 20, 13)
, ('2024-04-10 00:00:00', 40, 4, 22, 10)
, ('2024-04-10 00:00:00', 40, 4, 23, 0)
, ('2024-04-10 00:00:00', 40, 4, 24, 0)
, ('2024-04-10 00:00:00', 40, 4, 27, 11)
, ('2024-04-10 00:00:00', 40, 4, 31, 15)
, ('2024-04-10 00:00:00', 40, 4, 44, 9)
, ('2024-04-10 00:00:00', 40, 4, 55, 3)
, ('2024-04-10 00:00:00', 40, 4, 63, 7)
, ('2024-04-10 00:00:00', 40, 4, 77, 14)
, ('2024-04-10 00:00:00', 40, 4, 81, 8)

, ('2024-04-21 00:00:00', 50, 5, 1, 1)
, ('2024-04-21 00:00:00', 50, 5, 2, 17)
, ('2024-04-21 00:00:00', 50, 5, 3, 0)
, ('2024-04-21 00:00:00', 50, 5, 4, 2)
, ('2024-04-21 00:00:00', 50, 5, 10, 13)
, ('2024-04-21 00:00:00', 50, 5, 11, 3)
, ('2024-04-21 00:00:00', 50, 5, 14, 7)
, ('2024-04-21 00:00:00', 50, 5, 16, 4)
, ('2024-04-21 00:00:00', 50, 5, 18, 15)
, ('2024-04-21 00:00:00', 50, 5, 20, 16)
, ('2024-04-21 00:00:00', 50, 5, 22, 0)
, ('2024-04-21 00:00:00', 50, 5, 23, 12)
, ('2024-04-21 00:00:00', 50, 5, 24, 14)
, ('2024-04-21 00:00:00', 50, 5, 27, 10)
, ('2024-04-21 00:00:00', 50, 5, 31, 11)
, ('2024-04-21 00:00:00', 50, 5, 44, 9)
, ('2024-04-21 00:00:00', 50, 5, 55, 5)
, ('2024-04-21 00:00:00', 50, 5, 63, 6)
, ('2024-04-21 00:00:00', 50, 5, 77, 0)
, ('2024-04-21 00:00:00', 50, 5, 81, 8)

, ('2024-05-05 00:00:00', 60, 6, 1, 2)
, ('2024-05-05 00:00:00', 60, 6, 2, 0)
, ('2024-05-05 00:00:00', 60, 6, 3, 15)
, ('2024-05-05 00:00:00', 60, 6, 4, 1)
, ('2024-05-05 00:00:00', 60, 6, 10, 12)
, ('2024-05-05 00:00:00', 60, 6, 11, 4)
, ('2024-05-05 00:00:00', 60, 6, 14, 9)
, ('2024-05-05 00:00:00', 60, 6, 16, 3)
, ('2024-05-05 00:00:00', 60, 6, 18, 17)
, ('2024-05-05 00:00:00', 60, 6, 20, 19)
, ('2024-05-05 00:00:00', 60, 6, 22, 7)
, ('2024-05-05 00:00:00', 60, 6, 23, 18)
, ('2024-05-05 00:00:00', 60, 6, 24, 14)
, ('2024-05-05 00:00:00', 60, 6, 27, 11)
, ('2024-05-05 00:00:00', 60, 6, 31, 12)
, ('2024-05-05 00:00:00', 60, 6, 44, 6)
, ('2024-05-05 00:00:00', 60, 6, 55, 5)
, ('2024-05-05 00:00:00', 60, 6, 63, 8)
, ('2024-05-05 00:00:00', 60, 6, 77, 16)
, ('2024-05-05 00:00:00', 60, 6, 81, 13)

, ('2024-05-19 00:00:00', 70, 7, 1, 1)
, ('2024-05-19 00:00:00', 70, 7, 2, 4)
, ('2024-05-19 00:00:00', 70, 7, 3, 13)
, ('2024-05-19 00:00:00', 70, 7, 4, 2)
, ('2024-05-19 00:00:00', 70, 7, 10, 16)
, ('2024-05-19 00:00:00', 70, 7, 11, 8)
, ('2024-05-19 00:00:00', 70, 7, 14, 19)
, ('2024-05-19 00:00:00', 70, 7, 16, 3)
, ('2024-05-19 00:00:00', 70, 7, 18, 9)
, ('2024-05-19 00:00:00', 70, 7, 20, 12)
, ('2024-05-19 00:00:00', 70, 7, 22, 10)
, ('2024-05-19 00:00:00', 70, 7, 23, 0)
, ('2024-05-19 00:00:00', 70, 7, 24, 15)
, ('2024-05-19 00:00:00', 70, 7, 27, 11)
, ('2024-05-19 00:00:00', 70, 7, 31, 14)
, ('2024-05-19 00:00:00', 70, 7, 44, 6)
, ('2024-05-19 00:00:00', 70, 7, 55, 5)
, ('2024-05-19 00:00:00', 70, 7, 63, 7)
, ('2024-05-19 00:00:00', 70, 7, 77, 18)
, ('2024-05-19 00:00:00', 70, 7, 81, 4)

, ('2024-05-26 00:00:00', 80, 8, 1, 6)
, ('2024-05-26 00:00:00', 80, 8, 2, 15)
, ('2024-05-26 00:00:00', 80, 8, 3, 12)
, ('2024-05-26 00:00:00', 80, 8, 4, 4)
, ('2024-05-26 00:00:00', 80, 8, 10, 10)
, ('2024-05-26 00:00:00', 80, 8, 11, 0)
, ('2024-05-26 00:00:00', 80, 8, 14, 11)
, ('2024-05-26 00:00:00', 80, 8, 16, 1)
, ('2024-05-26 00:00:00', 80, 8, 18, 14)
, ('2024-05-26 00:00:00', 80, 8, 20, 0)
, ('2024-05-26 00:00:00', 80, 8, 22, 8)
, ('2024-05-26 00:00:00', 80, 8, 23, 9)
, ('2024-05-26 00:00:00', 80, 8, 24, 16)
, ('2024-05-26 00:00:00', 80, 8, 27, 0)
, ('2024-05-26 00:00:00', 80, 8, 31, 0)
, ('2024-05-26 00:00:00', 80, 8, 44, 7)
, ('2024-05-26 00:00:00', 80, 8, 55, 3)
, ('2024-05-26 00:00:00', 80, 8, 63, 5)
, ('2024-05-26 00:00:00', 80, 8, 77, 13)
, ('2024-05-26 00:00:00', 80, 8, 81, 2)

, ('2024-06-09 00:00:00', 90, 9, 1, 1)
, ('2024-06-09 00:00:00', 90, 9, 2, 0)
, ('2024-06-09 00:00:00', 90, 9, 3, 8)
, ('2024-06-09 00:00:00', 90, 9, 4, 2)
, ('2024-06-09 00:00:00', 90, 9, 10, 9)
, ('2024-06-09 00:00:00', 90, 9, 11, 0)
, ('2024-06-09 00:00:00', 90, 9, 14, 6)
, ('2024-06-09 00:00:00', 90, 9, 16, 0)
, ('2024-06-09 00:00:00', 90, 9, 18, 7)
, ('2024-06-09 00:00:00', 90, 9, 20, 12)
, ('2024-06-09 00:00:00', 90, 9, 22, 14)
, ('2024-06-09 00:00:00', 90, 9, 23, 31)
, ('2024-06-09 00:00:00', 90, 9, 24, 15)
, ('2024-06-09 00:00:00', 90, 9, 27, 11)
, ('2024-06-09 00:00:00', 90, 9, 31, 10)
, ('2024-06-09 00:00:00', 90, 9, 44, 4)
, ('2024-06-09 00:00:00', 90, 9, 55, 0)
, ('2024-06-09 00:00:00', 90, 9, 63, 3)
, ('2024-06-09 00:00:00', 90, 9, 77, 13)
, ('2024-06-09 00:00:00', 90, 9, 81, 5)

, ('2024-06-23 00:00:00', 100, 10, 1, 1)
, ('2024-06-23 00:00:00', 100, 10, 2, 20)
, ('2024-06-23 00:00:00', 100, 10, 3, 15)
, ('2024-06-23 00:00:00', 100, 10, 4, 2)
, ('2024-06-23 00:00:00', 100, 10, 10, 9)
, ('2024-06-23 00:00:00', 100, 10, 11, 8)
, ('2024-06-23 00:00:00', 100, 10, 14, 12)
, ('2024-06-23 00:00:00', 100, 10, 16, 5)
, ('2024-06-23 00:00:00', 100, 10, 18, 14)
, ('2024-06-23 00:00:00', 100, 10, 20, 17)
, ('2024-06-23 00:00:00', 100, 10, 22, 19)
, ('2024-06-23 00:00:00', 100, 10, 23, 18)
, ('2024-06-23 00:00:00', 100, 10, 24, 13)
, ('2024-06-23 00:00:00', 100, 10, 27, 11)
, ('2024-06-23 00:00:00', 100, 10, 31, 10)
, ('2024-06-23 00:00:00', 100, 10, 44, 3)
, ('2024-06-23 00:00:00', 100, 10, 55, 6)
, ('2024-06-23 00:00:00', 100, 10, 63, 4)
, ('2024-06-23 00:00:00', 100, 10, 77, 16)
, ('2024-06-23 00:00:00', 100, 10, 81, 7)

, ('2024-06-30 00:00:00', 110, 11, 1, 5)
, ('2024-06-30 00:00:00', 110, 11, 2, 19)
, ('2024-06-30 00:00:00', 110, 11, 3, 9)
, ('2024-06-30 00:00:00', 110, 11, 4, 20)
, ('2024-06-30 00:00:00', 110, 11, 10, 10)
, ('2024-06-30 00:00:00', 110, 11, 11, 7)
, ('2024-06-30 00:00:00', 110, 11, 14, 18)
, ('2024-06-30 00:00:00', 110, 11, 16, 11)
, ('2024-06-30 00:00:00', 110, 11, 18, 13)
, ('2024-06-30 00:00:00', 110, 11, 20, 8)
, ('2024-06-30 00:00:00', 110, 11, 22, 14)
, ('2024-06-30 00:00:00', 110, 11, 23, 15)
, ('2024-06-30 00:00:00', 110, 11, 24, 17)
, ('2024-06-30 00:00:00', 110, 11, 27, 6)
, ('2024-06-30 00:00:00', 110, 11, 31, 12)
, ('2024-06-30 00:00:00', 110, 11, 44, 4)
, ('2024-06-30 00:00:00', 110, 11, 55, 3)
, ('2024-06-30 00:00:00', 110, 11, 63, 1)
, ('2024-06-30 00:00:00', 110, 11, 77, 16)
, ('2024-06-30 00:00:00', 110, 11, 81, 2)

, ('2024-07-07 00:00:00', 120, 12, 1, 2)
, ('2024-07-07 00:00:00', 120, 12, 2, 11)
, ('2024-07-07 00:00:00', 120, 12, 3, 13)
, ('2024-07-07 00:00:00', 120, 12, 4, 3)
, ('2024-07-07 00:00:00', 120, 12, 10, 0)
, ('2024-07-07 00:00:00', 120, 12, 11, 17)
, ('2024-07-07 00:00:00', 120, 12, 14, 8)
, ('2024-07-07 00:00:00', 120, 12, 16, 14)
, ('2024-07-07 00:00:00', 120, 12, 18, 7)
, ('2024-07-07 00:00:00', 120, 12, 20, 12)
, ('2024-07-07 00:00:00', 120, 12, 22, 10)
, ('2024-07-07 00:00:00', 120, 12, 23, 9)
, ('2024-07-07 00:00:00', 120, 12, 24, 18)
, ('2024-07-07 00:00:00', 120, 12, 27, 6)
, ('2024-07-07 00:00:00', 120, 12, 31, 16)
, ('2024-07-07 00:00:00', 120, 12, 44, 1)
, ('2024-07-07 00:00:00', 120, 12, 55, 5)
, ('2024-07-07 00:00:00', 120, 12, 63, 0)
, ('2024-07-07 00:00:00', 120, 12, 77, 15)
, ('2024-07-07 00:00:00', 120, 12, 81, 4)

, ('2024-07-21 00:00:00', 130, 13, 1, 5)
, ('2024-07-21 00:00:00', 130, 13, 2, 17)
, ('2024-07-21 00:00:00', 130, 13, 3, 12)
, ('2024-07-21 00:00:00', 130, 13, 4, 2)
, ('2024-07-21 00:00:00', 130, 13, 10, 0)
, ('2024-07-21 00:00:00', 130, 13, 11, 7)
, ('2024-07-21 00:00:00', 130, 13, 14, 11)
, ('2024-07-21 00:00:00', 130, 13, 16, 4)
, ('2024-07-21 00:00:00', 130, 13, 18, 10)
, ('2024-07-21 00:00:00', 130, 13, 20, 15)
, ('2024-07-21 00:00:00', 130, 13, 22, 9)
, ('2024-07-21 00:00:00', 130, 13, 23, 14)
, ('2024-07-21 00:00:00', 130, 13, 24, 19)
, ('2024-07-21 00:00:00', 130, 13, 27, 13)
, ('2024-07-21 00:00:00', 130, 13, 31, 18)
, ('2024-07-21 00:00:00', 130, 13, 44, 3)
, ('2024-07-21 00:00:00', 130, 13, 55, 6)
, ('2024-07-21 00:00:00', 130, 13, 63, 8)
, ('2024-07-21 00:00:00', 130, 13, 77, 16)
, ('2024-07-21 00:00:00', 130, 13, 81, 1)

, ('2024-07-28 00:00:00', 140, 14, 1, 4)
, ('2024-07-28 00:00:00', 140, 14, 2, 17)
, ('2024-07-28 00:00:00', 140, 14, 3, 10)
, ('2024-07-28 00:00:00', 140, 14, 4, 5)
, ('2024-07-28 00:00:00', 140, 14, 10, 13)
, ('2024-07-28 00:00:00', 140, 14, 11, 7)
, ('2024-07-28 00:00:00', 140, 14, 14, 8)
, ('2024-07-28 00:00:00', 140, 14, 16, 3)
, ('2024-07-28 00:00:00', 140, 14, 18, 11)
, ('2024-07-28 00:00:00', 140, 14, 20, 14)
, ('2024-07-28 00:00:00', 140, 14, 22, 16)
, ('2024-07-28 00:00:00', 140, 14, 23, 12)
, ('2024-07-28 00:00:00', 140, 14, 24, 0)
, ('2024-07-28 00:00:00', 140, 14, 27, 18)
, ('2024-07-28 00:00:00', 140, 14, 31, 9)
, ('2024-07-28 00:00:00', 140, 14, 44, 1)
, ('2024-07-28 00:00:00', 140, 14, 55, 6)
, ('2024-07-28 00:00:00', 140, 14, 63, 0)
, ('2024-07-28 00:00:00', 140, 14, 77, 15)
, ('2024-07-28 00:00:00', 140, 14, 81, 2)

, ('2024-08-25 00:00:00', 150, 15, 1, 2)
, ('2024-08-25 00:00:00', 150, 15, 2, 16)
, ('2024-08-25 00:00:00', 150, 15, 3, 12)
, ('2024-08-25 00:00:00', 150, 15, 4, 1)
, ('2024-08-25 00:00:00', 150, 15, 10, 9)
, ('2024-08-25 00:00:00', 150, 15, 11, 6)
, ('2024-08-25 00:00:00', 150, 15, 14, 10)
, ('2024-08-25 00:00:00', 150, 15, 16, 3)
, ('2024-08-25 00:00:00', 150, 15, 18, 13)
, ('2024-08-25 00:00:00', 150, 15, 20, 18)
, ('2024-08-25 00:00:00', 150, 15, 22, 17)
, ('2024-08-25 00:00:00', 150, 15, 23, 14)
, ('2024-08-25 00:00:00', 150, 15, 24, 20)
, ('2024-08-25 00:00:00', 150, 15, 27, 11)
, ('2024-08-25 00:00:00', 150, 15, 31, 15)
, ('2024-08-25 00:00:00', 150, 15, 44, 8)
, ('2024-08-25 00:00:00', 150, 15, 55, 5)
, ('2024-08-25 00:00:00', 150, 15, 63, 7)
, ('2024-08-25 00:00:00', 150, 15, 77, 19)
, ('2024-08-25 00:00:00', 150, 15, 81, 4)

, ('2024-09-01 00:00:00', 160, 16, 1, 6)
, ('2024-09-01 00:00:00', 160, 16, 2, 12)
, ('2024-09-01 00:00:00', 160, 16, 3, 13)
, ('2024-09-01 00:00:00', 160, 16, 4, 3)
, ('2024-09-01 00:00:00', 160, 16, 10, 15)
, ('2024-09-01 00:00:00', 160, 16, 11, 8)
, ('2024-09-01 00:00:00', 160, 16, 14, 11)
, ('2024-09-01 00:00:00', 160, 16, 16, 1)
, ('2024-09-01 00:00:00', 160, 16, 18, 19)
, ('2024-09-01 00:00:00', 160, 16, 20, 10)
, ('2024-09-01 00:00:00', 160, 16, 22, 0)
, ('2024-09-01 00:00:00', 160, 16, 23, 9)
, ('2024-09-01 00:00:00', 160, 16, 24, 18)
, ('2024-09-01 00:00:00', 160, 16, 27, 17)
, ('2024-09-01 00:00:00', 160, 16, 31, 14)
, ('2024-09-01 00:00:00', 160, 16, 44, 5)
, ('2024-09-01 00:00:00', 160, 16, 55, 4)
, ('2024-09-01 00:00:00', 160, 16, 63, 7)
, ('2024-09-01 00:00:00', 160, 16, 77, 16)
, ('2024-09-01 00:00:00', 160, 16, 81, 2)

, ('2024-09-15 00:00:00', 170, 17, 1, 5)
, ('2024-09-15 00:00:00', 170, 17, 2, 8)
, ('2024-09-15 00:00:00', 170, 17, 3, 13)
, ('2024-09-15 00:00:00', 170, 17, 4, 4)
, ('2024-09-15 00:00:00', 170, 17, 10, 12)
, ('2024-09-15 00:00:00', 170, 17, 11, 17)
, ('2024-09-15 00:00:00', 170, 17, 14, 6)
, ('2024-09-15 00:00:00', 170, 17, 16, 2)
, ('2024-09-15 00:00:00', 170, 17, 18, 19)
, ('2024-09-15 00:00:00', 170, 17, 20, 10)
, ('2024-09-15 00:00:00', 170, 17, 22, 0)
, ('2024-09-15 00:00:00', 170, 17, 23, 7)
, ('2024-09-15 00:00:00', 170, 17, 24, 14)
, ('2024-09-15 00:00:00', 170, 17, 27, 11)
, ('2024-09-15 00:00:00', 170, 17, 31, 15)
, ('2024-09-15 00:00:00', 170, 17, 44, 9)
, ('2024-09-15 00:00:00', 170, 17, 55, 18)
, ('2024-09-15 00:00:00', 170, 17, 63, 3)
, ('2024-09-15 00:00:00', 170, 17, 77, 16)
, ('2024-09-15 00:00:00', 170, 17, 81, 1)

, ('2024-09-22 00:00:00', 180, 18, 1, 2)
, ('2024-09-22 00:00:00', 180, 18, 2, 11)
, ('2024-09-22 00:00:00', 180, 18, 3, 18)
, ('2024-09-22 00:00:00', 180, 18, 4, 1)
, ('2024-09-22 00:00:00', 180, 18, 10, 17)
, ('2024-09-22 00:00:00', 180, 18, 11, 10)
, ('2024-09-22 00:00:00', 180, 18, 14, 8)
, ('2024-09-22 00:00:00', 180, 18, 16, 5)
, ('2024-09-22 00:00:00', 180, 18, 18, 14)
, ('2024-09-22 00:00:00', 180, 18, 20, 19)
, ('2024-09-22 00:00:00', 180, 18, 22, 12)
, ('2024-09-22 00:00:00', 180, 18, 23, 0)
, ('2024-09-22 00:00:00', 180, 18, 24, 15)
, ('2024-09-22 00:00:00', 180, 18, 27, 9)
, ('2024-09-22 00:00:00', 180, 18, 31, 13)
, ('2024-09-22 00:00:00', 180, 18, 44, 6)
, ('2024-09-22 00:00:00', 180, 18, 55, 7)
, ('2024-09-22 00:00:00', 180, 18, 63, 4)
, ('2024-09-22 00:00:00', 180, 18, 77, 16)
, ('2024-09-22 00:00:00', 180, 18, 81, 3)

, ('2024-10-20 00:00:00', 190, 19, 1, 3)
, ('2024-10-20 00:00:00', 190, 19, 2, 10)
, ('2024-10-20 00:00:00', 190, 19, 3, 9)
, ('2024-10-20 00:00:00', 190, 19, 4, 4)
, ('2024-10-20 00:00:00', 190, 19, 10, 12)
, ('2024-10-20 00:00:00', 190, 19, 11, 7)
, ('2024-10-20 00:00:00', 190, 19, 14, 13)
, ('2024-10-20 00:00:00', 190, 19, 16, 1)
, ('2024-10-20 00:00:00', 190, 19, 18, 15)
, ('2024-10-20 00:00:00', 190, 19, 20, 11)
, ('2024-10-20 00:00:00', 190, 19, 22, 14)
, ('2024-10-20 00:00:00', 190, 19, 23, 16)
, ('2024-10-20 00:00:00', 190, 19, 24, 19)
, ('2024-10-20 00:00:00', 190, 19, 27, 8)
, ('2024-10-20 00:00:00', 190, 19, 31, 18)
, ('2024-10-20 00:00:00', 190, 19, 44, 0)
, ('2024-10-20 00:00:00', 190, 19, 55, 2)
, ('2024-10-20 00:00:00', 190, 19, 63, 6)
, ('2024-10-20 00:00:00', 190, 19, 77, 17)
, ('2024-10-20 00:00:00', 190, 19, 81, 5)

, ('2024-10-27 00:00:00', 200, 20, 1, 6)
, ('2024-10-27 00:00:00', 200, 20, 2, 12)
, ('2024-10-27 00:00:00', 200, 20, 3, 16)
, ('2024-10-27 00:00:00', 200, 20, 4, 2)
, ('2024-10-27 00:00:00', 200, 20, 10, 10)
, ('2024-10-27 00:00:00', 200, 20, 11, 17)
, ('2024-10-27 00:00:00', 200, 20, 14, 0)
, ('2024-10-27 00:00:00', 200, 20, 16, 3)
, ('2024-10-27 00:00:00', 200, 20, 18, 11)
, ('2024-10-27 00:00:00', 200, 20, 20, 7)
, ('2024-10-27 00:00:00', 200, 20, 22, 0)
, ('2024-10-27 00:00:00', 200, 20, 23, 0)
, ('2024-10-27 00:00:00', 200, 20, 24, 15)
, ('2024-10-27 00:00:00', 200, 20, 27, 9)
, ('2024-10-27 00:00:00', 200, 20, 31, 13)
, ('2024-10-27 00:00:00', 200, 20, 44, 4)
, ('2024-10-27 00:00:00', 200, 20, 55, 1)
, ('2024-10-27 00:00:00', 200, 20, 63, 5)
, ('2024-10-27 00:00:00', 200, 20, 77, 14)
, ('2024-10-27 00:00:00', 200, 20, 81, 8)

, ('2024-11-03 00:00:00', 210, 21, 1, 1)   
, ('2024-11-03 00:00:00', 210, 21, 2, 0)	
, ('2024-11-03 00:00:00', 210, 21, 3, 9)	
, ('2024-11-03 00:00:00', 210, 21, 4, 6)	
, ('2024-11-03 00:00:00', 210, 21, 10, 3)	
, ('2024-11-03 00:00:00', 210, 21, 11, 11)
, ('2024-11-03 00:00:00', 210, 21, 14, 14)
, ('2024-11-03 00:00:00', 210, 21, 16, 5)	
, ('2024-11-03 00:00:00', 210, 21, 18, 0)	
, ('2024-11-03 00:00:00', 210, 21, 20, 12)
, ('2024-11-03 00:00:00', 210, 21, 22, 7)	
, ('2024-11-03 00:00:00', 210, 21, 23, 0)	
, ('2024-11-03 00:00:00', 210, 21, 24, 15)
, ('2024-11-03 00:00:00', 210, 21, 27, 0)	
, ('2024-11-03 00:00:00', 210, 21, 31, 2)	
, ('2024-11-03 00:00:00', 210, 21, 44, 10)
, ('2024-11-03 00:00:00', 210, 21, 55, 0)	
, ('2024-11-03 00:00:00', 210, 21, 63, 4)	
, ('2024-11-03 00:00:00', 210, 21, 77, 13)
, ('2024-11-03 00:00:00', 210, 21, 81, 8)  

, ('2024-11-24 00:00:00', 220, 22, 1, 5)
, ('2024-11-24 00:00:00', 220, 22, 2, 14)
, ('2024-11-24 00:00:00', 220, 22, 3, 16)
, ('2024-11-24 00:00:00', 220, 22, 4, 6)
, ('2024-11-24 00:00:00', 220, 22, 10, 0)
, ('2024-11-24 00:00:00', 220, 22, 11, 10)
, ('2024-11-24 00:00:00', 220, 22, 14, 11)
, ('2024-11-24 00:00:00', 220, 22, 16, 4)
, ('2024-11-24 00:00:00', 220, 22, 18, 15)
, ('2024-11-24 00:00:00', 220, 22, 20, 12)
, ('2024-11-24 00:00:00', 220, 22, 22, 9)
, ('2024-11-24 00:00:00', 220, 22, 23, 0)
, ('2024-11-24 00:00:00', 220, 22, 24, 13)
, ('2024-11-24 00:00:00', 220, 22, 27, 8)
, ('2024-11-24 00:00:00', 220, 22, 31, 17)
, ('2024-11-24 00:00:00', 220, 22, 44, 2)
, ('2024-11-24 00:00:00', 220, 22, 55, 3)
, ('2024-11-24 00:00:00', 220, 22, 63, 1)
, ('2024-11-24 00:00:00', 220, 22, 77, 18)
, ('2024-11-24 00:00:00', 220, 22, 81, 7)

, ('2024-12-01 00:00:00', 230, 23, 1, 1)
, ('2024-12-01 00:00:00', 230, 23, 2, 0)
, ('2024-12-01 00:00:00', 230, 23, 3, 14)
, ('2024-12-01 00:00:00', 230, 23, 4, 10)
, ('2024-12-01 00:00:00', 230, 23, 10, 5)
, ('2024-12-01 00:00:00', 230, 23, 11, 0)
, ('2024-12-01 00:00:00', 230, 23, 14, 7)
, ('2024-12-01 00:00:00', 230, 23, 16, 2)
, ('2024-12-01 00:00:00', 230, 23, 18, 0)
, ('2024-12-01 00:00:00', 230, 23, 20, 9)
, ('2024-12-01 00:00:00', 230, 23, 22, 13)
, ('2024-12-01 00:00:00', 230, 23, 23, 15)
, ('2024-12-01 00:00:00', 230, 23, 24, 8)
, ('2024-12-01 00:00:00', 230, 23, 27, 0)
, ('2024-12-01 00:00:00', 230, 23, 31, 0)
, ('2024-12-01 00:00:00', 230, 23, 44, 12)
, ('2024-12-01 00:00:00', 230, 23, 55, 6)
, ('2024-12-01 00:00:00', 230, 23, 63, 4)
, ('2024-12-01 00:00:00', 230, 23, 77, 11)
, ('2024-12-01 00:00:00', 230, 23, 81, 3)

, ('2024-12-08 00:00:00', 240, 24, 1, 6)
, ('2024-12-08 00:00:00', 240, 24, 2, 0)
, ('2024-12-08 00:00:00', 240, 24, 3, 17)
, ('2024-12-08 00:00:00', 240, 24, 4, 1)
, ('2024-12-08 00:00:00', 240, 24, 10, 7)
, ('2024-12-08 00:00:00', 240, 24, 11, 0)
, ('2024-12-08 00:00:00', 240, 24, 14, 9)
, ('2024-12-08 00:00:00', 240, 24, 16, 3)
, ('2024-12-08 00:00:00', 240, 24, 18, 14)
, ('2024-12-08 00:00:00', 240, 24, 20, 16)
, ('2024-12-08 00:00:00', 240, 24, 22, 12)
, ('2024-12-08 00:00:00', 240, 24, 23, 11)
, ('2024-12-08 00:00:00', 240, 24, 24, 13)
, ('2024-12-08 00:00:00', 240, 24, 27, 8)
, ('2024-12-08 00:00:00', 240, 24, 31, 15)
, ('2024-12-08 00:00:00', 240, 24, 44, 4)
, ('2024-12-08 00:00:00', 240, 24, 55, 2)
, ('2024-12-08 00:00:00', 240, 24, 63, 5)
, ('2024-12-08 00:00:00', 240, 24, 77, 0)
, ('2024-12-08 00:00:00', 240, 24, 81, 10)
GO



----------This part combines between the last table to three of the other tables.
ALTER TABLE F1_Results
ADD CONSTRAINT F1Rslts_CrctID_FK FOREIGN KEY (Circuit_ID) REFERENCES Circuits (Circuit_ID)
GO

ALTER TABLE F1_Results
ADD CONSTRAINT F1Rslts_RceID_FK FOREIGN KEY (Race_ID) REFERENCES F1_Races (Race_ID)
GO

ALTER TABLE F1_Results
ADD CONSTRAINT F1Rslts_DrvrID_FK FOREIGN KEY (Driver_ID) REFERENCES F1_Drivers (Racing_Driver_Number)
GO


SELECT*
FROM F1_Results
GO