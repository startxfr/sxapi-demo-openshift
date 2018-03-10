-- MySQL dump 10.14  Distrib 5.5.58-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: 172.17.0.4    Database: dev_api
-- ------------------------------------------------------
-- Server version	5.5.59-MariaDB-1~wheezy

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

--
-- Table structure for table `entreprise`
--

DROP TABLE IF EXISTS `entreprise`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `entreprise` (
  `id_ent` mediumint(3) unsigned NOT NULL AUTO_INCREMENT,
  `type_ent` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `nom_ent` varchar(64) NOT NULL DEFAULT '???',
  `add1_ent` varchar(128) DEFAULT NULL,
  `add2_ent` varchar(128) DEFAULT NULL,
  `cp_ent` varchar(5) DEFAULT NULL,
  `ville_ent` varchar(64) DEFAULT NULL,
  `pays_ent` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `tel_ent` varchar(16) DEFAULT NULL,
  `telsi_ent` varchar(16) DEFAULT NULL,
  `fax_ent` varchar(16) DEFAULT NULL,
  `www_ent` varchar(128) DEFAULT NULL,
  `activite_ent` tinyint(1) unsigned DEFAULT NULL,
  `effectif_ent` varchar(4) DEFAULT NULL,
  `codefourn_ent` varchar(32) DEFAULT NULL,
  `SIRET_ent` varchar(32) DEFAULT NULL,
  `numeroTVA_ent` varchar(32) DEFAULT NULL,
  `tauxTVA_ent` decimal(3,1) NOT NULL DEFAULT '19.6',
  `remise_ent` decimal(5,2) DEFAULT '0.00',
  `groupe_ent` int(4) unsigned DEFAULT NULL,
  `siege_ent` int(1) unsigned DEFAULT NULL,
  `commsociete_ent` text,
  `loginRHN_ent` varchar(64) DEFAULT NULL,
  `actif_ent` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id_ent`),
  KEY `nom_ent` (`nom_ent`),
  KEY `add1_ent` (`add1_ent`),
  KEY `cp_ent` (`cp_ent`),
  KEY `ville_ent` (`ville_ent`),
  KEY `pays_ent` (`pays_ent`),
  KEY `activite_ent` (`activite_ent`),
  KEY `groupe_ent` (`groupe_ent`),
  KEY `siege_ent` (`siege_ent`),
  KEY `type_ent` (`type_ent`),
  KEY `loginRHN_ent` (`loginRHN_ent`),
  KEY `SIRET_ent` (`SIRET_ent`),
  KEY `codefourn_ent` (`codefourn_ent`)
) ENGINE=InnoDB AUTO_INCREMENT=11310 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `session`
--

DROP TABLE IF EXISTS `session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `session` (
  `id_sess` varchar(255) NOT NULL DEFAULT '',
  `user_sess` varchar(64) NOT NULL DEFAULT 'ERROR_USER',
  `date_sess` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `datefin_sess` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `secure_sess` varchar(16) DEFAULT NULL,
  `OS_sess` varchar(32) DEFAULT NULL,
  `browser_sess` varchar(32) DEFAULT NULL,
  `ip_sess` varchar(16) DEFAULT NULL,
  `host_sess` varchar(64) DEFAULT NULL,
  `channel_sess` varchar(32) DEFAULT NULL,
  `backup_sess` mediumtext,
  PRIMARY KEY (`id_sess`),
  KEY `OS_sess` (`OS_sess`),
  KEY `browser_sess` (`browser_sess`),
  KEY `secure_sess` (`secure_sess`),
  KEY `user_sess` (`user_sess`),
  KEY `channel_sess` (`channel_sess`),
  KEY `host_sess` (`host_sess`),
  KEY `ip_sess` (`ip_sess`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping events for database 'dev_api'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-01-25 15:19:07
