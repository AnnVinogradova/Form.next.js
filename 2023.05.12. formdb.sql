-- --------------------------------------------------------
-- Хост:                         127.0.0.1
-- Версия сервера:               11.0.1-MariaDB - mariadb.org binary distribution
-- Операционная система:         Win64
-- HeidiSQL Версия:              12.3.0.6589
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Дамп структуры базы данных formdb
CREATE DATABASE IF NOT EXISTS `formdb` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `formdb`;

-- Дамп структуры для таблица formdb.posts
CREATE TABLE IF NOT EXISTS `posts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(10) unsigned DEFAULT NULL,
  `title` tinytext DEFAULT NULL,
  `body` text DEFAULT NULL,
  `time` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `FK__users` (`userId`),
  CONSTRAINT `FK__users` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Дамп данных таблицы formdb.posts: ~1 rows (приблизительно)
INSERT INTO `posts` (`id`, `userId`, `title`, `body`, `time`) VALUES
	(1, 2, 'h', 'Hello!!!', '2023-05-08 21:00:00');

-- Дамп структуры для таблица formdb.sessions
CREATE TABLE IF NOT EXISTS `sessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) unsigned DEFAULT NULL,
  `secret` tinytext NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `secret` (`secret`) USING HASH,
  KEY `FK_sessions_users` (`userId`),
  CONSTRAINT `FK_sessions_users` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Дамп данных таблицы formdb.sessions: ~2 rows (приблизительно)
INSERT INTO `sessions` (`id`, `userId`, `secret`) VALUES
	(1, 1, '111'),
	(2, 1, 'aaaaa');

-- Дамп структуры для таблица formdb.users
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `login` char(30) NOT NULL,
  `psw` char(41) NOT NULL DEFAULT '',
  `realname` tinytext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Дамп данных таблицы formdb.users: ~2 rows (приблизительно)
INSERT INTO `users` (`id`, `login`, `psw`, `realname`) VALUES
	(1, 'user', '*7C2865310ECCDD62F5BCA98936223240F1E8C1A6', 'Виноградова Анна Владимировна'),
	(2, 'admin', '*5B3BD82ACFE5938026B3001B2540B9C3EB242DD8', 'ADMIN');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
