-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: churn_db
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
-- Temporary view structure for view `total_churn_rate`
--

DROP TABLE IF EXISTS `total_churn_rate`;
/*!50001 DROP VIEW IF EXISTS `total_churn_rate`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `total_churn_rate` AS SELECT 
 1 AS `total_customers`,
 1 AS `churned_customers`,
 1 AS `churned_rate_pct`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `churn_analysis`
--

DROP TABLE IF EXISTS `churn_analysis`;
/*!50001 DROP VIEW IF EXISTS `churn_analysis`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `churn_analysis` AS SELECT 
 1 AS `customer_id`,
 1 AS `age`,
 1 AS `gender`,
 1 AS `region`,
 1 AS `city`,
 1 AS `acquisition_channel`,
 1 AS `plan_type`,
 1 AS `contract_type`,
 1 AS `payment_method`,
 1 AS `monthly_charge`,
 1 AS `churn_reason`,
 1 AS `start_date`,
 1 AS `end_date`,
 1 AS `churned`,
 1 AS `tenure_months`,
 1 AS `ticket_count`,
 1 AS `avg_satisfaction`,
 1 AS `avg_logins`,
 1 AS `total_late_payments`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `total_churn_rate`
--

/*!50001 DROP VIEW IF EXISTS `total_churn_rate`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `total_churn_rate` AS select count(0) AS `total_customers`,sum((case when (`subscriptions`.`end_date` is not null) then 1 else 0 end)) AS `churned_customers`,round(((100.0 * sum((case when (`subscriptions`.`end_date` is not null) then 1 else 0 end))) / count(0)),1) AS `churned_rate_pct` from `subscriptions` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `churn_analysis`
--

/*!50001 DROP VIEW IF EXISTS `churn_analysis`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `churn_analysis` AS select `c`.`customer_id` AS `customer_id`,`c`.`age` AS `age`,`c`.`gender` AS `gender`,`c`.`region` AS `region`,`c`.`city` AS `city`,`c`.`acquisition_channel` AS `acquisition_channel`,`s`.`plan_type` AS `plan_type`,`s`.`contract_type` AS `contract_type`,`s`.`payment_method` AS `payment_method`,`s`.`monthly_charge` AS `monthly_charge`,`s`.`churn_reason` AS `churn_reason`,`s`.`start_date` AS `start_date`,`s`.`end_date` AS `end_date`,(case when (`s`.`end_date` is not null) then 1 else 0 end) AS `churned`,timestampdiff(MONTH,`s`.`start_date`,coalesce(`s`.`end_date`,'2025-06-30')) AS `tenure_months`,coalesce(`t`.`ticket_count`,0) AS `ticket_count`,`t`.`avg_satisfaction` AS `avg_satisfaction`,`u`.`avg_logins` AS `avg_logins`,`u`.`total_late_payments` AS `total_late_payments` from (((`customers` `c` join `subscriptions` `s` on((`c`.`customer_id` = `s`.`customer_id`))) left join (select `support_tickets`.`customer_id` AS `customer_id`,count(0) AS `ticket_count`,avg(`support_tickets`.`satisfaction_score`) AS `avg_satisfaction` from `support_tickets` group by `support_tickets`.`customer_id`) `t` on((`c`.`customer_id` = `t`.`customer_id`))) left join (select `monthly_usage`.`customer_id` AS `customer_id`,avg(`monthly_usage`.`logins`) AS `avg_logins`,sum(`monthly_usage`.`late_payments`) AS `total_late_payments` from `monthly_usage` group by `monthly_usage`.`customer_id`) `u` on((`c`.`customer_id` = `u`.`customer_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-29 16:06:47
