-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: db
-- Erstellungszeit: 18. Nov 2024 um 12:30
-- Server-Version: 11.5.2-MariaDB-ubu2404
-- PHP-Version: 8.2.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Datenbank: `skillforge_db`
--

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `event_days`
--

CREATE TABLE `event_days` (
  `DayID` bigint(20) NOT NULL,
  `EventDate` date NOT NULL,
  `StartTime` time DEFAULT NULL,
  `EndTime` time DEFAULT NULL,
  `EventLocation` varchar(50) DEFAULT NULL,
  `LocationFederalState` varchar(50) DEFAULT NULL,
  `consists_of` bigint(20) DEFAULT NULL
) ;

--
-- Daten für Tabelle `event_days`
--

INSERT INTO `event_days` (`DayID`, `EventDate`, `StartTime`, `EndTime`, `EventLocation`, `LocationFederalState`, `consists_of`) VALUES
(1, '2024-10-31', '10:00:00', '18:00:00', 'Heilbronn', 'BadenWuettenberg', 0),
(2, '2024-11-01', '08:00:00', '16:00:00', 'Heilbronn', 'BadenWuettenberg', 0),
(3, '2024-06-12', '06:00:00', '15:00:00', 'Berlin', 'Berlin', 1),
(4, '2024-07-30', '08:00:00', '20:00:00', 'Muenchen', 'Bayern', 2),
(5, '2024-07-31', '08:00:00', '16:00:00', 'Muenchen', 'Bayern', 2),
(6, '2024-09-19', '10:00:00', '16:00:00', 'Muenchen', 'Bayern', 2),
(7, '2024-09-20', '08:00:00', '18:00:00', 'Muenchen', 'Bayern', 2),
(8, '2024-09-21', '08:00:00', '18:00:00', 'Muenchen', 'Bayern', 2),
(9, '2024-12-02', '10:00:00', '22:00:00', 'Loerrach', 'Baden Wuettenberg', 3),
(10, '2024-12-03', '10:00:00', '22:00:00', 'Loerrach', 'Baden Wuettenberg', 3),
(11, '2024-02-01', '10:00:00', '18:00:00', 'Hannover', 'Niedersachsen', 4),
(12, '2024-02-02', '08:00:00', '14:00:00', 'Hannover', 'Niedersachsen', 4),
(13, '2024-05-06', '10:00:00', '18:00:00', 'Hannover', 'Niedersachsen', 4),
(14, '2024-05-07', '08:00:00', '14:00:00', 'Hannover', 'Niedersachsen', 4),
(15, '2024-08-21', '08:00:00', '20:00:00', 'Hamburg', 'Hamburg', 5),
(16, '2024-06-10', '10:00:00', '20:00:00', 'Dresden', 'Sachsen', 6),
(17, '2024-06-11', '08:00:00', '17:00:00', 'Dresden', 'Sachsen', 6),
(18, '2024-06-12', '08:00:00', '15:00:00', 'Dresden', 'Sachsen', 6),
(19, '2024-11-21', '10:00:00', '18:00:00', 'Dresden', 'Sachsen', 6),
(20, '2024-11-22', '08:00:00', '17:00:00', 'Dresden', 'Sachsen', 6),
(21, '2024-11-23', '08:00:00', '15:00:00', 'Dresden', 'Sachsen', 6),
(22, '2024-09-10', '06:00:00', '16:00:00', 'Mannheim', 'Baden Wuettenberg', 7),
(23, '2024-09-11', '08:00:00', '20:00:00', 'Mannheim', 'Baden Wuettenberg', 7);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `event_information`
--

CREATE TABLE `event_information` (
  `InformationID` bigint(20) NOT NULL,
  `NameDE` varchar(50) NOT NULL,
  `NameEN` varchar(50) NOT NULL,
  `DescriptionDE` text DEFAULT NULL,
  `DescriptionEN` text DEFAULT NULL,
  `SubjectArea` varchar(25) DEFAULT NULL,
  `EventType` varchar(20) NOT NULL,
  `describes` bigint(20) DEFAULT NULL
) ;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `participates`
--

