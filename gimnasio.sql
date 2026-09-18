-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: gymzone
-- ------------------------------------------------------
-- Server version	8.0.44

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

CREATE DATABASE IF NOT EXISTS `gymzone`;
USE `gymzone`;

--
-- Table structure for table `usuario`
--

DROP TABLE IF EXISTS `usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario` (
  `idusuario` int NOT NULL AUTO_INCREMENT,
  `primer_nombre` varchar(45) NOT NULL,
  `segundo_nombre` varchar(45) DEFAULT NULL,
  `primer_apellido` varchar(45) NOT NULL,
  `segundo_apellido` varchar(45) DEFAULT NULL,
  `tipo_doc` enum('CC','TI','CE','Pasaporte') NOT NULL,
  `num_doc` varchar(20) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `correo` varchar(100) NOT NULL,
  `password` varchar(255) DEFAULT NULL,
  `huella_biometrica` varbinary(8000) DEFAULT NULL,
  `rol` enum('Administrador','Entrenador','Cliente') NOT NULL,
  `estado_cuenta` enum('Activo','Inactivo') DEFAULT 'Activo',
  `plan_actual` varchar(50) DEFAULT 'BASICO',
  PRIMARY KEY (`idusuario`)
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` VALUES (1,'Admin',NULL,'General',NULL,'CC','1011',NULL,'contacto1@gymfitstyle.com',NULL,NULL,'Administrador','Activo','BASICO'),(2,'Entrenador',NULL,'Usuario2',NULL,'CC','1012',NULL,'contacto2@gymfitstyle.com',NULL,NULL,'Entrenador','Activo','BASICO'),(3,'Entrenador',NULL,'Usuario3',NULL,'CC','1013',NULL,'contacto3@gymfitstyle.com',NULL,NULL,'Entrenador','Activo','BASICO'),(4,'Entrenador',NULL,'Usuario4',NULL,'CC','1014',NULL,'contacto4@gymfitstyle.com',NULL,NULL,'Entrenador','Activo','BASICO'),(5,'Entrenador',NULL,'Usuario5',NULL,'CC','1015',NULL,'contacto5@gymfitstyle.com',NULL,NULL,'Entrenador','Activo','BASICO'),(6,'Entrenador',NULL,'Usuario6',NULL,'CC','1016',NULL,'contacto6@gymfitstyle.com',NULL,NULL,'Entrenador','Activo','BASICO'),(7,'Entrenador',NULL,'Usuario7',NULL,'CC','1017',NULL,'contacto7@gymfitstyle.com',NULL,NULL,'Entrenador','Activo','BASICO'),(8,'Entrenador',NULL,'Usuario8',NULL,'CC','1018',NULL,'contacto8@gymfitstyle.com',NULL,NULL,'Entrenador','Activo','BASICO'),(9,'Entrenador',NULL,'Usuario9',NULL,'CC','1019',NULL,'contacto9@gymfitstyle.com',NULL,NULL,'Entrenador','Activo','BASICO'),(10,'Entrenador',NULL,'Usuario10',NULL,'CC','1020',NULL,'contacto10@gymfitstyle.com',NULL,NULL,'Entrenador','Activo','BASICO'),(11,'Entrenador',NULL,'Usuario11',NULL,'CC','1021',NULL,'contacto11@gymfitstyle.com',NULL,NULL,'Entrenador','Activo','BASICO'),(12,'Cliente',NULL,'Usuario12',NULL,'CC','1022',NULL,'contacto12@gymfitstyle.com',NULL,NULL,'Cliente','Activo','BASICO'),(13,'Cliente',NULL,'Usuario13',NULL,'CC','1023',NULL,'contacto13@gymfitstyle.com',NULL,NULL,'Cliente','Activo','BASICO'),(14,'Cliente',NULL,'Usuario14',NULL,'CC','1024',NULL,'contacto14@gymfitstyle.com',NULL,NULL,'Cliente','Activo','BASICO'),(15,'Cliente',NULL,'Usuario15',NULL,'CC','1025',NULL,'contacto15@gymfitstyle.com',NULL,NULL,'Cliente','Activo','BASICO'),(16,'Cliente',NULL,'Usuario16',NULL,'CC','1026',NULL,'contacto16@gymfitstyle.com',NULL,NULL,'Cliente','Activo','BASICO'),(17,'Cliente',NULL,'Usuario17',NULL,'CC','1027',NULL,'contacto17@gymfitstyle.com',NULL,NULL,'Cliente','Activo','BASICO'),(18,'Cliente',NULL,'Usuario18',NULL,'CC','1028',NULL,'contacto18@gymfitstyle.com',NULL,NULL,'Cliente','Activo','BASICO'),(19,'Cliente',NULL,'Usuario19',NULL,'CC','1029',NULL,'contacto19@gymfitstyle.com',NULL,NULL,'Cliente','Activo','BASICO'),(20,'Cliente',NULL,'Usuario20',NULL,'CC','1030',NULL,'contacto20@gymfitstyle.com',NULL,NULL,'Cliente','Activo','BASICO'),(21,'Cliente',NULL,'Usuario21',NULL,'CC','1031',NULL,'contacto21@gymfitstyle.com',NULL,NULL,'Cliente','Activo','BASICO'),(22,'Cliente',NULL,'Usuario22',NULL,'CC','1032',NULL,'contacto22@gymfitstyle.com',NULL,NULL,'Cliente','Activo','BASICO'),(23,'Cliente',NULL,'Usuario23',NULL,'CC','1033',NULL,'contacto23@gymfitstyle.com',NULL,NULL,'Cliente','Activo','BASICO'),(24,'Cliente',NULL,'Usuario24',NULL,'CC','1034',NULL,'contacto24@gymfitstyle.com',NULL,NULL,'Cliente','Activo','BASICO'),(25,'Cliente',NULL,'Usuario25',NULL,'CC','1035',NULL,'contacto25@gymfitstyle.com',NULL,NULL,'Cliente','Activo','BASICO'),(26,'Cliente',NULL,'Usuario26',NULL,'CC','1036',NULL,'contacto26@gymfitstyle.com',NULL,NULL,'Cliente','Activo','BASICO'),(27,'Cliente',NULL,'Usuario27',NULL,'CC','1037',NULL,'contacto27@gymfitstyle.com',NULL,NULL,'Cliente','Activo','BASICO'),(28,'Cliente',NULL,'Usuario28',NULL,'CC','1038',NULL,'contacto28@gymfitstyle.com',NULL,NULL,'Cliente','Activo','BASICO'),(29,'Cliente',NULL,'Usuario29',NULL,'CC','1039',NULL,'contacto29@gymfitstyle.com',NULL,NULL,'Cliente','Activo','BASICO'),(30,'Cliente',NULL,'Usuario30',NULL,'CC','1040',NULL,'contacto30@gymfitstyle.com',NULL,NULL,'Cliente','Activo','BASICO'),(31,'Cliente',NULL,'Usuario31',NULL,'CC','1041',NULL,'contacto31@gymfitstyle.com',NULL,NULL,'Cliente','Activo','BASICO'),(32,'Cliente',NULL,'Usuario32',NULL,'CC','1042',NULL,'contacto32@gymfitstyle.com',NULL,NULL,'Cliente','Activo','BASICO'),(33,'Cliente',NULL,'Usuario33',NULL,'CC','1043',NULL,'contacto33@gymfitstyle.com',NULL,NULL,'Cliente','Activo','BASICO'),(34,'Cliente',NULL,'Usuario34',NULL,'CC','1044',NULL,'contacto34@gymfitstyle.com',NULL,NULL,'Cliente','Activo','BASICO'),(35,'Cliente',NULL,'Usuario35',NULL,'CC','1045',NULL,'contacto35@gymfitstyle.com',NULL,NULL,'Cliente','Activo','BASICO'),(36,'Cliente',NULL,'Usuario36',NULL,'CC','1046',NULL,'contacto36@gymfitstyle.com',NULL,NULL,'Cliente','Activo','BASICO'),(37,'Cliente',NULL,'Usuario37',NULL,'CC','1047',NULL,'contacto37@gymfitstyle.com',NULL,NULL,'Cliente','Activo','BASICO'),(38,'Cliente',NULL,'Usuario38',NULL,'CC','1048',NULL,'contacto38@gymfitstyle.com',NULL,NULL,'Cliente','Activo','BASICO'),(39,'Cliente',NULL,'Usuario39',NULL,'CC','1049',NULL,'contacto39@gymfitstyle.com',NULL,NULL,'Cliente','Activo','BASICO'),(40,'Cliente',NULL,'Usuario40',NULL,'CC','1050',NULL,'contacto40@gymfitstyle.com',NULL,NULL,'Cliente','Activo','BASICO'),(41,'Cliente',NULL,'Usuario41',NULL,'CC','1051',NULL,'contacto41@gymfitstyle.com',NULL,NULL,'Cliente','Activo','BASICO'),(42,'Cliente',NULL,'Usuario42',NULL,'CC','1052',NULL,'contacto42@gymfitstyle.com',NULL,NULL,'Cliente','Activo','BASICO'),(43,'Cliente',NULL,'Usuario43',NULL,'CC','1053',NULL,'contacto43@gymfitstyle.com',NULL,NULL,'Cliente','Activo','BASICO'),(44,'Cliente',NULL,'Usuario44',NULL,'CC','1054',NULL,'contacto44@gymfitstyle.com',NULL,NULL,'Cliente','Activo','BASICO'),(45,'Cliente',NULL,'Usuario45',NULL,'CC','1055',NULL,'contacto45@gymfitstyle.com',NULL,NULL,'Cliente','Activo','BASICO'),(46,'Cliente',NULL,'Usuario46',NULL,'CC','1056',NULL,'contacto46@gymfitstyle.com',NULL,NULL,'Cliente','Activo','BASICO'),(47,'Cliente',NULL,'Usuario47',NULL,'CC','1057',NULL,'contacto47@gymfitstyle.com',NULL,NULL,'Cliente','Activo','BASICO'),(48,'Cliente',NULL,'Usuario48',NULL,'CC','1058',NULL,'contacto48@gymfitstyle.com',NULL,NULL,'Cliente','Activo','BASICO'),(49,'Cliente',NULL,'Usuario49',NULL,'CC','1059',NULL,'contacto49@gymfitstyle.com',NULL,NULL,'Cliente','Activo','BASICO'),(50,'David',NULL,'Test',NULL,'CC','9999',NULL,'test@gymzone.com','1234',NULL,'Cliente','Activo','BASICO'),(51,'',NULL,'',NULL,'CC','1010',NULL,'admin1@gymzone.com','admin123',NULL,'Administrador','Activo','PREMIUM'),(52,'Henry',NULL,'Cavill',NULL,'CC','2020',NULL,'henry.coach@gymzone.com','coach123',NULL,'Entrenador','Activo','BASICO'),(53,'Gal',NULL,'Gadot',NULL,'CC','3030',NULL,'gal.entrenadora@gymzone.com','fit4life',NULL,'Entrenador','Activo','BASICO'),(54,'Tom',NULL,'holland',NULL,'CC','4040','No registrado','tom.cliente@gmail.com','spider123',NULL,'Cliente','Activo','PREMIUM'),(55,'Zendaya',NULL,'Coleman',NULL,'CC','5050',NULL,'zen.cliente@gmail.com','zen123',NULL,'Cliente','Activo','BASICO');
/*!40000 ALTER TABLE `usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `administrador`
--

DROP TABLE IF EXISTS `administrador`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `administrador` (
  `idadministrador` int NOT NULL AUTO_INCREMENT,
  `usuario_id` int NOT NULL,
  `cambiar_stock` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`idadministrador`),
  KEY `fk_admin_usuario` (`usuario_id`),
  CONSTRAINT `fk_admin_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuario` (`idusuario`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `administrador`
--

LOCK TABLES `administrador` WRITE;
/*!40000 ALTER TABLE `administrador` DISABLE KEYS */;
INSERT INTO `administrador` VALUES (1,1,'Si'),(2,1,'Si'),(3,1,'Si'),(4,1,'Si'),(5,1,'Si'),(6,1,'Si'),(7,1,'Si'),(8,1,'Si'),(9,1,'Si'),(10,1,'Si'),(11,1,'Si'),(12,1,'Si'),(13,1,'Si'),(14,1,'Si'),(15,1,'Si'),(16,1,'Si'),(17,1,'Si'),(18,1,'Si'),(19,1,'Si'),(20,1,'Si'),(21,1,'Si'),(22,1,'Si'),(23,1,'Si'),(24,1,'Si'),(25,1,'Si'),(26,1,'Si'),(27,1,'Si'),(28,1,'Si'),(29,1,'Si'),(30,1,'Si'),(31,1,'Si'),(32,1,'Si'),(33,1,'Si'),(34,1,'Si'),(35,1,'Si'),(36,1,'Si'),(37,1,'Si'),(38,1,'Si'),(39,1,'Si'),(40,1,'Si'),(41,1,'Si'),(42,1,'Si'),(43,1,'Si'),(44,1,'Si'),(45,1,'Si'),(46,1,'Si'),(47,1,'Si'),(48,1,'Si'),(49,1,'Si');
/*!40000 ALTER TABLE `administrador` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `asistencia`
--

DROP TABLE IF EXISTS `asistencia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `asistencia` (
  `id_asistencia` int NOT NULL AUTO_INCREMENT,
  `usuario_id` int NOT NULL,
  `fecha` date NOT NULL,
  `hora_ingreso` datetime NOT NULL,
  `hora_salida` datetime DEFAULT NULL,
  `total_horas_sesion` decimal(5,2) DEFAULT NULL,
  PRIMARY KEY (`id_asistencia`),
  KEY `fk_asistencia_usuario` (`usuario_id`),
  CONSTRAINT `fk_asistencia_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuario` (`idusuario`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `asistencia`
--

LOCK TABLES `asistencia` WRITE;
/*!40000 ALTER TABLE `asistencia` DISABLE KEYS */;
INSERT INTO `asistencia` VALUES (1,12,'2024-05-15','2024-05-15 08:30:00',NULL,1.50),(2,13,'2024-05-15','2024-05-15 08:30:00',NULL,1.50),(3,14,'2024-05-15','2024-05-15 08:30:00',NULL,1.50),(4,15,'2024-05-15','2024-05-15 08:30:00',NULL,1.50),(5,16,'2024-05-15','2024-05-15 08:30:00',NULL,1.50),(6,17,'2024-05-15','2024-05-15 08:30:00',NULL,1.50),(7,18,'2024-05-15','2024-05-15 08:30:00',NULL,1.50),(8,19,'2024-05-15','2024-05-15 08:30:00',NULL,1.50),(9,20,'2024-05-15','2024-05-15 08:30:00',NULL,1.50),(10,21,'2024-05-15','2024-05-15 08:30:00',NULL,1.50),(11,22,'2024-05-15','2024-05-15 08:30:00',NULL,1.50),(12,23,'2024-05-15','2024-05-15 08:30:00',NULL,1.50),(13,24,'2024-05-15','2024-05-15 08:30:00',NULL,1.50),(14,25,'2024-05-15','2024-05-15 08:30:00',NULL,1.50),(15,26,'2024-05-15','2024-05-15 08:30:00',NULL,1.50),(16,27,'2024-05-15','2024-05-15 08:30:00',NULL,1.50),(17,28,'2024-05-15','2024-05-15 08:30:00',NULL,1.50),(18,29,'2024-05-15','2024-05-15 08:30:00',NULL,1.50),(19,30,'2024-05-15','2024-05-15 08:30:00',NULL,1.50),(20,31,'2024-05-15','2024-05-15 08:30:00',NULL,1.50),(21,32,'2024-05-15','2024-05-15 08:30:00',NULL,1.50),(22,33,'2024-05-15','2024-05-15 08:30:00',NULL,1.50),(23,34,'2024-05-15','2024-05-15 08:30:00',NULL,1.50),(24,35,'2024-05-15','2024-05-15 08:30:00',NULL,1.50),(25,36,'2024-05-15','2024-05-15 08:30:00',NULL,1.50),(26,37,'2024-05-15','2024-05-15 08:30:00',NULL,1.50),(27,38,'2024-05-15','2024-05-15 08:30:00',NULL,1.50),(28,39,'2024-05-15','2024-05-15 08:30:00',NULL,1.50),(29,40,'2024-05-15','2024-05-15 08:30:00',NULL,1.50),(30,41,'2024-05-15','2024-05-15 08:30:00',NULL,1.50),(31,42,'2024-05-15','2024-05-15 08:30:00',NULL,1.50),(32,43,'2024-05-15','2024-05-15 08:30:00',NULL,1.50),(33,44,'2024-05-15','2024-05-15 08:30:00',NULL,1.50),(34,45,'2024-05-15','2024-05-15 08:30:00',NULL,1.50),(35,46,'2024-05-15','2024-05-15 08:30:00',NULL,1.50),(36,47,'2024-05-15','2024-05-15 08:30:00',NULL,1.50),(37,48,'2024-05-15','2024-05-15 08:30:00',NULL,1.50),(38,49,'2024-05-15','2024-05-15 08:30:00',NULL,1.50),(39,50,'2024-05-15','2024-05-15 08:30:00',NULL,1.50),(40,12,'2024-05-15','2024-05-15 08:30:00',NULL,1.50),(41,12,'2024-05-15','2024-05-15 08:30:00',NULL,1.50),(42,12,'2024-05-15','2024-05-15 08:30:00',NULL,1.50),(43,12,'2024-05-15','2024-05-15 08:30:00',NULL,1.50),(44,12,'2024-05-15','2024-05-15 08:30:00',NULL,1.50),(45,12,'2024-05-15','2024-05-15 08:30:00',NULL,1.50),(46,12,'2024-05-15','2024-05-15 08:30:00',NULL,1.50),(47,12,'2024-05-15','2024-05-15 08:30:00',NULL,1.50),(48,12,'2024-05-15','2024-05-15 08:30:00',NULL,1.50),(49,12,'2024-05-15','2024-05-15 08:30:00',NULL,1.50);
/*!40000 ALTER TABLE `asistencia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `entrenador`
--

DROP TABLE IF EXISTS `entrenador`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `entrenador` (
  `id_entrenador` int NOT NULL AUTO_INCREMENT,
  `usuario_id` int NOT NULL,
  `especialidad` varchar(45) DEFAULT NULL,
  `salario_hora` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id_entrenador`),
  KEY `fk_entrenador_usuario` (`usuario_id`),
  CONSTRAINT `fk_entrenador_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuario` (`idusuario`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `entrenador`
--

LOCK TABLES `entrenador` WRITE;
/*!40000 ALTER TABLE `entrenador` DISABLE KEYS */;
INSERT INTO `entrenador` VALUES (1,2,'Fitness y Musculación',35000.00),(2,3,'Fitness y Musculación',35000.00),(3,4,'Fitness y Musculación',35000.00),(4,5,'Fitness y Musculación',35000.00),(5,6,'Fitness y Musculación',35000.00),(6,7,'Fitness y Musculación',35000.00),(7,8,'Fitness y Musculación',35000.00),(8,9,'Fitness y Musculación',35000.00),(9,10,'Fitness y Musculación',35000.00),(10,11,'Fitness y Musculación',35000.00),(11,2,'Fitness y Musculación',35000.00),(12,2,'Fitness y Musculación',35000.00),(13,2,'Fitness y Musculación',35000.00),(14,2,'Fitness y Musculación',35000.00),(15,2,'Fitness y Musculación',35000.00),(16,2,'Fitness y Musculación',35000.00),(17,2,'Fitness y Musculación',35000.00),(18,2,'Fitness y Musculación',35000.00),(19,2,'Fitness y Musculación',35000.00),(20,2,'Fitness y Musculación',35000.00),(21,2,'Fitness y Musculación',35000.00),(22,2,'Fitness y Musculación',35000.00),(23,2,'Fitness y Musculación',35000.00),(24,2,'Fitness y Musculación',35000.00),(25,2,'Fitness y Musculación',35000.00),(26,2,'Fitness y Musculación',35000.00),(27,2,'Fitness y Musculación',35000.00),(28,2,'Fitness y Musculación',35000.00),(29,2,'Fitness y Musculación',35000.00),(30,2,'Fitness y Musculación',35000.00),(31,2,'Fitness y Musculación',35000.00),(32,2,'Fitness y Musculación',35000.00),(33,2,'Fitness y Musculación',35000.00),(34,2,'Fitness y Musculación',35000.00),(35,2,'Fitness y Musculación',35000.00),(36,2,'Fitness y Musculación',35000.00),(37,2,'Fitness y Musculación',35000.00),(38,2,'Fitness y Musculación',35000.00),(39,2,'Fitness y Musculación',35000.00),(40,2,'Fitness y Musculación',35000.00),(41,2,'Fitness y Musculación',35000.00),(42,2,'Fitness y Musculación',35000.00),(43,2,'Fitness y Musculación',35000.00),(44,2,'Fitness y Musculación',35000.00),(45,2,'Fitness y Musculación',35000.00),(46,2,'Fitness y Musculación',35000.00),(47,2,'Fitness y Musculación',35000.00),(48,2,'Fitness y Musculación',35000.00),(49,2,'Fitness y Musculación',35000.00);
/*!40000 ALTER TABLE `entrenador` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `planes`
--

DROP TABLE IF EXISTS `planes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `planes` (
  `id_planes` int NOT NULL AUTO_INCREMENT,
  `nombre_plan` varchar(45) NOT NULL,
  `tipo_plan` enum('Diario','Mensual','Semestral','Anual') DEFAULT NULL,
  `precio` decimal(10,2) NOT NULL,
  `duracion_dias` int DEFAULT NULL,
  `descripcion` text,
  PRIMARY KEY (`id_planes`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `planes`
--

LOCK TABLES `planes` WRITE;
/*!40000 ALTER TABLE `planes` DISABLE KEYS */;
INSERT INTO `planes` VALUES (1,'Plan Basic','Mensual',49900.00,30,'Acceso a zona de pesas y cardio.'),(2,'Plan Black','Mensual',89900.00,30,'Acceso total, clases grupales y zona de relax.'),(3,'Plan Platinum','Anual',850000.00,365,'Todo incluido, entrenador personal y nutrición.'),(4,'Plan Personalizado 1','Mensual',50400.00,30,'Servicios adicionales de entrenamiento y salud.'),(5,'Plan Personalizado 2','Mensual',50900.00,30,'Servicios adicionales de entrenamiento y salud.'),(6,'Plan Personalizado 3','Mensual',51400.00,30,'Servicios adicionales de entrenamiento y salud.'),(7,'Plan Personalizado 4','Mensual',51900.00,30,'Servicios adicionales de entrenamiento y salud.'),(8,'Plan Personalizado 5','Mensual',52400.00,30,'Servicios adicionales de entrenamiento y salud.'),(9,'Plan Personalizado 6','Mensual',52900.00,30,'Servicios adicionales de entrenamiento y salud.'),(10,'Plan Personalizado 7','Mensual',53400.00,30,'Servicios adicionales de entrenamiento y salud.'),(11,'Plan Personalizado 8','Mensual',53900.00,30,'Servicios adicionales de entrenamiento y salud.'),(12,'Plan Personalizado 9','Mensual',54400.00,30,'Servicios adicionales de entrenamiento y salud.'),(13,'Plan Personalizado 10','Mensual',54900.00,30,'Servicios adicionales de entrenamiento y salud.'),(14,'Plan Personalizado 11','Mensual',55400.00,30,'Servicios adicionales de entrenamiento y salud.'),(15,'Plan Personalizado 12','Mensual',55900.00,30,'Servicios adicionales de entrenamiento y salud.'),(16,'Plan Personalizado 13','Mensual',56400.00,30,'Servicios adicionales de entrenamiento y salud.'),(17,'Plan Personalizado 14','Mensual',56900.00,30,'Servicios adicionales de entrenamiento y salud.'),(18,'Plan Personalizado 15','Mensual',57400.00,30,'Servicios adicionales de entrenamiento y salud.'),(19,'Plan Personalizado 16','Mensual',57900.00,30,'Servicios adicionales de entrenamiento y salud.'),(20,'Plan Personalizado 17','Mensual',58400.00,30,'Servicios adicionales de entrenamiento y salud.'),(21,'Plan Personalizado 18','Mensual',58900.00,30,'Servicios adicionales de entrenamiento y salud.'),(22,'Plan Personalizado 19','Mensual',59400.00,30,'Servicios adicionales de entrenamiento y salud.'),(23,'Plan Personalizado 20','Mensual',59900.00,30,'Servicios adicionales de entrenamiento y salud.'),(24,'Plan Personalizado 21','Mensual',60400.00,30,'Servicios adicionales de entrenamiento y salud.'),(25,'Plan Personalizado 22','Mensual',60900.00,30,'Servicios adicionales de entrenamiento y salud.'),(26,'Plan Personalizado 23','Mensual',61400.00,30,'Servicios adicionales de entrenamiento y salud.'),(27,'Plan Personalizado 24','Mensual',61900.00,30,'Servicios adicionales de entrenamiento y salud.'),(28,'Plan Personalizado 25','Mensual',62400.00,30,'Servicios adicionales de entrenamiento y salud.'),(29,'Plan Personalizado 26','Mensual',62900.00,30,'Servicios adicionales de entrenamiento y salud.'),(30,'Plan Personalizado 27','Mensual',63400.00,30,'Servicios adicionales de entrenamiento y salud.'),(31,'Plan Personalizado 28','Mensual',63900.00,30,'Servicios adicionales de entrenamiento y salud.'),(32,'Plan Personalizado 29','Mensual',64400.00,30,'Servicios adicionales de entrenamiento y salud.'),(33,'Plan Personalizado 30','Mensual',64900.00,30,'Servicios adicionales de entrenamiento y salud.'),(34,'Plan Personalizado 31','Mensual',65400.00,30,'Servicios adicionales de entrenamiento y salud.'),(35,'Plan Personalizado 32','Mensual',65900.00,30,'Servicios adicionales de entrenamiento y salud.'),(36,'Plan Personalizado 33','Mensual',66400.00,30,'Servicios adicionales de entrenamiento y salud.'),(37,'Plan Personalizado 34','Mensual',66900.00,30,'Servicios adicionales de entrenamiento y salud.'),(38,'Plan Personalizado 35','Mensual',67400.00,30,'Servicios adicionales de entrenamiento y salud.'),(39,'Plan Personalizado 36','Mensual',67900.00,30,'Servicios adicionales de entrenamiento y salud.'),(40,'Plan Personalizado 37','Mensual',68400.00,30,'Servicios adicionales de entrenamiento y salud.'),(41,'Plan Personalizado 38','Mensual',68900.00,30,'Servicios adicionales de entrenamiento y salud.'),(42,'Plan Personalizado 39','Mensual',69400.00,30,'Servicios adicionales de entrenamiento y salud.'),(43,'Plan Personalizado 40','Mensual',69900.00,30,'Servicios adicionales de entrenamiento y salud.'),(44,'Plan Personalizado 41','Mensual',70400.00,30,'Servicios adicionales de entrenamiento y salud.'),(45,'Plan Personalizado 42','Mensual',70900.00,30,'Servicios adicionales de entrenamiento y salud.'),(46,'Plan Personalizado 43','Mensual',71400.00,30,'Servicios adicionales de entrenamiento y salud.'),(47,'Plan Personalizado 44','Mensual',71900.00,30,'Servicios adicionales de entrenamiento y salud.'),(48,'Plan Personalizado 45','Mensual',72400.00,30,'Servicios adicionales de entrenamiento y salud.'),(49,'Plan Personalizado 46','Mensual',72900.00,30,'Servicios adicionales de entrenamiento y salud.'),(50,'Plan Personalizado 47','Mensual',73400.00,30,'Servicios adicionales de entrenamiento y salud.');
/*!40000 ALTER TABLE `planes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sede`
--

DROP TABLE IF EXISTS `sede`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sede` (
  `id_sede` int NOT NULL AUTO_INCREMENT,
  `nombre_sede` varchar(45) NOT NULL,
  `direccion_sede` varchar(100) NOT NULL,
  `telefono_sede` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id_sede`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sede`
--

LOCK TABLES `sede` WRITE;
/*!40000 ALTER TABLE `sede` DISABLE KEYS */;
INSERT INTO `sede` VALUES (1,'Gym Fit Style','Av. Principal #123-45','+57 300 123 4567'),(2,'Gym Fit Style','Av. Principal #123-45','+57 300 123 4567'),(3,'Gym Fit Style','Av. Principal #123-45','+57 300 123 4567'),(4,'Gym Fit Style','Av. Principal #123-45','+57 300 123 4567'),(5,'Gym Fit Style','Av. Principal #123-45','+57 300 123 4567'),(6,'Gym Fit Style','Av. Principal #123-45','+57 300 123 4567'),(7,'Gym Fit Style','Av. Principal #123-45','+57 300 123 4567'),(8,'Gym Fit Style','Av. Principal #123-45','+57 300 123 4567'),(9,'Gym Fit Style','Av. Principal #123-45','+57 300 123 4567'),(10,'Gym Fit Style','Av. Principal #123-45','+57 300 123 4567'),(11,'Gym Fit Style','Av. Principal #123-45','+57 300 123 4567'),(12,'Gym Fit Style','Av. Principal #123-45','+57 300 123 4567'),(13,'Gym Fit Style','Av. Principal #123-45','+57 300 123 4567'),(14,'Gym Fit Style','Av. Principal #123-45','+57 300 123 4567'),(15,'Gym Fit Style','Av. Principal #123-45','+57 300 123 4567'),(16,'Gym Fit Style','Av. Principal #123-45','+57 300 123 4567'),(17,'Gym Fit Style','Av. Principal #123-45','+57 300 123 4567'),(18,'Gym Fit Style','Av. Principal #123-45','+57 300 123 4567'),(19,'Gym Fit Style','Av. Principal #123-45','+57 300 123 4567'),(20,'Gym Fit Style','Av. Principal #123-45','+57 300 123 4567'),(21,'Gym Fit Style','Av. Principal #123-45','+57 300 123 4567'),(22,'Gym Fit Style','Av. Principal #123-45','+57 300 123 4567'),(23,'Gym Fit Style','Av. Principal #123-45','+57 300 123 4567'),(24,'Gym Fit Style','Av. Principal #123-45','+57 300 123 4567'),(25,'Gym Fit Style','Av. Principal #123-45','+57 300 123 4567'),(26,'Gym Fit Style','Av. Principal #123-45','+57 300 123 4567'),(27,'Gym Fit Style','Av. Principal #123-45','+57 300 123 4567'),(28,'Gym Fit Style','Av. Principal #123-45','+57 300 123 4567'),(29,'Gym Fit Style','Av. Principal #123-45','+57 300 123 4567'),(30,'Gym Fit Style','Av. Principal #123-45','+57 300 123 4567'),(31,'Gym Fit Style','Av. Principal #123-45','+57 300 123 4567'),(32,'Gym Fit Style','Av. Principal #123-45','+57 300 123 4567'),(33,'Gym Fit Style','Av. Principal #123-45','+57 300 123 4567'),(34,'Gym Fit Style','Av. Principal #123-45','+57 300 123 4567'),(35,'Gym Fit Style','Av. Principal #123-45','+57 300 123 4567'),(36,'Gym Fit Style','Av. Principal #123-45','+57 300 123 4567'),(37,'Gym Fit Style','Av. Principal #123-45','+57 300 123 4567'),(38,'Gym Fit Style','Av. Principal #123-45','+57 300 123 4567'),(39,'Gym Fit Style','Av. Principal #123-45','+57 300 123 4567'),(40,'Gym Fit Style','Av. Principal #123-45','+57 300 123 4567'),(41,'Gym Fit Style','Av. Principal #123-45','+57 300 123 4567'),(42,'Gym Fit Style','Av. Principal #123-45','+57 300 123 4567'),(43,'Gym Fit Style','Av. Principal #123-45','+57 300 123 4567'),(44,'Gym Fit Style','Av. Principal #123-45','+57 300 123 4567'),(45,'Gym Fit Style','Av. Principal #123-45','+57 300 123 4567'),(46,'Gym Fit Style','Av. Principal #123-45','+57 300 123 4567'),(47,'Gym Fit Style','Av. Principal #123-45','+57 300 123 4567'),(48,'Gym Fit Style','Av. Principal #123-45','+57 300 123 4567'),(49,'Gym Fit Style','Av. Principal #123-45','+57 300 123 4567');
/*!40000 ALTER TABLE `sede` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cliente`
--

DROP TABLE IF EXISTS `cliente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cliente` (
  `id_cliente` int NOT NULL AUTO_INCREMENT,
  `usuario_id` int NOT NULL,
  `fecha_registro` date DEFAULT NULL,
  `entrenador_asignado` int DEFAULT NULL,
  `plan_actual` int DEFAULT NULL,
  `sede_id` int DEFAULT NULL,
  `fecha_vencimiento` date DEFAULT NULL,
  PRIMARY KEY (`id_cliente`),
  KEY `fk_cliente_entrenador` (`entrenador_asignado`),
  KEY `fk_cliente_planes` (`plan_actual`),
  KEY `fk_cliente_sede` (`sede_id`),
  KEY `fk_cliente_usuario` (`usuario_id`),
  CONSTRAINT `fk_cliente_entrenador` FOREIGN KEY (`entrenador_asignado`) REFERENCES `entrenador` (`id_entrenador`),
  CONSTRAINT `fk_cliente_planes` FOREIGN KEY (`plan_actual`) REFERENCES `planes` (`id_planes`),
  CONSTRAINT `fk_cliente_sede` FOREIGN KEY (`sede_id`) REFERENCES `sede` (`id_sede`),
  CONSTRAINT `fk_cliente_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuario` (`idusuario`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cliente`
--

LOCK TABLES `cliente` WRITE;
/*!40000 ALTER TABLE `cliente` DISABLE KEYS */;
INSERT INTO `cliente` VALUES (1,12,'2024-01-01',2,2,1,'2025-01-01'),(2,13,'2024-01-01',3,3,1,'2025-01-01'),(3,14,'2024-01-01',4,1,1,'2025-01-01'),(4,15,'2024-01-01',5,2,1,'2025-01-01'),(5,16,'2024-01-01',6,3,1,'2025-01-01'),(6,17,'2024-01-01',7,1,1,'2025-01-01'),(7,18,'2024-01-01',8,2,1,'2025-01-01'),(8,19,'2024-01-01',9,3,1,'2025-01-01'),(9,20,'2024-01-01',10,1,1,'2025-01-01'),(10,21,'2024-01-01',1,2,1,'2025-01-01'),(11,22,'2024-01-01',2,3,1,'2025-01-01'),(12,23,'2024-01-01',3,1,1,'2025-01-01'),(13,24,'2024-01-01',4,2,1,'2025-01-01'),(14,25,'2024-01-01',5,3,1,'2025-01-01'),(15,26,'2024-01-01',6,1,1,'2025-01-01'),(16,27,'2024-01-01',7,2,1,'2025-01-01'),(17,28,'2024-01-01',8,3,1,'2025-01-01'),(18,29,'2024-01-01',9,1,1,'2025-01-01'),(19,30,'2024-01-01',10,2,1,'2025-01-01'),(20,31,'2024-01-01',1,3,1,'2025-01-01'),(21,32,'2024-01-01',2,1,1,'2025-01-01'),(22,33,'2024-01-01',3,2,1,'2025-01-01'),(23,34,'2024-01-01',4,3,1,'2025-01-01'),(24,35,'2024-01-01',5,1,1,'2025-01-01'),(25,36,'2024-01-01',6,2,1,'2025-01-01'),(26,37,'2024-01-01',7,3,1,'2025-01-01'),(27,38,'2024-01-01',8,1,1,'2025-01-01'),(28,39,'2024-01-01',9,2,1,'2025-01-01'),(29,40,'2024-01-01',10,3,1,'2025-01-01'),(30,41,'2024-01-01',1,1,1,'2025-01-01'),(31,42,'2024-01-01',2,2,1,'2025-01-01'),(32,43,'2024-01-01',3,3,1,'2025-01-01'),(33,44,'2024-01-01',4,1,1,'2025-01-01'),(34,45,'2024-01-01',5,2,1,'2025-01-01'),(35,46,'2024-01-01',6,3,1,'2025-01-01'),(36,47,'2024-01-01',7,1,1,'2025-01-01'),(37,48,'2024-01-01',8,2,1,'2025-01-01'),(38,49,'2024-01-01',9,3,1,'2025-01-01'),(39,50,'2024-01-01',10,1,1,'2025-01-01'),(40,12,'2024-01-01',1,2,1,'2025-01-01'),(41,12,'2024-01-01',2,3,1,'2025-01-01'),(42,12,'2024-01-01',3,1,1,'2025-01-01'),(43,12,'2024-01-01',4,2,1,'2025-01-01'),(44,12,'2024-01-01',5,3,1,'2025-01-01'),(45,12,'2024-01-01',6,1,1,'2025-01-01'),(46,12,'2024-01-01',7,2,1,'2025-01-01'),(47,12,'2024-01-01',8,3,1,'2025-01-01'),(48,12,'2024-01-01',9,1,1,'2025-01-01'),(49,12,'2024-01-01',10,2,1,'2025-01-01');
/*!40000 ALTER TABLE `cliente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pagos`
--

DROP TABLE IF EXISTS `pagos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pagos` (
  `id_pagos` int NOT NULL AUTO_INCREMENT,
  `id_cliente` int NOT NULL,
  `id_plan` int DEFAULT NULL,
  `monto` decimal(10,2) NOT NULL,
  `fecha_pago` datetime DEFAULT CURRENT_TIMESTAMP,
  `metodo_pago` enum('Efectivo','Tarjeta','Transferencia') NOT NULL,
  PRIMARY KEY (`id_pagos`),
  KEY `fk_pagos_cliente` (`id_cliente`),
  KEY `fk_pagos_plan` (`id_plan`),
  CONSTRAINT `fk_pagos_cliente` FOREIGN KEY (`id_cliente`) REFERENCES `cliente` (`id_cliente`),
  CONSTRAINT `fk_pagos_plan` FOREIGN KEY (`id_plan`) REFERENCES `planes` (`id_planes`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pagos`
--

LOCK TABLES `pagos` WRITE;
/*!40000 ALTER TABLE `pagos` DISABLE KEYS */;
INSERT INTO `pagos` VALUES (1,1,2,89900.00,'2026-04-12 20:19:31','Tarjeta'),(2,2,3,850000.00,'2026-04-12 20:19:31','Tarjeta'),(3,3,1,49900.00,'2026-04-12 20:19:31','Tarjeta'),(4,4,2,89900.00,'2026-04-12 20:19:31','Tarjeta'),(5,5,3,850000.00,'2026-04-12 20:19:31','Tarjeta'),(6,6,1,49900.00,'2026-04-12 20:19:31','Tarjeta'),(7,7,2,89900.00,'2026-04-12 20:19:31','Tarjeta'),(8,8,3,850000.00,'2026-04-12 20:19:31','Tarjeta'),(9,9,1,49900.00,'2026-04-12 20:19:31','Tarjeta'),(10,10,2,89900.00,'2026-04-12 20:19:31','Tarjeta'),(11,11,3,850000.00,'2026-04-12 20:19:31','Tarjeta'),(12,12,1,49900.00,'2026-04-12 20:19:31','Tarjeta'),(13,13,2,89900.00,'2026-04-12 20:19:31','Tarjeta'),(14,14,3,850000.00,'2026-04-12 20:19:31','Tarjeta'),(15,15,1,49900.00,'2026-04-12 20:19:31','Tarjeta'),(16,16,2,89900.00,'2026-04-12 20:19:31','Tarjeta'),(17,17,3,850000.00,'2026-04-12 20:19:31','Tarjeta'),(18,18,1,49900.00,'2026-04-12 20:19:31','Tarjeta'),(19,19,2,89900.00,'2026-04-12 20:19:31','Tarjeta'),(20,20,3,850000.00,'2026-04-12 20:19:31','Tarjeta'),(21,21,1,49900.00,'2026-04-12 20:19:31','Tarjeta'),(22,22,2,89900.00,'2026-04-12 20:19:31','Tarjeta'),(23,23,3,850000.00,'2026-04-12 20:19:31','Tarjeta'),(24,24,1,49900.00,'2026-04-12 20:19:31','Tarjeta'),(25,25,2,89900.00,'2026-04-12 20:19:31','Tarjeta'),(26,26,3,850000.00,'2026-04-12 20:19:31','Tarjeta'),(27,27,1,49900.00,'2026-04-12 20:19:31','Tarjeta'),(28,28,2,89900.00,'2026-04-12 20:19:31','Tarjeta'),(29,29,3,850000.00,'2026-04-12 20:19:31','Tarjeta'),(30,30,1,49900.00,'2026-04-12 20:19:31','Tarjeta'),(31,31,2,89900.00,'2026-04-12 20:19:31','Tarjeta'),(32,32,3,850000.00,'2026-04-12 20:19:31','Tarjeta'),(33,33,1,49900.00,'2026-04-12 20:19:31','Tarjeta'),(34,34,2,89900.00,'2026-04-12 20:19:31','Tarjeta'),(35,35,3,850000.00,'2026-04-12 20:19:31','Tarjeta'),(36,36,1,49900.00,'2026-04-12 20:19:31','Tarjeta'),(37,37,2,89900.00,'2026-04-12 20:19:31','Tarjeta'),(38,38,3,850000.00,'2026-04-12 20:19:31','Tarjeta'),(39,39,1,49900.00,'2026-04-12 20:19:31','Tarjeta'),(40,40,2,89900.00,'2026-04-12 20:19:31','Tarjeta'),(41,41,3,850000.00,'2026-04-12 20:19:31','Tarjeta'),(42,42,1,49900.00,'2026-04-12 20:19:31','Tarjeta'),(43,43,2,89900.00,'2026-04-12 20:19:31','Tarjeta'),(44,44,3,850000.00,'2026-04-12 20:19:31','Tarjeta'),(45,45,1,49900.00,'2026-04-12 20:19:31','Tarjeta'),(46,46,2,89900.00,'2026-04-12 20:19:31','Tarjeta'),(47,47,3,850000.00,'2026-04-12 20:19:31','Tarjeta'),(48,48,1,49900.00,'2026-04-12 20:19:31','Tarjeta'),(49,49,2,89900.00,'2026-04-12 20:19:31','Tarjeta');
/*!40000 ALTER TABLE `pagos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `productos`
--

DROP TABLE IF EXISTS `productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `productos` (
  `id_producto` int NOT NULL AUTO_INCREMENT,
  `nombre_producto` varchar(45) NOT NULL,
  `stock` int NOT NULL,
  `precio_venta` decimal(10,2) NOT NULL,
  `tipo_producto` varchar(45) DEFAULT NULL,
  `fecha_vencimiento` date DEFAULT NULL,
  `administrador_idadministrador` int DEFAULT NULL,
  PRIMARY KEY (`id_producto`),
  KEY `fk_productos_administrador` (`administrador_idadministrador`),
  CONSTRAINT `fk_productos_administrador` FOREIGN KEY (`administrador_idadministrador`) REFERENCES `administrador` (`idadministrador`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productos`
--

LOCK TABLES `productos` WRITE;
/*!40000 ALTER TABLE `productos` DISABLE KEYS */;
INSERT INTO `productos` VALUES (1,'Creatina',100,145000.00,'Suplemento',NULL,1),(2,'Aminoácidos',100,145000.00,'Suplemento',NULL,1),(3,'Pre-Entreno',100,145000.00,'Suplemento',NULL,1),(4,'Proteína Whey',100,145000.00,'Suplemento',NULL,1),(5,'Creatina',100,145000.00,'Suplemento',NULL,1),(6,'Aminoácidos',100,145000.00,'Suplemento',NULL,1),(7,'Pre-Entreno',100,145000.00,'Suplemento',NULL,1),(8,'Proteína Whey',100,145000.00,'Suplemento',NULL,1),(9,'Creatina',100,145000.00,'Suplemento',NULL,1),(10,'Aminoácidos',100,145000.00,'Suplemento',NULL,1),(11,'Pre-Entreno',100,145000.00,'Suplemento',NULL,1),(12,'Proteína Whey',100,145000.00,'Suplemento',NULL,1),(13,'Creatina',100,145000.00,'Suplemento',NULL,1),(14,'Aminoácidos',100,145000.00,'Suplemento',NULL,1),(15,'Pre-Entreno',100,145000.00,'Suplemento',NULL,1),(16,'Proteína Whey',100,145000.00,'Suplemento',NULL,1),(17,'Creatina',100,145000.00,'Suplemento',NULL,1),(18,'Aminoácidos',100,145000.00,'Suplemento',NULL,1),(19,'Pre-Entreno',100,145000.00,'Suplemento',NULL,1),(20,'Proteína Whey',100,145000.00,'Suplemento',NULL,1),(21,'Creatina',100,145000.00,'Suplemento',NULL,1),(22,'Aminoácidos',100,145000.00,'Suplemento',NULL,1),(23,'Pre-Entreno',100,145000.00,'Suplemento',NULL,1),(24,'Proteína Whey',100,145000.00,'Suplemento',NULL,1),(25,'Creatina',100,145000.00,'Suplemento',NULL,1),(26,'Aminoácidos',100,145000.00,'Suplemento',NULL,1),(27,'Pre-Entreno',100,145000.00,'Suplemento',NULL,1),(28,'Proteína Whey',100,145000.00,'Suplemento',NULL,1),(29,'Creatina',100,145000.00,'Suplemento',NULL,1),(30,'Aminoácidos',100,145000.00,'Suplemento',NULL,1),(31,'Pre-Entreno',100,145000.00,'Suplemento',NULL,1),(32,'Proteína Whey',100,145000.00,'Suplemento',NULL,1),(33,'Creatina',100,145000.00,'Suplemento',NULL,1),(34,'Aminoácidos',100,145000.00,'Suplemento',NULL,1),(35,'Pre-Entreno',100,145000.00,'Suplemento',NULL,1),(36,'Proteína Whey',100,145000.00,'Suplemento',NULL,1),(37,'Creatina',100,145000.00,'Suplemento',NULL,1),(38,'Aminoácidos',100,145000.00,'Suplemento',NULL,1),(39,'Pre-Entreno',100,145000.00,'Suplemento',NULL,1),(40,'Proteína Whey',100,145000.00,'Suplemento',NULL,1),(41,'Creatina',100,145000.00,'Suplemento',NULL,1),(42,'Aminoácidos',100,145000.00,'Suplemento',NULL,1),(43,'Pre-Entreno',100,145000.00,'Suplemento',NULL,1),(44,'Proteína Whey',100,145000.00,'Suplemento',NULL,1),(45,'Creatina',100,145000.00,'Suplemento',NULL,1),(46,'Aminoácidos',100,145000.00,'Suplemento',NULL,1),(47,'Pre-Entreno',100,145000.00,'Suplemento',NULL,1),(48,'Proteína Whey',100,145000.00,'Suplemento',NULL,1),(49,'Creatina',100,145000.00,'Suplemento',NULL,1);
/*!40000 ALTER TABLE `productos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categoria_producto`
--

DROP TABLE IF EXISTS `categoria_producto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categoria_producto` (
  `id_categoria` int NOT NULL AUTO_INCREMENT,
  `nombre_categoria` varchar(45) NOT NULL,
  `tipo_categoria` varchar(45) NOT NULL,
  `productos_id_producto` int NOT NULL,
  PRIMARY KEY (`id_categoria`),
  KEY `fk_categoria_producto_productos` (`productos_id_producto`),
  CONSTRAINT `fk_categoria_producto_productos` FOREIGN KEY (`productos_id_producto`) REFERENCES `productos` (`id_producto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categoria_producto`
--

LOCK TABLES `categoria_producto` WRITE;
/*!40000 ALTER TABLE `categoria_producto` DISABLE KEYS */;
INSERT INTO `categoria_producto` VALUES (1,'Nutrición Deportiva','Venta Directa',1),(2,'Nutrición Deportiva','Venta Directa',2),(3,'Nutrición Deportiva','Venta Directa',3),(4,'Nutrición Deportiva','Venta Directa',4),(5,'Nutrición Deportiva','Venta Directa',5),(6,'Nutrición Deportiva','Venta Directa',6),(7,'Nutrición Deportiva','Venta Directa',7),(8,'Nutrición Deportiva','Venta Directa',8),(9,'Nutrición Deportiva','Venta Directa',9),(10,'Nutrición Deportiva','Venta Directa',10),(11,'Nutrición Deportiva','Venta Directa',11),(12,'Nutrición Deportiva','Venta Directa',12),(13,'Nutrición Deportiva','Venta Directa',13),(14,'Nutrición Deportiva','Venta Directa',14),(15,'Nutrición Deportiva','Venta Directa',15),(16,'Nutrición Deportiva','Venta Directa',16),(17,'Nutrición Deportiva','Venta Directa',17),(18,'Nutrición Deportiva','Venta Directa',18),(19,'Nutrición Deportiva','Venta Directa',19),(20,'Nutrición Deportiva','Venta Directa',20),(21,'Nutrición Deportiva','Venta Directa',21),(22,'Nutrición Deportiva','Venta Directa',22),(23,'Nutrición Deportiva','Venta Directa',23),(24,'Nutrición Deportiva','Venta Directa',24),(25,'Nutrición Deportiva','Venta Directa',25),(26,'Nutrición Deportiva','Venta Directa',26),(27,'Nutrición Deportiva','Venta Directa',27),(28,'Nutrición Deportiva','Venta Directa',28),(29,'Nutrición Deportiva','Venta Directa',29),(30,'Nutrición Deportiva','Venta Directa',30),(31,'Nutrición Deportiva','Venta Directa',31),(32,'Nutrición Deportiva','Venta Directa',32),(33,'Nutrición Deportiva','Venta Directa',33),(34,'Nutrición Deportiva','Venta Directa',34),(35,'Nutrición Deportiva','Venta Directa',35),(36,'Nutrición Deportiva','Venta Directa',36),(37,'Nutrición Deportiva','Venta Directa',37),(38,'Nutrición Deportiva','Venta Directa',38),(39,'Nutrición Deportiva','Venta Directa',39),(40,'Nutrición Deportiva','Venta Directa',40),(41,'Nutrición Deportiva','Venta Directa',41),(42,'Nutrición Deportiva','Venta Directa',42),(43,'Nutrición Deportiva','Venta Directa',43),(44,'Nutrición Deportiva','Venta Directa',44),(45,'Nutrición Deportiva','Venta Directa',45),(46,'Nutrición Deportiva','Venta Directa',46),(47,'Nutrición Deportiva','Venta Directa',47),(48,'Nutrición Deportiva','Venta Directa',48),(49,'Nutrición Deportiva','Venta Directa',49);
/*!40000 ALTER TABLE `categoria_producto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `detalle_venta_productos`
--

DROP TABLE IF EXISTS `detalle_venta_productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `detalle_venta_productos` (
  `id_detalle` int NOT NULL AUTO_INCREMENT,
  `pago_id` int NOT NULL,
  `producto_id` int NOT NULL,
  `cantidad` int NOT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id_detalle`),
  KEY `fk_det_pago` (`pago_id`),
  KEY `fk_det_prod` (`producto_id`),
  CONSTRAINT `fk_det_pago` FOREIGN KEY (`pago_id`) REFERENCES `pagos` (`id_pagos`),
  CONSTRAINT `fk_det_prod` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id_producto`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `detalle_venta_productos`
--

LOCK TABLES `detalle_venta_productos` WRITE;
/*!40000 ALTER TABLE `detalle_venta_productos` DISABLE KEYS */;
INSERT INTO `detalle_venta_productos` VALUES (1,1,1,1,145000.00),(2,2,2,1,145000.00),(3,3,3,1,145000.00),(4,4,4,1,145000.00),(5,5,5,1,145000.00),(6,6,6,1,145000.00),(7,7,7,1,145000.00),(8,8,8,1,145000.00),(9,9,9,1,145000.00),(10,10,10,1,145000.00),(11,11,11,1,145000.00),(12,12,12,1,145000.00),(13,13,13,1,145000.00),(14,14,14,1,145000.00),(15,15,15,1,145000.00),(16,16,16,1,145000.00),(17,17,17,1,145000.00),(18,18,18,1,145000.00),(19,19,19,1,145000.00),(20,20,20,1,145000.00),(21,21,21,1,145000.00),(22,22,22,1,145000.00),(23,23,23,1,145000.00),(24,24,24,1,145000.00),(25,25,25,1,145000.00),(26,26,26,1,145000.00),(27,27,27,1,145000.00),(28,28,28,1,145000.00),(29,29,29,1,145000.00),(30,30,30,1,145000.00),(31,31,31,1,145000.00),(32,32,32,1,145000.00),(33,33,33,1,145000.00),(34,34,34,1,145000.00),(35,35,35,1,145000.00),(36,36,36,1,145000.00),(37,37,37,1,145000.00),(38,38,38,1,145000.00),(39,39,39,1,145000.00),(40,40,40,1,145000.00),(41,41,41,1,145000.00),(42,42,42,1,145000.00),(43,43,43,1,145000.00),(44,44,44,1,145000.00),(45,45,45,1,145000.00),(46,46,46,1,145000.00),(47,47,47,1,145000.00),(48,48,48,1,145000.00),(49,49,49,1,145000.00);
/*!40000 ALTER TABLE `detalle_venta_productos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rutinas`
--

DROP TABLE IF EXISTS `rutinas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rutinas` (
  `id_rutinas` int NOT NULL AUTO_INCREMENT,
  `entrenador_id` int NOT NULL,
  `nombre_rutina` varchar(100) NOT NULL,
  `descripcion_ejercicios` text NOT NULL,
  `fecha_creacion` datetime DEFAULT CURRENT_TIMESTAMP,
  `planes_id_planes` int NOT NULL,
  PRIMARY KEY (`id_rutinas`),
  KEY `fk_rutina_entrenador` (`entrenador_id`),
  KEY `fk_rutinas_planes` (`planes_id_planes`),
  CONSTRAINT `fk_rutina_entrenador` FOREIGN KEY (`entrenador_id`) REFERENCES `entrenador` (`id_entrenador`),
  CONSTRAINT `fk_rutinas_planes` FOREIGN KEY (`planes_id_planes`) REFERENCES `planes` (`id_planes`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rutinas`
--

LOCK TABLES `rutinas` WRITE;
/*!40000 ALTER TABLE `rutinas` DISABLE KEYS */;
INSERT INTO `rutinas` VALUES (1,2,'Entrenamiento Especializado','Ejercicios de fuerza y acondicionamiento según el plan seleccionado.','2026-04-12 20:19:31',2),(2,3,'Entrenamiento Especializado','Ejercicios de fuerza y acondicionamiento según el plan seleccionado.','2026-04-12 20:19:31',3),(3,4,'Entrenamiento Especializado','Ejercicios de fuerza y acondicionamiento según el plan seleccionado.','2026-04-12 20:19:31',1),(4,5,'Entrenamiento Especializado','Ejercicios de fuerza y acondicionamiento según el plan seleccionado.','2026-04-12 20:19:31',2),(5,6,'Entrenamiento Especializado','Ejercicios de fuerza y acondicionamiento según el plan seleccionado.','2026-04-12 20:19:31',3),(6,7,'Entrenamiento Especializado','Ejercicios de fuerza y acondicionamiento según el plan seleccionado.','2026-04-12 20:19:31',1),(7,8,'Entrenamiento Especializado','Ejercicios de fuerza y acondicionamiento según el plan seleccionado.','2026-04-12 20:19:31',2),(8,9,'Entrenamiento Especializado','Ejercicios de fuerza y acondicionamiento según el plan seleccionado.','2026-04-12 20:19:31',3),(9,10,'Entrenamiento Especializado','Ejercicios de fuerza y acondicionamiento según el plan seleccionado.','2026-04-12 20:19:31',1),(10,1,'Entrenamiento Especializado','Ejercicios de fuerza y acondicionamiento según el plan seleccionado.','2026-04-12 20:19:31',2),(11,2,'Entrenamiento Especializado','Ejercicios de fuerza y acondicionamiento según el plan seleccionado.','2026-04-12 20:19:31',3),(12,3,'Entrenamiento Especializado','Ejercicios de fuerza y acondicionamiento según el plan seleccionado.','2026-04-12 20:19:31',1),(13,4,'Entrenamiento Especializado','Ejercicios de fuerza y acondicionamiento según el plan seleccionado.','2026-04-12 20:19:31',2),(14,5,'Entrenamiento Especializado','Ejercicios de fuerza y acondicionamiento según el plan seleccionado.','2026-04-12 20:19:31',3),(15,6,'Entrenamiento Especializado','Ejercicios de fuerza y acondicionamiento según el plan seleccionado.','2026-04-12 20:19:31',1),(16,7,'Entrenamiento Especializado','Ejercicios de fuerza y acondicionamiento según el plan seleccionado.','2026-04-12 20:19:31',2),(17,8,'Entrenamiento Especializado','Ejercicios de fuerza y acondicionamiento según el plan seleccionado.','2026-04-12 20:19:31',3),(18,9,'Entrenamiento Especializado','Ejercicios de fuerza y acondicionamiento según el plan seleccionado.','2026-04-12 20:19:31',1),(19,10,'Entrenamiento Especializado','Ejercicios de fuerza y acondicionamiento según el plan seleccionado.','2026-04-12 20:19:31',2),(20,1,'Entrenamiento Especializado','Ejercicios de fuerza y acondicionamiento según el plan seleccionado.','2026-04-12 20:19:31',3),(21,2,'Entrenamiento Especializado','Ejercicios de fuerza y acondicionamiento según el plan seleccionado.','2026-04-12 20:19:31',1),(22,3,'Entrenamiento Especializado','Ejercicios de fuerza y acondicionamiento según el plan seleccionado.','2026-04-12 20:19:31',2),(23,4,'Entrenamiento Especializado','Ejercicios de fuerza y acondicionamiento según el plan seleccionado.','2026-04-12 20:19:31',3),(24,5,'Entrenamiento Especializado','Ejercicios de fuerza y acondicionamiento según el plan seleccionado.','2026-04-12 20:19:31',1),(25,6,'Entrenamiento Especializado','Ejercicios de fuerza y acondicionamiento según el plan seleccionado.','2026-04-12 20:19:31',2),(26,7,'Entrenamiento Especializado','Ejercicios de fuerza y acondicionamiento según el plan seleccionado.','2026-04-12 20:19:31',3),(27,8,'Entrenamiento Especializado','Ejercicios de fuerza y acondicionamiento según el plan seleccionado.','2026-04-12 20:19:31',1),(28,9,'Entrenamiento Especializado','Ejercicios de fuerza y acondicionamiento según el plan seleccionado.','2026-04-12 20:19:31',2),(29,10,'Entrenamiento Especializado','Ejercicios de fuerza y acondicionamiento según el plan seleccionado.','2026-04-12 20:19:31',3),(30,1,'Entrenamiento Especializado','Ejercicios de fuerza y acondicionamiento según el plan seleccionado.','2026-04-12 20:19:31',1),(31,2,'Entrenamiento Especializado','Ejercicios de fuerza y acondicionamiento según el plan seleccionado.','2026-04-12 20:19:31',2),(32,3,'Entrenamiento Especializado','Ejercicios de fuerza y acondicionamiento según el plan seleccionado.','2026-04-12 20:19:31',3),(33,4,'Entrenamiento Especializado','Ejercicios de fuerza y acondicionamiento según el plan seleccionado.','2026-04-12 20:19:31',1),(34,5,'Entrenamiento Especializado','Ejercicios de fuerza y acondicionamiento según el plan seleccionado.','2026-04-12 20:19:31',2),(35,6,'Entrenamiento Especializado','Ejercicios de fuerza y acondicionamiento según el plan seleccionado.','2026-04-12 20:19:31',3),(36,7,'Entrenamiento Especializado','Ejercicios de fuerza y acondicionamiento según el plan seleccionado.','2026-04-12 20:19:31',1),(37,8,'Entrenamiento Especializado','Ejercicios de fuerza y acondicionamiento según el plan seleccionado.','2026-04-12 20:19:31',2),(38,9,'Entrenamiento Especializado','Ejercicios de fuerza y acondicionamiento según el plan seleccionado.','2026-04-12 20:19:31',3),(39,10,'Entrenamiento Especializado','Ejercicios de fuerza y acondicionamiento según el plan seleccionado.','2026-04-12 20:19:31',1),(40,1,'Entrenamiento Especializado','Ejercicios de fuerza y acondicionamiento según el plan seleccionado.','2026-04-12 20:19:31',2),(41,2,'Entrenamiento Especializado','Ejercicios de fuerza y acondicionamiento según el plan seleccionado.','2026-04-12 20:19:31',3),(42,3,'Entrenamiento Especializado','Ejercicios de fuerza y acondicionamiento según el plan seleccionado.','2026-04-12 20:19:31',1),(43,4,'Entrenamiento Especializado','Ejercicios de fuerza y acondicionamiento según el plan seleccionado.','2026-04-12 20:19:31',2),(44,5,'Entrenamiento Especializado','Ejercicios de fuerza y acondicionamiento según el plan seleccionado.','2026-04-12 20:19:31',3),(45,6,'Entrenamiento Especializado','Ejercicios de fuerza y acondicionamiento según el plan seleccionado.','2026-04-12 20:19:31',1),(46,7,'Entrenamiento Especializado','Ejercicios de fuerza y acondicionamiento según el plan seleccionado.','2026-04-12 20:19:31',2),(47,8,'Entrenamiento Especializado','Ejercicios de fuerza y acondicionamiento según el plan seleccionado.','2026-04-12 20:19:31',3),(48,9,'Entrenamiento Especializado','Ejercicios de fuerza y acondicionamiento según el plan seleccionado.','2026-04-12 20:19:31',1),(49,10,'Entrenamiento Especializado','Ejercicios de fuerza y acondicionamiento según el plan seleccionado.','2026-04-12 20:19:31',2);
/*!40000 ALTER TABLE `rutinas` ENABLE KEYS */;
UNLOCK TABLES;

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
CREATE TABLE IF NOT EXISTS `notificacion` (
  `id_notificacion` INT NOT NULL AUTO_INCREMENT,
  `usuario_id` INT NOT NULL,
  `mensaje` TEXT NOT NULL,
  `fecha_envio` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `leido` TINYINT(1) DEFAULT 0,
  PRIMARY KEY (`id_notificacion`),
  KEY `fk_notificacion_usuario` (`usuario_id`),
  CONSTRAINT `fk_notificacion_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuario` (`idusuario`) ON DELETE CASCADE
);