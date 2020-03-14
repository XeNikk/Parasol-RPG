-- phpMyAdmin SQL Dump
-- version 4.6.6deb4
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Czas generowania: 12 Lut 2020, 18:16
-- Wersja serwera: 10.1.41-MariaDB-0+deb9u1
-- Wersja PHP: 7.0.33-0+deb9u6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Baza danych: `czysta_baza`
--

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `pd-admin`
--

CREATE TABLE `pd-admin` (
  `id` int(11) NOT NULL,
  `nick` text NOT NULL,
  `serial` text NOT NULL,
  `rank` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `pd-autostart`
--

CREATE TABLE `pd-autostart` (
  `resource` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Zrzut danych tabeli `pd-autostart`
--

INSERT INTO `pd-autostart` (`resource`) VALUES
('admin'),
('ajax'),
('bone_attach'),
('coleditor'),
('npc_hlc'),
('pd-3dtext'),
('pd-achievements'),
('pd-admin'),
('pd-atms'),
('pd-autostart'),
('pd-core'),
('pd-cshop'),
('pd-dashboard'),
('pd-download'),
('pd-dynamic-light'),
('pd-engines'),
('pd-entrances'),
('pd-faggio'),
('pd-gui'),
('pd-help'),
('pd-interaction'),
('pd-job-bus'),
('pd-job-factory'),
('pd-job-hunter'),
('pd-job-mars'),
('pd-jobsettings'),
('pd-loading'),
('pd-logging'),
('pd-map-bus'),
('pd-map-cygan'),
('pd-map-dresser'),
('pd-map-exchange'),
('pd-map-factory'),
('pd-map-hunter'),
('pd-map-mars'),
('pd-map-osk'),
('pd-map-osk-interior'),
('pd-map-przecho-ls1'),
('pd-map-przecho-ls2'),
('pd-map-spawn-ls'),
('pd-mapa-kosmonauty'),
('pd-mapper-pack'),
('pd-markers'),
('pd-models'),
('pd-mysql'),
('pd-nametags'),
('pd-osk'),
('pd-radio'),
('pd-reload'),
('pd-scoreboard'),
('pd-vehicles'),
('pd-vehicles-destroy'),
('pd-vehicles-exchange'),
('pd-vehicles-fuel'),
('pd-vehicles-interaction'),
('pd-vehicles-limiter'),
('pd-vehicles-shop'),
('pd-vehicles-store'),
('pd_models_Test'),
('realdriveby'),
('runcode'),
('sylwester'),
('pd-job-diver'),
('pd-job-courier'),
('pd-workshop-repair'),
('pd-map-courier'),
('pd-anims'),
('pd-ammunation'),
('pd-hud'),
('pd-virtual-parks'),
('pd-models-download'),
('pd-workshop-tuner'),
('trailer'),
('pd-vehicles-default'),
('pd-map-salon-grove'),
('pd-mars'),
('pd-workshop-duty'),
('pd-dgs'),
('pd-map-cygan-farm'),
('pd-map-mechanic-ls'),
('pd-derby'),
('event-derby');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `pd-bans`
--

CREATE TABLE `pd-bans` (
  `id` int(11) NOT NULL,
  `nick` text NOT NULL,
  `serial` text NOT NULL,
  `ip` text NOT NULL,
  `admin` text NOT NULL,
  `reason` text NOT NULL,
  `timeout` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `active` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `pd-players`
--

CREATE TABLE `pd-players` (
  `uid` int(11) NOT NULL,
  `nick` text NOT NULL,
  `password` text NOT NULL,
  `registerDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `lastseen` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `rp` int(11) NOT NULL DEFAULT '0',
  `warns` int(11) NOT NULL DEFAULT '0',
  `saldoPP` int(11) NOT NULL DEFAULT '0',
  `premiumDate` timestamp NULL DEFAULT NULL,
  `email` text NOT NULL,
  `skin` int(11) NOT NULL,
  `money` int(11) NOT NULL DEFAULT '0',
  `bank_money` int(11) NOT NULL DEFAULT '0',
  `pj` text NOT NULL,
  `job_stats` text NOT NULL,
  `job_upgrades` text NOT NULL,
  `last-login` text NOT NULL,
  `achievements` text NOT NULL,
  `addData` text NOT NULL,
  `ACL` int(11) NOT NULL DEFAULT '0',
  `ACLrank` text,
  `active` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `pd-punishments`
--

CREATE TABLE `pd-punishments` (
  `id` int(11) NOT NULL,
  `nick` text NOT NULL,
  `serial` text NOT NULL,
  `admin` text NOT NULL,
  `reason` text NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `timeout` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `type` text NOT NULL,
  `active` int(11) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `pd-radio`
--

CREATE TABLE `pd-radio` (
  `id` int(11) NOT NULL,
  `uid` int(11) NOT NULL,
  `name` text NOT NULL,
  `link` text NOT NULL,
  `vehicle` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `pd-vehicles`
--

CREATE TABLE `pd-vehicles` (
  `vid` int(11) NOT NULL,
  `model` int(11) NOT NULL,
  `owner` text NOT NULL,
  `color` text NOT NULL,
  `variant` text NOT NULL,
  `position` text NOT NULL,
  `damage` text NOT NULL,
  `last_driver` int(11) NOT NULL,
  `fuel_type` text NOT NULL,
  `fuel` int(11) NOT NULL,
  `dm` text NOT NULL,
  `mileage` int(11) NOT NULL,
  `tuning` text NOT NULL,
  `addTuning` text NOT NULL,
  `paintjob` int(11) NOT NULL,
  `spawned` int(11) NOT NULL,
  `buyCost` int(11) NOT NULL,
  `wheels` text NOT NULL,
  `virtualparking` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `pd-whitelist`
--

CREATE TABLE `pd-whitelist` (
  `id` int(11) NOT NULL,
  `nick` text NOT NULL,
  `serial` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `pd_logs_chat`
--

CREATE TABLE `pd_logs_chat` (
  `id` int(11) NOT NULL,
  `type` text NOT NULL,
  `nick` text NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `text` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `pd_logs_login`
--

CREATE TABLE `pd_logs_login` (
  `id` int(11) NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `action` text NOT NULL,
  `text` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `pd_logs_money_transfer`
--

CREATE TABLE `pd_logs_money_transfer` (
  `id` int(11) NOT NULL,
  `from` text NOT NULL,
  `to` text NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `money` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `pd_logs_pw`
--

CREATE TABLE `pd_logs_pw` (
  `id` int(11) NOT NULL,
  `from` text NOT NULL,
  `to` text NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `text` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `pd_logs_sell`
--

CREATE TABLE `pd_logs_sell` (
  `id` int(11) NOT NULL,
  `type` text NOT NULL,
  `from` text NOT NULL,
  `to` text NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `value` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Indeksy dla zrzutów tabel
--

--
-- Indexes for table `pd-admin`
--
ALTER TABLE `pd-admin`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pd-bans`
--
ALTER TABLE `pd-bans`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pd-players`
--
ALTER TABLE `pd-players`
  ADD PRIMARY KEY (`uid`);

--
-- Indexes for table `pd-punishments`
--
ALTER TABLE `pd-punishments`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pd-radio`
--
ALTER TABLE `pd-radio`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pd-vehicles`
--
ALTER TABLE `pd-vehicles`
  ADD PRIMARY KEY (`vid`);

--
-- Indexes for table `pd-whitelist`
--
ALTER TABLE `pd-whitelist`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pd_logs_chat`
--
ALTER TABLE `pd_logs_chat`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pd_logs_login`
--
ALTER TABLE `pd_logs_login`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pd_logs_money_transfer`
--
ALTER TABLE `pd_logs_money_transfer`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pd_logs_pw`
--
ALTER TABLE `pd_logs_pw`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pd_logs_sell`
--
ALTER TABLE `pd_logs_sell`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT dla tabeli `pd-admin`
--
ALTER TABLE `pd-admin`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT dla tabeli `pd-bans`
--
ALTER TABLE `pd-bans`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT dla tabeli `pd-players`
--
ALTER TABLE `pd-players`
  MODIFY `uid` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT dla tabeli `pd-punishments`
--
ALTER TABLE `pd-punishments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT dla tabeli `pd-radio`
--
ALTER TABLE `pd-radio`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT dla tabeli `pd-vehicles`
--
ALTER TABLE `pd-vehicles`
  MODIFY `vid` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT dla tabeli `pd-whitelist`
--
ALTER TABLE `pd-whitelist`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT dla tabeli `pd_logs_chat`
--
ALTER TABLE `pd_logs_chat`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT dla tabeli `pd_logs_login`
--
ALTER TABLE `pd_logs_login`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT dla tabeli `pd_logs_money_transfer`
--
ALTER TABLE `pd_logs_money_transfer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT dla tabeli `pd_logs_pw`
--
ALTER TABLE `pd_logs_pw`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT dla tabeli `pd_logs_sell`
--
ALTER TABLE `pd_logs_sell`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
