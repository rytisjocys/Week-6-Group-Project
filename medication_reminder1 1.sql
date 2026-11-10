-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: medication_reminder
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `dose_confirmations`
--

DROP TABLE IF EXISTS `dose_confirmations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dose_confirmations` (
  `confirmation_id` int NOT NULL AUTO_INCREMENT,
  `schedule_id` int NOT NULL,
  `dose_date` date NOT NULL,
  `taken_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`confirmation_id`),
  UNIQUE KEY `uq_confirmation_schedule_date` (`schedule_id`,`dose_date`),
  CONSTRAINT `fk_confirmations_schedule` FOREIGN KEY (`schedule_id`) REFERENCES `schedules` (`schedule_id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dose_confirmations`
--

LOCK TABLES `dose_confirmations` WRITE;
/*!40000 ALTER TABLE `dose_confirmations` DISABLE KEYS */;
INSERT INTO `dose_confirmations` VALUES (1,4,'2026-11-02','2026-11-02 08:05:00'),(2,5,'2026-11-03','2026-11-03 20:05:00'),(3,6,'2026-11-04','2026-11-04 08:35:00'),(4,7,'2026-11-02','2026-11-02 07:05:00'),(5,8,'2026-11-03','2026-11-03 09:05:00'),(6,9,'2026-11-04','2026-11-04 07:35:00'),(7,10,'2026-11-02','2026-11-02 09:35:00'),(8,11,'2026-11-03','2026-11-03 08:05:00'),(9,12,'2026-11-04','2026-11-04 10:05:00'),(10,13,'2026-11-02','2026-11-02 09:05:00'),(16,4,'2026-11-09','2026-11-05 20:30:10');
/*!40000 ALTER TABLE `dose_confirmations` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_confirmations_before_insert` BEFORE INSERT ON `dose_confirmations` FOR EACH ROW BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM schedules AS s
        WHERE s.schedule_id = NEW.schedule_id
          AND NEW.dose_date >= s.start_date
          AND (
              s.end_date IS NULL
              OR NEW.dose_date <= s.end_date
          )
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Dose date must fall within an existing schedule date range.';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM schedule_days AS sd
        WHERE sd.schedule_id = NEW.schedule_id
          AND sd.day_of_week = WEEKDAY(NEW.dose_date)
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Dose date is not a selected weekday for this schedule.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_confirmations_before_update` BEFORE UPDATE ON `dose_confirmations` FOR EACH ROW BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM schedules AS s
        WHERE s.schedule_id = NEW.schedule_id
          AND NEW.dose_date >= s.start_date
          AND (
              s.end_date IS NULL
              OR NEW.dose_date <= s.end_date
          )
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Dose date must fall within an existing schedule date range.';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM schedule_days AS sd
        WHERE sd.schedule_id = NEW.schedule_id
          AND sd.day_of_week = WEEKDAY(NEW.dose_date)
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Dose date is not a selected weekday for this schedule.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `medications`
--

DROP TABLE IF EXISTS `medications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medications` (
  `medication_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `name` varchar(150) NOT NULL,
  `dosage_instructions` varchar(255) NOT NULL,
  PRIMARY KEY (`medication_id`),
  KEY `fk_medications_user` (`user_id`),
  CONSTRAINT `fk_medications_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medications`
--

LOCK TABLES `medications` WRITE;
/*!40000 ALTER TABLE `medications` DISABLE KEYS */;
INSERT INTO `medications` VALUES (1,1,'Demo Medication A','Fictional instructions for application testing only'),(2,1,'Demo Medication B','Fictional instructions for application testing only'),(3,3,'Amlodipine','Follow the prescription label; demonstration record only.'),(4,4,'Atorvastatin','Follow the prescription label; demonstration record only.'),(5,5,'Metformin','Follow the prescription label; demonstration record only.'),(6,6,'Levothyroxine','Follow the prescription label; demonstration record only.'),(7,7,'Cetirizine','Follow the prescription label; demonstration record only.'),(8,8,'Omeprazole','Follow the prescription label; demonstration record only.'),(9,9,'Sertraline','Follow the prescription label; demonstration record only.'),(10,10,'Losartan','Follow the prescription label; demonstration record only.'),(11,11,'Loratadine','Follow the prescription label; demonstration record only.'),(12,12,'Folic acid','Follow the prescription label; demonstration record only.');
/*!40000 ALTER TABLE `medications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schedule_days`
--

DROP TABLE IF EXISTS `schedule_days`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `schedule_days` (
  `schedule_id` int NOT NULL,
  `day_of_week` tinyint unsigned NOT NULL,
  PRIMARY KEY (`schedule_id`,`day_of_week`),
  CONSTRAINT `fk_schedule_days_schedule` FOREIGN KEY (`schedule_id`) REFERENCES `schedules` (`schedule_id`) ON DELETE RESTRICT,
  CONSTRAINT `chk_schedule_days_weekday` CHECK ((`day_of_week` between 0 and 6))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedule_days`
--

LOCK TABLES `schedule_days` WRITE;
/*!40000 ALTER TABLE `schedule_days` DISABLE KEYS */;
INSERT INTO `schedule_days` VALUES (4,0),(5,1),(6,2),(7,0),(8,1),(9,2),(10,0),(11,1),(12,2),(13,0);
/*!40000 ALTER TABLE `schedule_days` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schedules`
--

DROP TABLE IF EXISTS `schedules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `schedules` (
  `schedule_id` int NOT NULL AUTO_INCREMENT,
  `medication_id` int NOT NULL,
  `reminder_time` time NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`schedule_id`),
  KEY `fk_schedules_medication` (`medication_id`),
  CONSTRAINT `fk_schedules_medication` FOREIGN KEY (`medication_id`) REFERENCES `medications` (`medication_id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedules`
--

LOCK TABLES `schedules` WRITE;
/*!40000 ALTER TABLE `schedules` DISABLE KEYS */;
INSERT INTO `schedules` VALUES (1,1,'08:00:00','2026-10-30',NULL,1),(2,1,'20:00:00','2026-10-30',NULL,1),(3,2,'12:00:00','2026-10-30',NULL,1),(4,3,'08:00:00','2026-11-01',NULL,1),(5,4,'20:00:00','2026-11-01',NULL,1),(6,5,'08:30:00','2026-11-01',NULL,1),(7,6,'07:00:00','2026-11-01',NULL,1),(8,7,'09:00:00','2026-11-01',NULL,1),(9,8,'07:30:00','2026-11-01',NULL,1),(10,9,'09:30:00','2026-11-01',NULL,1),(11,10,'08:00:00','2026-11-01',NULL,1),(12,11,'10:00:00','2026-11-01',NULL,1),(13,12,'09:00:00','2026-11-01',NULL,1),(19,1,'08:00:00','2026-11-01','2026-11-10',1),(20,1,'08:00:00','2026-11-01','2026-11-10',1);
/*!40000 ALTER TABLE `schedules` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_schedules_before_insert` BEFORE INSERT ON `schedules` FOR EACH ROW BEGIN
    IF NEW.end_date IS NOT NULL
       AND NEW.end_date < NEW.start_date THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'End date cannot be earlier than start date.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_schedules_before_update` BEFORE UPDATE ON `schedules` FOR EACH ROW BEGIN
    IF NEW.end_date IS NOT NULL
       AND NEW.end_date < NEW.start_date THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'End date cannot be earlier than start date.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(254) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Demo User','demo.user@example.com','TEST_ONLY_NOT_A_VALID_PASSWORD_HASH'),(3,'Amelia Thompson','amelia.thompson@example.com','TEST_ONLY_NOT_A_VALID_PASSWORD_HASH'),(4,'Oliver Bennett','oliver.bennett@example.com','TEST_ONLY_NOT_A_VALID_PASSWORD_HASH'),(5,'Sophie Patel','sophie.patel@example.com','TEST_ONLY_NOT_A_VALID_PASSWORD_HASH'),(6,'James Wilson','james.wilson@example.com','TEST_ONLY_NOT_A_VALID_PASSWORD_HASH'),(7,'Aisha Khan','aisha.khan@example.com','TEST_ONLY_NOT_A_VALID_PASSWORD_HASH'),(8,'Daniel Williams','daniel.williams@example.com','TEST_ONLY_NOT_A_VALID_PASSWORD_HASH'),(9,'Grace Campbell','grace.campbell@example.com','TEST_ONLY_NOT_A_VALID_PASSWORD_HASH'),(10,'Mohammed Ahmed','mohammed.ahmed@example.com','TEST_ONLY_NOT_A_VALID_PASSWORD_HASH'),(11,'Chloe Robinson','chloe.robinson@example.com','TEST_ONLY_NOT_A_VALID_PASSWORD_HASH'),(12,'Ethan Clarke','ethan.clarke@example.com','TEST_ONLY_NOT_A_VALID_PASSWORD_HASH');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'medication_reminder'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-05 20:46:27
