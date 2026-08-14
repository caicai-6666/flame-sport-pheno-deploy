-- 燃动现象数据库初始化结构
-- 仅包含当前表结构，不包含生产或测试业务数据。

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
DROP TABLE IF EXISTS `department`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `department` (
  `id` varchar(64) NOT NULL COMMENT '部门ID',
  `name` varchar(64) NOT NULL COMMENT '部门名称',
  `status` tinyint unsigned NOT NULL DEFAULT '1' COMMENT '状态：1启用，0停用',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_department_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='部门表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `leaderboard_snapshot`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `leaderboard_snapshot` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '排行榜快照记录ID',
  `season_user_id` bigint unsigned NOT NULL COMMENT '赛季用户记录ID',
  `checkin_count` int unsigned NOT NULL DEFAULT '0' COMMENT '当前赛季累计打卡次数',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_leaderboard_snapshot_season_user` (`season_user_id`),
  KEY `idx_leaderboard_snapshot_checkin_count` (`checkin_count`),
  CONSTRAINT `fk_leaderboard_snapshot_season_user` FOREIGN KEY (`season_user_id`) REFERENCES `season_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='排行榜快照表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `point_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `point_record` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '积分变动记录ID',
  `user_id` varchar(64) NOT NULL COMMENT '用户ID',
  `product_id` bigint unsigned DEFAULT NULL COMMENT '商品ID，商品兑换及其退款流水使用',
  `change_type` varchar(32) NOT NULL COMMENT '积分变动类型：season_reward赛季奖励，exchange商品兑换，exchange_refund兑换退款，manual_adjust后台调整',
  `change_points` int NOT NULL COMMENT '积分变动值，正数增加，负数扣减',
  `points_after` int unsigned NOT NULL COMMENT '变动后的积分余额',
  `description` varchar(255) DEFAULT NULL COMMENT '积分变动描述',
  `status` tinyint unsigned NOT NULL DEFAULT '1' COMMENT '状态：1有效，0作废',
  `gift_distribution_status` varchar(16) NOT NULL DEFAULT 'pending' COMMENT '礼品发放状态：pending待发放，distributed已发放，rejected拒绝发放',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '积分变动时间',
  PRIMARY KEY (`id`),
  KEY `idx_point_record_user_created_at` (`user_id`,`created_at`),
  KEY `idx_point_record_product_id` (`product_id`),
  KEY `idx_point_record_gift_distribution` (`change_type`,`gift_distribution_status`,`created_at`),
  CONSTRAINT `fk_point_record_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`),
  CONSTRAINT `fk_point_record_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  CONSTRAINT `chk_point_record_gift_distribution_exchange` CHECK (((`gift_distribution_status` = _utf8mb4'pending') or ((`change_type` = _utf8mb4'exchange') and (`product_id` is not null)))),
  CONSTRAINT `chk_point_record_gift_distribution_status` CHECK ((`gift_distribution_status` in (_utf8mb4'pending',_utf8mb4'distributed',_utf8mb4'rejected')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='积分变动记录表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '商品ID',
  `name` varchar(128) NOT NULL COMMENT '商品名称',
  `description` varchar(255) DEFAULT NULL COMMENT '商品说明',
  `points_required` int unsigned NOT NULL COMMENT '兑换所需积分',
  `image_url` varchar(255) DEFAULT NULL COMMENT '商品图片地址',
  `status` tinyint unsigned NOT NULL DEFAULT '1' COMMENT '状态：1上架，0下架',
  PRIMARY KEY (`id`),
  KEY `idx_product_status` (`status`),
  KEY `idx_product_points_required` (`points_required`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `project`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `project` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '项目ID',
  `name` varchar(64) NOT NULL COMMENT '项目名称',
  `description` varchar(255) DEFAULT NULL COMMENT '项目说明',
  `icon_url` varchar(255) DEFAULT NULL COMMENT '项目图标地址',
  `status` tinyint unsigned NOT NULL DEFAULT '1' COMMENT '状态：1启用，0停用',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_project_name` (`name`),
  KEY `idx_project_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='项目表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `project_level`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `project_level` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '项目等级ID',
  `name` varchar(32) NOT NULL COMMENT '等级名称',
  `reward` int unsigned NOT NULL DEFAULT '0' COMMENT '挑战成功后奖励积分',
  `status` tinyint unsigned NOT NULL DEFAULT '1' COMMENT '状态：1启用，0停用',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_project_level_name` (`name`),
  KEY `idx_project_level_status` (`status`),
  KEY `idx_project_level_sort_order` (`reward`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='项目等级表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `project_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `project_rule` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '项目规则ID',
  `project_id` bigint unsigned NOT NULL COMMENT '项目ID',
  `level_id` bigint unsigned NOT NULL COMMENT '项目等级ID',
  `sub_desc` varchar(128) DEFAULT NULL COMMENT '挑战副描述',
  `rule_content` json NOT NULL COMMENT '规则指标内容，JSON数组',
  `rule_note` varchar(255) DEFAULT NULL COMMENT '规则备注说明',
  `status` tinyint unsigned NOT NULL DEFAULT '1' COMMENT '状态：1启用，0停用',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_project_rule_project_level` (`project_id`,`level_id`),
  KEY `idx_project_rule_project_id` (`project_id`),
  KEY `idx_project_rule_level_id` (`level_id`),
  KEY `idx_project_rule_status` (`status`),
  CONSTRAINT `fk_project_rule_level` FOREIGN KEY (`level_id`) REFERENCES `project_level` (`id`),
  CONSTRAINT `fk_project_rule_project` FOREIGN KEY (`project_id`) REFERENCES `project` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='项目规则表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `project_upload_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `project_upload_config` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '项目上传配置ID',
  `project_id` bigint unsigned NOT NULL COMMENT '项目ID',
  `record_type` varchar(64) NOT NULL COMMENT '凭证类型展示名称',
  `upload_hint` varchar(255) NOT NULL COMMENT '上传图片下方的凭证类型提示',
  `note_example` varchar(255) DEFAULT NULL COMMENT '备注输入框填写示例',
  `sort_order` int unsigned NOT NULL DEFAULT '0' COMMENT '展示排序，数值越小越靠前',
  `status` tinyint unsigned NOT NULL DEFAULT '1' COMMENT '状态：1启用，0停用',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_project_upload_config_project_record_type` (`project_id`,`record_type`),
  KEY `idx_project_upload_config_project_id` (`project_id`),
  KEY `idx_project_upload_config_status` (`status`),
  KEY `idx_project_upload_config_sort_order` (`sort_order`),
  CONSTRAINT `fk_project_upload_config_project` FOREIGN KEY (`project_id`) REFERENCES `project` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='项目上传配置表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `proof_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proof_record` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '凭证记录ID',
  `season_user_id` bigint unsigned NOT NULL COMMENT '赛季用户记录ID',
  `project_id` bigint unsigned NOT NULL COMMENT '项目ID',
  `project_upload_config_id` bigint unsigned NOT NULL COMMENT '项目上传配置ID',
  `image_url` varchar(500) NOT NULL COMMENT '上传图片路径',
  `note` varchar(255) DEFAULT NULL COMMENT '用户备注',
  `proof_date` date NOT NULL COMMENT '凭证对应的实际运动日期',
  `review_status` varchar(32) NOT NULL DEFAULT 'pending' COMMENT '审核状态：pending待初审，preliminary_approved初审通过，preliminary_rejected初审失败，approved终审通过，rejected终审失败',
  `review_comment` varchar(500) DEFAULT NULL COMMENT '审核评论，用于后台人员填写审核说明',
  `progress_delta` decimal(5,4) NOT NULL DEFAULT '0.0000' COMMENT '大模型初审给出的原始项目进度增量',
  `increase` decimal(5,4) NOT NULL DEFAULT '0.0000' COMMENT '当前凭证实际分配到项目进度条的贡献',
  `status` tinyint unsigned NOT NULL DEFAULT '1' COMMENT '状态：1正常，0无效/删除',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '上传时间',
  PRIMARY KEY (`id`),
  KEY `idx_proof_record_season_user_id` (`season_user_id`),
  KEY `idx_proof_record_project_id` (`project_id`),
  KEY `idx_proof_record_project_upload_config_id` (`project_upload_config_id`),
  KEY `idx_proof_record_review_status` (`review_status`),
  KEY `idx_proof_record_status` (`status`),
  KEY `idx_proof_record_created_at` (`created_at`),
  KEY `idx_proof_record_season_project_proof_date_status` (`season_user_id`,`project_id`,`proof_date`,`status`),
  CONSTRAINT `fk_proof_record_project` FOREIGN KEY (`project_id`) REFERENCES `project` (`id`),
  CONSTRAINT `fk_proof_record_project_upload_config` FOREIGN KEY (`project_upload_config_id`) REFERENCES `project_upload_config` (`id`),
  CONSTRAINT `fk_proof_record_season_user` FOREIGN KEY (`season_user_id`) REFERENCES `season_user` (`id`),
  CONSTRAINT `chk_proof_record_increase` CHECK (((`increase` >= 0) and (`increase` <= `progress_delta`))),
  CONSTRAINT `chk_proof_record_progress_delta` CHECK (((`progress_delta` >= 0) and (`progress_delta` <= 1)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='凭证记录表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `season`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `season` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '赛季ID',
  `name` varchar(64) NOT NULL COMMENT '赛季名称',
  `start_date` date NOT NULL COMMENT '赛季开始日期',
  `end_date` date NOT NULL COMMENT '赛季结束日期',
  `status` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '状态：0未开始，1进行中，2结算中，3已结束',
  `required_project_count` tinyint unsigned NOT NULL DEFAULT '3' COMMENT '当前赛季要求选择的项目数量',
  PRIMARY KEY (`id`),
  KEY `idx_season_status` (`status`),
  KEY `idx_season_date` (`start_date`,`end_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='赛季表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `season_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `season_user` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '赛季用户记录ID',
  `season_id` bigint unsigned NOT NULL COMMENT '赛季ID',
  `user_id` varchar(64) NOT NULL COMMENT '用户ID',
  `level_id` bigint unsigned DEFAULT NULL COMMENT '项目等级ID',
  `participated_at` datetime DEFAULT NULL COMMENT '正式报名时间（首次锁定挑战等级时写入）',
  `final_points` int unsigned DEFAULT NULL COMMENT '赛季最终获得积分，NULL表示尚未结算',
  `status` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '已锁定项目数量',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_season_user` (`season_id`,`user_id`),
  KEY `idx_season_user_season_id` (`season_id`),
  KEY `idx_season_user_user_id` (`user_id`),
  KEY `idx_season_user_level_id` (`level_id`),
  KEY `idx_season_user_status` (`status`),
  KEY `idx_season_user_participated_at` (`participated_at`),
  CONSTRAINT `fk_season_user_level` FOREIGN KEY (`level_id`) REFERENCES `project_level` (`id`),
  CONSTRAINT `fk_season_user_season` FOREIGN KEY (`season_id`) REFERENCES `season` (`id`),
  CONSTRAINT `fk_season_user_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='赛季用户表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `season_user_project`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `season_user_project` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '赛季用户项目记录ID',
  `season_user_id` bigint unsigned NOT NULL COMMENT '赛季用户记录ID',
  `project_id` bigint unsigned NOT NULL COMMENT '项目ID',
  `completion_progress` decimal(5,4) NOT NULL DEFAULT '0.0000' COMMENT '本赛季项目完成进度：0未完成，1已完成',
  `status` tinyint unsigned NOT NULL DEFAULT '1' COMMENT '状态：1已锁定，0无效/取消',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_season_user_project` (`season_user_id`,`project_id`),
  KEY `idx_season_user_project_season_user_id` (`season_user_id`),
  KEY `idx_season_user_project_project_id` (`project_id`),
  KEY `idx_season_user_project_status` (`status`),
  CONSTRAINT `fk_season_user_project_project` FOREIGN KEY (`project_id`) REFERENCES `project` (`id`),
  CONSTRAINT `fk_season_user_project_season_user` FOREIGN KEY (`season_user_id`) REFERENCES `season_user` (`id`),
  CONSTRAINT `chk_season_user_project_completion_progress` CHECK (((`completion_progress` >= 0) and (`completion_progress` <= 1)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='赛季用户项目表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` varchar(64) NOT NULL COMMENT '用户ID',
  `name` varchar(64) NOT NULL COMMENT '用户名称',
  `department_id` varchar(64) NOT NULL COMMENT '所属部门ID',
  `avatar_url` varchar(255) DEFAULT NULL COMMENT '头像地址',
  `height_cm` decimal(5,2) DEFAULT NULL COMMENT '用户身高，单位厘米，用于BMI计算',
  `status` tinyint unsigned NOT NULL DEFAULT '1' COMMENT '状态：1启用，0停用',
  PRIMARY KEY (`id`),
  KEY `idx_user_department_id` (`department_id`),
  KEY `idx_user_status` (`status`),
  CONSTRAINT `fk_user_department` FOREIGN KEY (`department_id`) REFERENCES `department` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `user_suggestion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_suggestion` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '用户建议唯一标识',
  `user_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '提交建议的用户ID，关联user表主键',
  `content` text NOT NULL COMMENT '用户填写的建议内容',
  `status` tinyint unsigned NOT NULL DEFAULT '1' COMMENT '记录状态：1可见，0隐藏',
  `processing_stage` varchar(32) NOT NULL DEFAULT 'pending' COMMENT '处理阶段：pending待处理，rejected拒绝，optimized已优化',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '用户提交建议的时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_suggestion_user_created` (`user_id`,`created_at`),
  KEY `idx_user_suggestion_status_created` (`status`,`created_at`),
  KEY `idx_user_suggestion_processing_stage_created` (`processing_stage`,`created_at`),
  CONSTRAINT `fk_user_suggestion_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  CONSTRAINT `chk_user_suggestion_processing_stage` CHECK ((`processing_stage` in (_utf8mb4'pending',_utf8mb4'rejected',_utf8mb4'optimized')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户建议表';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;