CREATE TABLE `participates` (
  `TrainingID` bigint(20) NOT NULL,
  `UserID` bigint(20) NOT NULL,
  `registration_date` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `trainingcourses`
--

CREATE TABLE `trainingcourses` (
  `TrainingID` bigint(20) NOT NULL,
  `MinParticipants` int(11) DEFAULT 7,
  `MaxParticipants` int(11) DEFAULT 25
) ;

--
-- Daten für Tabelle `trainingcourses`
--

INSERT INTO `trainingcourses` (`TrainingID`, `MinParticipants`, `MaxParticipants`) VALUES
(0, 7, 25),
(1, 7, 25),
(2, 7, 25),
(3, 7, 25),
(4, 7, 25),
(5, 7, 25),
(6, 7, 25),
(7, 7, 25);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `users`
--

CREATE TABLE `users` (
  `UserID` bigint(20) NOT NULL,
  `Username` varchar(50) NOT NULL,
  `PasswordHash` varchar(512) NOT NULL,
  `FirstName` varchar(50) NOT NULL,
  `LastName` varchar(50) NOT NULL,
  `Email` varchar(50) NOT NULL,
  `SpecializationField` varchar(25) NOT NULL,
  `is_admin` tinyint(1) DEFAULT 0,
  `is_active` tinyint(1) DEFAULT 1,
  `CountLoginAttempts` int(11) DEFAULT 0
) ;

--
-- Indizes der exportierten Tabellen
--

--
-- Indizes für die Tabelle `event_days`
--
ALTER TABLE `event_days`
  ADD PRIMARY KEY (`DayID`),
  ADD KEY `fk_eventdays_training` (`consists_of`);

--
-- Indizes für die Tabelle `event_information`
--
ALTER TABLE `event_information`
  ADD PRIMARY KEY (`InformationID`),
  ADD KEY `fk_eventinfo_training` (`describes`);

--
-- Indizes für die Tabelle `participates`
--
ALTER TABLE `participates`
  ADD PRIMARY KEY (`TrainingID`,`UserID`),
  ADD KEY `idx_userid` (`UserID`);

--
-- Indizes für die Tabelle `trainingcourses`
--
ALTER TABLE `trainingcourses`
  ADD PRIMARY KEY (`TrainingID`);

--
-- Indizes für die Tabelle `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`UserID`),
  ADD UNIQUE KEY `unique_username` (`Username`),
  ADD UNIQUE KEY `unique_email` (`Email`);

--
-- AUTO_INCREMENT für exportierte Tabellen
--

--
-- AUTO_INCREMENT für Tabelle `event_days`
--
ALTER TABLE `event_days`
  MODIFY `DayID` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `event_information`
--
ALTER TABLE `event_information`
  MODIFY `InformationID` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `trainingcourses`
--
ALTER TABLE `trainingcourses`
  MODIFY `TrainingID` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `users`
--
ALTER TABLE `users`
  MODIFY `UserID` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- Constraints der exportierten Tabellen
--

--
-- Constraints der Tabelle `event_days`
--
ALTER TABLE `event_days`
  ADD CONSTRAINT `fk_eventdays_training` FOREIGN KEY (`consists_of`) REFERENCES `trainingcourses` (`TrainingID`) ON DELETE CASCADE;

--
-- Constraints der Tabelle `event_information`
--
ALTER TABLE `event_information`
  ADD CONSTRAINT `fk_eventinfo_training` FOREIGN KEY (`describes`) REFERENCES `trainingcourses` (`TrainingID`) ON DELETE CASCADE;

--
-- Constraints der Tabelle `participates`
--
ALTER TABLE `participates`
  ADD CONSTRAINT `fk_participates_training` FOREIGN KEY (`TrainingID`) REFERENCES `trainingcourses` (`TrainingID`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_participates_user` FOREIGN KEY (`UserID`) REFERENCES `users` (`UserID`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
