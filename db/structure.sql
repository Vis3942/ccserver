
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
DROP TABLE IF EXISTS `ar_internal_metadata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ar_internal_metadata` (
  `key` varchar(255) NOT NULL,
  `value` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `devices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `devices` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `serial_number` varchar(255) DEFAULT NULL,
  `imei_number` varchar(255) DEFAULT NULL,
  `location_id` bigint(20) NOT NULL,
  `service_tag` varchar(255) DEFAULT NULL,
  `firmware_version` varchar(255) DEFAULT NULL,
  `device_ping_data` varchar(255) DEFAULT NULL,
  `device_ping_at` datetime DEFAULT NULL,
  `pay_per_use` tinyint(1) DEFAULT NULL,
  `decommissioned` tinyint(1) DEFAULT NULL,
  `missing` tinyint(1) DEFAULT NULL,
  `from` datetime DEFAULT NULL,
  `to` datetime DEFAULT NULL,
  `pay_per_use_approved` tinyint(1) DEFAULT NULL,
  `language_version` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_devices_on_service_tag` (`service_tag`),
  KEY `index_devices_on_location_id` (`location_id`),
  KEY `index_devices_on_serial_number` (`serial_number`),
  KEY `index_devices_on_imei_number` (`imei_number`),
  CONSTRAINT `fk_rails_6579ce3834` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `error_lists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `error_lists` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) DEFAULT NULL,
  `code` varchar(255) DEFAULT NULL,
  `shutdown` enum('no','yes') DEFAULT 'no',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `errors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `errors` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `device_id` bigint(20) NOT NULL,
  `location_id` bigint(20) NOT NULL,
  `occured_at` datetime DEFAULT NULL,
  `error_code` int(11) DEFAULT NULL,
  `received_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_errors_on_device_id` (`device_id`),
  KEY `index_errors_on_location_id` (`location_id`),
  CONSTRAINT `fk_rails_54b6be6710` FOREIGN KEY (`device_id`) REFERENCES `devices` (`id`),
  CONSTRAINT `fk_rails_8445c2a1b2` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `groups` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `account_qb_id` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_groups_on_account_qb_id` (`account_qb_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `locations` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `group_id` bigint(20) NOT NULL,
  `shipto_qb_id` varchar(255) DEFAULT NULL,
  `shipto_qb_name` varchar(255) DEFAULT NULL,
  `shipto_qb_address_l1` varchar(255) DEFAULT NULL,
  `shipto_qb_address_l2` varchar(255) DEFAULT NULL,
  `shipto_qb_city` varchar(255) DEFAULT NULL,
  `shipto_qb_state` varchar(255) DEFAULT NULL,
  `shipto_qb_zip` varchar(255) DEFAULT NULL,
  `shipto_qb_country` varchar(255) DEFAULT NULL,
  `shipto_qb_contact` varchar(255) DEFAULT NULL,
  `shipto_qb_phone_number` varchar(255) DEFAULT NULL,
  `time_zone` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_locations_on_shipto_qb_id` (`shipto_qb_id`),
  KEY `index_locations_on_group_id` (`group_id`),
  KEY `index_locations_on_shipto_qb_name` (`shipto_qb_name`),
  KEY `index_locations_on_shipto_qb_phone_number` (`shipto_qb_phone_number`),
  CONSTRAINT `fk_rails_75f551d444` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  PRIMARY KEY (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `usage_statistics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usage_statistics` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `device_id` bigint(20) NOT NULL,
  `location_id` bigint(20) NOT NULL,
  `received_at` datetime DEFAULT NULL,
  `cartridge_tag_id` varchar(255) DEFAULT NULL,
  `serum_name` varchar(255) DEFAULT NULL,
  `serum_part_number` varchar(255) DEFAULT NULL,
  `treatment_time` varchar(255) DEFAULT NULL,
  `datetime_used` varchar(255) DEFAULT NULL,
  `board_temperature` varchar(255) DEFAULT NULL,
  `min_co2_temperature` varchar(255) DEFAULT NULL,
  `max_co2_temperature` varchar(255) DEFAULT NULL,
  `average_co2_temperature` varchar(255) DEFAULT NULL,
  `tank_tag_id` varchar(255) DEFAULT NULL,
  `tank_time_remaining` varchar(255) DEFAULT NULL,
  `serum_lot_number` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_usage_statistics_on_device_id` (`device_id`),
  KEY `index_usage_statistics_on_location_id` (`location_id`),
  CONSTRAINT `fk_rails_1b92889b59` FOREIGN KEY (`device_id`) REFERENCES `devices` (`id`),
  CONSTRAINT `fk_rails_8c89e0214f` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `user_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_tokens` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `token` varchar(255) DEFAULT NULL,
  `user_id` bigint(20) NOT NULL,
  `expires_at` time DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_user_tokens_on_token` (`token`),
  KEY `index_user_tokens_on_user_id` (`user_id`),
  CONSTRAINT `fk_rails_e0a9c15abb` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL DEFAULT '',
  `encrypted_password` varchar(255) NOT NULL DEFAULT '',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `role` enum('techsupport','admin') DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_on_email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

INSERT INTO `schema_migrations` (version) VALUES
('20200525064148'),
('20200526051459'),
('20200531055829'),
('20200906063932'),
('20200915065500'),
('20200915065723'),
('20200915065829'),
('20201012002302'),
('20201014060002'),
('20201014101643'),
('20201019074925'),
('20201020072823'),
('20201022064609'),
('20201030062303'),
('20201030064630'),
('20201030064657'),
('20210106084116'),
('20210108070408');


