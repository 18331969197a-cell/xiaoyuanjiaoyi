/*
 Navicat Premium Data Transfer

 Source Server         : 付
 Source Server Type    : MySQL
 Source Server Version : 80039 (8.0.39)
 Source Host           : localhost:3306
 Source Schema         : demo1

 Target Server Type    : MySQL
 Target Server Version : 80039 (8.0.39)
 File Encoding         : 65001

 Date: 02/02/2026 14:44:04
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for biz_category
-- ----------------------------
DROP TABLE IF EXISTS `biz_category`;
CREATE TABLE `biz_category`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '鍒嗙被ID',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '鍒嗙被鍚嶇О',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '鐖剁骇ID锛?琛ㄧず椤剁骇',
  `icon` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '鍥炬爣',
  `sort` int NULL DEFAULT 0 COMMENT '鎺掑簭',
  `status` tinyint NULL DEFAULT 1 COMMENT '鐘舵?锛?-绂佺敤锛?-鍚?敤',
  `create_by` bigint NULL DEFAULT NULL COMMENT '鍒涘缓浜',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '鍒涘缓鏃堕棿',
  `update_by` bigint NULL DEFAULT NULL COMMENT '鏇存柊浜',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '鏇存柊鏃堕棿',
  `is_deleted` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '閫昏緫鍒犻櫎锛?-鏈?垹闄わ紝1-宸插垹闄',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_parent_id`(`parent_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '鐗╁搧鍒嗙被琛' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of biz_category
-- ----------------------------
INSERT INTO `biz_category` VALUES (1, '电子产品', 0, 'lucide:smartphone', 1, 1, NULL, '2025-12-27 23:46:09', NULL, '2025-12-29 13:26:53', '0', NULL);
INSERT INTO `biz_category` VALUES (2, '证件卡类', 0, 'lucide:credit-card', 2, 1, NULL, '2025-12-27 23:46:09', NULL, '2025-12-27 23:46:09', '0', NULL);
INSERT INTO `biz_category` VALUES (3, '生活用品', 0, 'lucide:briefcase', 3, 1, NULL, '2025-12-27 23:46:09', NULL, '2025-12-27 23:46:09', '0', NULL);
INSERT INTO `biz_category` VALUES (4, '书籍文具', 0, 'lucide:book-open', 4, 1, NULL, '2025-12-27 23:46:09', NULL, '2025-12-27 23:46:09', '0', NULL);
INSERT INTO `biz_category` VALUES (5, '服饰配件', 0, 'lucide:shirt', 5, 1, NULL, '2025-12-27 23:46:09', NULL, '2025-12-27 23:46:09', '0', NULL);
INSERT INTO `biz_category` VALUES (6, '其他', 0, 'lucide:more-horizontal', 99, 1, NULL, '2025-12-27 23:46:09', NULL, '2025-12-29 13:26:35', '1', NULL);
INSERT INTO `biz_category` VALUES (7, '手机', 1, 'lucide:smartphone', 1, 1, NULL, '2025-12-27 23:46:09', NULL, '2025-12-27 23:46:09', '0', NULL);
INSERT INTO `biz_category` VALUES (8, '电脑/平板', 1, 'lucide:laptop', 2, 1, NULL, '2025-12-27 23:46:09', NULL, '2025-12-27 23:46:09', '0', NULL);
INSERT INTO `biz_category` VALUES (9, '耳机/音箱', 1, 'lucide:headphones', 3, 1, NULL, '2025-12-27 23:46:09', NULL, '2025-12-27 23:46:09', '0', NULL);
INSERT INTO `biz_category` VALUES (10, '充电器/数据线', 1, 'lucide:cable', 4, 1, NULL, '2025-12-27 23:46:09', NULL, '2025-12-27 23:46:09', '0', NULL);
INSERT INTO `biz_category` VALUES (11, 'U盘/硬盘', 1, 'lucide:hard-drive', 5, 1, NULL, '2025-12-27 23:46:09', NULL, '2025-12-27 23:46:09', '0', NULL);
INSERT INTO `biz_category` VALUES (12, '学生证', 2, 'lucide:id-card', 1, 1, NULL, '2025-12-27 23:46:09', NULL, '2025-12-27 23:46:09', '0', NULL);
INSERT INTO `biz_category` VALUES (13, '身份证', 2, 'lucide:id-card', 2, 1, NULL, '2025-12-27 23:46:09', NULL, '2025-12-27 23:46:09', '0', NULL);
INSERT INTO `biz_category` VALUES (14, '校园卡/饭卡', 2, 'lucide:credit-card', 3, 1, NULL, '2025-12-27 23:46:09', NULL, '2025-12-27 23:46:09', '0', NULL);
INSERT INTO `biz_category` VALUES (15, '银行卡', 2, 'lucide:credit-card', 4, 1, NULL, '2025-12-27 23:46:09', NULL, '2025-12-27 23:46:09', '0', NULL);
INSERT INTO `biz_category` VALUES (16, '钥匙', 2, 'lucide:key', 5, 1, NULL, '2025-12-27 23:46:09', NULL, '2025-12-27 23:46:09', '0', NULL);
INSERT INTO `biz_category` VALUES (17, '手机(MCP测试新增)', 1, NULL, 0, 1, NULL, '2025-12-29 13:26:04', NULL, '2025-12-29 13:33:31', '1', NULL);
INSERT INTO `biz_category` VALUES (18, '其他', 0, 'lucide:more-horizontal', 99, 1, NULL, '2025-12-29 13:28:15', NULL, '2025-12-29 13:28:15', '0', NULL);
INSERT INTO `biz_category` VALUES (19, '手机', 1, 'lucide:smartphone', 0, 1, NULL, '2025-12-29 13:28:38', NULL, '2025-12-29 13:33:48', '1', NULL);

-- ----------------------------
-- Table structure for biz_claim
-- ----------------------------
DROP TABLE IF EXISTS `biz_claim`;
CREATE TABLE `biz_claim`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '认领ID',
  `post_id` bigint NOT NULL COMMENT '帖子ID',
  `claimant_id` bigint NOT NULL COMMENT '认领人ID',
  `poster_id` bigint NOT NULL COMMENT '发帖人ID',
  `proof_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '佐证说明',
  `proof_images_json` json NULL COMMENT '佐证图片JSON数组',
  `status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'APPLIED' COMMENT '状态：APPLIED-已提交，IN_CHAT-沟通中，NEED_PROOF-需补充佐证，APPROVED-已通过，REJECTED-已拒绝，CANCELLED-已取消，COMPLETED-已完成',
  `review_by` bigint NULL DEFAULT NULL COMMENT '审核人',
  `review_at` datetime NULL DEFAULT NULL COMMENT '审核时间',
  `review_reason` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '审核原因',
  `completed_at` datetime NULL DEFAULT NULL COMMENT '完成时间',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `feature_answers` json NULL COMMENT 'claimer feature answers',
  `auto_match_score` int NULL DEFAULT NULL COMMENT 'auto match score',
  `reward_pay_at` datetime NULL DEFAULT NULL COMMENT 'reward pay time',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_post_id`(`post_id` ASC) USING BTREE,
  INDEX `idx_claimant_id`(`claimant_id` ASC) USING BTREE,
  INDEX `idx_poster_id`(`poster_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_claim_status_time`(`status` ASC, `create_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '认领单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of biz_claim
-- ----------------------------
INSERT INTO `biz_claim` VALUES (1, 7, 9, 8, NULL, NULL, 'COMPLETED', 8, '2025-12-28 17:30:34', NULL, '2025-12-28 17:35:04', '2025-12-28 17:25:27', '2025-12-28 17:25:26', NULL, NULL, NULL);
INSERT INTO `biz_claim` VALUES (2, 11, 9, 8, NULL, NULL, 'APPROVED', 2, '2025-12-29 10:06:58', NULL, NULL, '2025-12-28 23:30:33', '2025-12-28 23:30:33', NULL, NULL, NULL);
INSERT INTO `biz_claim` VALUES (3, 18, 9, 9, NULL, NULL, 'COMPLETED', 2, '2026-02-02 11:38:11', NULL, '2026-02-02 11:50:18', '2026-02-02 11:35:06', '2026-02-02 11:35:06', '[]', 0, NULL);

-- ----------------------------
-- Table structure for biz_comment
-- ----------------------------
DROP TABLE IF EXISTS `biz_comment`;
CREATE TABLE `biz_comment`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '评论ID',
  `post_id` bigint NOT NULL COMMENT '帖子ID',
  `user_id` bigint NOT NULL COMMENT '评论人ID',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '评论内容',
  `status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'PUBLISHED' COMMENT '状态：PENDING-待审核，PUBLISHED-已发布，REJECTED-已拒绝',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '评论时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_deleted` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '逻辑删除：0-未删除，1-已删除',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_post_id`(`post_id` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '评论表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of biz_comment
-- ----------------------------
INSERT INTO `biz_comment` VALUES (1, 10, 9, '这个钱包是我的！请问怎么联系您？', 'PUBLISHED', '2025-12-28 18:11:26', '2025-12-28 18:11:25', '0');
INSERT INTO `biz_comment` VALUES (2, 7, 9, '1', 'PUBLISHED', '2025-12-28 22:36:16', '2025-12-28 22:36:15', '0');
INSERT INTO `biz_comment` VALUES (3, 7, 9, '1', 'PUBLISHED', '2025-12-28 22:36:21', '2025-12-28 22:36:21', '0');
INSERT INTO `biz_comment` VALUES (4, 7, 9, '这是一条测试评论，验证数据库交互功能', 'PUBLISHED', '2025-12-28 22:39:39', '2025-12-28 22:39:38', '0');
INSERT INTO `biz_comment` VALUES (5, 7, 9, 'MCP测试评论功能-验证数据库写入', 'PUBLISHED', '2025-12-28 22:43:20', '2025-12-28 22:43:19', '0');
INSERT INTO `biz_comment` VALUES (6, 11, 9, '我可能是失主，我的特征是...', 'PUBLISHED', '2025-12-28 23:31:33', '2025-12-30 13:59:47', '1');
INSERT INTO `biz_comment` VALUES (7, 11, 9, '我捡到了，联系方式...', 'PUBLISHED', '2025-12-28 23:31:37', '2025-12-29 12:01:00', '1');

-- ----------------------------
-- Table structure for biz_evaluation
-- ----------------------------
DROP TABLE IF EXISTS `biz_evaluation`;
CREATE TABLE `biz_evaluation`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '评价ID',
  `claim_id` bigint NOT NULL COMMENT '认领单ID',
  `from_user_id` bigint NOT NULL COMMENT '评价人ID',
  `to_user_id` bigint NOT NULL COMMENT '被评价人ID',
  `score` tinyint NOT NULL COMMENT '评分：1-5',
  `content` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '评价内容',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '评价时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_claim_from_to`(`claim_id` ASC, `from_user_id` ASC, `to_user_id` ASC) USING BTREE,
  INDEX `idx_claim_id`(`claim_id` ASC) USING BTREE,
  INDEX `idx_to_user_id`(`to_user_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '互评表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of biz_evaluation
-- ----------------------------

-- ----------------------------
-- Table structure for biz_exchange_order
-- ----------------------------
DROP TABLE IF EXISTS `biz_exchange_order`;
CREATE TABLE `biz_exchange_order`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '涓婚敭ID',
  `order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '璁㈠崟缂栧彿',
  `user_id` bigint NOT NULL COMMENT '鐢ㄦ埛ID',
  `gift_id` bigint NOT NULL COMMENT '绀煎搧ID',
  `gift_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '绀煎搧鍚嶇О(鍐椾綑)',
  `gift_type` enum('PHYSICAL','VIRTUAL') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '绀煎搧绫诲瀷',
  `points_cost` int NOT NULL COMMENT '娑堣?绉?垎',
  `quantity` int NULL DEFAULT 1 COMMENT '鍏戞崲鏁伴噺',
  `status` enum('PENDING','SHIPPED','COMPLETED','CANCELLED') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'PENDING' COMMENT '璁㈠崟鐘舵?',
  `receiver_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '鏀惰揣浜哄?鍚',
  `receiver_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '鏀惰揣浜虹數璇',
  `receiver_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '鏀惰揣鍦板潃',
  `tracking_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '鐗╂祦鍗曞彿',
  `shipped_at` datetime NULL DEFAULT NULL COMMENT '鍙戣揣鏃堕棿',
  `virtual_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '铏氭嫙绀煎搧鍐呭?',
  `completed_at` datetime NULL DEFAULT NULL COMMENT '瀹屾垚鏃堕棿',
  `cancelled_at` datetime NULL DEFAULT NULL COMMENT '鍙栨秷鏃堕棿',
  `cancel_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '鍙栨秷鍘熷洜',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '鍒涘缓鏃堕棿',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '鏇存柊鏃堕棿',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_order_no`(`order_no` ASC) USING BTREE,
  INDEX `idx_order_user`(`user_id` ASC) USING BTREE,
  INDEX `idx_order_status`(`status` ASC) USING BTREE,
  INDEX `idx_order_created`(`created_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '鍏戞崲璁㈠崟琛' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of biz_exchange_order
-- ----------------------------
INSERT INTO `biz_exchange_order` VALUES (1, 'EX202512311407428433FD4C', 9, 1, '校园纪念T恤', 'PHYSICAL', 100, 1, 'PENDING', '11', '11111', '1111', NULL, NULL, NULL, NULL, NULL, NULL, '2025-12-31 14:13:51', '2025-12-31 14:13:51');
INSERT INTO `biz_exchange_order` VALUES (2, 'EX202601061059042DCD9F3E', 9, 2, '1', 'PHYSICAL', 12, 1, 'PENDING', '张三', '13800138000', '教学楼A座101室', NULL, NULL, NULL, NULL, NULL, NULL, '2026-01-06 10:59:04', '2026-01-06 10:59:04');
INSERT INTO `biz_exchange_order` VALUES (3, 'EX2026010611013974AD466B', 9, 2, '1', 'PHYSICAL', 12, 1, 'SHIPPED', '1', '1', '1', '111111', '2026-01-17 15:46:19', NULL, NULL, NULL, NULL, '2026-01-06 11:01:40', '2026-01-17 15:46:18');

-- ----------------------------
-- Table structure for biz_favorite
-- ----------------------------
DROP TABLE IF EXISTS `biz_favorite`;
CREATE TABLE `biz_favorite`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '收藏ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `post_id` bigint NOT NULL COMMENT '帖子ID',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '收藏时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_post`(`user_id` ASC, `post_id` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_post_id`(`post_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '收藏表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of biz_favorite
-- ----------------------------
INSERT INTO `biz_favorite` VALUES (1, 9, 10, '2025-12-28 18:11:36');
INSERT INTO `biz_favorite` VALUES (2, 9, 11, '2025-12-28 21:17:57');
INSERT INTO `biz_favorite` VALUES (4, 9, 9, '2025-12-31 12:54:51');
INSERT INTO `biz_favorite` VALUES (5, 9, 8, '2025-12-31 12:54:54');
INSERT INTO `biz_favorite` VALUES (8, 9, 17, '2026-02-02 10:59:20');

-- ----------------------------
-- Table structure for biz_gift
-- ----------------------------
DROP TABLE IF EXISTS `biz_gift`;
CREATE TABLE `biz_gift`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '涓婚敭ID',
  `category_id` bigint NOT NULL COMMENT '鍒嗙被ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '绀煎搧鍚嶇О',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '绀煎搧鎻忚堪',
  `images_json` json NULL COMMENT '绀煎搧鍥剧墖',
  `points_cost` int NOT NULL COMMENT '鎵?渶绉?垎',
  `stock` int NULL DEFAULT 0 COMMENT '搴撳瓨鏁伴噺',
  `gift_type` enum('PHYSICAL','VIRTUAL') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'PHYSICAL' COMMENT '绀煎搧绫诲瀷 PHYSICAL瀹炵墿 VIRTUAL铏氭嫙',
  `virtual_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '铏氭嫙绀煎搧鍐呭?(濡傚厬鎹㈢爜)',
  `status` enum('ON','OFF') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'ON' COMMENT '涓婃灦鐘舵? ON涓婃灦 OFF涓嬫灦',
  `exchange_count` int NULL DEFAULT 0 COMMENT '宸插厬鎹㈡暟閲',
  `sort` int NULL DEFAULT 0 COMMENT '鎺掑簭',
  `created_by` bigint NULL DEFAULT NULL COMMENT '鍒涘缓浜',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '鍒涘缓鏃堕棿',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '鏇存柊鏃堕棿',
  `deleted` tinyint NULL DEFAULT 0 COMMENT '閫昏緫鍒犻櫎 0鏈?垹闄?1宸插垹闄',
  `version` int NULL DEFAULT 0 COMMENT '乐观锁版本号',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_gift_category`(`category_id` ASC) USING BTREE,
  INDEX `idx_gift_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '绀煎搧琛' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of biz_gift
-- ----------------------------
INSERT INTO `biz_gift` VALUES (1, 3, '校园纪念T恤', '', '[]', 100, 49, 'PHYSICAL', '', 'ON', 1, 0, 2, NULL, NULL, 1, 0);
INSERT INTO `biz_gift` VALUES (2, 2, '1', '1', '[\"/uploads/posts/2025/12/31/0841b163cc9d444e806c43409054bd92.jpg\"]', 12, 10, 'PHYSICAL', '', 'ON', 2, 1, 2, NULL, NULL, 0, 2);

-- ----------------------------
-- Table structure for biz_gift_category
-- ----------------------------
DROP TABLE IF EXISTS `biz_gift_category`;
CREATE TABLE `biz_gift_category`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '涓婚敭ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '鍒嗙被鍚嶇О',
  `sort` int NULL DEFAULT 0 COMMENT '鎺掑簭',
  `status` tinyint NULL DEFAULT 1 COMMENT '鐘舵? 1鍚?敤 0绂佺敤',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '鍒涘缓鏃堕棿',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '鏇存柊鏃堕棿',
  `deleted` tinyint NULL DEFAULT 0 COMMENT '閫昏緫鍒犻櫎 0鏈?垹闄?1宸插垹闄',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '绀煎搧鍒嗙被琛' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of biz_gift_category
-- ----------------------------
INSERT INTO `biz_gift_category` VALUES (1, '实物礼品', 1, 1, '2025-12-30 17:33:59', '2025-12-30 20:31:34', 0);
INSERT INTO `biz_gift_category` VALUES (2, '虚拟权益', 2, 1, '2025-12-30 17:33:59', '2025-12-30 20:31:34', 0);
INSERT INTO `biz_gift_category` VALUES (3, '校园周边', 3, 1, '2025-12-30 17:33:59', '2025-12-30 20:31:34', 0);

-- ----------------------------
-- Table structure for biz_handover
-- ----------------------------
DROP TABLE IF EXISTS `biz_handover`;
CREATE TABLE `biz_handover`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '交接ID',
  `claim_id` bigint NOT NULL COMMENT '认领单ID',
  `from_user_id` bigint NOT NULL COMMENT '交出方用户ID',
  `to_user_id` bigint NOT NULL COMMENT '接收方用户ID',
  `location` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '交接地点',
  `handover_time` datetime NULL DEFAULT NULL COMMENT '约定交接时间',
  `status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'PENDING' COMMENT '状态：PENDING-待确认，CONFIRMED-已确认',
  `confirmed_by_from_at` datetime NULL DEFAULT NULL COMMENT '交出方确认时间',
  `confirmed_by_to_at` datetime NULL DEFAULT NULL COMMENT '接收方确认时间',
  `remark` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_claim_id`(`claim_id` ASC) USING BTREE,
  INDEX `idx_from_user_id`(`from_user_id` ASC) USING BTREE,
  INDEX `idx_to_user_id`(`to_user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '交接记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of biz_handover
-- ----------------------------
INSERT INTO `biz_handover` VALUES (1, 1, 8, 9, '图书馆一楼大厅', '2025-12-29 15:00:00', 'CONFIRMED', '2025-12-28 17:33:11', '2025-12-28 17:35:04', NULL, '2025-12-28 17:31:01', '2025-12-28 22:31:37');
INSERT INTO `biz_handover` VALUES (2, 3, 9, 9, '11', '2026-02-02 00:04:00', 'PENDING', '2026-02-02 11:45:49', NULL, NULL, '2026-02-02 11:38:55', '2026-02-02 11:38:55');

-- ----------------------------
-- Table structure for biz_location
-- ----------------------------
DROP TABLE IF EXISTS `biz_location`;
CREATE TABLE `biz_location`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '地点ID',
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '地点名称',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父级ID，0表示顶级',
  `type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '类型：building-建筑，floor-楼层，room-房间，area-区域',
  `lng` decimal(10, 6) NULL DEFAULT NULL COMMENT '经度',
  `lat` decimal(10, 6) NULL DEFAULT NULL COMMENT '纬度',
  `is_pickup_point` tinyint NULL DEFAULT 0 COMMENT '是否招领点：0-否，1-是',
  `open_time` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '开放时间（招领点）',
  `contact` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系方式（招领点）',
  `address` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '详细地址',
  `sort` int NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` bigint NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_deleted` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '逻辑删除：0-未删除，1-已删除',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_parent_id`(`parent_id` ASC) USING BTREE,
  INDEX `idx_is_pickup_point`(`is_pickup_point` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '校园地点表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of biz_location
-- ----------------------------
INSERT INTO `biz_location` VALUES (1, '教学区', 0, 'area', NULL, NULL, 0, NULL, NULL, '校园东区，包含教学楼A、B、图书馆、实验楼', 1, 1, NULL, '2025-12-27 23:46:09', NULL, '2025-12-29 14:02:06', '0', NULL);
INSERT INTO `biz_location` VALUES (2, '生活区', 0, 'area', NULL, NULL, 0, NULL, NULL, '校园西区，包含学生宿舍、食堂、超市', 2, 1, NULL, '2025-12-27 23:46:09', NULL, '2025-12-29 14:02:24', '0', NULL);
INSERT INTO `biz_location` VALUES (3, '运动区', 0, 'area', NULL, NULL, 0, NULL, NULL, '校园南区，包含操场、体育馆、游泳池', 3, 1, NULL, '2025-12-27 23:46:09', NULL, '2025-12-29 14:03:27', '0', NULL);
INSERT INTO `biz_location` VALUES (4, '行政区', 0, 'area', NULL, NULL, 0, NULL, NULL, '校园北区，包含行政楼、校医院、招生办', 4, 1, NULL, '2025-12-27 23:46:09', NULL, '2025-12-29 14:03:48', '0', NULL);
INSERT INTO `biz_location` VALUES (5, '教学楼A', 1, 'building', NULL, NULL, 0, NULL, NULL, NULL, 1, 1, NULL, '2025-12-27 23:46:09', NULL, '2025-12-27 23:46:09', '0', NULL);
INSERT INTO `biz_location` VALUES (6, '教学楼B', 1, 'building', NULL, NULL, 0, NULL, NULL, NULL, 2, 1, NULL, '2025-12-27 23:46:09', NULL, '2025-12-27 23:46:09', '0', NULL);
INSERT INTO `biz_location` VALUES (7, '图书馆', 1, 'building', NULL, NULL, 0, NULL, NULL, NULL, 3, 1, NULL, '2025-12-27 23:46:09', NULL, '2025-12-27 23:46:09', '0', NULL);
INSERT INTO `biz_location` VALUES (8, '实验楼', 1, 'building', NULL, NULL, 0, NULL, NULL, NULL, 4, 1, NULL, '2025-12-27 23:46:09', NULL, '2025-12-27 23:46:09', '0', NULL);
INSERT INTO `biz_location` VALUES (9, '学生宿舍1号楼', 2, 'building', NULL, NULL, 0, NULL, NULL, NULL, 1, 1, NULL, '2025-12-27 23:46:09', NULL, '2025-12-27 23:46:09', '0', NULL);
INSERT INTO `biz_location` VALUES (10, '学生宿舍2号楼', 2, 'building', NULL, NULL, 0, NULL, NULL, NULL, 2, 1, NULL, '2025-12-27 23:46:09', NULL, '2025-12-27 23:46:09', '0', NULL);
INSERT INTO `biz_location` VALUES (11, '食堂', 2, 'building', NULL, NULL, 0, NULL, NULL, NULL, 3, 1, NULL, '2025-12-27 23:46:09', NULL, '2025-12-27 23:46:09', '0', NULL);
INSERT INTO `biz_location` VALUES (12, '超市', 2, 'building', NULL, NULL, 0, NULL, NULL, NULL, 4, 1, NULL, '2025-12-27 23:46:09', NULL, '2025-12-27 23:46:09', '0', NULL);
INSERT INTO `biz_location` VALUES (13, '图书馆失物招领处', 7, 'room', NULL, NULL, 1, '08:00-22:00', '保安室', NULL, 1, 1, NULL, '2025-12-27 23:46:09', NULL, '2025-12-27 23:46:09', '0', NULL);
INSERT INTO `biz_location` VALUES (14, '食堂失物招领处', 11, 'room', NULL, NULL, 1, '07:00-21:00', '食堂管理处', NULL, 1, 1, NULL, '2025-12-27 23:46:09', NULL, '2025-12-27 23:46:09', '0', NULL);
INSERT INTO `biz_location` VALUES (15, '1', 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, 1, NULL, '2025-12-28 12:36:50', NULL, '2025-12-30 13:59:37', '1', NULL);
INSERT INTO `biz_location` VALUES (16, '1', 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, 1, NULL, '2025-12-28 12:37:05', NULL, '2025-12-29 13:55:37', '0', NULL);
INSERT INTO `biz_location` VALUES (17, '1', 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, 0, NULL, '2025-12-28 12:37:33', NULL, '2025-12-28 12:37:33', '0', NULL);
INSERT INTO `biz_location` VALUES (18, '1', 1, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, 0, NULL, '2025-12-28 12:37:53', NULL, '2025-12-28 12:37:53', '0', NULL);

-- ----------------------------
-- Table structure for biz_message
-- ----------------------------
DROP TABLE IF EXISTS `biz_message`;
CREATE TABLE `biz_message`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '消息ID',
  `thread_id` bigint NOT NULL COMMENT '会话ID',
  `sender_id` bigint NOT NULL COMMENT '发送者ID',
  `receiver_id` bigint NOT NULL COMMENT '接收者ID',
  `msg_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'TEXT' COMMENT '消息类型：TEXT-文本，IMAGE-图片，SYSTEM-系统消息',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '消息内容',
  `image_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '图片URL',
  `read_at` datetime NULL DEFAULT NULL COMMENT '已读时间',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '发送时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_thread_id`(`thread_id` ASC) USING BTREE,
  INDEX `idx_sender_id`(`sender_id` ASC) USING BTREE,
  INDEX `idx_receiver_id`(`receiver_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '消息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of biz_message
-- ----------------------------
INSERT INTO `biz_message` VALUES (1, 1, 9, 8, 'TEXT', '你好，我想咨询一下这个黑色钱包的认领事宜', NULL, NULL, '2025-12-28 23:08:44');
INSERT INTO `biz_message` VALUES (2, 1, 9, 8, 'TEXT', '请问钱包里有什么证件吗？', NULL, NULL, '2025-12-28 23:14:16');
INSERT INTO `biz_message` VALUES (3, 1, 8, 9, 'TEXT', '钱包里有一张身份证和一张银行卡', NULL, '2025-12-28 23:14:33', '2025-12-28 23:14:24');
INSERT INTO `biz_message` VALUES (4, 2, 9, 9, 'TEXT', '你好', NULL, '2026-01-06 14:04:55', '2026-01-06 14:04:56');
INSERT INTO `biz_message` VALUES (5, 3, 2, 9, 'TEXT', '你好', NULL, NULL, '2026-02-02 10:40:52');

-- ----------------------------
-- Table structure for biz_msg_thread
-- ----------------------------
DROP TABLE IF EXISTS `biz_msg_thread`;
CREATE TABLE `biz_msg_thread`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '会话ID',
  `post_id` bigint NULL DEFAULT NULL COMMENT '关联帖子ID',
  `claim_id` bigint NULL DEFAULT NULL COMMENT '关联认领单ID',
  `user_a_id` bigint NOT NULL COMMENT '用户A ID',
  `user_b_id` bigint NOT NULL COMMENT '用户B ID',
  `last_message_id` bigint NULL DEFAULT NULL COMMENT '最后一条消息ID',
  `last_message_time` datetime NULL DEFAULT NULL COMMENT '最后消息时间',
  `user_a_unread` int NULL DEFAULT 0 COMMENT '用户A未读数',
  `user_b_unread` int NULL DEFAULT 0 COMMENT '用户B未读数',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_post_id`(`post_id` ASC) USING BTREE,
  INDEX `idx_claim_id`(`claim_id` ASC) USING BTREE,
  INDEX `idx_user_a_id`(`user_a_id` ASC) USING BTREE,
  INDEX `idx_user_b_id`(`user_b_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '消息会话表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of biz_msg_thread
-- ----------------------------
INSERT INTO `biz_msg_thread` VALUES (1, NULL, NULL, 9, 8, 2, '2025-12-28 23:14:16', 0, 2, '2025-12-28 23:01:11', '2025-12-28 23:14:16');
INSERT INTO `biz_msg_thread` VALUES (2, NULL, NULL, 9, 9, 4, '2026-01-06 14:04:56', 0, 0, '2025-12-31 13:48:08', '2026-01-06 14:04:55');
INSERT INTO `biz_msg_thread` VALUES (3, NULL, NULL, 2, 9, 5, '2026-02-02 10:40:52', 0, 1, '2026-02-02 10:39:29', '2026-02-02 10:40:52');

-- ----------------------------
-- Table structure for biz_notification
-- ----------------------------
DROP TABLE IF EXISTS `biz_notification`;
CREATE TABLE `biz_notification`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '通知ID',
  `user_id` bigint NOT NULL COMMENT '接收用户ID',
  `type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '通知类型：SYSTEM-系统通知，AUDIT-审核通知，CLAIM-认领通知，REPORT-举报通知，POINTS-积分通知',
  `title` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '通知标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '通知内容',
  `related_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联类型：POST-帖子，CLAIM-认领单，REPORT-举报',
  `related_id` bigint NULL DEFAULT NULL COMMENT '关联ID',
  `is_read` tinyint NULL DEFAULT 0 COMMENT '是否已读：0-未读，1-已读',
  `read_at` datetime NULL DEFAULT NULL COMMENT '阅读时间',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_type`(`type` ASC) USING BTREE,
  INDEX `idx_is_read`(`is_read` ASC) USING BTREE,
  INDEX `idx_create_time`(`create_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '通知表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of biz_notification
-- ----------------------------
INSERT INTO `biz_notification` VALUES (1, 8, 'SYSTEM', '帖子审核通过', '您发布的「测试通知功能的物品」已通过审核，现已发布。', 'POST', 11, 1, '2025-12-28 19:18:56', '2025-12-28 19:16:11');
INSERT INTO `biz_notification` VALUES (2, 2, 'SYSTEM', '帖子审核通过', '您发布的「学生卡」已通过审核，现已发布。', 'POST', 5, 1, '2025-12-31 15:15:26', '2025-12-28 21:14:43');
INSERT INTO `biz_notification` VALUES (3, 8, 'CLAIM', '收到新的认领申请', '您发布的「测试通知功能的物品」收到了新的认领申请，请及时处理。', 'CLAIM', 2, 0, NULL, '2025-12-28 23:30:33');
INSERT INTO `biz_notification` VALUES (5, 9, 'SYSTEM', '帖子审核通过', '您发布的「测试钱包」已通过审核，现已发布。', 'POST', 14, 1, '2025-12-31 15:17:44', '2025-12-31 13:55:04');
INSERT INTO `biz_notification` VALUES (6, 9, 'POINTS', '积分兑换成功', '您已成功兑换「1」，消耗12积分，请等待发货。', 'ORDER', 2, 1, '2026-01-06 10:59:34', '2026-01-06 10:59:04');
INSERT INTO `biz_notification` VALUES (7, 9, 'POINTS', '积分兑换成功', '您已成功兑换「1」，消耗12积分，请等待发货。', 'ORDER', 3, 1, '2026-01-06 11:01:56', '2026-01-06 11:01:40');
INSERT INTO `biz_notification` VALUES (8, 0, 'ANNOUNCEMENT', '欢迎使用校园互助失物招领平台', '本平台致力于帮助同学们找回丢失的物品，请大家积极发布招领信息，共建和谐校园！', 'SYSTEM', NULL, 0, NULL, '2026-01-06 11:15:20');
INSERT INTO `biz_notification` VALUES (9, 0, 'ANNOUNCEMENT', '平台使用须知', '发布信息时请勿包含个人联系方式，系统会自动过滤敏感信息。认领物品请通过平台私信联系。', 'SYSTEM', NULL, 0, NULL, '2026-01-06 11:15:20');
INSERT INTO `biz_notification` VALUES (10, 0, 'ANNOUNCEMENT', '积分商城上线啦', '现在发布招领信息、帮助他人找回物品都可以获得积分奖励，积分可在商城兑换精美礼品！', 'SYSTEM', NULL, 0, NULL, '2026-01-06 11:15:20');
INSERT INTO `biz_notification` VALUES (11, 9, 'SYSTEM', '帖子审核通过', '您发布的「测试物品」已通过审核，现已发布。', 'POST', 15, 1, '2026-01-06 11:34:26', '2026-01-06 11:18:26');
INSERT INTO `biz_notification` VALUES (12, 8, 'VERIFICATION', '身份认证成功', '恭喜您，身份认证已通过！学号：2021001001，姓名：张三', 'VERIFICATION', NULL, 0, NULL, '2026-01-17 15:41:11');
INSERT INTO `biz_notification` VALUES (13, 9, 'POINTS', '订单已发货', '您兑换的「1」已发货，请注意查收。', 'ORDER', 3, 0, NULL, '2026-01-17 15:46:19');
INSERT INTO `biz_notification` VALUES (14, 8, 'SYSTEM', '帖子审核通过', '您发布的「手表」已通过审核，现已发布。', 'POST', 16, 0, NULL, '2026-01-17 16:03:35');
INSERT INTO `biz_notification` VALUES (15, 9, 'SYSTEM', '帖子审核通过', '您发布的「钱包」已通过审核，现已发布。', 'POST', 17, 1, '2026-02-02 10:48:19', '2026-02-02 10:48:08');
INSERT INTO `biz_notification` VALUES (16, 9, 'SYSTEM', '帖子审核通过', '您发布的「钱包」已通过审核，现已发布。', 'POST', 18, 0, NULL, '2026-02-02 11:33:12');
INSERT INTO `biz_notification` VALUES (17, 9, 'CLAIM', '收到新的认领申请', '您发布的「钱包」收到了新的认领申请，请及时处理。', 'CLAIM', 3, 0, NULL, '2026-02-02 11:35:06');
INSERT INTO `biz_notification` VALUES (18, 9, 'CLAIM', '认领申请已通过', '您对「钱包」的认领申请已通过，请与发布者联系进行交接。', 'CLAIM', 3, 0, NULL, '2026-02-02 11:38:11');

-- ----------------------------
-- Table structure for biz_points_log
-- ----------------------------
DROP TABLE IF EXISTS `biz_points_log`;
CREATE TABLE `biz_points_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '流水ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `action` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '动作类型：CLAIM_FINDER-认领成功(拾到者)，CLAIM_OWNER-认领成功(失主)，ADMIN_ADJUST-管理员调整，POSITIVE_EVAL-好评奖励',
  `delta` int NOT NULL COMMENT '积分变化（正数增加，负数减少）',
  `balance` int NOT NULL COMMENT '变化后余额',
  `related_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联类型：CLAIM-认领单，EVALUATION-评价',
  `related_id` bigint NULL DEFAULT NULL COMMENT '关联ID',
  `remark` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `create_by` bigint NULL DEFAULT NULL COMMENT '操作人（管理员调整时）',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_action`(`action` ASC) USING BTREE,
  INDEX `idx_create_time`(`create_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '积分流水表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of biz_points_log
-- ----------------------------
INSERT INTO `biz_points_log` VALUES (1, 8, 'CLAIM_FINDER', 10, 10, 'CLAIM', 1, NULL, NULL, '2025-12-28 17:35:04');
INSERT INTO `biz_points_log` VALUES (2, 9, 'CLAIM_OWNER', 5, 5, 'CLAIM', 1, NULL, NULL, '2025-12-28 17:35:04');
INSERT INTO `biz_points_log` VALUES (3, 8, 'ADMIN_ADJUST', 50, 60, NULL, NULL, '测试积分调整功能', 2, '2025-12-28 19:08:44');
INSERT INTO `biz_points_log` VALUES (4, 8, 'ADMIN_ADJUST', 2, 62, NULL, NULL, '1', 2, '2025-12-28 19:38:51');
INSERT INTO `biz_points_log` VALUES (5, 7, 'ADMIN_ADJUST', 1, 1, NULL, NULL, '1', 2, '2025-12-28 19:39:02');
INSERT INTO `biz_points_log` VALUES (6, 6, 'ADMIN_ADJUST', 1, 1, NULL, NULL, '1', 2, '2025-12-28 21:03:39');
INSERT INTO `biz_points_log` VALUES (7, 8, 'ADMIN_ADJUST', 10, 72, NULL, NULL, 'MCP测试-管理员手动调整积分', 2, '2025-12-29 14:07:01');
INSERT INTO `biz_points_log` VALUES (8, 8, 'ADMIN_ADJUST', 1, 73, NULL, NULL, '11', 2, '2025-12-29 15:59:40');
INSERT INTO `biz_points_log` VALUES (9, 8, 'ADMIN_ADJUST', 11, 84, NULL, NULL, '11', 2, '2025-12-30 14:21:04');
INSERT INTO `biz_points_log` VALUES (10, 8, 'ADMIN_ADJUST', 1, 85, NULL, NULL, '1', 2, '2025-12-30 14:21:15');
INSERT INTO `biz_points_log` VALUES (11, 8, 'ADMIN_ADJUST', -1, 84, NULL, NULL, '1', 2, '2025-12-30 14:21:27');
INSERT INTO `biz_points_log` VALUES (12, 9, 'ADMIN_ADJUST', 1000, 1005, NULL, NULL, '1', 2, '2025-12-31 14:06:41');
INSERT INTO `biz_points_log` VALUES (13, 9, 'EXCHANGE', -100, 905, NULL, NULL, '兑换礼品: 校园纪念T恤', NULL, '2025-12-31 14:07:42');
INSERT INTO `biz_points_log` VALUES (14, 9, 'EXCHANGE', -12, 893, NULL, NULL, '兑换礼品: 1', NULL, '2026-01-06 10:59:04');
INSERT INTO `biz_points_log` VALUES (15, 9, 'EXCHANGE', -12, 881, NULL, NULL, '兑换礼品: 1', NULL, '2026-01-06 11:01:40');

-- ----------------------------
-- Table structure for biz_post
-- ----------------------------
DROP TABLE IF EXISTS `biz_post`;
CREATE TABLE `biz_post`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '帖子ID',
  `post_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '类型：LOST-寻物，FOUND-招领',
  `title` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '标题',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '描述',
  `category_id` bigint NULL DEFAULT NULL COMMENT '分类ID',
  `location_id` bigint NULL DEFAULT NULL COMMENT '地点ID',
  `location_detail` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '详细地点描述',
  `occur_time` datetime NULL DEFAULT NULL COMMENT '丢失/拾到时间',
  `storage_place` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '暂存地点（招领）',
  `deadline_time` datetime NULL DEFAULT NULL COMMENT '领取截止时间（招领）',
  `images_json` json NULL COMMENT '图片JSON数组',
  `status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'DRAFT' COMMENT '状态：DRAFT-草稿，PENDING-待审核，PUBLISHED-已发布，CLAIMING-认领中，CLOSED-已结案，REJECTED-已拒绝，OFFLINE-已下线',
  `view_count` int NULL DEFAULT 0 COMMENT '浏览量',
  `fav_count` int NULL DEFAULT 0 COMMENT '收藏数',
  `comment_count` int NULL DEFAULT 0 COMMENT '评论数',
  `is_top` tinyint NULL DEFAULT 0 COMMENT '是否置顶：0-否，1-是',
  `is_recommend` tinyint NULL DEFAULT 0 COMMENT '是否推荐：0-否，1-是',
  `audit_by` bigint NULL DEFAULT NULL COMMENT '审核人',
  `audit_at` datetime NULL DEFAULT NULL COMMENT '审核时间',
  `audit_reason` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '审核原因',
  `contact_info` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系方式',
  `created_by` bigint NOT NULL COMMENT '发布人',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` bigint NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_deleted` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '逻辑删除：0-未删除，1-已删除',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '创建者',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `reward_amount` decimal(12, 2) NULL DEFAULT NULL COMMENT 'reward amount',
  `reward_status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'NONE' COMMENT 'reward status',
  `reward_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'reward note',
  `feature_tokens` json NULL COMMENT 'finder feature tokens',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_post_type`(`post_type` ASC) USING BTREE,
  INDEX `idx_category_id`(`category_id` ASC) USING BTREE,
  INDEX `idx_location_id`(`location_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_created_by`(`created_by` ASC) USING BTREE,
  INDEX `idx_create_time`(`create_time` ASC) USING BTREE,
  INDEX `idx_is_top`(`is_top` ASC) USING BTREE,
  INDEX `idx_is_recommend`(`is_recommend` ASC) USING BTREE,
  INDEX `idx_post_status_type_time`(`status` ASC, `post_type` ASC, `create_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '帖子表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of biz_post
-- ----------------------------
INSERT INTO `biz_post` VALUES (1, 'FOUND', '1', '1', 1, 1, NULL, '2025-12-20 13:11:00', '13', NULL, '[]', 'PENDING', 0, 0, 0, 0, 0, NULL, NULL, NULL, '1', 2, '2025-12-28 13:11:57', NULL, '2025-12-28 13:11:57', '0', NULL, NULL, NULL, 'NONE', NULL, NULL);
INSERT INTO `biz_post` VALUES (2, 'FOUND', '1', '1', 1, 1, NULL, '2025-12-18 13:17:00', '13', NULL, '[]', 'PENDING', 0, 0, 0, 0, 0, NULL, NULL, NULL, '1', 2, '2025-12-28 13:17:23', NULL, '2025-12-28 13:17:23', '0', NULL, NULL, NULL, 'NONE', NULL, NULL);
INSERT INTO `biz_post` VALUES (3, 'LOST', '1', '11', 1, 1, NULL, '2025-12-18 13:26:00', NULL, NULL, '[]', 'PENDING', 0, 0, 0, 0, 0, NULL, NULL, NULL, '1', 2, '2025-12-28 13:26:22', NULL, '2025-12-28 13:26:22', '0', NULL, NULL, NULL, 'NONE', NULL, NULL);
INSERT INTO `biz_post` VALUES (4, 'LOST', '黑色钱包', '黑色皮质钱包，内有身份证和银行卡，品牌是某某，在教学楼附近丢失', 2, 1, NULL, '2025-12-27 15:59:00', NULL, NULL, '[]', 'PENDING', 0, 0, 0, 0, 0, NULL, NULL, NULL, '13800138000', 2, '2025-12-28 15:59:56', NULL, '2025-12-28 15:59:56', '0', NULL, NULL, NULL, 'NONE', NULL, NULL);
INSERT INTO `biz_post` VALUES (5, 'FOUND', '学生卡', '在图书馆门口捡到一张学生卡，姓名为张三，学号为2021001，请失主尽快联系认领', 2, 1, NULL, '2025-12-28 16:10:00', '', NULL, '[]', 'PUBLISHED', 0, 0, 0, 0, 0, 2, '2025-12-28 21:14:43', NULL, '', 2, '2025-12-28 16:11:09', NULL, '2025-12-28 21:14:42', '0', NULL, NULL, NULL, 'NONE', NULL, NULL);
INSERT INTO `biz_post` VALUES (6, 'LOST', '测试草稿物品', '', NULL, NULL, NULL, NULL, NULL, NULL, '[]', 'DRAFT', 0, 0, 0, 0, 0, NULL, NULL, NULL, '', 2, '2025-12-28 16:12:31', NULL, '2025-12-28 16:12:31', '0', NULL, NULL, NULL, 'NONE', NULL, NULL);
INSERT INTO `biz_post` VALUES (7, 'FOUND', '黑色钱包', '在图书馆一楼自习室捡到一个黑色钱包，内有学生证', 2, 1, NULL, '2025-12-28 10:00:00', '图书馆一楼服务台', NULL, '[]', 'CLOSED', 55, 0, 4, 0, 0, 2, '2025-12-28 17:16:16', NULL, '', 8, '2025-12-28 17:12:42', NULL, '2026-02-02 11:52:26', '0', NULL, NULL, NULL, 'NONE', NULL, NULL);
INSERT INTO `biz_post` VALUES (8, 'LOST', '蓝色水杯', '在食堂二楼吃饭时遗忘了一个蓝色保温杯，杯身有卡通图案，容量约500ml', 3, 2, NULL, '2025-12-28 17:37:00', NULL, NULL, '[]', 'PUBLISHED', 4, 1, 0, 0, 0, 2, '2025-12-28 18:09:06', NULL, '', 9, '2025-12-28 17:37:54', NULL, '2025-12-31 12:54:54', '0', NULL, NULL, NULL, 'NONE', NULL, NULL);
INSERT INTO `biz_post` VALUES (9, 'FOUND', '黑色钱包', '在教学楼一楼自习室捡到一个黑色钱包，内有学生证和一些现金。请失主尽快联系认领。', 2, 1, NULL, '2025-12-28 18:00:00', '', NULL, '[]', 'PUBLISHED', 2, 1, 0, 0, 0, 2, '2025-12-28 18:09:06', NULL, '', 8, '2025-12-28 18:01:18', NULL, '2026-01-17 15:44:26', '0', NULL, NULL, NULL, 'NONE', NULL, NULL);
INSERT INTO `biz_post` VALUES (10, 'FOUND', '黑色钱包', '在教学楼A座一楼大厅捡到一个黑色皮质钱包，内有现金和证件，请失主联系认领。', 5, 1, NULL, '2025-12-28 18:05:00', '', NULL, '[]', 'PUBLISHED', 41, 1, 1, 0, 0, 2, '2025-12-28 18:09:06', NULL, '', 8, '2025-12-28 18:05:47', NULL, '2026-02-02 11:31:40', '0', NULL, NULL, NULL, 'NONE', NULL, NULL);
INSERT INTO `biz_post` VALUES (11, 'FOUND', '测试通知功能的物品', '这是一个用于测试通知功能的物品，在教学楼一楼大厅拾获。', 1, 1, NULL, '2025-12-28 19:14:00', '', NULL, '[]', 'CLAIMING', 26, 1, 0, 0, 0, 2, '2025-12-29 09:43:06', NULL, '', 8, '2025-12-28 19:14:27', NULL, '2026-02-02 11:24:18', '0', NULL, NULL, NULL, 'NONE', NULL, NULL);
INSERT INTO `biz_post` VALUES (12, 'LOST', '黑色钱包', '11', 1, 1, NULL, '2025-12-31 00:03:00', NULL, NULL, '[]', 'PENDING', 2, 0, 0, 0, 0, NULL, NULL, NULL, '', 9, '2025-12-31 12:51:05', NULL, '2025-12-31 12:56:28', '0', NULL, NULL, NULL, 'NONE', NULL, NULL);
INSERT INTO `biz_post` VALUES (13, 'LOST', '测试手机', '这是一个测试手机，黑色外壳，屏幕有轻微划痕', 7, 5, NULL, '2025-12-30 12:57:00', NULL, NULL, '[]', 'PENDING', 3, 0, 0, 0, 0, NULL, NULL, NULL, '', 9, '2025-12-31 12:58:47', NULL, '2025-12-31 13:10:48', '0', NULL, NULL, NULL, 'NONE', NULL, NULL);
INSERT INTO `biz_post` VALUES (14, 'LOST', '测试钱包', '这是一个测试钱包，棕色皮质，里面有学生证和一些现金', 7, 5, NULL, '2025-12-31 13:12:00', NULL, NULL, '[\"/uploads/posts/2025/12/31/a0ba5b1415124363b1858ef1d35ba4af.png\"]', 'PUBLISHED', 37, 0, 0, 0, 0, 2, '2025-12-31 13:55:03', NULL, '', 9, '2025-12-31 13:14:11', NULL, '2026-01-17 15:38:23', '0', NULL, NULL, NULL, 'NONE', NULL, NULL);
INSERT INTO `biz_post` VALUES (15, 'LOST', '测试物品', '在图书馆丢失一把钥匙，银色金属材质，上面有一个小熊挂件', 7, 5, NULL, '2026-01-05 10:51:00', NULL, NULL, '[]', 'PUBLISHED', 6, 0, 0, 0, 0, 2, '2026-01-06 11:18:26', NULL, '', 9, '2026-01-06 10:54:10', NULL, '2026-01-06 14:12:05', '0', NULL, NULL, NULL, 'NONE', NULL, NULL);
INSERT INTO `biz_post` VALUES (16, 'LOST', '手表', '在西南角地方丢掉的 找到的人请与我联系', 8, 1, NULL, '2026-01-17 00:08:00', NULL, NULL, '[\"/uploads/posts/2026/01/17/9dd0cf91ffe242649f139bf0cfa4fad4.png\"]', 'PUBLISHED', 17, 0, 0, 0, 0, 2, '2026-01-17 16:03:35', NULL, '18331969791', 8, '2026-01-17 15:43:37', NULL, '2026-02-02 11:24:08', '0', NULL, NULL, 12.00, 'HOLD', '', '[]');
INSERT INTO `biz_post` VALUES (17, 'LOST', '钱包', '物品很多物品很多物品很多', 2, 1, NULL, '2026-02-02 00:02:00', NULL, NULL, '[\"/uploads/posts/2026/02/02/bddf0218f35643bfa09f21033d3c6cc9.png\", \"/uploads/posts/2026/02/02/0dd2ebfe0aee4a16a3f7ddb636a3158d.png\", \"/uploads/posts/2026/02/02/30665934ea42441895464ef3cc1ff2d0.png\", \"/uploads/posts/2026/02/02/bcfff067ea0a4a0cbaa339376dd9e348.png\", \"/uploads/posts/2026/02/02/a02ff7b857634137bd308a5b4a6a37fc.png\"]', 'PUBLISHED', 45, 1, 0, 0, 0, 2, '2026-02-02 10:48:08', NULL, '183319699999', 9, '2026-02-02 10:28:31', NULL, '2026-02-02 13:54:32', '0', NULL, NULL, 100.00, 'HOLD', '', '[]');
INSERT INTO `biz_post` VALUES (18, 'FOUND', '钱包', '你这页“发起认领”按钮是有的，但有两个前提条件', 1, 5, NULL, '2026-02-02 00:03:00', '14', NULL, '[\"/uploads/posts/2026/02/02/dac6893513e34b0d8dce7f7c9e74b219.png\"]', 'CLOSED', 20, 0, 0, 0, 0, 2, '2026-02-02 11:33:12', NULL, '18331969999', 9, '2026-02-02 11:32:54', NULL, '2026-02-02 12:03:18', '0', NULL, NULL, NULL, 'NONE', '', '[]');

-- ----------------------------
-- Table structure for biz_report
-- ----------------------------
DROP TABLE IF EXISTS `biz_report`;
CREATE TABLE `biz_report`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '举报ID',
  `reporter_id` bigint NOT NULL COMMENT '举报人ID',
  `target_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '举报目标类型：POST-帖子，COMMENT-评论，USER-用户',
  `target_id` bigint NOT NULL COMMENT '举报目标ID',
  `reason_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '举报原因类型：FAKE-虚假信息，SPAM-垃圾广告，ABUSE-辱骂攻击，OTHER-其他',
  `reason_detail` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '举报详情',
  `evidence_images_json` json NULL COMMENT '证据图片JSON数组',
  `status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'PENDING' COMMENT '状态：PENDING-待处理，RESOLVED-已处理，REJECTED-已驳回',
  `resolve_by` bigint NULL DEFAULT NULL COMMENT '处理人',
  `resolve_at` datetime NULL DEFAULT NULL COMMENT '处理时间',
  `resolve_result` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '处理结果',
  `resolve_action` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '处理动作：WARN-警告，OFFLINE_POST-下架帖子，BAN_USER-封禁用户',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '举报时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_reporter_id`(`reporter_id` ASC) USING BTREE,
  INDEX `idx_target_type_id`(`target_type` ASC, `target_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '举报表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of biz_report
-- ----------------------------
INSERT INTO `biz_report` VALUES (1, 9, 'POST', 10, 'OTHER', '测试举报功能 - 这是一个测试举报，请忽略', NULL, 'RESOLVED', 2, '2025-12-29 13:11:26', 'MCP测试处理功能-验证数据库更新', 'warning', '2025-12-28 18:14:16', '2025-12-28 18:14:16');
INSERT INTO `biz_report` VALUES (2, 9, 'POST', 7, 'OTHER', 'MCP测试举报功能-验证数据库写入', NULL, 'REJECTED', 2, '2025-12-29 13:01:16', '1', NULL, '2025-12-28 22:44:34', '2025-12-28 22:44:33');

-- ----------------------------
-- Table structure for biz_student_roster
-- ----------------------------
DROP TABLE IF EXISTS `biz_student_roster`;
CREATE TABLE `biz_student_roster`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `student_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '学号',
  `real_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '真实姓名',
  `id_card_suffix` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '身份证后6位',
  `college` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '学院',
  `major` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '专业',
  `class_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '班级',
  `enrollment_year` int NULL DEFAULT NULL COMMENT '入学年份',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态',
  `bound_user_id` bigint NULL DEFAULT NULL COMMENT '已绑定的用户ID',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_student_no`(`student_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '学生名单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of biz_student_roster
-- ----------------------------
INSERT INTO `biz_student_roster` VALUES (3, '2021001001', '张三', 'e10adc3949ba59abbe56e057f20f883e', '计算机学院', '软件工程', '软件2101', 2021, 0, 8, '2025-12-31 10:35:12', '2026-01-17 15:41:11');
INSERT INTO `biz_student_roster` VALUES (4, '2021001002', '李四', '508df4cb2f4d8f80519256258cfb975f', '计算机学院', '软件工程', '软件2101', 2021, 0, 9, '2025-12-31 10:35:12', '2025-12-31 10:44:07');

-- ----------------------------
-- Table structure for qrtz_blob_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_blob_triggers`;
CREATE TABLE `qrtz_blob_triggers`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `TRIGGER_NAME` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `TRIGGER_GROUP` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `BLOB_DATA` blob NULL,
  PRIMARY KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) USING BTREE,
  INDEX `SCHED_NAME`(`SCHED_NAME` ASC, `TRIGGER_NAME` ASC, `TRIGGER_GROUP` ASC) USING BTREE,
  CONSTRAINT `qrtz_blob_triggers_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `qrtz_triggers` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_blob_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_calendars
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_calendars`;
CREATE TABLE `qrtz_calendars`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `CALENDAR_NAME` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `CALENDAR` blob NOT NULL,
  PRIMARY KEY (`SCHED_NAME`, `CALENDAR_NAME`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_calendars
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_cron_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_cron_triggers`;
CREATE TABLE `qrtz_cron_triggers`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `TRIGGER_NAME` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `TRIGGER_GROUP` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `CRON_EXPRESSION` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `TIME_ZONE_ID` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) USING BTREE,
  CONSTRAINT `qrtz_cron_triggers_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `qrtz_triggers` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_cron_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_fired_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_fired_triggers`;
CREATE TABLE `qrtz_fired_triggers`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ENTRY_ID` varchar(95) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `TRIGGER_NAME` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `TRIGGER_GROUP` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `INSTANCE_NAME` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `FIRED_TIME` bigint NOT NULL,
  `SCHED_TIME` bigint NOT NULL,
  `PRIORITY` int NOT NULL,
  `STATE` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `JOB_NAME` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `JOB_GROUP` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `IS_NONCONCURRENT` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `REQUESTS_RECOVERY` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`SCHED_NAME`, `ENTRY_ID`) USING BTREE,
  INDEX `IDX_QRTZ_FT_TRIG_INST_NAME`(`SCHED_NAME` ASC, `INSTANCE_NAME` ASC) USING BTREE,
  INDEX `IDX_QRTZ_FT_INST_JOB_REQ_RCVRY`(`SCHED_NAME` ASC, `INSTANCE_NAME` ASC, `REQUESTS_RECOVERY` ASC) USING BTREE,
  INDEX `IDX_QRTZ_FT_J_G`(`SCHED_NAME` ASC, `JOB_NAME` ASC, `JOB_GROUP` ASC) USING BTREE,
  INDEX `IDX_QRTZ_FT_JG`(`SCHED_NAME` ASC, `JOB_GROUP` ASC) USING BTREE,
  INDEX `IDX_QRTZ_FT_T_G`(`SCHED_NAME` ASC, `TRIGGER_NAME` ASC, `TRIGGER_GROUP` ASC) USING BTREE,
  INDEX `IDX_QRTZ_FT_TG`(`SCHED_NAME` ASC, `TRIGGER_GROUP` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_fired_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_job_details
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_job_details`;
CREATE TABLE `qrtz_job_details`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `JOB_NAME` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `JOB_GROUP` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `DESCRIPTION` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `JOB_CLASS_NAME` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `IS_DURABLE` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `IS_NONCONCURRENT` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `IS_UPDATE_DATA` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `REQUESTS_RECOVERY` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `JOB_DATA` blob NULL,
  PRIMARY KEY (`SCHED_NAME`, `JOB_NAME`, `JOB_GROUP`) USING BTREE,
  INDEX `IDX_QRTZ_J_REQ_RECOVERY`(`SCHED_NAME` ASC, `REQUESTS_RECOVERY` ASC) USING BTREE,
  INDEX `IDX_QRTZ_J_GRP`(`SCHED_NAME` ASC, `JOB_GROUP` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_job_details
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_locks
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_locks`;
CREATE TABLE `qrtz_locks`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `LOCK_NAME` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`SCHED_NAME`, `LOCK_NAME`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_locks
-- ----------------------------
INSERT INTO `qrtz_locks` VALUES ('QuartzScheduler', 'TRIGGER_ACCESS');

-- ----------------------------
-- Table structure for qrtz_paused_trigger_grps
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_paused_trigger_grps`;
CREATE TABLE `qrtz_paused_trigger_grps`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `TRIGGER_GROUP` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`SCHED_NAME`, `TRIGGER_GROUP`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_paused_trigger_grps
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_scheduler_state
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_scheduler_state`;
CREATE TABLE `qrtz_scheduler_state`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `INSTANCE_NAME` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `LAST_CHECKIN_TIME` bigint NOT NULL,
  `CHECKIN_INTERVAL` bigint NOT NULL,
  PRIMARY KEY (`SCHED_NAME`, `INSTANCE_NAME`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_scheduler_state
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_simple_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simple_triggers`;
CREATE TABLE `qrtz_simple_triggers`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `TRIGGER_NAME` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `TRIGGER_GROUP` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `REPEAT_COUNT` bigint NOT NULL,
  `REPEAT_INTERVAL` bigint NOT NULL,
  `TIMES_TRIGGERED` bigint NOT NULL,
  PRIMARY KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) USING BTREE,
  CONSTRAINT `qrtz_simple_triggers_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `qrtz_triggers` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_simple_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_simprop_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simprop_triggers`;
CREATE TABLE `qrtz_simprop_triggers`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `TRIGGER_NAME` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `TRIGGER_GROUP` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `STR_PROP_1` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `STR_PROP_2` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `STR_PROP_3` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `INT_PROP_1` int NULL DEFAULT NULL,
  `INT_PROP_2` int NULL DEFAULT NULL,
  `LONG_PROP_1` bigint NULL DEFAULT NULL,
  `LONG_PROP_2` bigint NULL DEFAULT NULL,
  `DEC_PROP_1` decimal(13, 4) NULL DEFAULT NULL,
  `DEC_PROP_2` decimal(13, 4) NULL DEFAULT NULL,
  `BOOL_PROP_1` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `BOOL_PROP_2` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) USING BTREE,
  CONSTRAINT `qrtz_simprop_triggers_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `qrtz_triggers` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_simprop_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_triggers`;
CREATE TABLE `qrtz_triggers`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `TRIGGER_NAME` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `TRIGGER_GROUP` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `JOB_NAME` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `JOB_GROUP` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `DESCRIPTION` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `NEXT_FIRE_TIME` bigint NULL DEFAULT NULL,
  `PREV_FIRE_TIME` bigint NULL DEFAULT NULL,
  `PRIORITY` int NULL DEFAULT NULL,
  `TRIGGER_STATE` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `TRIGGER_TYPE` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `START_TIME` bigint NOT NULL,
  `END_TIME` bigint NULL DEFAULT NULL,
  `CALENDAR_NAME` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `MISFIRE_INSTR` smallint NULL DEFAULT NULL,
  `JOB_DATA` blob NULL,
  PRIMARY KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) USING BTREE,
  INDEX `IDX_QRTZ_T_J`(`SCHED_NAME` ASC, `JOB_NAME` ASC, `JOB_GROUP` ASC) USING BTREE,
  INDEX `IDX_QRTZ_T_JG`(`SCHED_NAME` ASC, `JOB_GROUP` ASC) USING BTREE,
  INDEX `IDX_QRTZ_T_C`(`SCHED_NAME` ASC, `CALENDAR_NAME` ASC) USING BTREE,
  INDEX `IDX_QRTZ_T_G`(`SCHED_NAME` ASC, `TRIGGER_GROUP` ASC) USING BTREE,
  INDEX `IDX_QRTZ_T_STATE`(`SCHED_NAME` ASC, `TRIGGER_STATE` ASC) USING BTREE,
  INDEX `IDX_QRTZ_T_N_STATE`(`SCHED_NAME` ASC, `TRIGGER_NAME` ASC, `TRIGGER_GROUP` ASC, `TRIGGER_STATE` ASC) USING BTREE,
  INDEX `IDX_QRTZ_T_N_G_STATE`(`SCHED_NAME` ASC, `TRIGGER_GROUP` ASC, `TRIGGER_STATE` ASC) USING BTREE,
  INDEX `IDX_QRTZ_T_NEXT_FIRE_TIME`(`SCHED_NAME` ASC, `NEXT_FIRE_TIME` ASC) USING BTREE,
  INDEX `IDX_QRTZ_T_NFT_ST`(`SCHED_NAME` ASC, `TRIGGER_STATE` ASC, `NEXT_FIRE_TIME` ASC) USING BTREE,
  INDEX `IDX_QRTZ_T_NFT_MISFIRE`(`SCHED_NAME` ASC, `MISFIRE_INSTR` ASC, `NEXT_FIRE_TIME` ASC) USING BTREE,
  INDEX `IDX_QRTZ_T_NFT_ST_MISFIRE`(`SCHED_NAME` ASC, `MISFIRE_INSTR` ASC, `NEXT_FIRE_TIME` ASC, `TRIGGER_STATE` ASC) USING BTREE,
  INDEX `IDX_QRTZ_T_NFT_ST_MISFIRE_GRP`(`SCHED_NAME` ASC, `MISFIRE_INSTR` ASC, `NEXT_FIRE_TIME` ASC, `TRIGGER_GROUP` ASC, `TRIGGER_STATE` ASC) USING BTREE,
  CONSTRAINT `qrtz_triggers_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `JOB_NAME`, `JOB_GROUP`) REFERENCES `qrtz_job_details` (`SCHED_NAME`, `JOB_NAME`, `JOB_GROUP`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for storage_config
-- ----------------------------
DROP TABLE IF EXISTS `storage_config`;
CREATE TABLE `storage_config`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `storage_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '参数名称',
  `storage_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '参数键名',
  `storage_value` varchar(4096) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '存储值',
  `storage_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '存储类型',
  `is_primary` tinyint(1) NULL DEFAULT 0 COMMENT '是否默认',
  `enable_trash` tinyint NULL DEFAULT 0 COMMENT '是否启用回收站(1启用0不启用)',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '文件配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of storage_config
-- ----------------------------

-- ----------------------------
-- Table structure for storage_file
-- ----------------------------
DROP TABLE IF EXISTS `storage_file`;
CREATE TABLE `storage_file`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `file_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '文件名,存储在计算机中的文件名',
  `original_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '文件名',
  `content_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '文件类型，如 image/jpeg, application/pdf 等',
  `file_size` bigint NULL DEFAULT NULL COMMENT '文件大小，字节为单位',
  `original_file_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '原始文件URL，直接访问地址',
  `original_relative_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '原始文件相对路径，存储在服务器上的路径',
  `preview_image_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '预览图片',
  `preview_relative_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '压缩文件相对路径，存储在服务器上的路径',
  `file_extension` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '文件扩展名',
  `storage_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '存储类型 (LOCAL/MINIO/ALIYUN_OSS)',
  `bucket_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '存储桶名称（OSS/MINIO 使用）',
  `uploader_id` bigint NULL DEFAULT NULL COMMENT '上传者ID',
  `uploader_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '上传者名称',
  `upload_time` datetime NULL DEFAULT NULL COMMENT '上传时间',
  `original_trash_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '原始文件回收站路径',
  `preview_trash_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '预览图文件回收站路径',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_trash` tinyint(1) NULL DEFAULT 0 COMMENT '是否在回收站，1代表在回收站',
  `is_deleted` tinyint(1) NULL DEFAULT 0 COMMENT '是否删除(0-未删除, 1-已删除)',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '文件上传记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of storage_file
-- ----------------------------
INSERT INTO `storage_file` VALUES (1, '19a76ed608be4d80a3e5fc5557380a2f.png', 'logo.png', 'image/png', 8074, '/uploads/posts/2026/01/06/19a76ed608be4d80a3e5fc5557380a2f.png', 'posts/2026/01/06/19a76ed608be4d80a3e5fc5557380a2f.png', NULL, NULL, 'png', 'LOCAL', NULL, 9, '11134', '2026-01-06 11:46:13', NULL, NULL, '2026-01-06 11:46:12', 0, 0);
INSERT INTO `storage_file` VALUES (2, '9dd0cf91ffe242649f139bf0cfa4fad4.png', 'Java学习路线图-阶段-电脑版.png', 'image/png', 601664, '/uploads/posts/2026/01/17/9dd0cf91ffe242649f139bf0cfa4fad4.png', 'posts/2026/01/17/9dd0cf91ffe242649f139bf0cfa4fad4.png', NULL, NULL, 'png', 'LOCAL', NULL, 8, '2450610521', '2026-01-17 15:41:57', NULL, NULL, '2026-01-17 15:41:57', 0, 0);
INSERT INTO `storage_file` VALUES (3, 'bddf0218f35643bfa09f21033d3c6cc9.png', '屏幕截图 2024-11-25 222406.png', 'image/png', 1691465, '/uploads/posts/2026/02/02/bddf0218f35643bfa09f21033d3c6cc9.png', 'posts/2026/02/02/bddf0218f35643bfa09f21033d3c6cc9.png', NULL, NULL, 'png', 'LOCAL', NULL, 9, '11134', '2026-02-02 10:27:43', NULL, NULL, '2026-02-02 10:27:43', 0, 0);
INSERT INTO `storage_file` VALUES (4, '0dd2ebfe0aee4a16a3f7ddb636a3158d.png', '屏幕截图 2024-11-25 222406.png', 'image/png', 1691465, '/uploads/posts/2026/02/02/0dd2ebfe0aee4a16a3f7ddb636a3158d.png', 'posts/2026/02/02/0dd2ebfe0aee4a16a3f7ddb636a3158d.png', NULL, NULL, 'png', 'LOCAL', NULL, 9, '11134', '2026-02-02 10:27:48', NULL, NULL, '2026-02-02 10:27:47', 0, 0);
INSERT INTO `storage_file` VALUES (5, '30665934ea42441895464ef3cc1ff2d0.png', '屏幕截图 2024-11-25 222406.png', 'image/png', 1691465, '/uploads/posts/2026/02/02/30665934ea42441895464ef3cc1ff2d0.png', 'posts/2026/02/02/30665934ea42441895464ef3cc1ff2d0.png', NULL, NULL, 'png', 'LOCAL', NULL, 9, '11134', '2026-02-02 10:27:50', NULL, NULL, '2026-02-02 10:27:50', 0, 0);
INSERT INTO `storage_file` VALUES (6, 'bcfff067ea0a4a0cbaa339376dd9e348.png', '屏幕截图 2024-11-25 222406.png', 'image/png', 1691465, '/uploads/posts/2026/02/02/bcfff067ea0a4a0cbaa339376dd9e348.png', 'posts/2026/02/02/bcfff067ea0a4a0cbaa339376dd9e348.png', NULL, NULL, 'png', 'LOCAL', NULL, 9, '11134', '2026-02-02 10:27:53', NULL, NULL, '2026-02-02 10:27:52', 0, 0);
INSERT INTO `storage_file` VALUES (7, 'a02ff7b857634137bd308a5b4a6a37fc.png', '屏幕截图 2024-11-25 222406.png', 'image/png', 1691465, '/uploads/posts/2026/02/02/a02ff7b857634137bd308a5b4a6a37fc.png', 'posts/2026/02/02/a02ff7b857634137bd308a5b4a6a37fc.png', NULL, NULL, 'png', 'LOCAL', NULL, 9, '11134', '2026-02-02 10:27:55', NULL, NULL, '2026-02-02 10:27:55', 0, 0);
INSERT INTO `storage_file` VALUES (8, 'dac6893513e34b0d8dce7f7c9e74b219.png', '屏幕截图 2024-11-25 222406.png', 'image/png', 1691465, '/uploads/posts/2026/02/02/dac6893513e34b0d8dce7f7c9e74b219.png', 'posts/2026/02/02/dac6893513e34b0d8dce7f7c9e74b219.png', NULL, NULL, 'png', 'LOCAL', NULL, 9, '11134', '2026-02-02 11:32:19', NULL, NULL, '2026-02-02 11:32:18', 0, 0);

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
  `config_id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `config_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '参数名称',
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '参数键名',
  `config_value` varchar(4096) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '参数键值',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_config
-- ----------------------------

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept`  (
  `dept_id` bigint NOT NULL AUTO_INCREMENT COMMENT '部门ID',
  `dept_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '部门名称',
  `status` tinyint(1) NULL DEFAULT 0 COMMENT '状态(0正常1停用)',
  `parent_id` bigint NULL DEFAULT NULL COMMENT '父部门ID',
  `manager` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '部门负责人',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '部门描述',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_by` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '创建人',
  `update_by` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '更新人',
  `remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '备注',
  PRIMARY KEY (`dept_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '部门表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
INSERT INTO `sys_dept` VALUES (1, '校园管理中心', 0, 0, '教务处', '校园管理中心', '2025-04-13 13:40:28', '2026-02-02 11:56:52', 'DEVELOP', 'DEVELOP', NULL);
INSERT INTO `sys_dept` VALUES (2, '计算机学院', 0, 1, NULL, '计算机学院', '2025-04-13 13:40:46', '2026-02-02 11:56:52', 'DEVELOP', 'DEVELOP', NULL);
INSERT INTO `sys_dept` VALUES (3, '软件工程系', 0, 2, NULL, '软件工程系', '2025-04-13 13:41:07', '2026-02-02 11:56:52', 'DEVELOP', 'DEVELOP', NULL);
INSERT INTO `sys_dept` VALUES (4, '网络工程系', 0, 2, NULL, '网络工程系', '2025-04-13 13:42:20', '2026-02-02 11:56:52', 'DEVELOP', 'DEVELOP', NULL);
INSERT INTO `sys_dept` VALUES (5, '信息工程学院', 0, 1, NULL, '信息工程学院', '2025-04-13 13:42:45', '2026-02-02 11:56:52', 'DEVELOP', 'DEVELOP', NULL);
INSERT INTO `sys_dept` VALUES (7, '物联网工程系', 0, 5, '韩经理', '物联网工程系', '2025-04-24 10:55:08', '2026-02-02 11:56:52', NULL, NULL, NULL);
INSERT INTO `sys_dept` VALUES (8, '通信工程系', 0, 5, '产经理', '通信工程系', '2025-04-24 14:01:28', '2026-02-02 11:56:52', NULL, NULL, NULL);

-- ----------------------------
-- Table structure for sys_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '字典类型（关联字典类型表dict_type）',
  `dict_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '字典标签（中文显示）',
  `dict_value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '字典值（业务使用的值）',
  `color` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '颜色',
  `sort` int NULL DEFAULT 0 COMMENT '排序（越小越前）',
  `status` tinyint(1) NULL DEFAULT 1 COMMENT '状态（1=启用，0=禁用）',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `create_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_dict_type`(`dict_type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '字典数据表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict_data
-- ----------------------------
INSERT INTO `sys_dict_data` VALUES (1, 'gender', '男', '0', NULL, 1, 1, '男性', 'admin', '2025-07-14 17:35:57', 'zhangchuang', '2025-07-18 19:49:54');
INSERT INTO `sys_dict_data` VALUES (2, 'gender', '女', '1', NULL, 2, 1, '女性', 'admin', '2025-07-14 17:35:57', 'zhangchuang', '2025-07-18 19:49:58');
INSERT INTO `sys_dict_data` VALUES (3, 'user_status', '启用', '1', NULL, 1, 1, '账号启用', 'admin', '2025-07-14 17:35:57', NULL, '2025-07-14 17:35:57');
INSERT INTO `sys_dict_data` VALUES (4, 'user_status', '禁用', '0', NULL, 2, 1, '账号禁用', 'admin', '2025-07-14 17:35:57', NULL, '2025-07-14 17:35:57');
INSERT INTO `sys_dict_data` VALUES (11, 'system_status', '正常', '0', NULL, 0, 0, NULL, 'zhangchuang', '2025-07-16 14:25:36', NULL, '2025-07-16 14:25:36');
INSERT INTO `sys_dict_data` VALUES (12, 'system_status', '禁用', '1', NULL, 0, 0, NULL, 'zhangchuang', '2025-07-16 14:25:44', 'zhangchuang', '2025-08-12 09:26:54');
INSERT INTO `sys_dict_data` VALUES (13, 'notice_type', '系统消息', 'system', NULL, 0, 0, NULL, 'zhangchuang', '2025-08-12 10:08:40', 'zhangchuang', '2025-08-12 10:09:03');
INSERT INTO `sys_dict_data` VALUES (14, 'notice_type', '通知消息', 'notice', NULL, 0, 0, NULL, 'zhangchuang', '2025-08-12 10:09:16', 'zhangchuang', '2025-08-12 10:09:58');
INSERT INTO `sys_dict_data` VALUES (15, 'notice_type', '公告消息', 'announcement', 'blue', 0, 0, NULL, 'zhangchuang', '2025-08-12 10:09:28', 'zhangchuang', '2025-08-12 10:21:20');
INSERT INTO `sys_dict_data` VALUES (16, 'test_dice', '正常', 'announcement', 'blue', 0, 0, '测试测试', 'admin', '2025-08-16 22:30:24', 'admin', '2025-08-16 22:30:40');

-- ----------------------------
-- Table structure for sys_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '字典类型（唯一）',
  `dict_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '字典名称',
  `status` tinyint(1) NULL DEFAULT 0 COMMENT '状态（0=启用，1=禁用）',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `create_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_dict_type`(`dict_type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '字典类型表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
INSERT INTO `sys_dict_type` VALUES (1, 'gender', '性别', 0, '性别分类', 'admin', '2025-07-14 17:35:50', 'zhangchuang', '2025-07-16 14:13:34');
INSERT INTO `sys_dict_type` VALUES (2, 'user_status', '用户状态', 0, '用户启用禁用状态', 'admin', '2025-07-14 17:35:50', 'zhangchuang', '2025-07-14 20:25:29');
INSERT INTO `sys_dict_type` VALUES (3, 'notice_type', '通知类型', 0, '系统通知类型', 'admin', '2025-07-14 17:35:50', 'zhangchuang', '2025-07-14 20:25:31');
INSERT INTO `sys_dict_type` VALUES (5, 'system_status', '系统状态', 0, '系统状态', 'zhangchuang', '2025-07-16 14:18:07', 'zhangchuang', '2025-07-16 14:22:04');
INSERT INTO `sys_dict_type` VALUES (6, 'test_dice', '测试字典', 1, '测试字典', 'admin', '2025-08-16 22:30:09', NULL, '2025-08-16 22:30:09');

-- ----------------------------
-- Table structure for sys_job
-- ----------------------------
DROP TABLE IF EXISTS `sys_job`;
CREATE TABLE `sys_job`  (
  `job_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务名称',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调用目标字符串',
  `schedule_type` int NOT NULL DEFAULT 0 COMMENT '调度策略（0=Cron表达式 1=固定频率 2=固定延迟 3=一次性执行）',
  `cron_expression` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'cron执行表达式',
  `fixed_rate` bigint NULL DEFAULT NULL COMMENT '固定频率间隔（毫秒）',
  `fixed_delay` bigint NULL DEFAULT NULL COMMENT '固定延迟间隔（毫秒）',
  `initial_delay` bigint NULL DEFAULT NULL COMMENT '初始延迟时间（毫秒）',
  `misfire_policy` int NOT NULL DEFAULT 0 COMMENT '计划执行错误策略（0=默认 1=立即执行 2=执行一次 3=放弃执行）',
  `concurrent` int NOT NULL DEFAULT 1 COMMENT '是否并发执行（0允许 1禁止）',
  `status` int NOT NULL DEFAULT 1 COMMENT '任务状态（0正常 1暂停）',
  `priority` int NOT NULL DEFAULT 5 COMMENT '任务优先级',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '任务描述',
  `job_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '任务参数',
  `dependent_job_ids` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '依赖任务ID（多个用逗号分隔）',
  `max_retry_count` int NOT NULL DEFAULT 0 COMMENT '最大重试次数',
  `retry_interval` bigint NOT NULL DEFAULT 0 COMMENT '重试间隔（毫秒）',
  `timeout` bigint NOT NULL DEFAULT 0 COMMENT '超时时间（毫秒）',
  `start_time` datetime NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '结束时间',
  `next_fire_time` datetime NULL DEFAULT NULL COMMENT '下次执行时间',
  `previous_fire_time` datetime NULL DEFAULT NULL COMMENT '上次执行时间',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '创建者',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '更新者',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`job_id`) USING BTREE,
  UNIQUE INDEX `uk_job_name`(`job_name` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_next_fire_time`(`next_fire_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '定时任务表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_job
-- ----------------------------

-- ----------------------------
-- Table structure for sys_job_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_job_log`;
CREATE TABLE `sys_job_log`  (
  `job_log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_id` bigint NOT NULL COMMENT '任务ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务名称',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调用目标字符串',
  `job_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '任务参数',
  `job_message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '日志信息',
  `status` int NOT NULL DEFAULT 0 COMMENT '执行状态（0正常 1失败）',
  `exception_info` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '异常信息',
  `start_time` datetime NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '结束时间',
  `execute_time` bigint NULL DEFAULT NULL COMMENT '执行耗时（毫秒）',
  `server_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '服务器IP',
  `server_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '服务器名称',
  `retry_count` int NOT NULL DEFAULT 0 COMMENT '重试次数',
  `trigger_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '触发器类型',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '创建者',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '更新者',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`job_log_id`) USING BTREE,
  INDEX `idx_job_id`(`job_id` ASC) USING BTREE,
  INDEX `idx_job_name`(`job_name` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_start_time`(`start_time` ASC) USING BTREE,
  CONSTRAINT `fk_job_log_job_id` FOREIGN KEY (`job_id`) REFERENCES `sys_job` (`job_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '定时任务执行日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_job_log
-- ----------------------------

-- ----------------------------
-- Table structure for sys_login_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_login_log`;
CREATE TABLE `sys_login_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `username` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户名',
  `status` tinyint(1) NOT NULL COMMENT '登录状态（0成功 1失败）',
  `ip` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '登录IP',
  `region` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '区域',
  `browser` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '浏览器',
  `os` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '操作系统',
  `login_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_by` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '创建人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 401 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统登录日志' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_login_log
-- ----------------------------
INSERT INTO `sys_login_log` VALUES (1, 'admin', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-10 09:54:58', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (2, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-10 09:55:19', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (3, 'admin', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-10 11:06:59', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (4, 'admin', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-10 11:13:05', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (5, 'admin', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-10 11:22:05', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (6, 'admin', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-10 11:22:16', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (7, 'admin', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-10 11:22:42', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (8, 'admin', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-10 11:22:49', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (9, 'admin', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-10 11:23:56', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (10, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-10 11:26:31', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (11, 'admin1', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-10 15:45:27', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (12, 'admin', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-10 15:48:27', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (13, 'admin', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-10 15:55:21', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (14, 'admin1', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-10 15:55:32', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (15, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-10 15:56:02', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (16, 'admin', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-10 19:43:55', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (17, 'demo', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-10 19:44:10', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (18, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-10 19:44:23', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (19, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-10 20:31:43', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (20, 'demo', 0, '127.0.0.1', '本机', 'Firefox 14', 'Windows 10', '2025-12-10 20:33:04', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (21, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-10 21:24:39', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (22, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-10 21:32:02', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (23, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-10 21:50:46', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (24, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-11 09:24:39', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (25, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-11 10:08:36', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (26, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-11 10:14:50', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (27, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-11 10:53:07', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (28, '111', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-11 11:11:40', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (29, '1112', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-11 11:16:56', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (30, '1113', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-11 11:27:07', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (31, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-11 11:27:24', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (32, '1113', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-11 11:28:30', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (33, '1113', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-11 11:47:10', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (34, '1113', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-11 11:47:35', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (35, '2450610522', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-11 11:49:57', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (36, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-11 11:50:15', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (37, '2450610522', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-11 11:50:54', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (38, '2450610522', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-11 11:51:11', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (39, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-11 11:56:05', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (40, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-11 12:03:57', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (41, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-11 14:00:17', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (42, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-11 14:11:12', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (43, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-11 14:13:10', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (44, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-11 14:20:12', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (45, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-11 14:46:57', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (46, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-11 14:52:45', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (47, '2450610522', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-11 14:53:19', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (48, '2450610522', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-11 14:53:36', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (49, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-11 14:53:50', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (50, '1113', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-11 14:55:37', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (51, '2450610522', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-11 14:55:49', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (52, '2450610521', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-11 14:56:54', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (53, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-11 14:57:04', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (54, '2450610521', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-11 14:57:21', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (55, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-11 14:57:43', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (56, '2450610521', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-11 14:58:29', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (57, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-11 14:58:45', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (58, '2450610521', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-11 14:59:20', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (59, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-11 14:59:32', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (60, '2450610521', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-11 15:04:52', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (61, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-11 15:07:20', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (62, '2450610521', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-11 15:10:13', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (63, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-11 15:10:53', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (64, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-13 22:06:45', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (65, '2450610521', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-13 22:08:59', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (66, '245061051', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-13 22:09:17', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (67, '245061052', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-13 22:09:26', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (68, '2450610522', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-13 22:09:43', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (69, '2450610522', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-13 22:09:52', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (70, '2450610521', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-13 22:10:01', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (71, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-13 22:10:11', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (72, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-15 20:07:47', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (73, '2450610521', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-15 22:00:24', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (74, '2450610521', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-15 22:00:37', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (75, '2450610521', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-15 22:01:24', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (76, '2450610522', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-15 22:01:33', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (77, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-15 22:07:23', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (78, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-15 22:13:22', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (79, '11134', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-15 22:15:06', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (80, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-15 22:15:18', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (81, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-15 22:15:37', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (82, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-15 22:16:05', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (83, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-16 09:28:29', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (84, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-16 11:31:49', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (85, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-17 11:06:17', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (86, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-17 21:35:26', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (87, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-17 21:51:00', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (88, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-18 21:38:43', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (89, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-26 14:44:55', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (90, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-27 20:32:37', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (91, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-27 21:24:44', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (92, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-27 22:05:16', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (93, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 00:07:04', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (94, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 00:07:32', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (95, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 00:24:04', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (96, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 00:53:41', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (97, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 01:00:45', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (98, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 01:04:14', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (99, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 01:05:46', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (100, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 01:11:01', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (101, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 01:14:32', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (102, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 01:22:36', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (103, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 01:24:04', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (104, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 01:30:56', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (105, 'demo', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 01:34:58', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (106, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 01:35:16', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (107, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 12:09:41', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (108, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 12:26:24', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (109, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 12:31:30', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (110, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 12:36:14', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (111, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 12:40:59', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (112, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 12:48:10', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (113, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 12:52:32', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (114, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 12:55:32', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (115, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 13:08:25', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (116, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 13:11:29', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (117, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 13:16:49', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (118, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 13:25:31', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (119, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 13:33:39', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (120, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 14:34:05', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (121, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 15:07:56', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (122, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 15:13:47', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (123, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 15:15:47', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (124, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 15:17:11', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (125, 'demo', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 15:54:36', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (126, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 15:56:55', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (127, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 16:17:34', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (128, '11134', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 16:19:56', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (129, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 16:20:28', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (130, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 16:23:38', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (131, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 16:24:20', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (132, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 16:36:35', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (133, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 16:37:25', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (134, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 16:40:12', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (135, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 16:41:25', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (136, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 16:41:37', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (137, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 16:43:00', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (138, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 16:43:18', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (139, '2450610521', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 17:11:00', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (140, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 17:13:35', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (141, '2450610521', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 17:18:57', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (142, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 17:19:52', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (143, '2450610521', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 17:28:05', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (144, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 17:34:42', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (145, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 17:55:55', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (146, '2450610521', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 18:00:04', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (147, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 18:01:59', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (148, '2450610521', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 18:04:43', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (149, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 18:06:41', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (150, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 18:10:04', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (151, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 18:17:42', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (152, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 18:35:30', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (153, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 19:07:00', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (154, '2450610521', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 19:11:12', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (155, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 19:15:26', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (156, '2450610521', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 19:17:07', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (157, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 19:25:27', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (158, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 19:38:33', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (159, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 19:42:11', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (160, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 21:03:20', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (161, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 21:17:05', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (162, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 21:23:24', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (163, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 21:37:20', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (164, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 21:52:51', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (165, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 21:58:47', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (166, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 22:10:44', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (167, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 22:24:32', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (168, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 22:26:59', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (169, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 22:34:29', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (170, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 22:56:42', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (171, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 23:08:26', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (172, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 23:17:46', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (173, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 23:21:11', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (174, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 23:26:02', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (175, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 23:52:12', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (176, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-28 23:57:03', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (177, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-29 00:03:25', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (178, 'demo', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-29 09:34:43', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (179, 'demo', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-29 09:34:48', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (180, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-29 09:34:58', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (181, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-29 09:54:23', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (182, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-29 10:05:34', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (183, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-29 11:38:41', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (184, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-29 11:50:01', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (185, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-29 12:05:44', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (186, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-29 12:50:58', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (187, 'demo', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-29 12:53:31', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (188, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-29 12:53:39', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (189, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-29 12:56:59', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (190, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-29 13:10:33', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (191, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-29 13:31:54', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (192, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-29 13:40:46', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (193, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-29 13:46:48', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (194, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-29 13:54:56', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (195, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-29 14:00:53', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (196, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-29 14:17:17', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (197, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-29 14:26:19', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (198, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-29 14:33:36', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (199, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-29 14:38:23', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (200, 'admin', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-29 17:53:03', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (201, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-29 17:53:14', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (202, 'admin', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 09:40:11', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (203, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 09:40:22', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (204, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 09:54:40', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (205, '256156465451', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 10:23:07', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (206, '1134', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 10:23:24', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (207, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 10:23:34', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (208, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 10:30:43', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (209, 'demo', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 10:45:49', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (210, 'demo', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 10:46:18', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (211, 'demo', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 10:46:22', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (212, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 10:46:30', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (213, 'demo', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 10:48:20', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (214, 'demo', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 10:48:44', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (215, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 10:48:55', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (216, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 10:51:32', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (217, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 10:52:13', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (218, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 10:59:46', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (219, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 11:01:17', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (220, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 11:04:19', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (221, 'admin', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 11:12:54', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (222, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 11:13:50', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (223, 'demo', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 11:20:07', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (224, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 11:20:31', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (225, 'demo', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 11:22:30', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (226, 'demo', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 11:22:39', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (227, 'admin', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 11:22:54', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (228, 'admin', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 11:23:02', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (229, 'demo', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 11:24:52', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (230, 'demo', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 11:26:43', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (231, 'admin', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 11:27:29', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (232, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 11:30:03', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (233, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 11:32:38', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (234, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 11:43:42', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (235, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 11:49:06', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (236, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 12:00:30', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (237, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 12:49:35', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (238, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 12:55:27', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (239, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 12:57:10', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (240, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 13:00:26', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (241, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 13:04:48', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (242, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 13:15:21', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (243, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 13:16:24', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (244, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 13:19:47', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (245, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 13:32:44', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (246, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 13:33:57', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (247, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 13:36:42', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (248, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 13:38:14', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (249, 'admin', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 13:39:46', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (250, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 13:41:19', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (251, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 13:41:42', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (252, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 13:42:10', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (253, 'demo', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 13:54:03', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (254, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 13:54:14', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (255, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 13:58:05', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (256, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 13:58:36', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (257, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 14:00:39', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (258, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 14:00:59', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (259, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 14:20:52', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (260, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 14:32:14', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (261, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 14:34:39', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (262, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 14:37:01', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (263, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 14:37:49', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (264, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 16:53:43', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (265, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 17:45:02', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (266, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 17:48:57', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (267, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 17:56:24', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (268, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 18:07:59', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (269, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 20:30:31', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (270, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 20:40:46', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (271, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 20:56:12', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (272, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 20:56:35', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (273, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 20:58:19', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (274, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 21:08:29', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (275, '11134', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 21:15:34', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (276, '11134', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 21:15:38', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (277, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 21:15:53', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (278, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 21:16:59', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (279, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 21:19:36', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (280, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 21:27:27', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (281, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 21:30:26', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (282, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 21:30:58', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (283, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-30 21:40:20', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (284, 'demo', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-31 09:48:15', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (285, 'demo', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-31 09:49:26', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (286, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-31 09:52:16', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (287, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-31 10:01:40', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (288, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-31 10:14:13', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (289, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-31 10:21:40', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (290, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-31 10:25:42', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (291, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-31 10:32:44', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (292, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-31 10:36:44', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (293, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-31 10:43:41', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (294, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-31 10:44:24', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (295, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-31 11:02:00', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (296, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-31 11:02:36', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (297, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-31 11:07:57', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (298, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-31 11:11:05', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (299, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-31 11:14:59', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (300, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-31 11:18:53', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (301, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-31 11:23:16', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (302, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-31 11:26:47', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (303, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-31 11:35:40', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (304, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-31 11:59:49', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (305, '11134', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-31 13:09:17', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (306, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-31 13:10:36', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (307, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-31 13:18:05', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (308, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-31 13:25:11', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (309, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-31 13:28:30', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (310, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-31 13:36:42', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (311, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-31 13:43:24', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (312, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-31 13:49:57', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (313, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-31 13:54:24', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (314, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-31 13:55:24', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (315, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-31 14:06:22', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (316, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-31 14:07:08', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (317, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-31 14:10:51', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (318, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-31 15:14:10', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (319, '11134', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-31 15:16:29', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (320, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-31 15:16:56', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (321, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-31 15:30:43', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (322, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-31 15:34:31', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (323, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-31 16:03:04', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (324, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-31 16:11:02', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (325, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-31 16:14:57', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (326, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-31 16:39:49', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (327, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-31 16:40:28', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (328, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-31 16:41:18', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (329, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-31 16:45:28', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (330, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-31 16:47:08', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (331, '11134', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-31 16:52:31', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (332, '11134', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-31 16:52:32', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (333, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-31 16:52:42', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (334, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2025-12-31 16:54:41', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (335, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-01-05 17:50:43', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (336, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-01-06 09:37:47', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (337, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-01-06 09:45:38', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (338, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-01-06 09:57:09', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (339, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-01-06 10:14:08', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (340, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-01-06 10:21:49', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (341, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-01-06 10:25:42', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (342, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-01-06 10:32:19', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (343, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-01-06 10:36:12', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (344, '11134', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-01-06 10:50:22', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (345, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-01-06 10:50:32', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (346, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-01-06 11:17:21', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (347, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-01-06 11:27:57', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (348, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-01-06 11:28:55', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (349, '11134', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-01-06 11:32:03', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (350, '11134', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-01-06 11:33:03', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (351, '11134', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-01-06 11:33:32', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (352, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-01-06 11:33:36', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (353, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-01-06 11:35:08', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (354, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-01-06 11:43:24', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (355, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-01-06 11:44:25', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (356, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-01-06 11:48:40', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (357, 'admin', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-01-06 11:54:04', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (358, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-01-06 11:55:02', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (359, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-01-06 11:59:13', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (360, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-01-06 14:14:52', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (361, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-01-06 14:15:38', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (362, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-01-06 14:18:20', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (363, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-01-17 15:24:02', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (364, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-01-17 15:35:52', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (365, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-01-17 15:36:18', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (366, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-01-17 15:36:57', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (367, '2450610521', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-01-17 15:37:49', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (368, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-01-17 15:44:38', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (369, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-01-17 15:45:43', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (370, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-01-17 16:04:37', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (371, '2450610521', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-01-17 16:05:54', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (372, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-01-17 16:06:51', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (373, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-02-01 23:41:41', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (374, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-02-02 00:04:44', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (375, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-02-02 00:07:57', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (376, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-02-02 00:21:26', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (377, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-02-02 00:22:13', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (378, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-02-02 09:51:10', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (379, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-02-02 09:51:44', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (380, '11134', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-02-02 09:52:47', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (381, '11134', 1, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-02-02 09:52:53', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (382, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-02-02 09:52:56', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (383, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-02-02 09:55:24', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (384, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-02-02 09:55:47', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (385, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-02-02 09:56:06', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (386, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-02-02 09:59:15', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (387, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-02-02 09:59:55', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (388, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-02-02 10:00:27', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (389, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-02-02 10:01:36', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (390, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-02-02 10:02:44', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (391, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-02-02 10:05:45', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (392, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-02-02 10:19:27', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (393, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-02-02 10:19:38', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (394, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-02-02 10:29:01', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (395, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-02-02 10:34:38', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (396, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-02-02 10:39:24', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (397, 'demo', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-02-02 10:40:30', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (398, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-02-02 13:48:04', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (399, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-02-02 14:00:41', '系统自动创建');
INSERT INTO `sys_login_log` VALUES (400, '11134', 0, '0:0:0:0:0:0:0:1', 'IPv6不支持查询', 'Chrome 14', 'Windows 10', '2026-02-02 14:31:33', '系统自动创建');

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '名称',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '标题',
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '路径',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '类型',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态',
  `parent_id` bigint NOT NULL DEFAULT 0 COMMENT '父级ID',
  `active_path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '激活路径',
  `active_icon` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '激活图标',
  `icon` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '图标',
  `component` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '组件',
  `permission` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '权限标识',
  `badge_type` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '徽标类型',
  `badge` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '徽标',
  `badge_variants` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '徽标颜色',
  `keep_alive` tinyint NULL DEFAULT 0 COMMENT '是否缓存',
  `affix_tab` tinyint NULL DEFAULT 0 COMMENT '是否固定标签页',
  `hide_in_menu` tinyint NULL DEFAULT 0 COMMENT '隐藏菜单',
  `hide_children_in_menu` tinyint NULL DEFAULT 0 COMMENT '隐藏子菜单',
  `hide_in_breadcrumb` tinyint NULL DEFAULT 0 COMMENT '隐藏在面包屑中',
  `hide_in_tab` tinyint NULL DEFAULT 0 COMMENT '隐藏在标签页中',
  `link` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '外部链接地址',
  `sort` int NOT NULL DEFAULT 0 COMMENT '排序',
  `create_time` datetime NULL DEFAULT (now()) COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT (now()) COMMENT '更新时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '创建者',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '更新者',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 373 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '菜单表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (1, 'SystemManage', '系统管理', '/system', 'catalog', 0, 0, '', '', 'carbon:settings', '', '', '', '', 'destructive', 0, 0, 0, 0, 0, 0, '', 1, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', 'demo', NULL);
INSERT INTO `sys_menu` VALUES (2, 'Monitor', '系统监控', '/monitor', 'catalog', 0, 0, '', '', 'carbon:cloud-monitoring', NULL, '', '', '', '', 0, 0, 1, 0, 0, 0, '', 2, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', 'demo', NULL);
INSERT INTO `sys_menu` VALUES (3, 'SystemTools', '系统工具', '/tool', 'catalog', 0, 0, '', '', 'carbon:tool-kit', NULL, '', '', '', '', 0, 0, 1, 0, 0, 0, '', 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', 'demo', NULL);
INSERT INTO `sys_menu` VALUES (4, 'UserManage', '用户管理', '/system/user', 'menu', 0, 1, '', '', 'carbon:user', '/system/user/index', '', '', '', 'default', 0, 0, 0, 0, 0, 0, '', 10, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', 'admin', NULL);
INSERT INTO `sys_menu` VALUES (5, 'RoleManage', '角色管理', '/system/role', 'menu', 0, 1, '', '', 'carbon:user-role', '/system/role/list', '', '', '', '', 0, 0, 0, 0, 0, 0, '', 10, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', 'admin', NULL);
INSERT INTO `sys_menu` VALUES (6, 'MenuManage', '菜单管理', '/system/menu', 'menu', 0, 1, NULL, NULL, 'carbon:menu', '/system/menu/list', NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, 0, '', 9, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (7, 'DeptManage', '部门管理', '/system/dept', 'menu', 0, 1, '', '', 'carbon:column-dependency', '/system/dept/list', '', '', '', '', 0, 0, 0, 0, 0, 0, '', 10, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', 'admin', NULL);
INSERT INTO `sys_menu` VALUES (8, 'PostManage', '岗位管理', '/system/post', 'menu', 0, 1, NULL, NULL, 'carbon:workspace', '/system/post/index', NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, 0, NULL, 5, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', NULL, NULL);
INSERT INTO `sys_menu` VALUES (9, 'DictManage', '字典管理', '/system/dict', 'menu', 0, 1, NULL, NULL, 'carbon:package-text-analysis', '/system/dict/type/index', NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, 0, '', 7, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (10, 'DictData', '字典数据', '/system/dict/data/:id', 'menu', 0, 1, NULL, NULL, 'carbon:report-data', '/system/dict/data/index', NULL, NULL, NULL, NULL, 0, 0, 1, 0, 0, 0, '', 7, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (11, 'SystemStorage', '系统存储', '/system/storage', 'catalog', 0, 1, NULL, NULL, 'carbon:block-storage', NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (12, 'SystemLog', '系统日志', '/system/log', 'catalog', 0, 1, '', '', 'carbon:ibm-knowledge-catalog-standard', NULL, '', '', '', '', 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', 'demo', NULL);
INSERT INTO `sys_menu` VALUES (13, 'OnlineManage', '在线管理', '/system/online', 'catalog', 0, 1, '', '', 'carbon:user-online', '', '', '', '', '', 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (14, 'StorageConfig', '存储配置', '/system/storage/config', 'menu', 0, 11, NULL, NULL, 'carbon:ibm-global-storage-architecture', '/system/storage/config/index', NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 1, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', NULL, NULL);
INSERT INTO `sys_menu` VALUES (15, 'StorageFile', '存储文件', '/system/storage/file', 'menu', 0, 11, NULL, NULL, 'carbon:ibm-cloud-vpc-file-storage', '/system/storage/file/index', NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 2, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', NULL, NULL);
INSERT INTO `sys_menu` VALUES (16, 'LoginLog', '登录日志', '/system/log/login', 'menu', 0, 12, NULL, NULL, 'carbon:login', '/system/log/login/index', NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 1, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', NULL, NULL);
INSERT INTO `sys_menu` VALUES (17, 'OperationLog', '操作日志', '/system/log/operation', 'menu', 0, 12, NULL, NULL, 'carbon:operations-field', '/system/log/operation/index', NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 2, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', NULL, NULL);
INSERT INTO `sys_menu` VALUES (18, 'SystemMetrics', '系统指标', '/monitor/metrics', 'menu', 0, 2, NULL, NULL, 'carbon:business-metrics', '/monitor/metrics/index', NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 1, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', NULL, NULL);
INSERT INTO `sys_menu` VALUES (19, 'SqlMonitor', '数据监控', '/monitor/database', 'embedded', 0, 2, '', '', 'carbon:db2-database', 'IFrameView', '', '', '', '', 1, 0, 0, 0, 0, 0, 'https://echo.zhangchuangla.cn/api/druid/login.html', 2, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', 'admin', NULL);
INSERT INTO `sys_menu` VALUES (20, 'Job', '定时任务', '/tool/job', 'catalog', 0, 3, '', '', 'carbon:network-time-protocol', '', '', '', '', '', 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (21, 'OpenApi', '接口文档', '/tool/openapi', 'embedded', 0, 3, '', '', 'carbon:api-1', 'IFrameView', '', '', '', '', 1, 0, 0, 0, 0, 0, 'https://echo.zhangchuangla.cn/api/swagger-ui/index.html', 2, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', 'admin', NULL);
INSERT INTO `sys_menu` VALUES (22, 'JobManage', '任务管理', '/tool/job/manage', 'menu', 0, 20, NULL, NULL, 'material-symbols:manage-history', '/tool/job/manage/index', NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 1, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', NULL, NULL);
INSERT INTO `sys_menu` VALUES (23, 'JobLog', '任务日志', '/tool/job/log', 'menu', 0, 20, '', '', 'carbon:notebook-reference', '/tool/job/log/index', '', '', '', '', 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (24, 'DeviceManage', '设备管理', '/system/online/device', 'menu', 0, 13, NULL, NULL, 'carbon:devices', '/system/online/device/index', NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 1, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', NULL, NULL);
INSERT INTO `sys_menu` VALUES (25, 'SessionManage', '会话管理', '/system/online/session', 'menu', 0, 13, NULL, NULL, 'carbon:user-activity', '/system/online/session/index', NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 2, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', NULL, NULL);
INSERT INTO `sys_menu` VALUES (101, 'addUser', '新增用户', '', 'button', 0, 4, NULL, NULL, NULL, NULL, 'system:user:add', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', NULL, NULL);
INSERT INTO `sys_menu` VALUES (102, 'deleteUser', '删除用户', '', 'button', 0, 4, NULL, NULL, NULL, NULL, 'system:user:delete', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', NULL, NULL);
INSERT INTO `sys_menu` VALUES (103, 'updateUser', '修改用户', '', 'button', 0, 4, NULL, NULL, NULL, NULL, 'system:user:update', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', NULL, NULL);
INSERT INTO `sys_menu` VALUES (104, 'queryUser', '查询用户', '', 'button', 0, 4, NULL, NULL, NULL, NULL, 'system:user:query', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', NULL, NULL);
INSERT INTO `sys_menu` VALUES (105, 'listUser', '用户列表', '', 'button', 0, 4, NULL, NULL, NULL, NULL, 'system:user:list', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', NULL, NULL);
INSERT INTO `sys_menu` VALUES (106, 'exportUser', '导出用户', '', 'button', 0, 4, NULL, NULL, NULL, NULL, 'system:user:export', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', NULL, NULL);
INSERT INTO `sys_menu` VALUES (107, 'addMenu', '新增菜单', '', 'button', 0, 6, NULL, NULL, NULL, NULL, 'system:menu:add', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', NULL, NULL);
INSERT INTO `sys_menu` VALUES (108, 'deleteMenu', '删除菜单', '', 'button', 0, 6, NULL, NULL, NULL, NULL, 'system:menu:delete', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', NULL, NULL);
INSERT INTO `sys_menu` VALUES (109, 'updateMenu', '修改菜单', '', 'button', 0, 6, NULL, NULL, NULL, NULL, 'system:menu:update', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', NULL, NULL);
INSERT INTO `sys_menu` VALUES (110, 'queryMenu', '查询菜单', '', 'button', 0, 6, NULL, NULL, NULL, NULL, 'system:menu:query', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', NULL, NULL);
INSERT INTO `sys_menu` VALUES (111, 'listMenu', '菜单列表', '', 'button', 0, 6, NULL, NULL, NULL, NULL, 'system:menu:list', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', NULL, NULL);
INSERT INTO `sys_menu` VALUES (112, 'exportMenu', '导出菜单', '', 'button', 0, 6, NULL, NULL, NULL, NULL, 'system:menu:export', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', NULL, NULL);
INSERT INTO `sys_menu` VALUES (113, 'addDept', '新增部门', '', 'button', 0, 7, NULL, NULL, NULL, NULL, 'system:dept:add', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', NULL, NULL);
INSERT INTO `sys_menu` VALUES (114, 'deleteDept', '删除部门', '', 'button', 0, 7, NULL, NULL, NULL, NULL, 'system:dept:delete', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', NULL, NULL);
INSERT INTO `sys_menu` VALUES (115, 'updateDept', '修改部门', '', 'button', 0, 7, NULL, NULL, NULL, NULL, 'system:dept:update', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', NULL, NULL);
INSERT INTO `sys_menu` VALUES (116, 'queryDept', '查询部门', '', 'button', 0, 7, NULL, NULL, NULL, NULL, 'system:dept:query', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', NULL, NULL);
INSERT INTO `sys_menu` VALUES (117, 'listDept', '部门列表', '', 'button', 0, 7, NULL, NULL, NULL, NULL, 'system:dept:list', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', NULL, NULL);
INSERT INTO `sys_menu` VALUES (118, 'exportDept', '导出部门', '', 'button', 0, 7, NULL, NULL, NULL, NULL, 'system:dept:export', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', NULL, NULL);
INSERT INTO `sys_menu` VALUES (119, 'addPost', '新增岗位', '', 'button', 0, 8, NULL, NULL, NULL, NULL, 'system:post:add', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', NULL, NULL);
INSERT INTO `sys_menu` VALUES (120, 'deletePost', '删除岗位', '', 'button', 0, 8, NULL, NULL, NULL, NULL, 'system:post:delete', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', NULL, NULL);
INSERT INTO `sys_menu` VALUES (121, 'updatePost', '修改岗位', '', 'button', 0, 8, NULL, NULL, NULL, NULL, 'system:post:update', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', NULL, NULL);
INSERT INTO `sys_menu` VALUES (122, 'queryPost', '查询岗位', '', 'button', 0, 8, NULL, NULL, NULL, NULL, 'system:post:query', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', NULL, NULL);
INSERT INTO `sys_menu` VALUES (123, 'listPost', '岗位列表', '', 'button', 0, 8, NULL, NULL, NULL, NULL, 'system:post:list', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', NULL, NULL);
INSERT INTO `sys_menu` VALUES (124, 'exportPost', '导出岗位', '', 'button', 0, 8, NULL, NULL, NULL, NULL, 'system:post:export', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', NULL, NULL);
INSERT INTO `sys_menu` VALUES (125, 'addDictType', '新增字典类型', '', 'button', 0, 9, NULL, NULL, NULL, NULL, 'system:dict-type:add', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (126, 'deleteDictType', '删除字典类型', '', 'button', 0, 9, NULL, NULL, NULL, NULL, 'system:dict-type:delete', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (127, 'updateDictType', '修改字典类型', '', 'button', 0, 9, NULL, NULL, NULL, NULL, 'system:dict-type:update', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (128, 'queryDictType', '查询字典类型', '', 'button', 0, 9, NULL, NULL, NULL, NULL, 'system:dict-type:query', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (129, 'listDictType', '字典类型列表', '', 'button', 0, 9, NULL, NULL, NULL, NULL, 'system:dict-type:list', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (130, 'exportDictType', '导出字典类型', '', 'button', 0, 9, NULL, NULL, NULL, NULL, 'system:dict-type:export', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (131, 'addDictData', '新增字典数据', '', 'button', 0, 10, NULL, NULL, NULL, NULL, 'system:dict-data:add', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (132, 'deleteDictData', '删除字典数据', '', 'button', 0, 10, NULL, NULL, NULL, NULL, 'system:dict-data:delete', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (133, 'updateDictData', '修改字典数据', '', 'button', 0, 10, NULL, NULL, NULL, NULL, 'system:dict-data:update', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (134, 'queryDictData', '查询字典数据', '', 'button', 0, 10, NULL, NULL, NULL, NULL, 'system:dict-data:query', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (135, 'listDictData', '字典数据列表', '', 'button', 0, 10, NULL, NULL, NULL, NULL, 'system:dict-data:list', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (136, 'exportDictData', '导出字典数据', '', 'button', 0, 10, NULL, NULL, NULL, NULL, 'system:dict-data:export', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (137, 'addStorageConfig', '新增配置', '', 'button', 0, 14, NULL, NULL, NULL, NULL, 'system:storage-config:add', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (138, 'deleteStorageConfig', '删除配置', '', 'button', 0, 14, NULL, NULL, NULL, NULL, 'system:storage-config:delete', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (139, 'updateStorageConfig', '修改配置', '', 'button', 0, 14, NULL, NULL, NULL, NULL, 'system:storage-config:update', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (140, 'queryStorageConfig', '查询配置', '', 'button', 0, 14, NULL, NULL, NULL, NULL, 'system:storage-config:query', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (141, 'listStorageConfig', '配置列表', '', 'button', 0, 14, NULL, NULL, NULL, NULL, 'system:storage-config:list', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (142, 'exportStorageConfig', '导出配置', '', 'button', 0, 14, NULL, NULL, NULL, NULL, 'system:storage-config:export', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (143, 'refreshStorageConfig', '刷新配置', '', 'button', 0, 14, NULL, NULL, NULL, NULL, 'system:storage-config:refresh', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (144, 'queryStorageFile', '查询文件', '', 'button', 0, 15, NULL, NULL, NULL, NULL, 'system:storage-file:query', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (145, 'listStorageFile', '文件列表', '', 'button', 0, 15, NULL, NULL, NULL, NULL, 'system:storage-file:list', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (146, 'deleteStorageFile', '删除文件', '', 'button', 0, 15, NULL, NULL, NULL, NULL, 'system:storage-file:delete', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (147, 'exportStorageFile', '导出文件', '', 'button', 0, 15, NULL, NULL, NULL, NULL, 'system:storage-file:export', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (148, 'restoreStorageFile', '恢复文件', '', 'button', 0, 15, NULL, NULL, NULL, NULL, 'system:storage-file:restore', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (149, 'queryLoginLog', '查询登录日志', '', 'button', 0, 16, NULL, NULL, NULL, NULL, 'system:log-login:query', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (150, 'deleteLoginLog', '删除登录日志', '', 'button', 0, 16, NULL, NULL, NULL, NULL, 'system:log-login:delete', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (151, 'exportLoginLog', '导出登录日志', '', 'button', 0, 16, NULL, NULL, NULL, NULL, 'system:log-login:export', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (152, 'queryOperationLog', '查询操作日志', '', 'button', 0, 17, NULL, NULL, NULL, NULL, 'system:log-operation:query', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (153, 'deleteOperationLog', '删除操作日志', '', 'button', 0, 17, NULL, NULL, NULL, NULL, 'system:log-operation:delete', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (154, 'exportOperationLog', '导出操作日志', '', 'button', 0, 17, NULL, NULL, NULL, NULL, 'system:log-operation:export', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (156, 'listDevice', '设备列表', '', 'button', 0, 24, NULL, NULL, NULL, NULL, 'system:online-device:list', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (157, 'exportDevice', '导出设备', '', 'button', 0, 24, NULL, NULL, NULL, NULL, 'system:online-device:export', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (158, 'deleteDevice', '删除设备', '', 'button', 0, 24, NULL, NULL, NULL, NULL, 'system:online-device:delete', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (159, 'querySession', '查询会话', '', 'button', 0, 25, NULL, NULL, NULL, NULL, 'system:online-session:query', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (160, 'listSession', '会话列表', '', 'button', 0, 25, NULL, NULL, NULL, NULL, 'system:online-session:list', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (161, 'exportSession', '导出会话', '', 'button', 0, 25, NULL, NULL, NULL, NULL, 'system:online-session:export', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (162, 'deleteSession', '删除会话', '', 'button', 0, 25, NULL, NULL, NULL, NULL, 'system:online-session:delete', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 08:32:15', '2025-08-07 08:32:15', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (163, 'addRole', '添加角色', '', 'button', 0, 5, NULL, NULL, NULL, NULL, 'system:role:add', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 0, '2025-08-07 08:41:51', '2025-08-07 08:41:51', 'system_init', NULL, NULL);
INSERT INTO `sys_menu` VALUES (164, 'deleteRole', '删除角色', '', 'button', 0, 5, NULL, NULL, NULL, NULL, 'system:role:delete', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 0, '2025-08-07 08:41:51', '2025-08-07 08:41:51', 'system_init', NULL, NULL);
INSERT INTO `sys_menu` VALUES (165, 'updateRole', '修改角色', '', 'button', 0, 5, NULL, NULL, NULL, NULL, 'system:role:update', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 0, '2025-08-07 08:41:51', '2025-08-07 08:41:51', 'system_init', NULL, NULL);
INSERT INTO `sys_menu` VALUES (166, 'listRole', '角色列表', '', 'button', 0, 5, NULL, NULL, NULL, NULL, 'system:role:list', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 0, '2025-08-07 08:41:51', '2025-08-07 08:41:51', 'system_init', NULL, NULL);
INSERT INTO `sys_menu` VALUES (167, 'queryRole', '查询角色', '', 'button', 0, 5, NULL, NULL, NULL, NULL, 'system:role:query', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 0, '2025-08-07 08:41:51', '2025-08-07 08:41:51', 'system_init', NULL, NULL);
INSERT INTO `sys_menu` VALUES (168, 'exportRole', '导出角色', '', 'button', 0, 5, NULL, NULL, NULL, NULL, 'system:role:export', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 0, '2025-08-07 08:41:51', '2025-08-07 08:41:51', 'system_init', NULL, NULL);
INSERT INTO `sys_menu` VALUES (169, 'queryJobLog', '查询任务日志', '', 'button', 0, 23, NULL, NULL, NULL, NULL, 'tool:job-log:query', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 08:41:51', '2025-08-07 08:41:51', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (170, 'listJobLog', '任务日志列表', '', 'button', 0, 23, NULL, NULL, NULL, NULL, 'tool:job-log:list', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 08:41:51', '2025-08-07 08:41:51', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (171, 'exportJobLog', '导出任务日志', '', 'button', 0, 23, NULL, NULL, NULL, NULL, 'tool:job-log:export', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 08:41:51', '2025-08-07 08:41:51', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (172, 'addJob', '新增任务', '', 'button', 0, 22, NULL, NULL, NULL, NULL, 'tool:job:add', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 08:41:51', '2025-08-07 08:41:51', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (173, 'updateJob', '修改任务', '', 'button', 0, 22, NULL, NULL, NULL, NULL, 'tool:job:update', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 08:41:51', '2025-08-07 08:41:51', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (174, 'deleteJob', '删除任务', '', 'button', 0, 22, NULL, NULL, NULL, NULL, 'tool:job:delete', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 08:41:51', '2025-08-07 08:41:51', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (175, 'exportJob', '导出任务', '', 'button', 0, 22, NULL, NULL, NULL, NULL, 'tool:job:export', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 08:41:51', '2025-08-07 08:41:51', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (176, 'listJob', '任务列表', '', 'button', 0, 22, NULL, NULL, NULL, NULL, 'tool:job:list', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 08:41:51', '2025-08-07 08:41:51', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (177, 'batchJob', '批量操作', '', 'button', 0, 22, NULL, NULL, NULL, NULL, 'tool:job:batch', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 08:41:51', '2025-08-07 08:41:51', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (178, 'execJob', '执行任务', '', 'button', 0, 22, NULL, NULL, NULL, NULL, 'tool:job:run', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 08:41:51', '2025-08-07 08:41:51', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (179, 'refreshJob', '刷新任务', '', 'button', 0, 22, NULL, NULL, NULL, NULL, 'tool:job:refresh', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 08:41:51', '2025-08-07 08:41:51', 'system_init', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (181, 'assignPermission', '分配权限', NULL, 'button', 0, 5, NULL, NULL, NULL, NULL, 'system:role:assign', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 0, '2025-08-07 08:50:35', '2025-08-07 08:50:35', 'zhangchuang', NULL, NULL);
INSERT INTO `sys_menu` VALUES (182, 'pauseJob', '暂停任务', '', 'button', 0, 22, NULL, NULL, NULL, NULL, 'tool:job:pause', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 09:32:42', '2025-08-07 09:32:42', 'zhangchuang', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (183, 'resumeJob', '恢复任务', NULL, 'button', 0, 22, NULL, NULL, NULL, NULL, 'tool:job:resume', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 0, '2025-08-07 09:37:57', '2025-08-07 09:37:57', 'zhangchuang', NULL, NULL);
INSERT INTO `sys_menu` VALUES (184, 'startJob', '启动任务', NULL, 'button', 0, 22, NULL, NULL, NULL, NULL, 'tool:job:start', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 0, '2025-08-07 09:46:24', '2025-08-07 09:46:24', 'zhangchuang', NULL, NULL);
INSERT INTO `sys_menu` VALUES (185, 'cleanJobLog', '清空任务日志', '', 'button', 0, 23, NULL, NULL, NULL, NULL, 'tool:job-log:clean', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 09:48:42', '2025-08-07 09:48:42', 'zhangchuang', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (186, 'refreshDict', '刷新字典', '', 'button', 0, 9, NULL, NULL, NULL, NULL, 'system:dict-refresh', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, '', 0, '2025-08-07 09:56:18', '2025-08-07 09:56:18', 'zhangchuang', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (189, 'noticeManage', '系统公告管理', '/system/notice', 'menu', 0, 1, '', '', 'carbon:notification', '/system/notice/index', '', '', '', '', 0, 0, 0, 0, 0, 0, '', 1, '2025-08-08 17:03:58', '2025-08-08 17:03:58', 'zhangchuang', 'demo', NULL);
INSERT INTO `sys_menu` VALUES (191, 'systemMessage', '系统消息', '/system/message', 'catalog', 0, 1, '', '', 'fluent:comment-multiple-16-regular', '', '', '', '', '', 0, 0, 0, 0, 0, 0, '', 0, '2025-08-10 09:37:59', '2025-08-10 09:37:59', 'zhangchuang', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (192, 'systemMessageManage', '消息管理', '/system/message/manage', 'menu', 0, 191, '', '', 'fluent:comment-text-28-regular', '/system/message/manage/index', '', '', '', '', 0, 0, 0, 0, 0, 0, '', 0, '2025-08-10 09:43:25', '2025-08-10 09:43:25', 'zhangchuang', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (193, 'systemMessageSend', '消息发送', '/system/message/send', 'menu', 0, 191, '', '', 'fluent:send-28-regular', '/system/message/send/index', '', '', '', '', 0, 0, 0, 0, 0, 0, '', 0, '2025-08-10 09:45:09', '2025-08-10 09:45:09', 'zhangchuang', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (194, 'ToolWebSocket', 'WebSocket 测试', '/tool/websocket', 'menu', 0, 3, '', '', 'lucide:radio', '/tool/websocket/index', '', '', '', '', 0, 0, 0, 0, 0, 0, '', 1, '2025-08-11 10:54:31', '2025-08-11 10:54:31', 'zhangchuang', 'zhangchuang', NULL);
INSERT INTO `sys_menu` VALUES (195, 'Endpoints', '端点监控', '/monitor/endpoints', 'menu', 0, 2, '', '', 'carbon:ibm-cloud-vpc-endpoints', '/monitor/endpoints/index', '', '', '', '', 0, 0, 0, 0, 0, 0, NULL, 0, '2025-08-12 14:13:45', '2025-08-12 14:13:45', 'zhangchuang', NULL, NULL);
INSERT INTO `sys_menu` VALUES (196, 'MessageSend', '消息发送', NULL, 'button', 0, 193, NULL, NULL, NULL, NULL, 'system:message:send', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 0, '2025-08-14 09:17:49', '2025-08-14 09:17:49', 'zhangchuang', NULL, NULL);
INSERT INTO `sys_menu` VALUES (198, 'MessageList', '消息列表', NULL, 'button', 0, 192, NULL, NULL, NULL, NULL, 'system.message:list', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 0, '2025-08-14 09:19:58', '2025-08-14 09:19:58', 'zhangchuang', NULL, NULL);
INSERT INTO `sys_menu` VALUES (199, 'MessageQuery', '消息查询', NULL, 'button', 0, 192, NULL, NULL, NULL, NULL, 'system.message:query', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 0, '2025-08-14 09:20:34', '2025-08-14 09:20:34', 'zhangchuang', NULL, NULL);
INSERT INTO `sys_menu` VALUES (200, 'MessageUpdate', '消息修改', NULL, 'button', 0, 192, NULL, NULL, NULL, NULL, 'system.message:update', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 0, '2025-08-14 09:20:58', '2025-08-14 09:20:58', 'zhangchuang', NULL, NULL);
INSERT INTO `sys_menu` VALUES (201, 'MessageDelete', '消息删除', NULL, 'button', 0, 192, NULL, NULL, NULL, NULL, 'system.message:delete', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 0, '2025-08-14 09:21:25', '2025-08-14 09:21:25', 'zhangchuang', NULL, NULL);
INSERT INTO `sys_menu` VALUES (202, 'NoticeList', '消息列表', NULL, 'button', 0, 189, NULL, NULL, NULL, NULL, 'system:notice:list', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 0, '2025-08-14 09:35:19', '2025-08-14 09:35:19', 'zhangchuang', NULL, NULL);
INSERT INTO `sys_menu` VALUES (203, 'noticeQuery', '消息查询', NULL, 'button', 0, 189, NULL, NULL, NULL, NULL, 'system:notice:query', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 0, '2025-08-14 09:35:47', '2025-08-14 09:35:47', 'zhangchuang', NULL, NULL);
INSERT INTO `sys_menu` VALUES (204, 'AddNotice', '添加公告', NULL, 'button', 0, 189, NULL, NULL, NULL, NULL, 'system:notice:add', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 0, '2025-08-14 09:36:28', '2025-08-14 09:36:28', 'zhangchuang', NULL, NULL);
INSERT INTO `sys_menu` VALUES (205, 'updateNotice', '修改公告', NULL, 'button', 0, 189, NULL, NULL, NULL, NULL, 'system:notice:update', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 0, '2025-08-14 09:36:58', '2025-08-14 09:36:58', 'zhangchuang', NULL, NULL);
INSERT INTO `sys_menu` VALUES (206, 'DeleteNotice', '删除公告', NULL, 'button', 0, 189, NULL, NULL, NULL, NULL, 'system:notice:delete', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 0, '2025-08-14 09:37:59', '2025-08-14 09:37:59', 'zhangchuang', NULL, NULL);
INSERT INTO `sys_menu` VALUES (207, 'ExportNotice', '导出公告', NULL, 'button', 0, 189, NULL, NULL, NULL, NULL, 'system:notice:export', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 0, '2025-08-14 09:38:31', '2025-08-14 09:38:31', 'zhangchuang', NULL, NULL);
INSERT INTO `sys_menu` VALUES (208, 'EndpointsList', '端点列表', NULL, 'button', 0, 195, NULL, NULL, NULL, NULL, 'monitor:endpoints:list', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 0, '2025-08-14 09:40:08', '2025-08-14 09:40:08', 'zhangchuang', NULL, NULL);
INSERT INTO `sys_menu` VALUES (209, 'MonitorMetrics', '监控查询', NULL, 'button', 0, 18, NULL, NULL, NULL, NULL, 'monitor:metrics:query', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 0, '2025-08-14 09:42:00', '2025-08-14 09:42:00', 'zhangchuang', NULL, NULL);
INSERT INTO `sys_menu` VALUES (210, 'MessageExport', '消息导出', NULL, 'button', 0, 192, NULL, NULL, NULL, NULL, 'system:message:export', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 0, '2025-08-14 09:54:43', '2025-08-14 09:54:43', 'zhangchuang', NULL, NULL);
INSERT INTO `sys_menu` VALUES (211, 'PersonaCenter', '个人中心', '/personal', 'catalog', 0, 0, '', '', 'fluent:home-empty-28-regular', '', '', '', '', '', 0, 0, 0, 0, 0, 0, NULL, 1, '2025-08-16 13:51:01', '2025-08-16 13:51:01', 'admin', 'admin', NULL);
INSERT INTO `sys_menu` VALUES (212, 'Profile', '个人资料', '/personal/profile', 'menu', 0, 211, '', '', 'fluent:slide-text-person-24-regular', '/personal/profile/index', '', '', '', '', 0, 0, 0, 0, 0, 0, NULL, 0, '2025-08-16 13:53:15', '2025-08-16 13:53:15', 'admin', NULL, NULL);
INSERT INTO `sys_menu` VALUES (213, 'MyMessage', '我的消息', '/personal/message', 'menu', 0, 211, '', '', 'fluent:comment-24-regular', '/personal/message/index', '', '', '', '', 0, 0, 0, 0, 0, 0, NULL, 0, '2025-08-16 13:56:37', '2025-08-16 13:56:37', 'admin', 'admin', NULL);
INSERT INTO `sys_menu` VALUES (214, 'updateProfile', '修改资料', NULL, 'button', 0, 212, NULL, NULL, NULL, NULL, 'personal:profile:updatee', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 0, '2025-08-16 14:08:40', '2025-08-16 14:08:40', 'admin', NULL, NULL);
INSERT INTO `sys_menu` VALUES (215, 'UpdatePassword', '修改密码', NULL, 'button', 0, 212, NULL, NULL, NULL, NULL, 'personal:profile:password', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 0, '2025-08-16 14:09:15', '2025-08-16 14:09:15', 'admin', NULL, NULL);
INSERT INTO `sys_menu` VALUES (216, 'ResetUserPassword', '重置密码', NULL, 'button', 0, 4, NULL, NULL, NULL, NULL, 'system:user:resetPassword', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 0, '2025-08-16 14:42:16', '2025-08-16 14:42:16', 'admin', NULL, NULL);
INSERT INTO `sys_menu` VALUES (217, 'PersonalMessageDetail', '消息详情', '/personal/message/detail', 'menu', 0, 211, '/personal/message', 'fluent:comment-28-filled', 'fluent:comment-28-filled', '/personal/message/detail', '', '', '', '', 0, 0, 1, 0, 0, 0, NULL, 0, '2025-08-16 15:40:58', '2025-08-16 15:40:58', 'admin', NULL, NULL);
INSERT INTO `sys_menu` VALUES (218, 'listOperationLog', '列表操作日志', '', 'button', 0, 17, NULL, NULL, NULL, NULL, 'system:log-operation:list', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 0, '2025-12-10 21:04:26', '2025-12-10 21:04:26', 'system_init', NULL, NULL);
INSERT INTO `sys_menu` VALUES (219, 'QcOperationLog', 'QC操作记录', '/system/log/qc', 'menu', 1, 12, '', 'carbon:align-box-bottom-center', 'carbon:align-box-bottom-center', '/system/log/qc-operation/index', '', '', '', '', 0, 0, 1, 0, 0, 0, NULL, 3, '2025-12-11 10:29:29', '2025-12-11 10:29:29', 'admin', 'demo', NULL);
INSERT INTO `sys_menu` VALUES (220, 'RepairOperationLog', '修复操作记录', '/system/log/repair', 'menu', 1, 12, '', 'carbon:group-objects', 'carbon:group-objects', '/system/log/repair-operation/index', '', '', '', '', 0, 0, 1, 0, 0, 0, NULL, 4, '2025-12-11 10:29:29', '2025-12-11 10:29:29', 'admin', 'demo', NULL);
INSERT INTO `sys_menu` VALUES (233, 'queryDataOverview', '查询', '', 'button', 0, 222, NULL, NULL, NULL, NULL, 'ocean:overview:query', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 1, '2025-12-11 14:09:51', '2025-12-11 14:09:51', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (234, 'addDataOverview', '新增', '', 'button', 0, 222, NULL, NULL, NULL, NULL, 'ocean:overview:add', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 2, '2025-12-11 14:09:51', '2025-12-11 14:09:51', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (235, 'updateDataOverview', '修改', '', 'button', 0, 222, NULL, NULL, NULL, NULL, 'ocean:overview:edit', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 3, '2025-12-11 14:09:51', '2025-12-11 14:09:51', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (236, 'deleteDataOverview', '删除', '', 'button', 0, 222, NULL, NULL, NULL, NULL, 'ocean:overview:delete', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 4, '2025-12-11 14:09:51', '2025-12-11 14:09:51', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (241, 'OceanDataQuery', '数据查询', NULL, 'button', 0, 238, NULL, NULL, NULL, NULL, 'ocean:data:query', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 10, '2025-12-15 21:41:16', '2025-12-15 21:41:16', NULL, 'demo', NULL);
INSERT INTO `sys_menu` VALUES (242, 'OceanDataUpdate', '数据修改', NULL, 'button', 0, 238, NULL, NULL, NULL, NULL, 'ocean:data:update', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 11, '2025-12-15 21:41:16', '2025-12-15 21:41:16', NULL, 'demo', NULL);
INSERT INTO `sys_menu` VALUES (243, 'OceanDataExport', '数据导出', NULL, 'button', 0, 238, NULL, NULL, NULL, NULL, 'ocean:data:export', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 12, '2025-12-15 21:41:16', '2025-12-15 21:41:16', NULL, 'demo', NULL);
INSERT INTO `sys_menu` VALUES (246, 'OceanRepairQuery', '队列查询', NULL, 'button', 1, 244, NULL, NULL, NULL, NULL, 'ocean:repair:query', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 10, '2025-12-15 21:41:16', '2025-12-15 21:41:16', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (247, 'OceanRepairAdd', '添加到队列', NULL, 'button', 1, 244, NULL, NULL, NULL, NULL, 'ocean:repair:add', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 11, '2025-12-15 21:41:16', '2025-12-15 21:41:16', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (248, 'OceanRepairUpdate', '更新状态', NULL, 'button', 1, 244, NULL, NULL, NULL, NULL, 'ocean:repair:update', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 12, '2025-12-15 21:41:16', '2025-12-15 21:41:16', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (249, 'OceanRepairDelete', '移除队列', NULL, 'button', 1, 244, NULL, NULL, NULL, NULL, 'ocean:repair:delete', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 13, '2025-12-15 21:41:16', '2025-12-15 21:41:16', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (250, 'OceanRepairAssign', '分配用户', NULL, 'button', 1, 244, NULL, NULL, NULL, NULL, 'ocean:repair:assign', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 14, '2025-12-15 21:41:16', '2025-12-15 21:41:16', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (254, 'OceanQcQuery', 'QC查询', NULL, 'button', 0, 251, NULL, NULL, NULL, NULL, 'ocean:qc:query', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 10, '2025-12-15 21:41:16', '2025-12-15 21:41:16', NULL, 'demo', NULL);
INSERT INTO `sys_menu` VALUES (255, 'OceanQcExecute', '执行QC', NULL, 'button', 0, 251, NULL, NULL, NULL, NULL, 'ocean:qc:execute', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 11, '2025-12-15 21:41:16', '2025-12-15 21:41:16', NULL, 'demo', NULL);
INSERT INTO `sys_menu` VALUES (256, 'OceanQcConfirm', '确认异常', NULL, 'button', 0, 251, NULL, NULL, NULL, NULL, 'ocean:qc:confirm', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 12, '2025-12-15 21:41:16', '2025-12-15 21:41:16', NULL, 'demo', NULL);
INSERT INTO `sys_menu` VALUES (257, 'OceanQcReject', '否决异常', NULL, 'button', 0, 251, NULL, NULL, NULL, NULL, 'ocean:qc:reject', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 13, '2025-12-15 21:41:16', '2025-12-15 21:41:16', NULL, 'demo', NULL);
INSERT INTO `sys_menu` VALUES (261, 'OceanFileQuery', '文件查询', NULL, 'button', 0, 258, NULL, NULL, NULL, NULL, 'ocean:file:query', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 10, '2025-12-15 21:41:16', '2025-12-15 21:41:16', NULL, 'demo', NULL);
INSERT INTO `sys_menu` VALUES (262, 'OceanFileUpload', '文件上传', NULL, 'button', 0, 258, NULL, NULL, NULL, NULL, 'ocean:file:upload', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 11, '2025-12-15 21:41:16', '2025-12-15 21:41:16', NULL, 'demo', NULL);
INSERT INTO `sys_menu` VALUES (263, 'OceanTemplateAdd', '创建模板', NULL, 'button', 0, 258, NULL, NULL, NULL, NULL, 'ocean:template:add', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 12, '2025-12-15 21:41:16', '2025-12-15 21:41:16', NULL, 'demo', NULL);
INSERT INTO `sys_menu` VALUES (264, 'OceanTemplateUpdate', '更新模板', NULL, 'button', 0, 258, NULL, NULL, NULL, NULL, 'ocean:template:update', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 13, '2025-12-15 21:41:16', '2025-12-15 21:41:16', NULL, 'demo', NULL);
INSERT INTO `sys_menu` VALUES (265, 'OceanTemplateDelete', '删除模板', NULL, 'button', 0, 258, NULL, NULL, NULL, NULL, 'ocean:template:delete', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 14, '2025-12-15 21:41:16', '2025-12-15 21:41:16', NULL, 'demo', NULL);
INSERT INTO `sys_menu` VALUES (272, 'OceanAdminQuery', '后台查询', NULL, 'button', 1, 269, NULL, NULL, NULL, NULL, 'ocean:admin:query', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 10, '2025-12-15 21:41:16', '2025-12-15 21:41:16', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (273, 'OceanAdminAudit', '数据审核', NULL, 'button', 1, 269, NULL, NULL, NULL, NULL, 'ocean:admin:audit', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 11, '2025-12-15 21:41:16', '2025-12-15 21:41:16', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (275, 'OceanRepairQueueList', '修复队列列表', NULL, 'button', 0, 226, NULL, NULL, NULL, NULL, 'ocean:repair:queue:list', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 1, '2025-12-17 21:32:05', '2025-12-17 21:32:05', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (276, 'OceanRepairQueueQuery', '修复队列查询', NULL, 'button', 0, 226, NULL, NULL, NULL, NULL, 'ocean:repair:queue:query', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 2, '2025-12-17 21:32:05', '2025-12-17 21:32:05', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (277, 'OceanRepairQueueAdd', '添加修复队列', NULL, 'button', 0, 226, NULL, NULL, NULL, NULL, 'ocean:repair:queue:add', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 3, '2025-12-17 21:32:05', '2025-12-17 21:32:05', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (278, 'OceanRepairQueueUpdate', '更新修复队列', NULL, 'button', 0, 226, NULL, NULL, NULL, NULL, 'ocean:repair:queue:update', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 4, '2025-12-17 21:32:05', '2025-12-17 21:32:05', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (279, 'OceanRepairQueueDelete', '删除修复队列', NULL, 'button', 0, 226, NULL, NULL, NULL, NULL, 'ocean:repair:queue:delete', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 5, '2025-12-17 21:32:05', '2025-12-17 21:32:05', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (280, 'OceanRepairExecute', '执行修复', NULL, 'button', 0, 226, NULL, NULL, NULL, NULL, 'ocean:repair:execute', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 6, '2025-12-17 21:32:05', '2025-12-17 21:32:05', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (281, 'LostFound', '失物招领', '/lostfound', 'menu', 0, 0, '', '', 'lucide:search', 'BasicLayout', '', '', '', '', 0, 0, 1, 0, 0, 0, NULL, 11, '2025-12-27 23:46:09', '2025-12-27 23:46:09', NULL, 'demo', NULL);
INSERT INTO `sys_menu` VALUES (282, 'LostFoundHome', '首页', '/lostfound/home', 'menu', 0, 0, '', '', 'lucide:home', '/lostfound/home/index', '', '', '', '', 0, 0, 0, 0, 0, 0, NULL, 11, '2025-12-27 23:46:09', '2025-12-27 23:46:09', NULL, 'demo', NULL);
INSERT INTO `sys_menu` VALUES (283, 'LostFoundSearch', '搜索', '/lostfound/search', 'menu', 0, 0, '', '', 'lucide:search', '/lostfound/search/index', '', '', '', '', 0, 0, 0, 0, 0, 0, NULL, 11, '2025-12-27 23:46:09', '2025-12-27 23:46:09', NULL, 'demo', NULL);
INSERT INTO `sys_menu` VALUES (284, 'LostFoundPublishLost', '发布寻物', '/lostfound/publish/lost', 'menu', 0, 0, '', '', 'lucide:file-plus', '/lostfound/publish/lost', '', '', '', '', 0, 0, 0, 0, 0, 0, NULL, 10, '2025-12-27 23:46:09', '2025-12-27 23:46:09', NULL, 'demo', NULL);
INSERT INTO `sys_menu` VALUES (285, 'LostFoundPublishFound', '发布招领', '/lostfound/publish/found', 'menu', 0, 0, '', '', 'lucide:file-check', '/lostfound/publish/found', '', '', '', '', 0, 0, 0, 0, 0, 0, NULL, 9, '2025-12-27 23:46:09', '2025-12-27 23:46:09', NULL, 'demo', NULL);
INSERT INTO `sys_menu` VALUES (286, 'LostFoundMessages', '消息中心', '/lostfound/messages', 'menu', 0, 0, '', '', 'lucide:message-circle', '/lostfound/messages/index', '', '', '', '', 0, 0, 0, 0, 0, 0, NULL, 8, '2025-12-27 23:46:09', '2025-12-27 23:46:09', NULL, 'demo', NULL);
INSERT INTO `sys_menu` VALUES (287, 'LostFoundMyPosts', '我的发布', '/lostfound/me/posts', 'menu', 0, 0, '', '', 'lucide:file-text', '/lostfound/me/posts', '', '', '', '', 0, 0, 0, 0, 0, 0, NULL, 7, '2025-12-27 23:46:09', '2025-12-27 23:46:09', NULL, 'demo', NULL);
INSERT INTO `sys_menu` VALUES (288, 'LostFoundMyFavorites', '我的收藏', '/lostfound/me/favorites', 'menu', 0, 0, '', '', 'lucide:heart', '/lostfound/me/favorites', '', '', '', '', 0, 0, 0, 0, 0, 0, NULL, 5, '2025-12-27 23:46:09', '2025-12-27 23:46:09', NULL, 'demo', NULL);
INSERT INTO `sys_menu` VALUES (289, 'LostFoundMyClaims', '我的认领', '/lostfound/me/claims', 'menu', 0, 0, '', '', 'lucide:hand', '/lostfound/me/claims', '', '', '', '', 0, 0, 0, 0, 0, 0, NULL, 4, '2025-12-27 23:46:09', '2025-12-27 23:46:09', NULL, 'demo', NULL);
INSERT INTO `sys_menu` VALUES (290, 'LostFoundMyPoints', '我的积分', '/lostfound/me/points', 'menu', 0, 0, '', '', 'lucide:coins', '/lostfound/me/points', '', '', '', '', 0, 0, 0, 0, 0, 0, NULL, 3, '2025-12-27 23:46:09', '2025-12-27 23:46:09', NULL, 'demo', NULL);
INSERT INTO `sys_menu` VALUES (291, 'LostFoundNotifications', '通知中心', '/lostfound/notifications', 'menu', 0, 0, '', '', 'lucide:bell', '/lostfound/notifications/index', '', '', '', '', 0, 0, 0, 0, 0, 0, NULL, 2, '2025-12-27 23:46:09', '2025-12-27 23:46:09', NULL, 'demo', NULL);
INSERT INTO `sys_menu` VALUES (292, 'LostFoundPostDetail', '帖子详情', '/lostfound/posts/:id', 'menu', 0, 281, '', '', '', '/lostfound/posts/detail', '', '', '', '', 0, 0, 1, 0, 0, 0, NULL, 11, '2025-12-27 23:46:09', '2025-12-27 23:46:09', NULL, 'demo', NULL);
INSERT INTO `sys_menu` VALUES (293, 'LostFoundClaimCreate', '发起认领', '/lostfound/claims/create', 'menu', 0, 281, '', '', '', '/lostfound/claims/create', '', '', '', '', 0, 0, 1, 0, 0, 0, NULL, 12, '2025-12-27 23:46:09', '2025-12-27 23:46:09', NULL, 'demo', NULL);
INSERT INTO `sys_menu` VALUES (294, 'LostFoundClaimDetail', '认领详情', '/lostfound/claims/:id', 'menu', 0, 281, '', '', '', '/lostfound/claims/detail', '', '', '', '', 0, 0, 1, 0, 0, 0, NULL, 13, '2025-12-27 23:46:09', '2025-12-27 23:46:09', NULL, 'demo', NULL);
INSERT INTO `sys_menu` VALUES (295, 'LostFoundChat', '聊天', '/lostfound/messages/:threadId', 'menu', 0, 281, '', '', '', '/lostfound/messages/chat', '', '', '', '', 0, 0, 1, 0, 0, 0, NULL, 14, '2025-12-27 23:46:09', '2025-12-27 23:46:09', NULL, 'demo', NULL);
INSERT INTO `sys_menu` VALUES (296, 'LostFoundAdmin', '失物招领管理', '/lostfound/admin', 'menu', 0, 0, '', '', 'lucide:settings', 'BasicLayout', '', '', '', '', 0, 0, 1, 0, 0, 0, NULL, 21, '2025-12-27 23:46:09', '2025-12-27 23:46:09', NULL, 'demo', NULL);
INSERT INTO `sys_menu` VALUES (297, 'LostFoundDashboard', '数据概览', '/lostfound/admin/dashboard', 'menu', 0, 0, '', '', 'lucide:layout-dashboard', '/lostfound/admin/dashboard/index', 'lostfound:dashboard:view', '', '', '', 0, 0, 1, 0, 0, 0, NULL, 1, '2025-12-27 23:46:10', '2025-12-27 23:46:10', NULL, 'demo', NULL);
INSERT INTO `sys_menu` VALUES (298, 'LostFoundPostAudit', '帖子审核', '/lostfound/admin/posts', 'menu', 0, 0, '', '', 'lucide:file-check-2', '/lostfound/admin/posts/index', 'lostfound:post:audit', '', '', '', 0, 0, 0, 0, 0, 0, NULL, 2, '2025-12-27 23:46:10', '2025-12-27 23:46:10', NULL, 'demo', NULL);
INSERT INTO `sys_menu` VALUES (299, 'LostFoundClaimAudit', '认领管理', '/lostfound/admin/claims', 'menu', 0, 0, '', '', 'lucide:hand-helping', '/lostfound/admin/claims/index', 'lostfound:claim:audit', '', '', '', 0, 0, 0, 0, 0, 0, NULL, 3, '2025-12-27 23:46:10', '2025-12-27 23:46:10', NULL, 'demo', NULL);
INSERT INTO `sys_menu` VALUES (300, 'LostFoundCommentAudit', '评论管理', '/lostfound/admin/comments', 'menu', 0, 0, '', '', 'lucide:message-square', '/lostfound/admin/comments/index', 'lostfound:comment:audit', '', '', '', 0, 0, 0, 0, 0, 0, NULL, 4, '2025-12-27 23:46:10', '2025-12-27 23:46:10', NULL, 'demo', NULL);
INSERT INTO `sys_menu` VALUES (301, 'LostFoundReportAudit', '举报处理', '/lostfound/admin/reports', 'menu', 0, 0, '', '', 'lucide:flag', '/lostfound/admin/reports/index', 'lostfound:report:audit', '', '', '', 0, 0, 0, 0, 0, 0, NULL, 5, '2025-12-27 23:46:10', '2025-12-27 23:46:10', NULL, 'demo', NULL);
INSERT INTO `sys_menu` VALUES (302, 'LostFoundCategory', '分类管理', '/lostfound/admin/categories', 'menu', 0, 0, '', '', 'lucide:folder-tree', '/lostfound/admin/categories/index', 'lostfound:category:list', '', '', '', 0, 0, 0, 0, 0, 0, NULL, 7, '2025-12-27 23:46:10', '2025-12-27 23:46:10', NULL, 'demo', NULL);
INSERT INTO `sys_menu` VALUES (303, 'LostFoundLocation', '地点管理', '/lostfound/admin/locations', 'menu', 0, 0, '', '', 'lucide:map-pin', '/lostfound/admin/locations/index', 'lostfound:location:list', '', '', '', 0, 0, 0, 0, 0, 0, NULL, 8, '2025-12-27 23:46:10', '2025-12-27 23:46:10', NULL, 'demo', NULL);
INSERT INTO `sys_menu` VALUES (304, 'LostFoundStats', '统计报表', '/lostfound/admin/stats', 'menu', 0, 0, '', '', 'lucide:bar-chart-3', '/lostfound/admin/stats/index', 'lostfound:stats:view', '', '', '', 0, 0, 0, 0, 0, 0, NULL, 9, '2025-12-27 23:46:10', '2025-12-27 23:46:10', NULL, 'demo', NULL);
INSERT INTO `sys_menu` VALUES (305, 'LostFoundPointsAdmin', '积分管理', '/lostfound/admin/points', 'menu', 0, 0, NULL, NULL, 'lucide:coins', '/lostfound/admin/points/index', NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, 0, NULL, 9, '2025-12-28 01:21:16', '2025-12-28 01:21:16', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (306, 'LostFoundLocationAdd', '新增地点', '', 'button', 0, 303, NULL, NULL, NULL, NULL, 'lostfound:location:add', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 1, '2025-12-28 01:27:46', '2025-12-28 01:27:46', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (307, 'LostFoundLocationEdit', '编辑地点', '', 'button', 0, 303, NULL, NULL, NULL, NULL, 'lostfound:location:edit', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 2, '2025-12-28 01:27:46', '2025-12-28 01:27:46', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (308, 'LostFoundLocationDelete', '删除地点', '', 'button', 0, 303, NULL, NULL, NULL, NULL, 'lostfound:location:delete', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 3, '2025-12-28 01:27:46', '2025-12-28 01:27:46', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (309, 'LostFoundCategoryAdd', '新增分类', '', 'button', 0, 302, NULL, NULL, NULL, NULL, 'lostfound:category:add', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 1, '2025-12-28 01:28:38', '2025-12-28 01:28:38', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (310, 'LostFoundCategoryEdit', '编辑分类', '', 'button', 0, 302, NULL, NULL, NULL, NULL, 'lostfound:category:edit', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 2, '2025-12-28 01:28:38', '2025-12-28 01:28:38', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (311, 'LostFoundCategoryDelete', '删除分类', '', 'button', 0, 302, NULL, NULL, NULL, NULL, 'lostfound:category:delete', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 3, '2025-12-28 01:28:38', '2025-12-28 01:28:38', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (312, 'LostFoundPostAuditBtn', '帖子审核', '', 'button', 0, 298, NULL, NULL, NULL, NULL, 'lostfound:post:audit', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 1, '2025-12-28 01:28:38', '2025-12-28 01:28:38', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (313, 'LostFoundReportList', '举报列表', '', 'button', 0, 301, NULL, NULL, NULL, NULL, 'lostfound:report:list', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 1, '2025-12-28 01:28:38', '2025-12-28 01:28:38', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (314, 'LostFoundReportHandle', '处理举报', '', 'button', 0, 301, NULL, NULL, NULL, NULL, 'lostfound:report:handle', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 2, '2025-12-28 01:28:38', '2025-12-28 01:28:38', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (315, 'LostFoundCommentAuditBtn', '评论审核', '', 'button', 0, 300, NULL, NULL, NULL, NULL, 'lostfound:comment:audit', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 1, '2025-12-28 01:28:38', '2025-12-28 01:28:38', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (316, 'LostFoundReportList', '举报列表', NULL, 'button', 1, 301, NULL, NULL, NULL, NULL, 'lostfound:report:list', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 1, '2025-12-28 12:21:30', '2025-12-28 12:21:30', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (317, 'LostFoundReportHandle', '处理举报', NULL, 'button', 1, 301, NULL, NULL, NULL, NULL, 'lostfound:report:handle', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 2, '2025-12-28 12:21:46', '2025-12-28 12:21:46', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (318, 'LostFoundCategoryAdd', '新增分类', NULL, 'button', 1, 302, NULL, NULL, NULL, NULL, 'lostfound:category:add', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 1, '2025-12-28 12:22:11', '2025-12-28 12:22:11', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (319, 'LostFoundCategoryEdit', '编辑分类', NULL, 'button', 1, 302, NULL, NULL, NULL, NULL, 'lostfound:category:edit', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 2, '2025-12-28 12:22:27', '2025-12-28 12:22:27', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (320, 'LostFoundCategoryDelete', '删除分类', NULL, 'button', 1, 302, NULL, NULL, NULL, NULL, 'lostfound:category:delete', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 3, '2025-12-28 12:22:42', '2025-12-28 12:22:42', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (321, 'LostFoundLocationAdd', '新增地点', NULL, 'button', 1, 303, NULL, NULL, NULL, NULL, 'lostfound:location:add', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 1, '2025-12-28 12:22:58', '2025-12-28 12:22:58', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (322, 'LostFoundLocationEdit', '编辑地点', NULL, 'button', 1, 303, NULL, NULL, NULL, NULL, 'lostfound:location:edit', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 2, '2025-12-28 12:23:13', '2025-12-28 12:23:13', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (323, 'LostFoundLocationDelete', '删除地点', NULL, 'button', 1, 303, NULL, NULL, NULL, NULL, 'lostfound:location:delete', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 3, '2025-12-28 12:23:29', '2025-12-28 12:23:29', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (324, 'LostFoundStatsView', '查看统计', NULL, 'button', 1, 304, NULL, NULL, NULL, NULL, 'lostfound:statistics:view', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 1, '2025-12-28 12:23:44', '2025-12-28 12:23:44', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (325, 'Workspace', '工作台', '/workspace', 'menu', 0, 0, '', '', 'carbon:workspace', '/dashboard/workspace/index', '', '', '', '', 0, 0, 0, 0, 0, 0, NULL, 100, '2025-12-30 12:51:39', '2025-12-30 12:51:39', NULL, 'demo', NULL);
INSERT INTO `sys_menu` VALUES (326, 'LostFoundCommentList', '评论列表', '', 'button', 0, 300, NULL, NULL, NULL, NULL, 'lostfound:comment:list', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 1, '2025-12-30 13:26:55', '2025-12-30 13:26:55', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (327, 'LostFoundClaimList', '认领列表', '', 'button', 0, 299, NULL, NULL, NULL, NULL, 'lostfound:claim:list', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 1, '2025-12-30 13:26:55', '2025-12-30 13:26:55', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (328, 'LostFoundPostList', '帖子列表', '', 'button', 0, 298, NULL, NULL, NULL, NULL, 'lostfound:post:list', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 1, '2025-12-30 13:26:55', '2025-12-30 13:26:55', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (329, 'LostFoundCommentDelete', '删除评论', '', 'button', 0, 300, NULL, NULL, NULL, NULL, 'lostfound:comment:delete', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 2, '2025-12-30 13:28:38', '2025-12-30 13:28:38', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (330, 'LostFoundClaimComplete', '完成认领', '', 'button', 0, 299, NULL, NULL, NULL, NULL, 'lostfound:claim:complete', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 2, '2025-12-30 13:28:38', '2025-12-30 13:28:38', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (331, 'adjustPoints', '调整积分', NULL, 'button', 0, 305, NULL, NULL, NULL, NULL, 'lostfound:points:adjust', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 1, '2025-12-30 14:09:36', '2025-12-30 14:09:36', 'demo', NULL, NULL);
INSERT INTO `sys_menu` VALUES (341, 'GiftMall', '礼品商城', '/lostfound/gifts', 'menu', 0, 0, '', '', 'lucide:gift', '/lostfound/gifts/index', '', '', '', '', 0, 0, 0, 0, 0, 0, NULL, 1, '2025-12-30 17:38:50', '2025-12-30 17:38:50', NULL, 'demo', NULL);
INSERT INTO `sys_menu` VALUES (342, 'MyExchange', '我的兑换', '/lostfound/me/exchange', 'menu', 0, 211, '', '', 'carbon:gradient', '/lostfound/me/exchange', '', '', '', '', 0, 0, 0, 0, 0, 0, NULL, 30, '2025-12-30 17:38:50', '2025-12-30 17:38:50', NULL, 'demo', NULL);
INSERT INTO `sys_menu` VALUES (343, 'GiftManage', '礼品管理', '/lostfound/admin/gifts', 'menu', 0, 0, '', '', 'carbon:global-filters', '/lostfound/admin/gifts/index', '', '', '', '', 0, 0, 0, 0, 0, 0, NULL, 61, '2025-12-30 17:38:50', '2025-12-30 17:38:50', NULL, 'demo', NULL);
INSERT INTO `sys_menu` VALUES (344, 'GiftCategory', '礼品分类管理', '/lostfound/admin/gifts/categories', 'menu', 0, 0, '', 'carbon:apps', 'carbon:align-box-middle-left', '/lostfound/admin/gifts/categories', '', '', '', '', 0, 0, 0, 0, 0, 0, NULL, 1, '2025-12-30 17:38:50', '2025-12-30 17:38:50', NULL, 'demo', NULL);
INSERT INTO `sys_menu` VALUES (345, 'GiftList', '礼品列表', '', 'button', 0, 343, NULL, NULL, NULL, '', 'lostfound:gift:list', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 2, '2025-12-30 17:38:50', '2025-12-30 17:38:50', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (346, 'GiftAdd', '新增礼品', '', 'button', 0, 343, NULL, NULL, NULL, '', 'lostfound:gift:add', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 3, '2025-12-30 17:38:50', '2025-12-30 17:38:50', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (347, 'GiftEdit', '编辑礼品', '', 'button', 0, 343, NULL, NULL, NULL, '', 'lostfound:gift:edit', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 4, '2025-12-30 17:38:50', '2025-12-30 17:38:50', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (348, 'GiftDelete', '删除礼品', '', 'button', 0, 343, NULL, NULL, NULL, '', 'lostfound:gift:delete', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 5, '2025-12-30 17:38:50', '2025-12-30 17:38:50', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (349, 'ExchangeManage', '兑换订单', '/lostfound/admin/exchange', 'menu', 0, 0, '', '', 'carbon:blog', '/lostfound/admin/exchange/index', '', '', '', '', 0, 0, 0, 0, 0, 0, NULL, 71, '2025-12-30 17:38:50', '2025-12-30 17:38:50', NULL, 'demo', NULL);
INSERT INTO `sys_menu` VALUES (350, 'ExchangeList', '订单列表', '', 'button', 0, 349, NULL, NULL, NULL, '', 'lostfound:exchange:list', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 1, '2025-12-30 17:38:50', '2025-12-30 17:38:50', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (351, 'ExchangeShip', '订单发货', '', 'button', 0, 349, NULL, NULL, NULL, '', 'lostfound:exchange:ship', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 2, '2025-12-30 17:38:50', '2025-12-30 17:38:50', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (352, 'ExchangeCancel', '取消订单', '', 'button', 0, 349, NULL, NULL, NULL, '', 'lostfound:exchange:cancel', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 3, '2025-12-30 17:38:50', '2025-12-30 17:38:50', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (360, 'MyVerification', '身份认证', '/lostfound/me/verification', 'menu', 0, 211, NULL, NULL, 'lucide:shield-check', '/lostfound/me/verification', NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 10, '2025-12-31 09:53:39', '2025-12-31 09:53:39', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (361, 'VerificationManage', '认证管理', '/lostfound/admin/verification', 'menu', 0, 0, NULL, NULL, 'lucide:user-check', '', NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 81, '2025-12-31 09:53:39', '2025-12-31 09:53:39', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (362, 'StudentRoster', '学生名单', '/lostfound/admin/verification/roster', 'menu', 0, 361, NULL, NULL, 'lucide:users', '/lostfound/admin/verification/roster', NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 1, '2025-12-31 09:53:39', '2025-12-31 09:53:39', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (363, 'VerificationRecords', '认证记录', '/lostfound/admin/verification/records', 'menu', 0, 361, NULL, NULL, 'lucide:file-check', '/lostfound/admin/verification/records', NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 2, '2025-12-31 09:53:39', '2025-12-31 09:53:39', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (364, 'VerificationList', '认证列表', '', 'button', 0, 361, NULL, NULL, NULL, '', 'lostfound:verification:list', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 3, '2025-12-31 09:53:39', '2025-12-31 09:53:39', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (365, 'VerificationRevoke', '撤销认证', '', 'button', 0, 361, NULL, NULL, NULL, '', 'lostfound:verification:revoke', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 4, '2025-12-31 09:53:39', '2025-12-31 09:53:39', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (366, 'RosterImport', '导入名单', '', 'button', 0, 361, NULL, NULL, NULL, '', 'lostfound:verification:import', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 5, '2025-12-31 09:53:39', '2025-12-31 09:53:39', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (370, 'LostFoundAnnouncement', '公告管理', '/lostfound/admin/announcement', 'menu', 0, 296, NULL, NULL, 'lucide:megaphone', '/lostfound/admin/announcement/index', NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 10, '2026-01-06 11:21:17', '2026-01-06 11:21:17', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (371, 'LostFoundGiftDetail', '礼品详情', '/lostfound/gifts/:id', 'menu', 0, 0, NULL, NULL, NULL, '/lostfound/gifts/detail', NULL, NULL, NULL, NULL, 0, 0, 1, 0, 0, 0, NULL, 0, '2026-01-22 20:45:58', '2026-01-22 20:45:58', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (372, 'LostFoundRiskAlerts', '风险告警', '/lostfound/admin/risk-alerts', 'menu', 0, 0, NULL, NULL, 'lucide:alert-triangle', '/lostfound/admin/risk-alerts/index', 'system:security-log:list', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, 6, '2026-01-22 21:54:25', '2026-01-22 21:54:25', 'demo', NULL, NULL);

-- ----------------------------
-- Table structure for sys_message
-- ----------------------------
DROP TABLE IF EXISTS `sys_message`;
CREATE TABLE `sys_message`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '消息ID',
  `title` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '消息标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '消息内容',
  `type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '消息类型',
  `level` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '消息级别',
  `sender_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '发送者姓名',
  `target_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '目标类型',
  `publish_time` datetime NULL DEFAULT NULL COMMENT '发布时间',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否删除：0-未删除 1-已删除',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '创建人',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_type`(`type` ASC) USING BTREE,
  INDEX `idx_level`(`level` ASC) USING BTREE,
  INDEX `idx_target_type`(`target_type` ASC) USING BTREE,
  INDEX `idx_publish_time`(`publish_time` ASC) USING BTREE,
  INDEX `idx_create_time`(`create_time` ASC) USING BTREE,
  INDEX `idx_is_deleted`(`is_deleted` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '系统消息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_message
-- ----------------------------
INSERT INTO `sys_message` VALUES (1, '11', '<p>111</p>', 'system', 'normal', 'admin', 'all', '2025-08-16 15:41:13', 0, '2025-08-16 15:41:13', '2025-08-16 15:41:13', NULL, NULL);
INSERT INTO `sys_message` VALUES (2, '测试发送消息', '<div>\n <img src=\"https://minio.zhangchuangla.cn/echopro/resource/2025/08/file/0f19c67892084fc79ab9a133a09b9e73.jpg\" width=\"592\" height=\"auto\">\n</div>\n<p></p>', 'system', 'normal', 'admin', 'all', '2025-08-16 15:57:55', 0, '2025-08-16 15:57:55', '2025-08-16 15:57:54', NULL, NULL);

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告标题',
  `notice_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告内容',
  `notice_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告类型',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '创建者',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '更新者',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '公告表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_notice
-- ----------------------------
INSERT INTO `sys_notice` VALUES (1, '测试测试', '<p>很显然！这是一个测试公告哈哈哈！</p>\n<video controls=\"true\" width=\"350\">\n <source src=\"https://minio.zhangchuangla.cn/echopro/resource/2025/08/file/cb202e2f4aba484da57754cf0bcf769a.mov\">\n</video>', '1', '2025-08-16 22:38:22', '2025-08-16 22:38:22', 'admin', NULL, NULL);
INSERT INTO `sys_notice` VALUES (2, '请勿轻信陌生人，谨防诈骗', '<p>在认领物品时，请核实对方身份，不要轻易转账或提供个人敏感信息。</p>', '1', '2025-12-28 23:36:24', '2025-12-31 15:51:18', 'admin', 'demo', NULL);
INSERT INTO `sys_notice` VALUES (3, '认领物品请携带有效证件', '认领物品时请携带学生证、身份证等有效证件，以便核实身份。', '1', '2025-12-28 23:36:24', '2025-12-28 23:36:24', 'admin', NULL, NULL);
INSERT INTO `sys_notice` VALUES (4, '贵重物品建议当面交接', '对于手机、电脑等贵重物品，建议在公共场所当面交接，确保安全。', '1', '2025-12-28 23:36:24', '2025-12-28 23:36:24', 'admin', NULL, NULL);
INSERT INTO `sys_notice` VALUES (5, '1', '<p>1</p>', '1', '2025-12-31 15:51:36', '2025-12-31 15:51:36', 'demo', NULL, NULL);
INSERT INTO `sys_notice` VALUES (6, '2', '<p>1</p>', '1', '2026-01-06 11:28:30', '2026-01-06 11:28:30', 'demo', NULL, NULL);

-- ----------------------------
-- Table structure for sys_operation_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_operation_log`;
CREATE TABLE `sys_operation_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户名',
  `module` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '操作模块',
  `operation_status` tinyint(1) NOT NULL DEFAULT 2 COMMENT '操作状态 0成功 1失败 2未知',
  `request_method` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '请求方法',
  `operation_ip` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '操作IP',
  `operation_region` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '操作地区',
  `response_result` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '操作结果',
  `operation_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '操作类型（CREATE/UPDATE/DELETE）',
  `request_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '请求地址',
  `method_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '方法名称',
  `request_params` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '请求参数',
  `error_msg` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '错误信息',
  `cost_time` bigint NULL DEFAULT NULL COMMENT '耗时（毫秒）',
  `create_time` datetime(6) NULL DEFAULT NULL COMMENT '操作时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 358 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '操作日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_operation_log
-- ----------------------------
INSERT INTO `sys_operation_log` VALUES (1, 2, 'demo', '岗位管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765367155098}', 'UPDATE', '/system/post', 'updatePost', '{}', NULL, 7, '2025-12-10 19:45:55.116000');
INSERT INTO `sys_operation_log` VALUES (2, 2, 'demo', '岗位管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765367156574}', 'UPDATE', '/system/post', 'updatePost', '{}', NULL, 2, '2025-12-10 19:45:56.574000');
INSERT INTO `sys_operation_log` VALUES (3, 2, 'demo', '岗位管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765367157458}', 'UPDATE', '/system/post', 'updatePost', '{}', NULL, 3, '2025-12-10 19:45:57.458000');
INSERT INTO `sys_operation_log` VALUES (4, 2, 'demo', '岗位管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765367158883}', 'UPDATE', '/system/post', 'updatePost', '{}', NULL, 1, '2025-12-10 19:45:58.883000');
INSERT INTO `sys_operation_log` VALUES (5, 2, 'demo', '用户管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765423684680}', 'UPDATE', '/system/user', 'updateUserInfoById', '{}', NULL, 53, '2025-12-11 11:28:04.692000');
INSERT INTO `sys_operation_log` VALUES (6, 2, 'demo', '用户管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765425029995}', 'UPDATE', '/system/user', 'updateUserInfoById', '{}', NULL, 48, '2025-12-11 11:50:29.996000');
INSERT INTO `sys_operation_log` VALUES (7, 7, '2450610522', '角色管理', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765425168997}', 'INSERT', '/system/role', 'addRoleInfo', '{}', NULL, 68, '2025-12-11 11:52:48.998000');
INSERT INTO `sys_operation_log` VALUES (8, 2, 'demo', '角色管理', 1, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', NULL, 'UPDATE', '/system/role', 'updateRoleInfo', '{}', '\r\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Duplicate entry \'管理员\' for key \'sys_role.role_name\'\r\n### The error may exist in cn/zhangchuangla/system/core/mapper/SysRoleMapper.java (best guess)\r\n### The error may involve cn.zhangchuangla.system.core.mapper.SysRoleMapper.updateById-Inline\r\n### The error occurred while setting parameters\r\n### SQL: UPDATE sys_role SET role_name=?, status=?, role_key=?, sort=?,    update_by=?, remark=? WHERE id=?\r\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Duplicate entry \'管理员\' for key \'sys_role.role_name\'\n; Duplicate entry \'管理员\' for key \'sys_role.role_name\'', 142, '2025-12-11 12:04:30.229000');
INSERT INTO `sys_operation_log` VALUES (9, 2, 'demo', '角色管理', 1, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', NULL, 'UPDATE', '/system/role', 'updateRoleInfo', '{}', '\r\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Duplicate entry \'管理员\' for key \'sys_role.role_name\'\r\n### The error may exist in cn/zhangchuangla/system/core/mapper/SysRoleMapper.java (best guess)\r\n### The error may involve cn.zhangchuangla.system.core.mapper.SysRoleMapper.updateById-Inline\r\n### The error occurred while setting parameters\r\n### SQL: UPDATE sys_role SET role_name=?, status=?, role_key=?, sort=?,    update_by=?, remark=? WHERE id=?\r\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Duplicate entry \'管理员\' for key \'sys_role.role_name\'\n; Duplicate entry \'管理员\' for key \'sys_role.role_name\'', 14, '2025-12-11 12:04:39.722000');
INSERT INTO `sys_operation_log` VALUES (10, 2, 'demo', '角色管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765425939897}', 'UPDATE', '/system/role', 'updateRoleInfo', '{}', NULL, 13, '2025-12-11 12:05:39.914000');
INSERT INTO `sys_operation_log` VALUES (11, 2, 'demo', '角色管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765428788984}', 'UPDATE', '/system/role', 'updateRoleInfo', '{}', NULL, 16, '2025-12-11 12:53:08.985000');
INSERT INTO `sys_operation_log` VALUES (12, 2, 'demo', '角色管理', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765428834664}', 'INSERT', '/system/role', 'addRoleInfo', '{}', NULL, 41, '2025-12-11 12:53:54.664000');
INSERT INTO `sys_operation_log` VALUES (13, 2, 'demo', '用户管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765431451227}', 'UPDATE', '/system/user', 'updateUserInfoById', '{}', NULL, 67, '2025-12-11 13:37:31.227000');
INSERT INTO `sys_operation_log` VALUES (14, 2, 'demo', '用户管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765431466991}', 'UPDATE', '/system/user', 'updateUserInfoById', '{}', NULL, 26, '2025-12-11 13:37:46.991000');
INSERT INTO `sys_operation_log` VALUES (15, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765434065870}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 24, '2025-12-11 14:21:05.870000');
INSERT INTO `sys_operation_log` VALUES (16, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765434591911}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 17, '2025-12-11 14:29:51.911000');
INSERT INTO `sys_operation_log` VALUES (17, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765434609506}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 21, '2025-12-11 14:30:09.506000');
INSERT INTO `sys_operation_log` VALUES (18, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765434671485}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 23, '2025-12-11 14:31:11.485000');
INSERT INTO `sys_operation_log` VALUES (19, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765434689657}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 20, '2025-12-11 14:31:29.657000');
INSERT INTO `sys_operation_log` VALUES (20, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765434949291}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 70, '2025-12-11 14:35:49.291000');
INSERT INTO `sys_operation_log` VALUES (21, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765435014697}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 24, '2025-12-11 14:36:54.697000');
INSERT INTO `sys_operation_log` VALUES (22, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765435088731}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 15, '2025-12-11 14:38:08.731000');
INSERT INTO `sys_operation_log` VALUES (23, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765435106157}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 22, '2025-12-11 14:38:26.157000');
INSERT INTO `sys_operation_log` VALUES (24, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765435167922}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 19, '2025-12-11 14:39:27.922000');
INSERT INTO `sys_operation_log` VALUES (25, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765435259909}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 13, '2025-12-11 14:40:59.909000');
INSERT INTO `sys_operation_log` VALUES (26, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765435738086}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 36, '2025-12-11 14:48:58.087000');
INSERT INTO `sys_operation_log` VALUES (27, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765435751697}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 18, '2025-12-11 14:49:11.697000');
INSERT INTO `sys_operation_log` VALUES (28, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765435783400}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 20, '2025-12-11 14:49:43.400000');
INSERT INTO `sys_operation_log` VALUES (29, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765435803137}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 17, '2025-12-11 14:50:03.137000');
INSERT INTO `sys_operation_log` VALUES (30, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765435817908}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 17, '2025-12-11 14:50:17.908000');
INSERT INTO `sys_operation_log` VALUES (31, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765435841833}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 15, '2025-12-11 14:50:41.833000');
INSERT INTO `sys_operation_log` VALUES (32, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765435863609}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 15, '2025-12-11 14:51:03.609000');
INSERT INTO `sys_operation_log` VALUES (33, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765435904312}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 17, '2025-12-11 14:51:44.312000');
INSERT INTO `sys_operation_log` VALUES (34, 2, 'demo', '角色权限管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765435944157}', 'UPDATE', '/system/role/permission', 'updateRolePermission', '{}', NULL, 47, '2025-12-11 14:52:24.157000');
INSERT INTO `sys_operation_log` VALUES (35, 2, 'demo', '用户管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765435988017}', 'UPDATE', '/system/user', 'updateUserInfoById', '{}', NULL, 24, '2025-12-11 14:53:08.017000');
INSERT INTO `sys_operation_log` VALUES (36, 2, 'demo', '用户管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765436121280}', 'UPDATE', '/system/user', 'updateUserInfoById', '{}', NULL, 70, '2025-12-11 14:55:21.280000');
INSERT INTO `sys_operation_log` VALUES (37, 2, 'demo', '用户管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765436230444}', 'UPDATE', '/system/user', 'updateUserInfoById', '{}', NULL, 42, '2025-12-11 14:57:10.444000');
INSERT INTO `sys_operation_log` VALUES (38, 2, 'demo', '用户管理', 1, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', NULL, 'UPDATE', '/system/user', 'updateUserInfoById', '{}', '邮箱已存在', 3, '2025-12-11 14:58:00.042000');
INSERT INTO `sys_operation_log` VALUES (39, 2, 'demo', '用户管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765436285375}', 'UPDATE', '/system/user', 'updateUserInfoById', '{}', NULL, 17, '2025-12-11 14:58:05.375000');
INSERT INTO `sys_operation_log` VALUES (40, 2, 'demo', '用户管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765436345939}', 'UPDATE', '/system/user/resetPassword', 'resetPassword', '{}', NULL, 12, '2025-12-11 14:59:05.939000');
INSERT INTO `sys_operation_log` VALUES (41, 2, 'demo', '用户管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765436849434}', 'UPDATE', '/system/user', 'updateUserInfoById', '{}', NULL, 68, '2025-12-11 15:07:29.435000');
INSERT INTO `sys_operation_log` VALUES (42, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765437071739}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 24, '2025-12-11 15:11:11.740000');
INSERT INTO `sys_operation_log` VALUES (43, 2, 'demo', '用户管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765635033905}', 'UPDATE', '/system/user/resetPassword', 'resetPassword', '{}', NULL, 23, '2025-12-13 22:10:33.906000');
INSERT INTO `sys_operation_log` VALUES (44, 2, 'demo', '用户管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765807206791}', 'UPDATE', '/system/user/resetPassword', 'resetPassword', '{}', NULL, 18, '2025-12-15 22:00:06.818000');
INSERT INTO `sys_operation_log` VALUES (45, 2, 'demo', '用户管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765808126198}', 'UPDATE', '/system/user', 'updateUserInfoById', '{}', NULL, 40, '2025-12-15 22:15:26.209000');
INSERT INTO `sys_operation_log` VALUES (46, 2, 'demo', '数据备份', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":{\"message\":\"备份完成\",\"progress\":100,\"status\":\"success\",\"taskId\":\"19a44d69-8aee-4448-8417-ab6d6fc16013\"},\"message\":\"操作成功\",\"timestamp\":1765849196579}', 'INSERT', '/ocean/admin/settings/backup', 'createBackup', '{}', NULL, 1, '2025-12-16 09:39:56.591000');
INSERT INTO `sys_operation_log` VALUES (47, 2, 'demo', '海洋数据', 1, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', NULL, 'EXPORT', '/ocean/data/export', 'exportData', '{}', '\r\n### Error querying database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_time\' in \'field list\'\r\n### The error may exist in cn/zhangchuangla/system/core/mapper/ocean/OceanObservationMapper.java (best guess)\r\n### The error may involve defaultParameterMap\r\n### The error occurred while setting parameters\r\n### SQL: SELECT id,file_id,station_id,datetime,depth,temperature,temperature2,salinity,conductivity1,conductivity2,density,sound_speed,fluorescence,qc_flag,source_flag,create_time,update_time,create_by,update_by,remark FROM ocean_observations         ORDER BY datetime DESC,depth ASC LIMIT 10000\r\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_time\' in \'field list\'\n; bad SQL grammar []', 105, '2025-12-16 10:11:56.446000');
INSERT INTO `sys_operation_log` VALUES (48, 2, 'demo', 'QC质控', 1, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', NULL, 'OTHER', '/ocean/qc/batch', 'runQcBatch', '{}', '\r\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'qc_params\' in \'field list\'\r\n### The error may exist in cn/zhangchuangla/system/core/mapper/ocean/OceanQcTaskMapper.java (best guess)\r\n### The error may involve cn.zhangchuangla.system.core.mapper.ocean.OceanQcTaskMapper.insert-Inline\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO ocean_qc_tasks ( user_id, status,     qc_params,   create_time ) VALUES ( ?, ?,     ?,   ? )\r\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'qc_params\' in \'field list\'\n; bad SQL grammar []', 24, '2025-12-16 10:26:41.634000');
INSERT INTO `sys_operation_log` VALUES (49, 2, 'demo', 'QC质控', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":{\"createTime\":1765853102896,\"id\":1,\"qcParams\":\"{\\\"qcTypes\\\":[\\\"range_check\\\",\\\"missing_check\\\",\\\"spike_check\\\",\\\"gradient_check\\\",\\\"density_check\\\",\\\"monotonic_check\\\",\\\"ts_logic_check\\\"],\\\"timeRange\\\":[\\\"2025-12-04T16:54:00.961Z\\\",\\\"2025-12-19T02:44:54.961Z\\\"]}\",\"status\":0,\"userId\":2},\"message\":\"操作成功\",\"timestamp\":1765853102950}', 'OTHER', '/ocean/qc/batch', 'runQcBatch', '{}', NULL, 72, '2025-12-16 10:45:02.965000');
INSERT INTO `sys_operation_log` VALUES (50, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765854973768}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 46, '2025-12-16 11:16:13.768000');
INSERT INTO `sys_operation_log` VALUES (51, 2, 'demo', '角色权限管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765855850495}', 'UPDATE', '/system/role/permission', 'updateRolePermission', '{}', NULL, 81, '2025-12-16 11:30:50.495000');
INSERT INTO `sys_operation_log` VALUES (52, 2, 'demo', '角色权限管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765855861220}', 'UPDATE', '/system/role/permission', 'updateRolePermission', '{}', NULL, 92, '2025-12-16 11:31:01.220000');
INSERT INTO `sys_operation_log` VALUES (53, 2, 'demo', '角色权限管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765855892622}', 'UPDATE', '/system/role/permission', 'updateRolePermission', '{}', NULL, 67, '2025-12-16 11:31:32.623000');
INSERT INTO `sys_operation_log` VALUES (54, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765857403251}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 78, '2025-12-16 11:56:43.269000');
INSERT INTO `sys_operation_log` VALUES (55, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765857467556}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 18, '2025-12-16 11:57:47.556000');
INSERT INTO `sys_operation_log` VALUES (56, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765857488327}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 17, '2025-12-16 11:58:08.327000');
INSERT INTO `sys_operation_log` VALUES (57, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765857498554}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 18, '2025-12-16 11:58:18.554000');
INSERT INTO `sys_operation_log` VALUES (58, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765857517365}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 12, '2025-12-16 11:58:37.366000');
INSERT INTO `sys_operation_log` VALUES (59, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765857531847}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 17, '2025-12-16 11:58:51.847000');
INSERT INTO `sys_operation_log` VALUES (60, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765857542020}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 19, '2025-12-16 11:59:02.020000');
INSERT INTO `sys_operation_log` VALUES (61, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765857545835}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 19, '2025-12-16 11:59:05.836000');
INSERT INTO `sys_operation_log` VALUES (62, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765857557325}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 19, '2025-12-16 11:59:17.325000');
INSERT INTO `sys_operation_log` VALUES (63, 2, 'demo', '海洋数据导入', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":500,\"message\":\"文件上传失败: \\r\\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'file_format\' in \'field list\'\\r\\n### The error may exist in cn/zhangchuangla/system/core/mapper/ocean/OceanRawFileMapper.java (best guess)\\r\\n### The error may involve cn.zhangchuangla.system.core.mapper.ocean.OceanRawFileMapper.insert-Inline\\r\\n### The error occurred while setting parameters\\r\\n### SQL: INSERT INTO ocean_raw_files ( filename,  uploader_id, upload_time, status,    file_format, file_size ) VALUES ( ?,  ?, ?, ?,    ?, ? )\\r\\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'file_format\' in \'field list\'\\n; bad SQL grammar []\",\"timestamp\":1765861867555}', 'INSERT', '/ocean/file/upload', 'uploadFile', '{}', NULL, 317, '2025-12-16 13:11:07.566000');
INSERT INTO `sys_operation_log` VALUES (64, 2, 'demo', '海洋数据导入', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":{\"errors\":[\"不支持的文件格式\"],\"failCount\":1,\"fileId\":1,\"successCount\":0},\"message\":\"操作成功\",\"timestamp\":1765862452220}', 'INSERT', '/ocean/file/upload', 'uploadFile', '{}', NULL, 62, '2025-12-16 13:20:52.243000');
INSERT INTO `sys_operation_log` VALUES (65, 2, 'demo', '海洋数据导入', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":{\"errors\":[\"不支持的文件格式\"],\"failCount\":1,\"fileId\":2,\"successCount\":0},\"message\":\"操作成功\",\"timestamp\":1765862506574}', 'INSERT', '/ocean/file/upload', 'uploadFile', '{}', NULL, 27, '2025-12-16 13:21:46.574000');
INSERT INTO `sys_operation_log` VALUES (66, 2, 'demo', '海洋数据导入', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":{\"errors\":[\"文件导入失败: \\r\\n### Error updating database.  Cause: java.sql.SQLException: Field \'station_id\' doesn\'t have a default value\\r\\n### The error may exist in cn/zhangchuangla/system/core/mapper/ocean/OceanObservationMapper.java (best guess)\\r\\n### The error may involve cn.zhangchuangla.system.core.mapper.ocean.OceanObservationMapper.insert-Inline\\r\\n### The error occurred while setting parameters\\r\\n### SQL: INSERT INTO ocean_observations ( file_id,  datetime, depth, temperature, temperature2, salinity, conductivity1, conductivity2,   fluorescence, qc_flag, source_flag ) VALUES ( ?,  ?, ?, ?, ?, ?, ?, ?,   ?, ?, ? )\\r\\n### Cause: java.sql.SQLException: Field \'station_id\' doesn\'t have a default value\\n; Field \'station_id\' doesn\'t have a default value\"],\"failCount\":0,\"fileId\":3,\"successCount\":0},\"message\":\"操作成功\",\"timestamp\":1765862788122}', 'INSERT', '/ocean/file/upload', 'uploadFile', '{}', NULL, 227, '2025-12-16 13:26:28.136000');
INSERT INTO `sys_operation_log` VALUES (67, 2, 'demo', '海洋数据导入', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":{\"errors\":[\"文件导入失败: \\r\\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Cannot add or update a child row: a foreign key constraint fails (`item`.`ocean_observations`, CONSTRAINT `ocean_observations_ibfk_1` FOREIGN KEY (`station_id`) REFERENCES `ocean_stations` (`id`) ON DELETE RESTRICT)\\r\\n### The error may exist in cn/zhangchuangla/system/core/mapper/ocean/OceanObservationMapper.java (best guess)\\r\\n### The error may involve cn.zhangchuangla.system.core.mapper.ocean.OceanObservationMapper.insert-Inline\\r\\n### The error occurred while setting parameters\\r\\n### SQL: INSERT INTO ocean_observations ( file_id, station_id, datetime, depth, temperature, temperature2, salinity, conductivity1, conductivity2,   fluorescence, qc_flag, source_flag ) VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?,   ?, ?, ? )\\r\\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Cannot add or update a child row: a foreign key constraint fails (`item`.`ocean_observations`, CONSTRAINT `ocean_observations_ibfk_1` FOREIGN KEY (`station_id`) REFERENCES `ocean_stations` (`id`) ON DELETE RESTRICT)\\n; Cannot add or update a child row: a foreign key constraint fails (`item`.`ocean_observations`, CONSTRAINT `ocean_observations_ibfk_1` FOREIGN KEY (`station_id`) REFERENCES `ocean_stations` (`id`) ON DELETE RESTRICT)\"],\"failCount\":0,\"fileId\":4,\"successCount\":0},\"message\":\"操作成功\",\"timestamp\":1765862995896}', 'INSERT', '/ocean/file/upload', 'uploadFile', '{}', NULL, 182, '2025-12-16 13:29:55.916000');
INSERT INTO `sys_operation_log` VALUES (68, 2, 'demo', '海洋数据导入', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":{\"failCount\":0,\"fileId\":5,\"successCount\":59},\"message\":\"操作成功\",\"timestamp\":1765863232112}', 'INSERT', '/ocean/file/upload', 'uploadFile', '{}', NULL, 67, '2025-12-16 13:33:52.133000');
INSERT INTO `sys_operation_log` VALUES (69, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765863733065}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 39, '2025-12-16 13:42:13.065000');
INSERT INTO `sys_operation_log` VALUES (70, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765864349977}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 15, '2025-12-16 13:52:29.977000');
INSERT INTO `sys_operation_log` VALUES (71, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765864428148}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 18, '2025-12-16 13:53:48.148000');
INSERT INTO `sys_operation_log` VALUES (72, 2, 'demo', '海洋数据导入', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":{\"failCount\":0,\"fileId\":6,\"successCount\":59},\"message\":\"操作成功\",\"timestamp\":1765891194456}', 'INSERT', '/ocean/file/upload', 'uploadFile', '{}', NULL, 196, '2025-12-16 21:19:54.477000');
INSERT INTO `sys_operation_log` VALUES (73, 2, 'demo', '海洋数据导入', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":{\"failCount\":0,\"fileId\":7,\"successCount\":59},\"message\":\"操作成功\",\"timestamp\":1765937861564}', 'INSERT', '/ocean/file/upload', 'uploadFile', '{}', NULL, 207, '2025-12-17 10:17:41.578000');
INSERT INTO `sys_operation_log` VALUES (74, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765942559264}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 30, '2025-12-17 11:35:59.284000');
INSERT INTO `sys_operation_log` VALUES (75, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765942563179}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 15, '2025-12-17 11:36:03.179000');
INSERT INTO `sys_operation_log` VALUES (76, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765942567794}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 20, '2025-12-17 11:36:07.794000');
INSERT INTO `sys_operation_log` VALUES (77, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765942571778}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 12, '2025-12-17 11:36:11.778000');
INSERT INTO `sys_operation_log` VALUES (78, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765942575357}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 12, '2025-12-17 11:36:15.357000');
INSERT INTO `sys_operation_log` VALUES (79, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765942581050}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 21, '2025-12-17 11:36:21.050000');
INSERT INTO `sys_operation_log` VALUES (80, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765942584402}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 52, '2025-12-17 11:36:24.402000');
INSERT INTO `sys_operation_log` VALUES (81, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765942753097}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 25, '2025-12-17 11:39:13.097000');
INSERT INTO `sys_operation_log` VALUES (82, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765942757242}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 16, '2025-12-17 11:39:17.242000');
INSERT INTO `sys_operation_log` VALUES (83, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765942765652}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 13, '2025-12-17 11:39:25.652000');
INSERT INTO `sys_operation_log` VALUES (84, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765943124584}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 21, '2025-12-17 11:45:24.584000');
INSERT INTO `sys_operation_log` VALUES (85, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765943139513}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 7, '2025-12-17 11:45:39.514000');
INSERT INTO `sys_operation_log` VALUES (86, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765943587509}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 18, '2025-12-17 11:53:07.509000');
INSERT INTO `sys_operation_log` VALUES (87, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765943742931}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 19, '2025-12-17 11:55:42.931000');
INSERT INTO `sys_operation_log` VALUES (88, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765943764609}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 34, '2025-12-17 11:56:04.609000');
INSERT INTO `sys_operation_log` VALUES (89, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765944170100}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 23, '2025-12-17 12:02:50.100000');
INSERT INTO `sys_operation_log` VALUES (90, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765944180721}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 19, '2025-12-17 12:03:00.722000');
INSERT INTO `sys_operation_log` VALUES (91, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765944184160}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 19, '2025-12-17 12:03:04.160000');
INSERT INTO `sys_operation_log` VALUES (92, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765944187524}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 16, '2025-12-17 12:03:07.525000');
INSERT INTO `sys_operation_log` VALUES (93, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765944190674}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 12, '2025-12-17 12:03:10.674000');
INSERT INTO `sys_operation_log` VALUES (94, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765950285791}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 19, '2025-12-17 13:44:45.791000');
INSERT INTO `sys_operation_log` VALUES (95, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765950335852}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 19, '2025-12-17 13:45:35.852000');
INSERT INTO `sys_operation_log` VALUES (96, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765950345048}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 14, '2025-12-17 13:45:45.048000');
INSERT INTO `sys_operation_log` VALUES (97, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765950359834}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 15, '2025-12-17 13:45:59.835000');
INSERT INTO `sys_operation_log` VALUES (98, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765950374189}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 19, '2025-12-17 13:46:14.189000');
INSERT INTO `sys_operation_log` VALUES (99, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765950437138}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 20, '2025-12-17 13:47:17.138000');
INSERT INTO `sys_operation_log` VALUES (100, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765950492433}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 16, '2025-12-17 13:48:12.433000');
INSERT INTO `sys_operation_log` VALUES (101, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765950511030}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 23, '2025-12-17 13:48:31.030000');
INSERT INTO `sys_operation_log` VALUES (102, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765950519695}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 7, '2025-12-17 13:48:39.695000');
INSERT INTO `sys_operation_log` VALUES (103, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765950696299}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 21, '2025-12-17 13:51:36.300000');
INSERT INTO `sys_operation_log` VALUES (104, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765950873508}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 18, '2025-12-17 13:54:33.508000');
INSERT INTO `sys_operation_log` VALUES (105, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765951007865}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 14, '2025-12-17 13:56:47.865000');
INSERT INTO `sys_operation_log` VALUES (106, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765951016584}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 14, '2025-12-17 13:56:56.584000');
INSERT INTO `sys_operation_log` VALUES (107, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765951052143}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 17, '2025-12-17 13:57:32.143000');
INSERT INTO `sys_operation_log` VALUES (108, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765951059179}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 14, '2025-12-17 13:57:39.180000');
INSERT INTO `sys_operation_log` VALUES (109, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765951070921}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 17, '2025-12-17 13:57:50.921000');
INSERT INTO `sys_operation_log` VALUES (110, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765951101836}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 13, '2025-12-17 13:58:21.836000');
INSERT INTO `sys_operation_log` VALUES (111, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765974643847}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 28, '2025-12-17 20:30:43.875000');
INSERT INTO `sys_operation_log` VALUES (112, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765974694084}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 33, '2025-12-17 20:31:34.084000');
INSERT INTO `sys_operation_log` VALUES (113, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765974735432}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 15, '2025-12-17 20:32:15.432000');
INSERT INTO `sys_operation_log` VALUES (114, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765974792985}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 15, '2025-12-17 20:33:12.985000');
INSERT INTO `sys_operation_log` VALUES (115, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765974991996}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 15, '2025-12-17 20:36:31.996000');
INSERT INTO `sys_operation_log` VALUES (116, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765975003577}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 64, '2025-12-17 20:36:43.578000');
INSERT INTO `sys_operation_log` VALUES (117, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765975015166}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 12, '2025-12-17 20:36:55.166000');
INSERT INTO `sys_operation_log` VALUES (118, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765975023669}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 29, '2025-12-17 20:37:03.669000');
INSERT INTO `sys_operation_log` VALUES (119, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765975026958}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 16, '2025-12-17 20:37:06.958000');
INSERT INTO `sys_operation_log` VALUES (120, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765975085899}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 78, '2025-12-17 20:38:05.899000');
INSERT INTO `sys_operation_log` VALUES (121, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765975179293}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 18, '2025-12-17 20:39:39.293000');
INSERT INTO `sys_operation_log` VALUES (122, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765975220672}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 18, '2025-12-17 20:40:20.672000');
INSERT INTO `sys_operation_log` VALUES (123, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765975287418}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 17, '2025-12-17 20:41:27.418000');
INSERT INTO `sys_operation_log` VALUES (124, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765975316012}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 17, '2025-12-17 20:41:56.012000');
INSERT INTO `sys_operation_log` VALUES (125, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765975322857}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 16, '2025-12-17 20:42:02.857000');
INSERT INTO `sys_operation_log` VALUES (126, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765975863170}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 20, '2025-12-17 20:51:03.171000');
INSERT INTO `sys_operation_log` VALUES (127, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765975887437}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 12, '2025-12-17 20:51:27.437000');
INSERT INTO `sys_operation_log` VALUES (128, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765976029322}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 12, '2025-12-17 20:53:49.322000');
INSERT INTO `sys_operation_log` VALUES (129, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765976369583}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 12, '2025-12-17 20:59:29.584000');
INSERT INTO `sys_operation_log` VALUES (130, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1765976419982}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 70, '2025-12-17 21:00:19.982000');
INSERT INTO `sys_operation_log` VALUES (131, 2, 'demo', '海洋数据导入', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":{\"failCount\":0,\"fileId\":8,\"successCount\":59},\"message\":\"操作成功\",\"timestamp\":1765977007199}', 'INSERT', '/ocean/file/upload', 'uploadFile', '{}', NULL, 231, '2025-12-17 21:10:07.204000');
INSERT INTO `sys_operation_log` VALUES (132, 2, 'demo', '批量数据修复', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":{\"failCount\":0,\"successCount\":2},\"message\":\"操作成功\",\"timestamp\":1765980300759}', 'UPDATE', '/ocean/repair/batch', 'batchRepair', '{}', NULL, 94, '2025-12-17 22:05:00.772000');
INSERT INTO `sys_operation_log` VALUES (133, 2, 'demo', '批量数据修复', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":{\"failCount\":0,\"successCount\":1},\"message\":\"操作成功\",\"timestamp\":1765980459529}', 'UPDATE', '/ocean/repair/batch', 'batchRepair', '{}', NULL, 50, '2025-12-17 22:07:39.530000');
INSERT INTO `sys_operation_log` VALUES (134, 2, 'demo', '修复队列', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":{\"failCount\":1,\"successCount\":0},\"message\":\"操作成功\",\"timestamp\":1765980566454}', 'INSERT', '/ocean/repair/queue/batch', 'batchAddToQueue', '{}', NULL, 3, '2025-12-17 22:09:26.456000');
INSERT INTO `sys_operation_log` VALUES (135, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766066489312}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 29, '2025-12-18 22:01:29.331000');
INSERT INTO `sys_operation_log` VALUES (136, 2, 'demo', '菜单管理', 1, 'DELETE', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', NULL, 'DELETE', '/system/menu/221', 'deleteMenu', '{}', '当前菜单包含子菜单，请先删除子菜单', 6, '2025-12-27 20:33:21.463000');
INSERT INTO `sys_operation_log` VALUES (137, 2, 'demo', '菜单管理', 1, 'DELETE', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', NULL, 'DELETE', '/system/menu/232', 'deleteMenu', '{}', '当前菜单已分配，请先解除分配', 8, '2025-12-27 20:33:28.090000');
INSERT INTO `sys_operation_log` VALUES (138, 2, 'demo', '菜单管理', 1, 'DELETE', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', NULL, 'DELETE', '/system/menu/232', 'deleteMenu', '{}', '当前菜单已分配，请先解除分配', 10, '2025-12-27 20:33:32.796000');
INSERT INTO `sys_operation_log` VALUES (139, 2, 'demo', '角色权限管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766838835349}', 'UPDATE', '/system/role/permission', 'updateRolePermission', '{}', NULL, 44, '2025-12-27 20:33:55.373000');
INSERT INTO `sys_operation_log` VALUES (140, 2, 'demo', '角色权限管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766838845561}', 'UPDATE', '/system/role/permission', 'updateRolePermission', '{}', NULL, 21, '2025-12-27 20:34:05.561000');
INSERT INTO `sys_operation_log` VALUES (141, 2, 'demo', '角色权限管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766838857233}', 'UPDATE', '/system/role/permission', 'updateRolePermission', '{}', NULL, 84, '2025-12-27 20:34:17.234000');
INSERT INTO `sys_operation_log` VALUES (142, 2, 'demo', '角色权限管理', 1, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', NULL, 'UPDATE', '/system/role/permission', 'updateRolePermission', '{}', '超级管理员角色不允许修改权限', 5, '2025-12-27 20:34:22.778000');
INSERT INTO `sys_operation_log` VALUES (143, 2, 'demo', '菜单管理', 1, 'DELETE', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', NULL, 'DELETE', '/system/menu/232', 'deleteMenu', '{}', '当前菜单已分配，请先解除分配', 3, '2025-12-27 20:34:34.063000');
INSERT INTO `sys_operation_log` VALUES (144, 2, 'demo', '菜单管理', 1, 'DELETE', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', NULL, 'DELETE', '/system/menu/232', 'deleteMenu', '{}', '当前菜单已分配，请先解除分配', 3, '2025-12-27 20:35:13.774000');
INSERT INTO `sys_operation_log` VALUES (145, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766851813703}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 37, '2025-12-28 00:10:13.703000');
INSERT INTO `sys_operation_log` VALUES (146, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766851865944}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 22, '2025-12-28 00:11:05.944000');
INSERT INTO `sys_operation_log` VALUES (147, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766851869927}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 11, '2025-12-28 00:11:09.927000');
INSERT INTO `sys_operation_log` VALUES (148, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766851874074}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 12, '2025-12-28 00:11:14.074000');
INSERT INTO `sys_operation_log` VALUES (149, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766851877396}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 20, '2025-12-28 00:11:17.396000');
INSERT INTO `sys_operation_log` VALUES (150, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766851880912}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 16, '2025-12-28 00:11:20.912000');
INSERT INTO `sys_operation_log` VALUES (151, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766851892695}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 22, '2025-12-28 00:11:32.696000');
INSERT INTO `sys_operation_log` VALUES (152, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766851897467}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 17, '2025-12-28 00:11:37.467000');
INSERT INTO `sys_operation_log` VALUES (153, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766851900458}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 19, '2025-12-28 00:11:40.458000');
INSERT INTO `sys_operation_log` VALUES (154, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766851903747}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 16, '2025-12-28 00:11:43.747000');
INSERT INTO `sys_operation_log` VALUES (155, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766851909627}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 14, '2025-12-28 00:11:49.627000');
INSERT INTO `sys_operation_log` VALUES (156, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766851912854}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 12, '2025-12-28 00:11:52.854000');
INSERT INTO `sys_operation_log` VALUES (157, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766851916924}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 17, '2025-12-28 00:11:56.925000');
INSERT INTO `sys_operation_log` VALUES (158, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766851920842}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 18, '2025-12-28 00:12:00.843000');
INSERT INTO `sys_operation_log` VALUES (159, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766851924067}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 19, '2025-12-28 00:12:04.067000');
INSERT INTO `sys_operation_log` VALUES (160, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766851927447}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 22, '2025-12-28 00:12:07.448000');
INSERT INTO `sys_operation_log` VALUES (161, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766851930569}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 18, '2025-12-28 00:12:10.569000');
INSERT INTO `sys_operation_log` VALUES (162, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766851936032}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 13, '2025-12-28 00:12:16.032000');
INSERT INTO `sys_operation_log` VALUES (163, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766851939783}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 19, '2025-12-28 00:12:19.783000');
INSERT INTO `sys_operation_log` VALUES (164, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766851942581}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 24, '2025-12-28 00:12:22.581000');
INSERT INTO `sys_operation_log` VALUES (165, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766851945684}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 14, '2025-12-28 00:12:25.684000');
INSERT INTO `sys_operation_log` VALUES (166, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766851948613}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 14, '2025-12-28 00:12:28.613000');
INSERT INTO `sys_operation_log` VALUES (167, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766851951429}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 17, '2025-12-28 00:12:31.429000');
INSERT INTO `sys_operation_log` VALUES (168, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766851954370}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 16, '2025-12-28 00:12:34.370000');
INSERT INTO `sys_operation_log` VALUES (169, 2, 'demo', '角色权限管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766855094279}', 'UPDATE', '/system/role/permission', 'updateRolePermission', '{}', NULL, 151, '2025-12-28 01:04:54.279000');
INSERT INTO `sys_operation_log` VALUES (170, 2, 'demo', '用户管理', 1, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', NULL, 'UPDATE', '/system/user', 'updateUserInfoById', '{}', '不允许修改自己的信息！', 1, '2025-12-28 01:05:13.562000');
INSERT INTO `sys_operation_log` VALUES (171, 2, 'demo', '创建地点', 1, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', NULL, 'OTHER', '/lostfound/location', 'create', '{\"location\":{\"isPickupPoint\":0,\"parentId\":0,\"sort\":0,\"status\":0}}', '\r\n### Error updating database.  Cause: java.sql.SQLException: Field \'name\' doesn\'t have a default value\r\n### The error may exist in cn/zhangchuangla/system/lostfound/mapper/BizLocationMapper.java (best guess)\r\n### The error may involve cn.zhangchuangla.system.lostfound.mapper.BizLocationMapper.insert-Inline\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO biz_location ( parent_id,    is_pickup_point,   sort, status ) VALUES ( ?,    ?,   ?, ? )\r\n### Cause: java.sql.SQLException: Field \'name\' doesn\'t have a default value\n; Field \'name\' doesn\'t have a default value', 202, '2025-12-28 12:31:45.285000');
INSERT INTO `sys_operation_log` VALUES (172, 2, 'demo', '创建地点', 1, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', NULL, 'OTHER', '/lostfound/location', 'create', '{\"location\":{\"isPickupPoint\":0,\"parentId\":0,\"sort\":0,\"status\":0}}', '\r\n### Error updating database.  Cause: java.sql.SQLException: Field \'name\' doesn\'t have a default value\r\n### The error may exist in cn/zhangchuangla/system/lostfound/mapper/BizLocationMapper.java (best guess)\r\n### The error may involve cn.zhangchuangla.system.lostfound.mapper.BizLocationMapper.insert-Inline\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO biz_location ( parent_id,    is_pickup_point,   sort, status ) VALUES ( ?,    ?,   ?, ? )\r\n### Cause: java.sql.SQLException: Field \'name\' doesn\'t have a default value\n; Field \'name\' doesn\'t have a default value', 6, '2025-12-28 12:31:55.116000');
INSERT INTO `sys_operation_log` VALUES (173, 2, 'demo', '创建地点', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":15,\"message\":\"操作成功\",\"timestamp\":1766896610504}', 'OTHER', '/lostfound/location', 'create', '{\"location\":{\"id\":15,\"isPickupPoint\":0,\"name\":\"1\",\"parentId\":0,\"sort\":0,\"status\":0}}', NULL, 64, '2025-12-28 12:36:50.520000');
INSERT INTO `sys_operation_log` VALUES (174, 2, 'demo', '创建地点', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":16,\"message\":\"操作成功\",\"timestamp\":1766896625360}', 'OTHER', '/lostfound/location', 'create', '{\"location\":{\"id\":16,\"isPickupPoint\":0,\"name\":\"1\",\"parentId\":0,\"sort\":0,\"status\":0}}', NULL, 17, '2025-12-28 12:37:05.361000');
INSERT INTO `sys_operation_log` VALUES (175, 2, 'demo', '创建地点', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":17,\"message\":\"操作成功\",\"timestamp\":1766896653180}', 'OTHER', '/lostfound/location', 'create', '{\"location\":{\"id\":17,\"isPickupPoint\":0,\"name\":\"1\",\"parentId\":1,\"sort\":0,\"status\":0}}', NULL, 20, '2025-12-28 12:37:33.181000');
INSERT INTO `sys_operation_log` VALUES (176, 2, 'demo', '创建地点', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":18,\"message\":\"操作成功\",\"timestamp\":1766896673195}', 'OTHER', '/lostfound/location', 'create', '{\"location\":{\"id\":18,\"isPickupPoint\":1,\"name\":\"1\",\"parentId\":1,\"sort\":0,\"status\":0}}', NULL, 13, '2025-12-28 12:37:53.195000');
INSERT INTO `sys_operation_log` VALUES (177, 2, 'demo', '创建分类', 1, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', NULL, 'OTHER', '/lostfound/category', 'create', '{\"category\":{\"parentId\":1,\"sort\":0,\"status\":0}}', '\r\n### Error updating database.  Cause: java.sql.SQLException: Field \'name\' doesn\'t have a default value\r\n### The error may exist in cn/zhangchuangla/system/lostfound/mapper/BizCategoryMapper.java (best guess)\r\n### The error may involve cn.zhangchuangla.system.lostfound.mapper.BizCategoryMapper.insert-Inline\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO biz_category ( parent_id,  sort, status ) VALUES ( ?,  ?, ? )\r\n### Cause: java.sql.SQLException: Field \'name\' doesn\'t have a default value\n; Field \'name\' doesn\'t have a default value', 153, '2025-12-28 12:38:17.103000');
INSERT INTO `sys_operation_log` VALUES (178, 2, 'demo', '创建分类', 1, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', NULL, 'OTHER', '/lostfound/category', 'create', '{\"category\":{\"parentId\":1,\"sort\":0,\"status\":0}}', '\r\n### Error updating database.  Cause: java.sql.SQLException: Field \'name\' doesn\'t have a default value\r\n### The error may exist in cn/zhangchuangla/system/lostfound/mapper/BizCategoryMapper.java (best guess)\r\n### The error may involve cn.zhangchuangla.system.lostfound.mapper.BizCategoryMapper.insert-Inline\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO biz_category ( parent_id,  sort, status ) VALUES ( ?,  ?, ? )\r\n### Cause: java.sql.SQLException: Field \'name\' doesn\'t have a default value\n; Field \'name\' doesn\'t have a default value', 2, '2025-12-28 12:38:25.227000');
INSERT INTO `sys_operation_log` VALUES (179, 2, 'demo', '发布帖子', 1, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', NULL, 'OTHER', '/lostfound/post', 'create', '{\"post\":{\"categoryId\":1,\"commentCount\":0,\"createdBy\":2,\"description\":\"1\",\"favCount\":0,\"isRecommend\":false,\"isTop\":false,\"locationId\":1,\"status\":\"PENDING\",\"viewCount\":0}}', '\r\n### Error updating database.  Cause: java.sql.SQLException: Field \'post_type\' doesn\'t have a default value\r\n### The error may exist in cn/zhangchuangla/system/lostfound/mapper/BizPostMapper.java (best guess)\r\n### The error may involve cn.zhangchuangla.system.lostfound.mapper.BizPostMapper.insert-Inline\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO biz_post ( description, category_id, location_id,      status, view_count, fav_count, comment_count, is_top, is_recommend,    created_by ) VALUES ( ?, ?, ?,      ?, ?, ?, ?, ?, ?,    ? )\r\n### Cause: java.sql.SQLException: Field \'post_type\' doesn\'t have a default value\n; Field \'post_type\' doesn\'t have a default value', 113, '2025-12-28 12:57:57.057000');
INSERT INTO `sys_operation_log` VALUES (180, 2, 'demo', '发布帖子', 1, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', NULL, 'OTHER', '/lostfound/post', 'create', '{\"post\":{\"categoryId\":1,\"commentCount\":0,\"createdBy\":2,\"description\":\"1\",\"favCount\":0,\"isRecommend\":false,\"isTop\":false,\"locationId\":1,\"status\":\"PENDING\",\"viewCount\":0}}', '\r\n### Error updating database.  Cause: java.sql.SQLException: Field \'post_type\' doesn\'t have a default value\r\n### The error may exist in cn/zhangchuangla/system/lostfound/mapper/BizPostMapper.java (best guess)\r\n### The error may involve cn.zhangchuangla.system.lostfound.mapper.BizPostMapper.insert-Inline\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO biz_post ( description, category_id, location_id,      status, view_count, fav_count, comment_count, is_top, is_recommend,    created_by ) VALUES ( ?, ?, ?,      ?, ?, ?, ?, ?, ?,    ? )\r\n### Cause: java.sql.SQLException: Field \'post_type\' doesn\'t have a default value\n; Field \'post_type\' doesn\'t have a default value', 5, '2025-12-28 12:58:05.467000');
INSERT INTO `sys_operation_log` VALUES (181, 2, 'demo', '保存草稿', 1, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', NULL, 'OTHER', '/lostfound/post/draft', 'saveDraft', '{\"post\":{\"categoryId\":1,\"commentCount\":0,\"createdBy\":2,\"description\":\"1\",\"favCount\":0,\"isRecommend\":false,\"isTop\":false,\"locationId\":1,\"status\":\"DRAFT\",\"viewCount\":0}}', '\r\n### Error updating database.  Cause: java.sql.SQLException: Field \'post_type\' doesn\'t have a default value\r\n### The error may exist in cn/zhangchuangla/system/lostfound/mapper/BizPostMapper.java (best guess)\r\n### The error may involve cn.zhangchuangla.system.lostfound.mapper.BizPostMapper.insert-Inline\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO biz_post ( description, category_id, location_id,      status, view_count, fav_count, comment_count, is_top, is_recommend,    created_by ) VALUES ( ?, ?, ?,      ?, ?, ?, ?, ?, ?,    ? )\r\n### Cause: java.sql.SQLException: Field \'post_type\' doesn\'t have a default value\n; Field \'post_type\' doesn\'t have a default value', 3, '2025-12-28 12:58:09.151000');
INSERT INTO `sys_operation_log` VALUES (182, 2, 'demo', '发布帖子', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":1,\"message\":\"操作成功\",\"timestamp\":1766898717203}', 'OTHER', '/lostfound/post', 'create', '{}', NULL, 39, '2025-12-28 13:11:57.206000');
INSERT INTO `sys_operation_log` VALUES (183, 2, 'demo', '发布帖子', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":2,\"message\":\"操作成功\",\"timestamp\":1766899044007}', 'OTHER', '/lostfound/post', 'create', '{}', NULL, 36, '2025-12-28 13:17:24.009000');
INSERT INTO `sys_operation_log` VALUES (184, 2, 'demo', '发布帖子', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":3,\"message\":\"操作成功\",\"timestamp\":1766899582693}', 'OTHER', '/lostfound/post', 'create', '{}', NULL, 36, '2025-12-28 13:26:22.697000');
INSERT INTO `sys_operation_log` VALUES (185, 2, 'demo', '菜单管理', 1, 'DELETE', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', NULL, 'DELETE', '/system/menu/220', 'deleteMenu', '{}', '当前菜单已分配，请先解除分配', 11, '2025-12-28 14:42:38.449000');
INSERT INTO `sys_operation_log` VALUES (186, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766904191176}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 32, '2025-12-28 14:43:11.177000');
INSERT INTO `sys_operation_log` VALUES (187, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766904227532}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 18, '2025-12-28 14:43:47.532000');
INSERT INTO `sys_operation_log` VALUES (188, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766904243941}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 22, '2025-12-28 14:44:03.941000');
INSERT INTO `sys_operation_log` VALUES (189, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766904251620}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 24, '2025-12-28 14:44:11.620000');
INSERT INTO `sys_operation_log` VALUES (190, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766904312159}', 'UPDATE', '/system/menu', 'updateMenu', '{}', NULL, 17, '2025-12-28 14:45:12.159000');
INSERT INTO `sys_operation_log` VALUES (191, 2, 'demo', '发布帖子', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":4,\"message\":\"操作成功\",\"timestamp\":1766908796489}', 'OTHER', '/lostfound/post', 'create', '{}', NULL, 49, '2025-12-28 15:59:56.492000');
INSERT INTO `sys_operation_log` VALUES (192, 2, 'demo', '发布帖子', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":5,\"message\":\"操作成功\",\"timestamp\":1766909469093}', 'OTHER', '/lostfound/post', 'create', '{}', NULL, 17, '2025-12-28 16:11:09.094000');
INSERT INTO `sys_operation_log` VALUES (193, 2, 'demo', '保存草稿', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":6,\"message\":\"操作成功\",\"timestamp\":1766909551463}', 'OTHER', '/lostfound/post/draft', 'saveDraft', '{}', NULL, 60, '2025-12-28 16:12:31.463000');
INSERT INTO `sys_operation_log` VALUES (194, 2, 'demo', '用户管理', 1, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', NULL, 'UPDATE', '/system/user', 'updateUserInfoById', '{}', '邮箱已存在', 7, '2025-12-28 16:18:45.961000');
INSERT INTO `sys_operation_log` VALUES (195, 2, 'demo', '用户管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766909931054}', 'UPDATE', '/system/user', 'updateUserInfoById', '{}', NULL, 24, '2025-12-28 16:18:51.054000');
INSERT INTO `sys_operation_log` VALUES (196, 2, 'demo', '用户管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766909956458}', 'UPDATE', '/system/user/resetPassword', 'resetPassword', '{}', NULL, 4, '2025-12-28 16:19:16.458000');
INSERT INTO `sys_operation_log` VALUES (197, 2, 'demo', '角色权限管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766909981529}', 'UPDATE', '/system/role/permission', 'updateRolePermission', '{}', NULL, 53, '2025-12-28 16:19:41.529000');
INSERT INTO `sys_operation_log` VALUES (198, 2, 'demo', '用户管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766910237446}', 'RESET_PWD', '/system/user/resetPassword', 'resetPassword', '{\"request\":{\"password\":\"admin123\",\"userId\":9}}', NULL, 95, '2025-12-28 16:23:57.457000');
INSERT INTO `sys_operation_log` VALUES (199, 2, 'demo', '角色权限管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766911095017}', 'UPDATE', '/system/role/permission', 'updateRolePermission', '{\"request\":{\"allocatedMenuId\":[281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,211,212,213,217,214,215],\"roleId\":31}}', NULL, 73, '2025-12-28 16:38:15.026000');
INSERT INTO `sys_operation_log` VALUES (200, 2, 'demo', '角色权限管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766911123677}', 'UPDATE', '/system/role/permission', 'updateRolePermission', '{\"request\":{\"allocatedMenuId\":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,181,182,183,184,185,186,189,191,192,193,194,195,196,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,296,297,298,299,300,301,302,303,304,316,317,318,319,320,321,322,323,324,305,312,315,313,314,309,310,311,306,307,308],\"roleId\":23}}', NULL, 90, '2025-12-28 16:38:43.678000');
INSERT INTO `sys_operation_log` VALUES (201, 2, 'demo', '角色权限管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766911141373}', 'UPDATE', '/system/role/permission', 'updateRolePermission', '{\"request\":{\"allocatedMenuId\":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,181,182,183,184,185,186,189,191,192,193,194,195,196,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,296,297,298,299,300,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295],\"roleId\":23}}', NULL, 75, '2025-12-28 16:39:01.374000');
INSERT INTO `sys_operation_log` VALUES (202, 2, 'demo', '角色权限管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766911195634}', 'UPDATE', '/system/role/permission', 'updateRolePermission', '{\"request\":{\"allocatedMenuId\":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,181,182,183,184,185,186,189,191,192,193,194,195,196,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,296,297,298,299,300,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324],\"roleId\":23}}', NULL, 77, '2025-12-28 16:39:55.634000');
INSERT INTO `sys_operation_log` VALUES (203, 2, 'demo', '角色权限管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766911231306}', 'UPDATE', '/system/role/permission', 'updateRolePermission', '{\"request\":{\"allocatedMenuId\":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,181,182,183,184,185,186,189,191,192,193,194,195,196,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,296,297,298,299,300,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295],\"roleId\":23}}', NULL, 76, '2025-12-28 16:40:31.306000');
INSERT INTO `sys_operation_log` VALUES (204, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766911267804}', 'UPDATE', '/system/menu', 'updateMenu', '{\"request\":{\"activeIcon\":\"\",\"activePath\":\"\",\"affixTab\":false,\"badge\":\"\",\"badgeType\":\"\",\"badgeVariants\":\"\",\"component\":\"BasicLayout\",\"hideChildrenInMenu\":false,\"hideInBreadcrumb\":false,\"hideInMenu\":true,\"hideInTab\":false,\"icon\":\"lucide:search\",\"id\":281,\"keepAlive\":false,\"link\":\"\",\"name\":\"LostFound\",\"parentId\":0,\"path\":\"/lostfound\",\"permission\":\"\",\"sort\":10,\"status\":0,\"title\":\"失物招领\",\"type\":\"MENU\"}}', NULL, 45, '2025-12-28 16:41:07.814000');
INSERT INTO `sys_operation_log` VALUES (205, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766911316956}', 'UPDATE', '/system/menu', 'updateMenu', '{\"request\":{\"activeIcon\":\"\",\"activePath\":\"\",\"affixTab\":false,\"badge\":\"\",\"badgeType\":\"\",\"badgeVariants\":\"\",\"component\":\"BasicLayout\",\"hideChildrenInMenu\":false,\"hideInBreadcrumb\":false,\"hideInMenu\":false,\"hideInTab\":false,\"icon\":\"lucide:search\",\"id\":281,\"keepAlive\":false,\"link\":\"\",\"name\":\"LostFound\",\"parentId\":0,\"path\":\"/lostfound\",\"permission\":\"\",\"sort\":10,\"status\":0,\"title\":\"失物招领\",\"type\":\"MENU\"}}', NULL, 15, '2025-12-28 16:41:56.956000');
INSERT INTO `sys_operation_log` VALUES (206, 2, 'demo', '用户管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766912835145}', 'RESET_PWD', '/system/user/resetPassword', 'resetPassword', '{\"request\":{\"password\":\"admin123\",\"userId\":8}}', NULL, 107, '2025-12-28 17:07:15.148000');
INSERT INTO `sys_operation_log` VALUES (207, 8, '2450610521', '发布帖子', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":7,\"message\":\"操作成功\",\"timestamp\":1766913162902}', 'OTHER', '/lostfound/post', 'create', '{\"post\":{\"categoryId\":2,\"commentCount\":0,\"contactInfo\":\"\",\"createdBy\":8,\"description\":\"在图书馆一楼自习室捡到一个黑色钱包，内有学生证\",\"favCount\":0,\"id\":7,\"imagesJson\":[],\"isRecommend\":false,\"isTop\":false,\"locationId\":1,\"occurTime\":\"2025-12-28 10:00\",\"postType\":\"FOUND\",\"status\":\"PENDING\",\"storagePlace\":\"\",\"title\":\"黑色钱包\",\"viewCount\":0}}', NULL, 25, '2025-12-28 17:12:42.918000');
INSERT INTO `sys_operation_log` VALUES (208, 2, 'demo', '审核通过帖子', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766913376508}', 'OTHER', '/lostfound/post/7/approve', 'approve', '{\"id\":7}', NULL, 10, '2025-12-28 17:16:16.508000');
INSERT INTO `sys_operation_log` VALUES (209, 9, '11134', '发起认领', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":1,\"message\":\"操作成功\",\"timestamp\":1766913926677}', 'OTHER', '/lostfound/claim', 'create', '{\"claim\":{\"claimantId\":9,\"createTime\":1766913926665,\"id\":1,\"postId\":7,\"posterId\":8,\"status\":\"APPLIED\"}}', NULL, 14, '2025-12-28 17:25:26.680000');
INSERT INTO `sys_operation_log` VALUES (210, 8, '2450610521', '同意认领', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766914233905}', 'OTHER', '/lostfound/claim/1/approve', 'approve', '{\"id\":1}', NULL, 11, '2025-12-28 17:30:33.906000');
INSERT INTO `sys_operation_log` VALUES (211, 8, '2450610521', '创建交接', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":1,\"message\":\"操作成功\",\"timestamp\":1766914261071}', 'OTHER', '/lostfound/handover', 'create', '{\"handover\":{\"claimId\":1,\"createTime\":1766914261058,\"fromUserId\":8,\"handoverTime\":1766991600000,\"id\":1,\"status\":\"PENDING\",\"toUserId\":9}}', NULL, 22, '2025-12-28 17:31:01.072000');
INSERT INTO `sys_operation_log` VALUES (212, 8, '2450610521', '确认交接', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766914391267}', 'OTHER', '/lostfound/handover/1/confirm', 'confirm', '{\"id\":1}', NULL, 16, '2025-12-28 17:33:11.267000');
INSERT INTO `sys_operation_log` VALUES (213, 9, '11134', '确认交接', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766914504144}', 'OTHER', '/lostfound/handover/1/confirm', 'confirm', '{\"id\":1}', NULL, 22, '2025-12-28 17:35:04.144000');
INSERT INTO `sys_operation_log` VALUES (214, 9, '11134', '提交评价', 1, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', NULL, 'OTHER', '/lostfound/evaluation', 'create', '{\"evaluation\":{\"content\":\"非常感谢，物品完好无损，交接很顺利！\",\"score\":5}}', '认领单不存在', 5, '2025-12-28 17:35:27.493000');
INSERT INTO `sys_operation_log` VALUES (215, 9, '11134', '发布帖子', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":8,\"message\":\"操作成功\",\"timestamp\":1766914674810}', 'OTHER', '/lostfound/post', 'create', '{\"post\":{\"categoryId\":3,\"commentCount\":0,\"contactInfo\":\"\",\"createdBy\":9,\"description\":\"在食堂二楼吃饭时遗忘了一个蓝色保温杯，杯身有卡通图案，容量约500ml\",\"favCount\":0,\"id\":8,\"imagesJson\":[],\"isRecommend\":false,\"isTop\":false,\"locationId\":2,\"occurTime\":\"2025-12-28 17:37\",\"postType\":\"LOST\",\"status\":\"PENDING\",\"title\":\"蓝色水杯\",\"viewCount\":0}}', NULL, 13, '2025-12-28 17:37:54.811000');
INSERT INTO `sys_operation_log` VALUES (216, 8, '2450610521', '发布帖子', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":9,\"message\":\"操作成功\",\"timestamp\":1766916078168}', 'OTHER', '/lostfound/post', 'create', '{\"post\":{\"categoryId\":2,\"commentCount\":0,\"contactInfo\":\"\",\"createdBy\":8,\"description\":\"在教学楼一楼自习室捡到一个黑色钱包，内有学生证和一些现金。请失主尽快联系认领。\",\"favCount\":0,\"id\":9,\"imagesJson\":[],\"isRecommend\":false,\"isTop\":false,\"locationId\":1,\"occurTime\":\"2025-12-28 18:00\",\"postType\":\"FOUND\",\"status\":\"PENDING\",\"storagePlace\":\"\",\"title\":\"黑色钱包\",\"viewCount\":0}}', NULL, 13, '2025-12-28 18:01:18.168000');
INSERT INTO `sys_operation_log` VALUES (217, 8, '2450610521', '发布帖子', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":10,\"message\":\"操作成功\",\"timestamp\":1766916347458}', 'OTHER', '/lostfound/post', 'create', '{\"post\":{\"categoryId\":5,\"commentCount\":0,\"contactInfo\":\"\",\"createdBy\":8,\"description\":\"在教学楼A座一楼大厅捡到一个黑色皮质钱包，内有现金和证件，请失主联系认领。\",\"favCount\":0,\"id\":10,\"imagesJson\":[],\"isRecommend\":false,\"isTop\":false,\"locationId\":1,\"occurTime\":\"2025-12-28 18:05\",\"postType\":\"FOUND\",\"status\":\"PENDING\",\"storagePlace\":\"\",\"title\":\"黑色钱包\",\"viewCount\":0}}', NULL, 9, '2025-12-28 18:05:47.459000');
INSERT INTO `sys_operation_log` VALUES (218, 2, 'demo', '审核通过帖子', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766916545647}', 'OTHER', '/lostfound/post/8/approve', 'approve', '{\"id\":8}', NULL, 11, '2025-12-28 18:09:05.648000');
INSERT INTO `sys_operation_log` VALUES (219, 2, 'demo', '审核通过帖子', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766916545658}', 'OTHER', '/lostfound/post/9/approve', 'approve', '{\"id\":9}', NULL, 6, '2025-12-28 18:09:05.658000');
INSERT INTO `sys_operation_log` VALUES (220, 2, 'demo', '审核通过帖子', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766916545667}', 'OTHER', '/lostfound/post/10/approve', 'approve', '{\"id\":10}', NULL, 4, '2025-12-28 18:09:05.667000');
INSERT INTO `sys_operation_log` VALUES (221, 2, 'demo', '审核通过帖子', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766916545676}', 'OTHER', '/lostfound/post/11/approve', 'approve', '{\"id\":11}', NULL, 2, '2025-12-28 18:09:05.676000');
INSERT INTO `sys_operation_log` VALUES (222, 2, 'demo', '审核通过帖子', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766916545689}', 'OTHER', '/lostfound/post/12/approve', 'approve', '{\"id\":12}', NULL, 5, '2025-12-28 18:09:05.689000');
INSERT INTO `sys_operation_log` VALUES (223, 9, '11134', '发表评论', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":1,\"message\":\"操作成功\",\"timestamp\":1766916685629}', 'OTHER', '/lostfound/comment', 'create', '{\"comment\":{\"content\":\"这个钱包是我的！请问怎么联系您？\",\"createTime\":1766916685620,\"id\":1,\"postId\":10,\"status\":\"PUBLISHED\",\"userId\":9}}', NULL, 9, '2025-12-28 18:11:25.632000');
INSERT INTO `sys_operation_log` VALUES (224, 9, '11134', '添加收藏', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766916695692}', 'OTHER', '/lostfound/favorite/10', 'addFavorite', '{\"postId\":10}', NULL, 13, '2025-12-28 18:11:35.692000');
INSERT INTO `sys_operation_log` VALUES (225, 9, '11134', '提交举报', 1, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', NULL, 'OTHER', '/lostfound/report', 'create', '{\"report\":{\"createTime\":1766916709480,\"reporterId\":9,\"status\":\"PENDING\",\"targetId\":10,\"targetType\":\"post\"}}', '\r\n### Error updating database.  Cause: java.sql.SQLException: Field \'reason_type\' doesn\'t have a default value\r\n### The error may exist in cn/zhangchuangla/system/lostfound/mapper/BizReportMapper.java (best guess)\r\n### The error may involve cn.zhangchuangla.system.lostfound.mapper.BizReportMapper.insert-Inline\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO biz_report ( reporter_id, target_type, target_id,    status,     create_time ) VALUES ( ?, ?, ?,    ?,     ? )\r\n### Cause: java.sql.SQLException: Field \'reason_type\' doesn\'t have a default value\n; Field \'reason_type\' doesn\'t have a default value', 195, '2025-12-28 18:11:49.676000');
INSERT INTO `sys_operation_log` VALUES (226, 9, '11134', '提交举报', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":1,\"message\":\"操作成功\",\"timestamp\":1766916856191}', 'OTHER', '/lostfound/report', 'create', '{\"report\":{\"createTime\":1766916856179,\"id\":1,\"reasonDetail\":\"测试举报功能 - 这是一个测试举报，请忽略\",\"reasonType\":\"OTHER\",\"reporterId\":9,\"status\":\"PENDING\",\"targetId\":10,\"targetType\":\"POST\"}}', NULL, 13, '2025-12-28 18:14:16.191000');
INSERT INTO `sys_operation_log` VALUES (227, 8, '2450610521', '发布帖子', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":11,\"message\":\"操作成功\",\"timestamp\":1766920467398}', 'OTHER', '/lostfound/post', 'create', '{\"post\":{\"categoryId\":1,\"commentCount\":0,\"contactInfo\":\"\",\"createdBy\":8,\"description\":\"这是一个用于测试通知功能的物品，在教学楼一楼大厅拾获。\",\"favCount\":0,\"id\":11,\"imagesJson\":[],\"isRecommend\":false,\"isTop\":false,\"locationId\":1,\"occurTime\":\"2025-12-28 19:14\",\"postType\":\"FOUND\",\"status\":\"PENDING\",\"storagePlace\":\"\",\"title\":\"测试通知功能的物品\",\"viewCount\":0}}', NULL, 62, '2025-12-28 19:14:27.425000');
INSERT INTO `sys_operation_log` VALUES (228, 2, 'demo', '审核通过帖子', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766920570789}', 'OTHER', '/lostfound/post/11/approve', 'approve', '{\"id\":11}', NULL, 13, '2025-12-28 19:16:10.789000');
INSERT INTO `sys_operation_log` VALUES (229, 2, 'demo', '审核通过帖子', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766927682752}', 'OTHER', '/lostfound/post/5/approve', 'approve', '{\"id\":5}', NULL, 17, '2025-12-28 21:14:42.780000');
INSERT INTO `sys_operation_log` VALUES (230, 9, '11134', '添加收藏', 1, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', NULL, 'OTHER', '/lostfound/favorite/10', 'addFavorite', '{\"postId\":10}', '您已收藏过该帖子', 12, '2025-12-28 21:17:52.970000');
INSERT INTO `sys_operation_log` VALUES (231, 9, '11134', '添加收藏', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766927876546}', 'OTHER', '/lostfound/favorite/11', 'addFavorite', '{\"postId\":11}', NULL, 17, '2025-12-28 21:17:56.546000');
INSERT INTO `sys_operation_log` VALUES (232, 9, '11134', '发表评论', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":2,\"message\":\"操作成功\",\"timestamp\":1766932575891}', 'OTHER', '/lostfound/comment', 'create', '{\"comment\":{\"content\":\"1\",\"createTime\":1766932575872,\"id\":2,\"postId\":7,\"status\":\"PUBLISHED\",\"userId\":9}}', NULL, 35, '2025-12-28 22:36:15.906000');
INSERT INTO `sys_operation_log` VALUES (233, 9, '11134', '发表评论', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":3,\"message\":\"操作成功\",\"timestamp\":1766932581444}', 'OTHER', '/lostfound/comment', 'create', '{\"comment\":{\"content\":\"1\",\"createTime\":1766932581304,\"id\":3,\"postId\":7,\"status\":\"PUBLISHED\",\"userId\":9}}', NULL, 141, '2025-12-28 22:36:21.445000');
INSERT INTO `sys_operation_log` VALUES (234, 9, '11134', '添加收藏', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766932709002}', 'OTHER', '/lostfound/favorite/7', 'addFavorite', '{\"postId\":7}', NULL, 38, '2025-12-28 22:38:29.002000');
INSERT INTO `sys_operation_log` VALUES (235, 9, '11134', '取消收藏', 0, 'DELETE', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766932732341}', 'OTHER', '/lostfound/favorite/7', 'removeFavorite', '{\"postId\":7}', NULL, 11, '2025-12-28 22:38:52.341000');
INSERT INTO `sys_operation_log` VALUES (236, 9, '11134', '发表评论', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":4,\"message\":\"操作成功\",\"timestamp\":1766932778636}', 'OTHER', '/lostfound/comment', 'create', '{\"comment\":{\"content\":\"这是一条测试评论，验证数据库交互功能\",\"createTime\":1766932778626,\"id\":4,\"postId\":7,\"status\":\"PUBLISHED\",\"userId\":9}}', NULL, 12, '2025-12-28 22:39:38.637000');
INSERT INTO `sys_operation_log` VALUES (237, 9, '11134', '发表评论', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":5,\"message\":\"操作成功\",\"timestamp\":1766932999659}', 'OTHER', '/lostfound/comment', 'create', '{\"comment\":{\"content\":\"MCP测试评论功能-验证数据库写入\",\"createTime\":1766932999649,\"id\":5,\"postId\":7,\"status\":\"PUBLISHED\",\"userId\":9}}', NULL, 10, '2025-12-28 22:43:19.659000');
INSERT INTO `sys_operation_log` VALUES (238, 9, '11134', '提交举报', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":2,\"message\":\"操作成功\",\"timestamp\":1766933073942}', 'OTHER', '/lostfound/report', 'create', '{\"report\":{\"createTime\":1766933073897,\"id\":2,\"reasonDetail\":\"MCP测试举报功能-验证数据库写入\",\"reasonType\":\"OTHER\",\"reporterId\":9,\"status\":\"PENDING\",\"targetId\":7,\"targetType\":\"POST\"}}', NULL, 47, '2025-12-28 22:44:33.954000');
INSERT INTO `sys_operation_log` VALUES (239, 9, '11134', '发送私信', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":1,\"message\":\"操作成功\",\"timestamp\":1766934524458}', 'OTHER', '/lostfound/message', 'sendMessage', '{\"message\":{\"content\":\"你好，我想咨询一下这个黑色钱包的认领事宜\",\"createTime\":1766934524421,\"id\":1,\"msgType\":\"TEXT\",\"receiverId\":8,\"senderId\":9,\"threadId\":1}}', NULL, 42, '2025-12-28 23:08:44.474000');
INSERT INTO `sys_operation_log` VALUES (240, 9, '11134', '发送私信', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":2,\"message\":\"操作成功\",\"timestamp\":1766934855851}', 'OTHER', '/lostfound/message', 'sendMessage', '{\"message\":{\"content\":\"请问钱包里有什么证件吗？\",\"createTime\":1766934855790,\"id\":2,\"msgType\":\"TEXT\",\"receiverId\":8,\"senderId\":9,\"threadId\":1}}', NULL, 63, '2025-12-28 23:14:15.853000');
INSERT INTO `sys_operation_log` VALUES (241, 9, '11134', '发起认领', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":2,\"message\":\"操作成功\",\"timestamp\":1766935833131}', 'OTHER', '/lostfound/claim', 'create', '{}', NULL, 25, '2025-12-28 23:30:33.134000');
INSERT INTO `sys_operation_log` VALUES (242, 9, '11134', '添加收藏', 1, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', NULL, 'OTHER', '/lostfound/favorite/11', 'addFavorite', '{\"postId\":11}', '您已收藏过该帖子', 7, '2025-12-28 23:31:22.473000');
INSERT INTO `sys_operation_log` VALUES (243, 9, '11134', '发表评论', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":6,\"message\":\"操作成功\",\"timestamp\":1766935893376}', 'OTHER', '/lostfound/comment', 'create', '{}', NULL, 16, '2025-12-28 23:31:33.377000');
INSERT INTO `sys_operation_log` VALUES (244, 9, '11134', '发表评论', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":7,\"message\":\"操作成功\",\"timestamp\":1766935896754}', 'OTHER', '/lostfound/comment', 'create', '{}', NULL, 14, '2025-12-28 23:31:36.754000');
INSERT INTO `sys_operation_log` VALUES (245, 2, 'demo', '设置帖子置顶', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766972532238}', 'OTHER', '/lostfound/post/11/top/true', 'setTop', '{\"isTop\":true,\"id\":11}', NULL, 38, '2025-12-29 09:42:12.245000');
INSERT INTO `sys_operation_log` VALUES (246, 2, 'demo', '设置帖子推荐', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766972558566}', 'OTHER', '/lostfound/post/11/recommend/true', 'setRecommend', '{\"isRecommend\":true,\"id\":11}', NULL, 11, '2025-12-29 09:42:38.566000');
INSERT INTO `sys_operation_log` VALUES (247, 2, 'demo', '下架帖子', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766972586444}', 'OTHER', '/lostfound/post/11/offline', 'offline', '{\"id\":11}', NULL, 14, '2025-12-29 09:43:06.444000');
INSERT INTO `sys_operation_log` VALUES (248, 2, 'demo', '管理员审核通过认领', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766974018507}', 'OTHER', '/lostfound/claim/admin/2/approve', 'adminApprove', '{\"id\":2}', NULL, 52, '2025-12-29 10:06:58.513000');
INSERT INTO `sys_operation_log` VALUES (249, 2, 'demo', '管理员删除评论', 0, 'DELETE', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766980860108}', 'OTHER', '/lostfound/comment/admin/7', 'adminDelete', '{}', NULL, 44, '2025-12-29 12:01:00.109000');
INSERT INTO `sys_operation_log` VALUES (250, 2, 'demo', '驳回举报', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766984475948}', 'OTHER', '/lostfound/report/admin/2/reject', 'reject', '{\"reason\":\"1\",\"id\":2}', NULL, 38, '2025-12-29 13:01:15.952000');
INSERT INTO `sys_operation_log` VALUES (251, 2, 'demo', '处理举报', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766985086216}', 'OTHER', '/lostfound/report/admin/1/resolve', 'resolve', '{\"action\":\"warning\",\"remark\":\"MCP测试处理功能-验证数据库更新\",\"id\":1}', NULL, 12, '2025-12-29 13:11:26.216000');
INSERT INTO `sys_operation_log` VALUES (252, 2, 'demo', '更新分类', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766985946167}', 'OTHER', '/lostfound/category', 'update', '{\"category\":{\"icon\":\"lucide:smartphone\",\"id\":1,\"name\":\"电子产品(MCP测试编辑)\",\"parentId\":0,\"sort\":1,\"status\":1}}', NULL, 15, '2025-12-29 13:25:46.171000');
INSERT INTO `sys_operation_log` VALUES (253, 2, 'demo', '创建分类', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":17,\"message\":\"操作成功\",\"timestamp\":1766985964417}', 'OTHER', '/lostfound/category', 'create', '{\"category\":{\"id\":17,\"name\":\"手机(MCP测试新增)\",\"parentId\":1,\"sort\":0,\"status\":1}}', NULL, 9, '2025-12-29 13:26:04.419000');
INSERT INTO `sys_operation_log` VALUES (254, 2, 'demo', '删除分类', 0, 'DELETE', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766985995259}', 'OTHER', '/lostfound/category/6', 'delete', '{\"id\":6}', NULL, 14, '2025-12-29 13:26:35.259000');
INSERT INTO `sys_operation_log` VALUES (255, 2, 'demo', '更新分类', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766986013930}', 'OTHER', '/lostfound/category', 'update', '{\"category\":{\"icon\":\"lucide:smartphone\",\"id\":1,\"name\":\"电子产品\",\"parentId\":0,\"sort\":1,\"status\":1}}', NULL, 67, '2025-12-29 13:26:53.930000');
INSERT INTO `sys_operation_log` VALUES (256, 2, 'demo', '创建分类', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":18,\"message\":\"操作成功\",\"timestamp\":1766986095651}', 'OTHER', '/lostfound/category', 'create', '{\"category\":{\"icon\":\"lucide:more-horizontal\",\"id\":18,\"name\":\"其他\",\"parentId\":0,\"sort\":99,\"status\":1}}', NULL, 82, '2025-12-29 13:28:15.652000');
INSERT INTO `sys_operation_log` VALUES (257, 2, 'demo', '创建分类', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":19,\"message\":\"操作成功\",\"timestamp\":1766986118390}', 'OTHER', '/lostfound/category', 'create', '{\"category\":{\"icon\":\"lucide:smartphone\",\"id\":19,\"name\":\"手机\",\"parentId\":1,\"sort\":0,\"status\":1}}', NULL, 11, '2025-12-29 13:28:38.391000');
INSERT INTO `sys_operation_log` VALUES (258, 2, 'demo', '删除分类', 0, 'DELETE', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766986411468}', 'OTHER', '/lostfound/category/17', 'delete', '{}', NULL, 45, '2025-12-29 13:33:31.470000');
INSERT INTO `sys_operation_log` VALUES (259, 2, 'demo', '删除分类', 0, 'DELETE', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766986428129}', 'OTHER', '/lostfound/category/19', 'delete', '{}', NULL, 11, '2025-12-29 13:33:48.129000');
INSERT INTO `sys_operation_log` VALUES (260, 2, 'demo', '更新地点', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766986683588}', 'OTHER', '/lostfound/location', 'update', '{\"location\":{\"id\":1,\"isPickupPoint\":0,\"name\":\"教学区(测试修改)\",\"parentId\":0,\"sort\":1,\"status\":1}}', NULL, 41, '2025-12-29 13:38:03.603000');
INSERT INTO `sys_operation_log` VALUES (261, 2, 'demo', '更新地点', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766986723355}', 'OTHER', '/lostfound/location', 'update', '{\"location\":{\"id\":1,\"isPickupPoint\":0,\"name\":\"教学区\",\"parentId\":0,\"sort\":1,\"status\":1}}', NULL, 9, '2025-12-29 13:38:43.355000');
INSERT INTO `sys_operation_log` VALUES (262, 2, 'demo', '更新地点', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766987708817}', 'OTHER', '/lostfound/location', 'update', '{\"location\":{\"id\":15,\"isPickupPoint\":1,\"name\":\"1\",\"parentId\":0,\"sort\":0,\"status\":0}}', NULL, 22, '2025-12-29 13:55:08.830000');
INSERT INTO `sys_operation_log` VALUES (263, 2, 'demo', '更新地点', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766987720894}', 'OTHER', '/lostfound/location', 'update', '{\"location\":{\"id\":15,\"isPickupPoint\":1,\"name\":\"1\",\"parentId\":0,\"sort\":0,\"status\":0}}', NULL, 5, '2025-12-29 13:55:20.895000');
INSERT INTO `sys_operation_log` VALUES (264, 2, 'demo', '更新地点', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766987726865}', 'OTHER', '/lostfound/location', 'update', '{\"location\":{\"id\":16,\"isPickupPoint\":0,\"name\":\"1\",\"parentId\":0,\"sort\":0,\"status\":1}}', NULL, 16, '2025-12-29 13:55:26.866000');
INSERT INTO `sys_operation_log` VALUES (265, 2, 'demo', '更新地点', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766987730347}', 'OTHER', '/lostfound/location', 'update', '{\"location\":{\"id\":15,\"isPickupPoint\":1,\"name\":\"1\",\"parentId\":0,\"sort\":0,\"status\":1}}', NULL, 12, '2025-12-29 13:55:30.347000');
INSERT INTO `sys_operation_log` VALUES (266, 2, 'demo', '更新地点', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766987737892}', 'OTHER', '/lostfound/location', 'update', '{\"location\":{\"id\":16,\"isPickupPoint\":1,\"name\":\"1\",\"parentId\":0,\"sort\":0,\"status\":1}}', NULL, 18, '2025-12-29 13:55:37.892000');
INSERT INTO `sys_operation_log` VALUES (267, 2, 'demo', '更新地点', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766987859230}', 'OTHER', '/lostfound/location', 'update', '{\"location\":{\"id\":1,\"isPickupPoint\":0,\"name\":\"教学区\",\"parentId\":0,\"sort\":1,\"status\":1}}', NULL, 4, '2025-12-29 13:57:39.231000');
INSERT INTO `sys_operation_log` VALUES (268, 2, 'demo', '更新地点', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766988126354}', 'OTHER', '/lostfound/location', 'update', '{}', NULL, 49, '2025-12-29 14:02:06.355000');
INSERT INTO `sys_operation_log` VALUES (269, 2, 'demo', '更新地点', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766988144567}', 'OTHER', '/lostfound/location', 'update', '{}', NULL, 11, '2025-12-29 14:02:24.567000');
INSERT INTO `sys_operation_log` VALUES (270, 2, 'demo', '更新地点', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766988207622}', 'OTHER', '/lostfound/location', 'update', '{}', NULL, 30, '2025-12-29 14:03:27.623000');
INSERT INTO `sys_operation_log` VALUES (271, 2, 'demo', '更新地点', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1766988228741}', 'OTHER', '/lostfound/location', 'update', '{}', NULL, 16, '2025-12-29 14:03:48.741000');
INSERT INTO `sys_operation_log` VALUES (272, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1767062958961}', 'UPDATE', '/system/menu', 'updateMenu', '{\"request\":{\"activeIcon\":\"\",\"activePath\":\"\",\"affixTab\":false,\"badge\":\"\",\"badgeType\":\"\",\"badgeVariants\":\"destructive\",\"component\":\"\",\"hideChildrenInMenu\":false,\"hideInBreadcrumb\":false,\"hideInMenu\":true,\"hideInTab\":false,\"icon\":\"carbon:settings\",\"id\":1,\"keepAlive\":false,\"link\":\"\",\"name\":\"SystemManage\",\"parentId\":0,\"path\":\"/system\",\"permission\":\"\",\"sort\":1,\"status\":0,\"title\":\"系统管理\",\"type\":\"CATALOG\"}}', NULL, 35, '2025-12-30 10:49:18.985000');
INSERT INTO `sys_operation_log` VALUES (273, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1767062981257}', 'UPDATE', '/system/menu', 'updateMenu', '{\"request\":{\"activeIcon\":\"\",\"activePath\":\"\",\"affixTab\":false,\"badge\":\"\",\"badgeType\":\"\",\"badgeVariants\":\"destructive\",\"component\":\"\",\"hideChildrenInMenu\":false,\"hideInBreadcrumb\":false,\"hideInMenu\":false,\"hideInTab\":false,\"icon\":\"carbon:settings\",\"id\":1,\"keepAlive\":false,\"link\":\"\",\"name\":\"SystemManage\",\"parentId\":0,\"path\":\"/system\",\"permission\":\"\",\"sort\":1,\"status\":0,\"title\":\"系统管理\",\"type\":\"CATALOG\"}}', NULL, 14, '2025-12-30 10:49:41.257000');
INSERT INTO `sys_operation_log` VALUES (274, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1767063005918}', 'UPDATE', '/system/menu', 'updateMenu', '{\"request\":{\"activeIcon\":\"\",\"activePath\":\"\",\"affixTab\":false,\"badge\":\"\",\"badgeType\":\"\",\"badgeVariants\":\"\",\"component\":\"\",\"hideChildrenInMenu\":false,\"hideInBreadcrumb\":false,\"hideInMenu\":true,\"hideInTab\":false,\"icon\":\"carbon:cloud-monitoring\",\"id\":2,\"keepAlive\":false,\"link\":\"\",\"name\":\"Monitor\",\"parentId\":0,\"path\":\"/monitor\",\"permission\":\"\",\"sort\":2,\"status\":0,\"title\":\"系统监控\",\"type\":\"CATALOG\"}}', NULL, 17, '2025-12-30 10:50:05.918000');
INSERT INTO `sys_operation_log` VALUES (275, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1767063024871}', 'UPDATE', '/system/menu', 'updateMenu', '{\"request\":{\"activeIcon\":\"\",\"activePath\":\"\",\"affixTab\":false,\"badge\":\"\",\"badgeType\":\"\",\"badgeVariants\":\"\",\"component\":\"\",\"hideChildrenInMenu\":false,\"hideInBreadcrumb\":false,\"hideInMenu\":true,\"hideInTab\":false,\"icon\":\"carbon:tool-kit\",\"id\":3,\"keepAlive\":false,\"link\":\"\",\"name\":\"SystemTools\",\"parentId\":0,\"path\":\"/tool\",\"permission\":\"\",\"sort\":0,\"status\":0,\"title\":\"系统工具\",\"type\":\"CATALOG\"}}', NULL, 16, '2025-12-30 10:50:24.871000');
INSERT INTO `sys_operation_log` VALUES (276, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1767063189542}', 'UPDATE', '/system/menu', 'updateMenu', '{\"request\":{\"activeIcon\":\"\",\"activePath\":\"\",\"affixTab\":false,\"badge\":\"\",\"badgeType\":\"\",\"badgeVariants\":\"\",\"component\":\"/lostfound/home/index\",\"hideChildrenInMenu\":false,\"hideInBreadcrumb\":false,\"hideInMenu\":false,\"hideInTab\":false,\"icon\":\"lucide:home\",\"id\":282,\"keepAlive\":false,\"link\":\"\",\"name\":\"LostFoundHome\",\"parentId\":281,\"path\":\"/lostfound/home\",\"permission\":\"\",\"sort\":1,\"status\":0,\"title\":\"首页\",\"type\":\"CATALOG\"}}', NULL, 15, '2025-12-30 10:53:09.542000');
INSERT INTO `sys_operation_log` VALUES (277, 2, 'demo', '角色权限管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1767063459044}', 'UPDATE', '/system/role/permission', 'updateRolePermission', '{\"request\":{\"allocatedMenuId\":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,181,182,183,184,185,186,189,191,192,193,194,195,196,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295],\"roleId\":23}}', NULL, 130, '2025-12-30 10:57:39.047000');
INSERT INTO `sys_operation_log` VALUES (278, 2, 'demo', '角色权限管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1767063481028}', 'UPDATE', '/system/role/permission', 'updateRolePermission', '{\"request\":{\"allocatedMenuId\":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,181,182,183,184,185,186,189,191,192,193,194,195,196,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,296,297,298,299,300,301,302,303,304,305,312,315,313,316,314,317,309,318,310,319,311,320,306,321,307,322,308,323,324],\"roleId\":23}}', NULL, 76, '2025-12-30 10:58:01.028000');
INSERT INTO `sys_operation_log` VALUES (279, 2, 'demo', '角色权限管理', 1, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', NULL, 'UPDATE', '/system/role/permission', 'updateRolePermission', '{\"request\":{\"allocatedMenuId\":[1,4,5,6,7,8,9,10,11,12,13,17,152,153,154,189,191,296,297,298,299,300,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,101,102,103,104,105,106,216,163,164,165,166,167,168,181,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,186,131,132,133,134,135,136,14,15,16,219,220,24,25,202,203,204,205,206,207,192,193,316,317,318,319,320,321,322,323,324,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,218,156,157,158,159,160,161,162,198,199,200,201,210,196],\"roleId\":1}}', '超级管理员角色不允许修改权限', 11, '2025-12-30 10:58:14.442000');
INSERT INTO `sys_operation_log` VALUES (280, 2, 'demo', '角色权限管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1767063802345}', 'UPDATE', '/system/role/permission', 'updateRolePermission', '{\"request\":{\"allocatedMenuId\":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,181,182,183,184,185,186,189,191,192,193,194,195,196,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,296,297,298,299,300,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324],\"roleId\":23}}', NULL, 81, '2025-12-30 11:03:22.345000');
INSERT INTO `sys_operation_log` VALUES (281, 2, 'demo', '用户管理', 1, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', NULL, 'UPDATE', '/system/user', 'updateUserInfoById', '{\"request\":{\"avatar\":\"http://minio.zhangchuangla.cn/echopro/resource/2025/08/image/original/05bd63fe553544388eeb33f63c7e262f.jpg\",\"deptId\":1,\"email\":\"admin@qq.com\",\"gender\":1,\"nickname\":\"管理员\",\"phone\":\"18888888888\",\"postId\":6,\"roleIds\":[23],\"status\":0,\"userId\":2}}', '不允许修改自己的信息！', 0, '2025-12-30 11:06:28.248000');
INSERT INTO `sys_operation_log` VALUES (282, 2, 'demo', '用户管理', 1, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', NULL, 'UPDATE', '/system/user', 'updateUserInfoById', '{\"request\":{\"avatar\":\"http://minio.zhangchuangla.cn/echopro/resource/2025/08/image/original/05bd63fe553544388eeb33f63c7e262f.jpg\",\"deptId\":1,\"email\":\"admin@qq.com\",\"gender\":1,\"nickname\":\"管理员\",\"phone\":\"18888888888\",\"postId\":6,\"roleIds\":[23],\"status\":0,\"userId\":2}}', '不允许修改自己的信息！', 0, '2025-12-30 11:06:31.597000');
INSERT INTO `sys_operation_log` VALUES (283, 2, 'demo', '用户管理', 1, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', NULL, 'UPDATE', '/system/user', 'updateUserInfoById', '{\"request\":{\"avatar\":\"http://minio.zhangchuangla.cn/echopro/resource/2025/08/image/original/05bd63fe553544388eeb33f63c7e262f.jpg\",\"deptId\":1,\"email\":\"admin@qq.com\",\"gender\":1,\"nickname\":\"管理员\",\"phone\":\"18888888888\",\"postId\":6,\"roleIds\":[23],\"status\":0,\"userId\":2}}', '不允许修改自己的信息！', 2, '2025-12-30 11:06:52.865000');
INSERT INTO `sys_operation_log` VALUES (284, 2, 'demo', '用户管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":500,\"message\":\"密码格式不正确\",\"timestamp\":1767064057044}', 'RESET_PWD', '/system/user/resetPassword', 'resetPassword', '{\"request\":{\"password\":\"123456\",\"userId\":1}}', NULL, 0, '2025-12-30 11:07:37.044000');
INSERT INTO `sys_operation_log` VALUES (285, 2, 'demo', '用户管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":500,\"message\":\"密码格式不正确\",\"timestamp\":1767064063978}', 'RESET_PWD', '/system/user/resetPassword', 'resetPassword', '{\"request\":{\"password\":\"admin23\",\"userId\":1}}', NULL, 0, '2025-12-30 11:07:43.978000');
INSERT INTO `sys_operation_log` VALUES (286, 2, 'demo', '用户管理', 1, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', NULL, 'RESET_PWD', '/system/user/resetPassword', 'resetPassword', '{\"request\":{\"password\":\"admin123\",\"userId\":1}}', '不允许重置超级管理员密码', 77, '2025-12-30 11:07:48.377000');
INSERT INTO `sys_operation_log` VALUES (287, 2, 'demo', '用户管理', 1, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', NULL, 'UPDATE', '/system/user', 'updateUserInfoById', '{\"request\":{\"avatar\":\"http://minio.zhangchuangla.cn/echopro/resource/2025/08/image/original/05bd63fe553544388eeb33f63c7e262f.jpg\",\"deptId\":1,\"email\":\"admin@qq.com\",\"gender\":1,\"nickname\":\"管理员\",\"phone\":\"18888888888\",\"postId\":6,\"roleIds\":[23],\"status\":0,\"userId\":2}}', '不允许修改自己的信息！', 0, '2025-12-30 11:22:01.616000');
INSERT INTO `sys_operation_log` VALUES (288, 2, 'demo', '角色权限管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1767066002021}', 'UPDATE', '/system/role/permission', 'updateRolePermission', '{\"request\":{\"allocatedMenuId\":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,181,182,183,184,185,186,189,191,192,193,194,195,196,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,296,297,298,299,300,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324],\"roleId\":23}}', NULL, 68, '2025-12-30 11:40:02.021000');
INSERT INTO `sys_operation_log` VALUES (289, 1, 'admin', '角色权限管理', 1, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', NULL, 'UPDATE', '/system/role/permission', 'updateRolePermission', '{\"request\":{\"allocatedMenuId\":[1,4,5,6,7,8,9,10,11,12,13,17,152,153,154,189,191,282,283,296,297,298,299,300,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,325,101,102,103,104,105,106,216,163,164,165,166,167,168,181,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,186,131,132,133,134,135,136,14,15,16,219,220,24,25,202,203,204,205,206,207,192,193,328,327,330,326,329,316,317,318,319,320,321,322,323,324,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,218,156,157,158,159,160,161,162,198,199,200,201,210,196],\"roleId\":1}}', '超级管理员角色不允许修改权限', 8, '2025-12-30 13:40:27.973000');
INSERT INTO `sys_operation_log` VALUES (290, 1, 'admin', '角色权限管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1767073246095}', 'UPDATE', '/system/role/permission', 'updateRolePermission', '{\"request\":{\"allocatedMenuId\":[212,214,215,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295],\"roleId\":31}}', NULL, 65, '2025-12-30 13:40:46.095000');
INSERT INTO `sys_operation_log` VALUES (291, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1767074336394}', 'UPDATE', '/system/menu', 'updateMenu', '{\"request\":{\"activeIcon\":\"\",\"activePath\":\"\",\"affixTab\":false,\"badge\":\"\",\"badgeType\":\"\",\"badgeVariants\":\"\",\"component\":\"/dashboard/workspace/index\",\"hideChildrenInMenu\":false,\"hideInBreadcrumb\":false,\"hideInMenu\":false,\"hideInTab\":false,\"icon\":\"carbon:workspace\",\"id\":325,\"keepAlive\":false,\"link\":\"\",\"name\":\"Workspace\",\"parentId\":0,\"path\":\"/workspace\",\"permission\":\"\",\"sort\":99,\"status\":0,\"title\":\"工作台\",\"type\":\"MENU\"}}', NULL, 26, '2025-12-30 13:58:56.403000');
INSERT INTO `sys_operation_log` VALUES (292, 2, 'demo', '更新地点', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1767074371730}', 'OTHER', '/lostfound/location', 'update', '{\"location\":{\"id\":15,\"isPickupPoint\":1,\"name\":\"1\",\"parentId\":0,\"sort\":0,\"status\":1}}', NULL, 4, '2025-12-30 13:59:31.734000');
INSERT INTO `sys_operation_log` VALUES (293, 2, 'demo', '删除地点', 0, 'DELETE', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1767074377736}', 'OTHER', '/lostfound/location/15', 'delete', '{\"id\":15}', NULL, 17, '2025-12-30 13:59:37.736000');
INSERT INTO `sys_operation_log` VALUES (294, 2, 'demo', '管理员删除评论', 0, 'DELETE', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1767074387225}', 'OTHER', '/lostfound/comment/admin/6', 'adminDelete', '{\"id\":6}', NULL, 49, '2025-12-30 13:59:47.225000');
INSERT INTO `sys_operation_log` VALUES (295, 2, 'demo', '菜单管理', 1, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', NULL, 'INSERT', '/system/menu', 'addMenu', '{\"request\":{\"activeIcon\":\"\",\"activePath\":\"\",\"affixTab\":false,\"badge\":\"\",\"badgeType\":\"\",\"badgeVariants\":\"\",\"component\":\"\",\"hideChildrenInMenu\":false,\"hideInBreadcrumb\":false,\"hideInMenu\":false,\"hideInTab\":false,\"icon\":\"\",\"keepAlive\":false,\"link\":\"\",\"name\":\"调整积分\",\"parentId\":305,\"path\":\"\",\"permission\":\"lostfound:points:adjust\",\"sort\":1,\"status\":0,\"title\":\"调整积分\",\"type\":\"BUTTON\"}}', '菜单名称仅允许英文', 2, '2025-12-30 14:09:07.932000');
INSERT INTO `sys_operation_log` VALUES (296, 2, 'demo', '菜单管理', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1767074976461}', 'INSERT', '/system/menu', 'addMenu', '{\"request\":{\"activeIcon\":\"\",\"activePath\":\"\",\"affixTab\":false,\"badge\":\"\",\"badgeType\":\"\",\"badgeVariants\":\"\",\"component\":\"\",\"hideChildrenInMenu\":false,\"hideInBreadcrumb\":false,\"hideInMenu\":false,\"hideInTab\":false,\"icon\":\"\",\"keepAlive\":false,\"link\":\"\",\"name\":\"adjustPoints\",\"parentId\":305,\"path\":\"\",\"permission\":\"lostfound:points:adjust\",\"sort\":1,\"status\":0,\"title\":\"调整积分\",\"type\":\"BUTTON\"}}', NULL, 70, '2025-12-30 14:09:36.462000');
INSERT INTO `sys_operation_log` VALUES (297, 2, 'demo', '新增礼品', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":1,\"message\":\"操作成功\",\"timestamp\":1767098211411}', 'OTHER', '/lostfound/admin/gifts', 'createGift', '{\"gift\":{\"categoryId\":3,\"createdBy\":2,\"description\":\"\",\"exchangeCount\":0,\"giftType\":\"PHYSICAL\",\"id\":1,\"imagesJson\":[],\"name\":\"校园纪念T恤\",\"pointsCost\":100,\"sort\":0,\"status\":\"ON\",\"stock\":50,\"virtualContent\":\"\"}}', NULL, 36, '2025-12-30 20:36:51.425000');
INSERT INTO `sys_operation_log` VALUES (298, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1767098667284}', 'UPDATE', '/system/menu', 'updateMenu', '{\"request\":{\"activeIcon\":\"\",\"activePath\":\"\",\"affixTab\":false,\"badge\":\"\",\"badgeType\":\"\",\"badgeVariants\":\"\",\"component\":\"BasicLayout\",\"hideChildrenInMenu\":false,\"hideInBreadcrumb\":false,\"hideInMenu\":false,\"hideInTab\":false,\"icon\":\"lucide:settings\",\"id\":296,\"keepAlive\":false,\"link\":\"\",\"name\":\"LostFoundAdmin\",\"parentId\":0,\"path\":\"/lostfound/admin\",\"permission\":\"\",\"sort\":20,\"status\":0,\"title\":\"失物招领管理\",\"type\":\"MENU\"}}', NULL, 86, '2025-12-30 20:44:27.292000');
INSERT INTO `sys_operation_log` VALUES (299, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1767098848928}', 'UPDATE', '/system/menu', 'updateMenu', '{\"request\":{\"activeIcon\":\"\",\"activePath\":\"\",\"affixTab\":false,\"badge\":\"\",\"badgeType\":\"\",\"badgeVariants\":\"\",\"component\":\"/lostfound/admin/gifts/categories\",\"hideChildrenInMenu\":false,\"hideInBreadcrumb\":false,\"hideInMenu\":false,\"hideInTab\":false,\"icon\":\"folder\",\"id\":344,\"keepAlive\":false,\"link\":\"\",\"name\":\"GiftCategory\",\"parentId\":296,\"path\":\"/lostfound/admin/gifts/categories\",\"permission\":\"\",\"sort\":1,\"status\":0,\"title\":\"礼品分类管理\",\"type\":\"MENU\"}}', NULL, 13, '2025-12-30 20:47:28.928000');
INSERT INTO `sys_operation_log` VALUES (300, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1767099270434}', 'UPDATE', '/system/menu', 'updateMenu', '{\"request\":{\"activeIcon\":\"carbon:apps\",\"activePath\":\"\",\"affixTab\":false,\"badge\":\"\",\"badgeType\":\"\",\"badgeVariants\":\"\",\"component\":\"/lostfound/admin/gifts/categories\",\"hideChildrenInMenu\":false,\"hideInBreadcrumb\":false,\"hideInMenu\":false,\"hideInTab\":false,\"icon\":\"folder\",\"id\":344,\"keepAlive\":false,\"link\":\"\",\"name\":\"GiftCategory\",\"parentId\":0,\"path\":\"/lostfound/admin/gifts/categories\",\"permission\":\"\",\"sort\":1,\"status\":0,\"title\":\"礼品分类管理\",\"type\":\"MENU\"}}', NULL, 12, '2025-12-30 20:54:30.436000');
INSERT INTO `sys_operation_log` VALUES (301, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1767099293166}', 'UPDATE', '/system/menu', 'updateMenu', '{\"request\":{\"activeIcon\":\"carbon:apps\",\"activePath\":\"\",\"affixTab\":false,\"badge\":\"\",\"badgeType\":\"\",\"badgeVariants\":\"\",\"component\":\"/lostfound/admin/gifts/categories\",\"hideChildrenInMenu\":false,\"hideInBreadcrumb\":false,\"hideInMenu\":false,\"hideInTab\":false,\"icon\":\"carbon:align-box-middle-left\",\"id\":344,\"keepAlive\":false,\"link\":\"\",\"name\":\"GiftCategory\",\"parentId\":0,\"path\":\"/lostfound/admin/gifts/categories\",\"permission\":\"\",\"sort\":1,\"status\":0,\"title\":\"礼品分类管理\",\"type\":\"MENU\"}}', NULL, 16, '2025-12-30 20:54:53.166000');
INSERT INTO `sys_operation_log` VALUES (302, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1767099317976}', 'UPDATE', '/system/menu', 'updateMenu', '{\"request\":{\"activeIcon\":\"\",\"activePath\":\"\",\"affixTab\":false,\"badge\":\"\",\"badgeType\":\"\",\"badgeVariants\":\"\",\"component\":\"/lostfound/admin/gifts/index\",\"hideChildrenInMenu\":false,\"hideInBreadcrumb\":false,\"hideInMenu\":false,\"hideInTab\":false,\"icon\":\"carbon:global-filters\",\"id\":343,\"keepAlive\":false,\"link\":\"\",\"name\":\"GiftManage\",\"parentId\":0,\"path\":\"/lostfound/admin/gifts\",\"permission\":\"\",\"sort\":60,\"status\":0,\"title\":\"礼品管理\",\"type\":\"MENU\"}}', NULL, 12, '2025-12-30 20:55:17.977000');
INSERT INTO `sys_operation_log` VALUES (303, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1767099340562}', 'UPDATE', '/system/menu', 'updateMenu', '{\"request\":{\"activeIcon\":\"\",\"activePath\":\"\",\"affixTab\":false,\"badge\":\"\",\"badgeType\":\"\",\"badgeVariants\":\"\",\"component\":\"/lostfound/admin/exchange/index\",\"hideChildrenInMenu\":false,\"hideInBreadcrumb\":false,\"hideInMenu\":false,\"hideInTab\":false,\"icon\":\"carbon:blog\",\"id\":349,\"keepAlive\":false,\"link\":\"\",\"name\":\"ExchangeManage\",\"parentId\":0,\"path\":\"/lostfound/admin/exchange\",\"permission\":\"\",\"sort\":70,\"status\":0,\"title\":\"兑换订单\",\"type\":\"MENU\"}}', NULL, 33, '2025-12-30 20:55:40.563000');
INSERT INTO `sys_operation_log` VALUES (304, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1767101266189}', 'UPDATE', '/system/menu', 'updateMenu', '{\"request\":{\"activeIcon\":\"\",\"activePath\":\"\",\"affixTab\":false,\"badge\":\"\",\"badgeType\":\"\",\"badgeVariants\":\"\",\"component\":\"/lostfound/gifts/index\",\"hideChildrenInMenu\":false,\"hideInBreadcrumb\":false,\"hideInMenu\":false,\"hideInTab\":false,\"icon\":\"lucide:gift\",\"id\":341,\"keepAlive\":false,\"link\":\"\",\"name\":\"GiftMall\",\"parentId\":0,\"path\":\"/lostfound/gifts\",\"permission\":\"\",\"sort\":1,\"status\":0,\"title\":\"礼品商城\",\"type\":\"MENU\"}}', NULL, 11, '2025-12-30 21:27:46.189000');
INSERT INTO `sys_operation_log` VALUES (305, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1767101317001}', 'UPDATE', '/system/menu', 'updateMenu', '{\"request\":{\"activeIcon\":\"\",\"activePath\":\"\",\"affixTab\":false,\"badge\":\"\",\"badgeType\":\"\",\"badgeVariants\":\"\",\"component\":\"/lostfound/me/exchange\",\"hideChildrenInMenu\":false,\"hideInBreadcrumb\":false,\"hideInMenu\":false,\"hideInTab\":false,\"icon\":\"carbon:gradient\",\"id\":342,\"keepAlive\":false,\"link\":\"\",\"name\":\"MyExchange\",\"parentId\":211,\"path\":\"/lostfound/me/exchange\",\"permission\":\"\",\"sort\":30,\"status\":0,\"title\":\"我的兑换\",\"type\":\"MENU\"}}', NULL, 21, '2025-12-30 21:28:37.001000');
INSERT INTO `sys_operation_log` VALUES (306, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1767101817450}', 'UPDATE', '/system/menu', 'updateMenu', '{\"request\":{\"activeIcon\":\"\",\"activePath\":\"\",\"affixTab\":false,\"badge\":\"\",\"badgeType\":\"\",\"badgeVariants\":\"\",\"component\":\"BasicLayout\",\"hideChildrenInMenu\":false,\"hideInBreadcrumb\":false,\"hideInMenu\":true,\"hideInTab\":false,\"icon\":\"lucide:settings\",\"id\":296,\"keepAlive\":false,\"link\":\"\",\"name\":\"LostFoundAdmin\",\"parentId\":0,\"path\":\"/lostfound/admin\",\"permission\":\"\",\"sort\":20,\"status\":0,\"title\":\"失物招领管理\",\"type\":\"MENU\"}}', NULL, 10, '2025-12-30 21:36:57.450000');
INSERT INTO `sys_operation_log` VALUES (307, 9, '11134', '发布帖子', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":12,\"message\":\"操作成功\",\"timestamp\":1767156665379}', 'OTHER', '/lostfound/post', 'create', '{\"post\":{\"categoryId\":1,\"commentCount\":0,\"contactInfo\":\"\",\"createdBy\":9,\"description\":\"11\",\"favCount\":0,\"id\":12,\"imagesJson\":[],\"isRecommend\":false,\"isTop\":false,\"locationId\":1,\"occurTime\":\"2025-12-31 00:03\",\"postType\":\"LOST\",\"status\":\"PENDING\",\"title\":\"黑色钱包\",\"viewCount\":0}}', NULL, 41, '2025-12-31 12:51:05.399000');
INSERT INTO `sys_operation_log` VALUES (308, 9, '11134', '添加收藏', 1, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', NULL, 'OTHER', '/lostfound/favorite/10', 'addFavorite', '{\"postId\":10}', '您已收藏过该帖子', 11, '2025-12-31 12:54:49.007000');
INSERT INTO `sys_operation_log` VALUES (309, 9, '11134', '添加收藏', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1767156891082}', 'OTHER', '/lostfound/favorite/9', 'addFavorite', '{\"postId\":9}', NULL, 30, '2025-12-31 12:54:51.082000');
INSERT INTO `sys_operation_log` VALUES (310, 9, '11134', '添加收藏', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1767156894217}', 'OTHER', '/lostfound/favorite/8', 'addFavorite', '{\"postId\":8}', NULL, 40, '2025-12-31 12:54:54.218000');
INSERT INTO `sys_operation_log` VALUES (311, 9, '11134', '发布帖子', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":13,\"message\":\"操作成功\",\"timestamp\":1767157128010}', 'OTHER', '/lostfound/post', 'create', '{\"post\":{\"categoryId\":7,\"commentCount\":0,\"contactInfo\":\"\",\"createdBy\":9,\"description\":\"这是一个测试手机，黑色外壳，屏幕有轻微划痕\",\"favCount\":0,\"id\":13,\"imagesJson\":[],\"isRecommend\":false,\"isTop\":false,\"locationId\":5,\"occurTime\":\"2025-12-30 12:57\",\"postType\":\"LOST\",\"status\":\"PENDING\",\"title\":\"测试手机\",\"viewCount\":0}}', NULL, 21, '2025-12-31 12:58:48.011000');
INSERT INTO `sys_operation_log` VALUES (312, 9, '11134', '发布帖子', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":14,\"message\":\"操作成功\",\"timestamp\":1767158051344}', 'OTHER', '/lostfound/post', 'create', '{\"post\":{\"categoryId\":7,\"commentCount\":0,\"contactInfo\":\"\",\"createdBy\":9,\"description\":\"这是一个测试钱包，棕色皮质，里面有学生证和一些现金\",\"favCount\":0,\"id\":14,\"imagesJson\":[\"/uploads/posts/2025/12/31/a0ba5b1415124363b1858ef1d35ba4af.png\"],\"isRecommend\":false,\"isTop\":false,\"locationId\":5,\"occurTime\":\"2025-12-31 13:12\",\"postType\":\"LOST\",\"status\":\"PENDING\",\"title\":\"测试钱包\",\"viewCount\":0}}', NULL, 37, '2025-12-31 13:14:11.362000');
INSERT INTO `sys_operation_log` VALUES (313, 2, 'demo', '审核通过帖子', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1767160503514}', 'OTHER', '/lostfound/post/14/approve', 'approve', '{\"id\":14}', NULL, 23, '2025-12-31 13:55:03.517000');
INSERT INTO `sys_operation_log` VALUES (314, 9, '11134', '兑换礼品', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":1,\"message\":\"操作成功\",\"timestamp\":1767161262350}', 'OTHER', '/lostfound/exchange', 'exchangeGift', '{\"params\":{\"giftId\":1,\"quantity\":1,\"receiverName\":\"11\",\"receiverPhone\":\"11111\",\"receiverAddress\":\"1111\"}}', NULL, 31, '2025-12-31 14:07:42.351000');
INSERT INTO `sys_operation_log` VALUES (315, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1767166821289}', 'UPDATE', '/system/menu', 'updateMenu', '{\"request\":{\"activeIcon\":\"\",\"activePath\":\"\",\"affixTab\":false,\"badge\":\"\",\"badgeType\":\"\",\"badgeVariants\":\"\",\"component\":\"BasicLayout\",\"hideChildrenInMenu\":false,\"hideInBreadcrumb\":false,\"hideInMenu\":false,\"hideInTab\":false,\"icon\":\"lucide:settings\",\"id\":296,\"keepAlive\":false,\"link\":\"\",\"name\":\"LostFoundAdmin\",\"parentId\":0,\"path\":\"/lostfound/admin\",\"permission\":\"\",\"sort\":20,\"status\":0,\"title\":\"失物招领管理\",\"type\":\"MENU\"}}', NULL, 44, '2025-12-31 15:40:21.302000');
INSERT INTO `sys_operation_log` VALUES (316, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1767166857365}', 'UPDATE', '/system/menu', 'updateMenu', '{\"request\":{\"activeIcon\":\"\",\"activePath\":\"\",\"affixTab\":false,\"badge\":\"\",\"badgeType\":\"\",\"badgeVariants\":\"\",\"component\":\"BasicLayout\",\"hideChildrenInMenu\":false,\"hideInBreadcrumb\":false,\"hideInMenu\":true,\"hideInTab\":false,\"icon\":\"lucide:settings\",\"id\":296,\"keepAlive\":false,\"link\":\"\",\"name\":\"LostFoundAdmin\",\"parentId\":0,\"path\":\"/lostfound/admin\",\"permission\":\"\",\"sort\":20,\"status\":0,\"title\":\"失物招领管理\",\"type\":\"MENU\"}}', NULL, 18, '2025-12-31 15:40:57.365000');
INSERT INTO `sys_operation_log` VALUES (317, 2, 'demo', '公告管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"修改成功\",\"timestamp\":1767167478417}', 'UPDATE', '/system/notice', 'edit', '{\"request\":{\"id\":2,\"noticeContent\":\"<p>在认领物品时，请核实对方身份，不要轻易转账或提供个人敏感信息。</p>\",\"noticeTitle\":\"请勿轻信陌生人，谨防诈骗\",\"noticeType\":\"1\"}}', NULL, 108, '2025-12-31 15:51:18.419000');
INSERT INTO `sys_operation_log` VALUES (318, 2, 'demo', '公告管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"修改成功\",\"timestamp\":1767167485891}', 'UPDATE', '/system/notice', 'edit', '{\"request\":{\"id\":2,\"noticeContent\":\"<p>在认领物品时，请核实对方身份，不要轻易转账或提供个人敏感信息。</p>\",\"noticeTitle\":\"请勿轻信陌生人，谨防诈骗\",\"noticeType\":\"1\"}}', NULL, 5, '2025-12-31 15:51:25.893000');
INSERT INTO `sys_operation_log` VALUES (319, 2, 'demo', '公告管理', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"新增成功\",\"timestamp\":1767167496133}', 'INSERT', '/system/notice', 'add', '{\"request\":{\"noticeContent\":\"<p>1</p>\",\"noticeTitle\":\"1\",\"noticeType\":\"1\"}}', NULL, 16, '2025-12-31 15:51:36.136000');
INSERT INTO `sys_operation_log` VALUES (320, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1767167628206}', 'UPDATE', '/system/menu', 'updateMenu', '{\"request\":{\"activeIcon\":\"\",\"activePath\":\"\",\"affixTab\":false,\"badge\":\"\",\"badgeType\":\"\",\"badgeVariants\":\"\",\"component\":\"/system/notice/index\",\"hideChildrenInMenu\":false,\"hideInBreadcrumb\":false,\"hideInMenu\":false,\"hideInTab\":false,\"icon\":\"carbon:notification\",\"id\":189,\"keepAlive\":false,\"link\":\"\",\"name\":\"noticeManage\",\"parentId\":1,\"path\":\"/system/notice\",\"permission\":\"\",\"sort\":1,\"status\":0,\"title\":\"系统公告管理\",\"type\":\"MENU\"}}', NULL, 15, '2025-12-31 15:53:48.207000');
INSERT INTO `sys_operation_log` VALUES (321, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1767167847103}', 'UPDATE', '/system/menu', 'updateMenu', '{\"request\":{\"activeIcon\":\"\",\"activePath\":\"\",\"affixTab\":false,\"badge\":\"\",\"badgeType\":\"\",\"badgeVariants\":\"\",\"component\":\"BasicLayout\",\"hideChildrenInMenu\":false,\"hideInBreadcrumb\":false,\"hideInMenu\":false,\"hideInTab\":false,\"icon\":\"lucide:settings\",\"id\":296,\"keepAlive\":false,\"link\":\"\",\"name\":\"LostFoundAdmin\",\"parentId\":0,\"path\":\"/lostfound/admin\",\"permission\":\"\",\"sort\":20,\"status\":0,\"title\":\"失物招领管理\",\"type\":\"MENU\"}}', NULL, 32, '2025-12-31 15:57:27.104000');
INSERT INTO `sys_operation_log` VALUES (322, 2, 'demo', '新增礼品', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":2,\"message\":\"操作成功\",\"timestamp\":1767168869681}', 'OTHER', '/lostfound/admin/gifts', 'createGift', '{\"gift\":{\"categoryId\":2,\"createdBy\":2,\"description\":\"1\",\"exchangeCount\":0,\"giftType\":\"PHYSICAL\",\"id\":2,\"imagesJson\":[\"/uploads/posts/2025/12/31/0841b163cc9d444e806c43409054bd92.jpg\"],\"name\":\"1\",\"pointsCost\":12,\"sort\":1,\"status\":\"ON\",\"stock\":12,\"virtualContent\":\"\"}}', NULL, 38, '2025-12-31 16:14:29.692000');
INSERT INTO `sys_operation_log` VALUES (323, 2, 'demo', '更新礼品状态', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1767168877467}', 'OTHER', '/lostfound/admin/gifts/2/status', 'updateGiftStatus', '{\"id\":2,\"status\":\"OFF\"}', NULL, 14, '2025-12-31 16:14:37.468000');
INSERT INTO `sys_operation_log` VALUES (324, 2, 'demo', '更新礼品状态', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1767168878810}', 'OTHER', '/lostfound/admin/gifts/2/status', 'updateGiftStatus', '{\"id\":2,\"status\":\"ON\"}', NULL, 14, '2025-12-31 16:14:38.810000');
INSERT INTO `sys_operation_log` VALUES (325, 2, 'demo', '删除礼品', 0, 'DELETE', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1767168882216}', 'OTHER', '/lostfound/admin/gifts/1', 'deleteGift', '{\"id\":1}', NULL, 12, '2025-12-31 16:14:42.217000');
INSERT INTO `sys_operation_log` VALUES (326, 9, '11134', '发布帖子', 1, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', NULL, 'OTHER', '/lostfound/post', 'create', '{\"post\":{\"categoryId\":7,\"contactInfo\":\"\",\"description\":\"丢失了一个钱包，联系我13812345678\",\"imagesJson\":[],\"locationId\":5,\"occurTime\":\"2026-01-05 10:51\",\"postType\":\"LOST\",\"title\":\"测试物品\"}}', '内容包含敏感信息', 8, '2026-01-06 10:52:21.987000');
INSERT INTO `sys_operation_log` VALUES (327, 9, '11134', '发布帖子', 1, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', NULL, 'OTHER', '/lostfound/post', 'create', '{\"post\":{\"categoryId\":7,\"contactInfo\":\"\",\"description\":\"丢失了一个钱包，QQ号123456789联系我\",\"imagesJson\":[],\"locationId\":5,\"occurTime\":\"2026-01-05 10:51\",\"postType\":\"LOST\",\"title\":\"测试物品\"}}', '内容包含敏感信息', 5, '2026-01-06 10:53:28.230000');
INSERT INTO `sys_operation_log` VALUES (328, 9, '11134', '发布帖子', 1, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', NULL, 'OTHER', '/lostfound/post', 'create', '{\"post\":{\"categoryId\":7,\"contactInfo\":\"\",\"description\":\"丢失了一个钱包，加微信abc123456联系我\",\"imagesJson\":[],\"locationId\":5,\"occurTime\":\"2026-01-05 10:51\",\"postType\":\"LOST\",\"title\":\"测试物品\"}}', '内容包含敏感信息', 7, '2026-01-06 10:53:53.462000');
INSERT INTO `sys_operation_log` VALUES (329, 9, '11134', '发布帖子', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":15,\"message\":\"操作成功\",\"timestamp\":1767668050586}', 'OTHER', '/lostfound/post', 'create', '{\"post\":{\"categoryId\":7,\"commentCount\":0,\"contactInfo\":\"\",\"createdBy\":9,\"description\":\"在图书馆丢失一把钥匙，银色金属材质，上面有一个小熊挂件\",\"favCount\":0,\"id\":15,\"imagesJson\":[],\"isRecommend\":false,\"isTop\":false,\"locationId\":5,\"occurTime\":\"2026-01-05 10:51\",\"postType\":\"LOST\",\"status\":\"PENDING\",\"title\":\"测试物品\",\"viewCount\":0}}', NULL, 21, '2026-01-06 10:54:10.588000');
INSERT INTO `sys_operation_log` VALUES (330, 9, '11134', '兑换礼品', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":2,\"message\":\"操作成功\",\"timestamp\":1767668344349}', 'OTHER', '/lostfound/exchange', 'exchangeGift', '{\"params\":{\"giftId\":2,\"quantity\":1,\"receiverName\":\"张三\",\"receiverPhone\":\"13800138000\",\"receiverAddress\":\"教学楼A座101室\"}}', NULL, 43, '2026-01-06 10:59:04.349000');
INSERT INTO `sys_operation_log` VALUES (331, 9, '11134', '兑换礼品', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":3,\"message\":\"操作成功\",\"timestamp\":1767668499531}', 'OTHER', '/lostfound/exchange', 'exchangeGift', '{\"params\":{\"giftId\":2,\"quantity\":1,\"receiverName\":\"1\",\"receiverPhone\":\"1\",\"receiverAddress\":\"1\"}}', NULL, 31, '2026-01-06 11:01:39.531000');
INSERT INTO `sys_operation_log` VALUES (332, 2, 'demo', '审核通过帖子', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1767669505521}', 'OTHER', '/lostfound/post/15/approve', 'approve', '{\"id\":15}', NULL, 14, '2026-01-06 11:18:25.521000');
INSERT INTO `sys_operation_log` VALUES (333, 2, 'demo', '公告管理', 1, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', NULL, 'INSERT', '/system/notice', 'add', '{\"request\":{\"noticeContent\":\"<p>1</p>\",\"noticeTitle\":\"1\",\"noticeType\":\"1\"}}', '公告标题已存在', 8, '2026-01-06 11:28:26.077000');
INSERT INTO `sys_operation_log` VALUES (334, 2, 'demo', '公告管理', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"新增成功\",\"timestamp\":1767670110022}', 'INSERT', '/system/notice', 'add', '{\"request\":{\"noticeContent\":\"<p>1</p>\",\"noticeTitle\":\"2\",\"noticeType\":\"1\"}}', NULL, 60, '2026-01-06 11:28:30.022000');
INSERT INTO `sys_operation_log` VALUES (335, 9, '11134', '发布帖子', 1, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', NULL, 'OTHER', '/lostfound/post', 'create', '{\"post\":{\"categoryId\":7,\"contactInfo\":\"\",\"description\":\"1111111111\",\"imagesJson\":[\"/uploads/posts/2026/01/06/19a76ed608be4d80a3e5fc5557380a2f.png\"],\"locationId\":1,\"occurTime\":\"2026-01-06 00:07\",\"postType\":\"LOST\",\"title\":\"黑色钱包\"}}', '内容包含敏感信息', 8, '2026-01-06 11:48:08.685000');
INSERT INTO `sys_operation_log` VALUES (336, 9, '11134', '发送私信', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":4,\"message\":\"操作成功\",\"timestamp\":1767679495925}', 'OTHER', '/lostfound/message', 'sendMessage', '{\"message\":{\"content\":\"你好\",\"createTime\":1767679495909,\"id\":4,\"msgType\":\"TEXT\",\"receiverId\":9,\"senderId\":9,\"threadId\":2}}', NULL, 20, '2026-01-06 14:04:55.933000');
INSERT INTO `sys_operation_log` VALUES (337, 8, '2450610521', '发布帖子', 1, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', NULL, 'OTHER', '/lostfound/post', 'create', '{\"post\":{\"categoryId\":8,\"contactInfo\":\"11111111111\",\"description\":\"111111111111\",\"featureTokens\":[],\"imagesJson\":[\"/uploads/posts/2026/01/17/9dd0cf91ffe242649f139bf0cfa4fad4.png\"],\"locationId\":1,\"occurTime\":\"2026-01-17 00:08\",\"postType\":\"LOST\",\"rewardAmount\":12,\"rewardDesc\":\"\",\"title\":\"11\"}}', '内容包含敏感信息', 11, '2026-01-17 15:42:38.130000');
INSERT INTO `sys_operation_log` VALUES (338, 8, '2450610521', '发布帖子', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":16,\"message\":\"操作成功\",\"timestamp\":1768635817948}', 'OTHER', '/lostfound/post', 'create', '{\"post\":{\"categoryId\":8,\"commentCount\":0,\"contactInfo\":\"18331969791\",\"createdBy\":8,\"description\":\"在西南角地方丢掉的 找到的人请与我联系\",\"favCount\":0,\"featureTokens\":[],\"id\":16,\"imagesJson\":[\"/uploads/posts/2026/01/17/9dd0cf91ffe242649f139bf0cfa4fad4.png\"],\"isRecommend\":false,\"isTop\":false,\"locationId\":1,\"occurTime\":\"2026-01-17 00:08\",\"postType\":\"LOST\",\"rewardAmount\":12,\"rewardDesc\":\"\",\"rewardStatus\":\"HOLD\",\"status\":\"PENDING\",\"title\":\"手表\",\"viewCount\":0}}', NULL, 23, '2026-01-17 15:43:37.953000');
INSERT INTO `sys_operation_log` VALUES (339, 2, 'demo', '订单发货', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1768635978852}', 'OTHER', '/lostfound/admin/exchange/orders/3/ship', 'shipOrder', '{\"id\":3,\"params\":{\"trackingNo\":\"111111\"}}', NULL, 56, '2026-01-17 15:46:18.852000');
INSERT INTO `sys_operation_log` VALUES (340, 2, 'demo', '审核通过帖子', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1768637015190}', 'OTHER', '/lostfound/post/16/approve', 'approve', '{\"id\":16}', NULL, 21, '2026-01-17 16:03:35.190000');
INSERT INTO `sys_operation_log` VALUES (341, 9, '11134', '发布帖子', 1, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', NULL, 'OTHER', '/lostfound/post', 'create', '{\"post\":{\"categoryId\":2,\"contactInfo\":\"183319699999\",\"description\":\"物品很多111111\",\"featureTokens\":[],\"imagesJson\":[\"/uploads/posts/2026/02/02/bddf0218f35643bfa09f21033d3c6cc9.png\",\"/uploads/posts/2026/02/02/0dd2ebfe0aee4a16a3f7ddb636a3158d.png\",\"/uploads/posts/2026/02/02/30665934ea42441895464ef3cc1ff2d0.png\",\"/uploads/posts/2026/02/02/bcfff067ea0a4a0cbaa339376dd9e348.png\",\"/uploads/posts/2026/02/02/a02ff7b857634137bd308a5b4a6a37fc.png\"],\"locationId\":1,\"occurTime\":\"2026-02-02 00:02\",\"postType\":\"LOST\",\"rewardAmount\":100,\"rewardDesc\":\"\",\"title\":\"钱包\"}}', '内容包含敏感信息', 8, '2026-02-02 10:28:16.256000');
INSERT INTO `sys_operation_log` VALUES (342, 9, '11134', '发布帖子', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":17,\"message\":\"操作成功\",\"timestamp\":1769999311580}', 'OTHER', '/lostfound/post', 'create', '{\"post\":{\"categoryId\":2,\"commentCount\":0,\"contactInfo\":\"183319699999\",\"createdBy\":9,\"description\":\"物品很多物品很多物品很多\",\"favCount\":0,\"featureTokens\":[],\"id\":17,\"imagesJson\":[\"/uploads/posts/2026/02/02/bddf0218f35643bfa09f21033d3c6cc9.png\",\"/uploads/posts/2026/02/02/0dd2ebfe0aee4a16a3f7ddb636a3158d.png\",\"/uploads/posts/2026/02/02/30665934ea42441895464ef3cc1ff2d0.png\",\"/uploads/posts/2026/02/02/bcfff067ea0a4a0cbaa339376dd9e348.png\",\"/uploads/posts/2026/02/02/a02ff7b857634137bd308a5b4a6a37fc.png\"],\"isRecommend\":false,\"isTop\":false,\"locationId\":1,\"occurTime\":\"2026-02-02 00:02\",\"postType\":\"LOST\",\"rewardAmount\":100,\"rewardDesc\":\"\",\"rewardStatus\":\"HOLD\",\"status\":\"PENDING\",\"title\":\"钱包\",\"viewCount\":0}}', NULL, 17, '2026-02-02 10:28:31.582000');
INSERT INTO `sys_operation_log` VALUES (343, 2, 'demo', '添加收藏', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1769999706523}', 'OTHER', '/lostfound/favorite/17', 'addFavorite', '{\"postId\":17}', NULL, 19, '2026-02-02 10:35:06.523000');
INSERT INTO `sys_operation_log` VALUES (344, 2, 'demo', '取消收藏', 0, 'DELETE', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1769999707776}', 'OTHER', '/lostfound/favorite/17', 'removeFavorite', '{\"postId\":17}', NULL, 11, '2026-02-02 10:35:07.776000');
INSERT INTO `sys_operation_log` VALUES (345, 2, 'demo', '发送私信', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":5,\"message\":\"操作成功\",\"timestamp\":1770000051930}', 'OTHER', '/lostfound/message', 'sendMessage', '{\"message\":{\"content\":\"你好\",\"createTime\":1770000051882,\"id\":5,\"msgType\":\"TEXT\",\"receiverId\":9,\"senderId\":2,\"threadId\":3}}', NULL, 50, '2026-02-02 10:40:51.935000');
INSERT INTO `sys_operation_log` VALUES (346, 2, 'demo', '菜单管理', 0, 'PUT', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1770000238051}', 'UPDATE', '/system/menu', 'updateMenu', '{\"request\":{\"activeIcon\":\"\",\"activePath\":\"\",\"affixTab\":false,\"badge\":\"\",\"badgeType\":\"\",\"badgeVariants\":\"\",\"component\":\"/lostfound/admin/dashboard/index\",\"hideChildrenInMenu\":false,\"hideInBreadcrumb\":false,\"hideInMenu\":true,\"hideInTab\":false,\"icon\":\"lucide:layout-dashboard\",\"id\":297,\"keepAlive\":false,\"link\":\"\",\"name\":\"LostFoundDashboard\",\"parentId\":0,\"path\":\"/lostfound/admin/dashboard\",\"permission\":\"lostfound:dashboard:view\",\"sort\":1,\"status\":0,\"title\":\"数据概览\",\"type\":\"MENU\"}}', NULL, 16, '2026-02-02 10:43:58.054000');
INSERT INTO `sys_operation_log` VALUES (347, 2, 'demo', '审核通过帖子', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1770000487748}', 'OTHER', '/lostfound/post/17/approve', 'approve', '{\"id\":17}', NULL, 34, '2026-02-02 10:48:07.748000');
INSERT INTO `sys_operation_log` VALUES (348, 9, '11134', '添加收藏', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1770000572731}', 'OTHER', '/lostfound/favorite/17', 'addFavorite', '{\"postId\":17}', NULL, 16, '2026-02-02 10:49:32.731000');
INSERT INTO `sys_operation_log` VALUES (349, 9, '11134', '取消收藏', 0, 'DELETE', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1770001158720}', 'OTHER', '/lostfound/favorite/17', 'removeFavorite', '{\"postId\":17}', NULL, 13, '2026-02-02 10:59:18.720000');
INSERT INTO `sys_operation_log` VALUES (350, 9, '11134', '添加收藏', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1770001160510}', 'OTHER', '/lostfound/favorite/17', 'addFavorite', '{\"postId\":17}', NULL, 14, '2026-02-02 10:59:20.510000');
INSERT INTO `sys_operation_log` VALUES (351, 9, '11134', '发布帖子', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":18,\"message\":\"操作成功\",\"timestamp\":1770003174998}', 'OTHER', '/lostfound/post', 'create', '{\"post\":{\"categoryId\":1,\"commentCount\":0,\"contactInfo\":\"18331969999\",\"createdBy\":9,\"description\":\"你这页“发起认领”按钮是有的，但有两个前提条件\",\"favCount\":0,\"featureTokens\":[],\"id\":18,\"imagesJson\":[\"/uploads/posts/2026/02/02/dac6893513e34b0d8dce7f7c9e74b219.png\"],\"isRecommend\":false,\"isTop\":false,\"locationId\":5,\"occurTime\":\"2026-02-02 00:03\",\"postType\":\"FOUND\",\"rewardDesc\":\"\",\"rewardStatus\":\"NONE\",\"status\":\"PENDING\",\"storagePlace\":\"14\",\"title\":\"钱包\",\"viewCount\":0}}', NULL, 33, '2026-02-02 11:32:54.998000');
INSERT INTO `sys_operation_log` VALUES (352, 2, 'demo', '审核通过帖子', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1770003192098}', 'OTHER', '/lostfound/post/18/approve', 'approve', '{\"id\":18}', NULL, 36, '2026-02-02 11:33:12.098000');
INSERT INTO `sys_operation_log` VALUES (353, 9, '11134', '发起认领', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":3,\"message\":\"操作成功\",\"timestamp\":1770003306190}', 'OTHER', '/lostfound/claim', 'create', '{\"claim\":{\"autoMatchScore\":0,\"claimantId\":9,\"createTime\":1770003306178,\"featureAnswers\":[],\"id\":3,\"postId\":18,\"posterId\":9,\"status\":\"APPLIED\"}}', NULL, 15, '2026-02-02 11:35:06.198000');
INSERT INTO `sys_operation_log` VALUES (354, 2, 'demo', '管理员审核通过认领', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1770003490703}', 'OTHER', '/lostfound/claim/admin/3/approve', 'adminApprove', '{\"id\":3}', NULL, 21, '2026-02-02 11:38:10.703000');
INSERT INTO `sys_operation_log` VALUES (355, 9, '11134', '创建交接', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"data\":2,\"message\":\"操作成功\",\"timestamp\":1770003535140}', 'OTHER', '/lostfound/handover', 'create', '{\"handover\":{\"claimId\":3,\"createTime\":1770003535084,\"fromUserId\":9,\"handoverTime\":1769961840000,\"id\":2,\"location\":\"11\",\"status\":\"PENDING\",\"toUserId\":9}}', NULL, 61, '2026-02-02 11:38:55.146000');
INSERT INTO `sys_operation_log` VALUES (356, 9, '11134', '确认交接', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1770003949072}', 'OTHER', '/lostfound/handover/2/confirm', 'confirm', '{\"id\":2}', NULL, 16, '2026-02-02 11:45:49.072000');
INSERT INTO `sys_operation_log` VALUES (357, 2, 'demo', '管理员强制完成认领', 0, 'POST', '0:0:0:0:0:0:0:1', 'IPv6不支持查询', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1770004218486}', 'OTHER', '/lostfound/claim/admin/3/complete', 'adminComplete', '{\"id\":3}', NULL, 16, '2026-02-02 11:50:18.486000');

-- ----------------------------
-- Table structure for sys_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_post`;
CREATE TABLE `sys_post`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
  `post_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '岗位编码',
  `post_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '岗位名称',
  `sort` int NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint(1) NULL DEFAULT 0 COMMENT '状态(0-正常,1-停用)',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_by` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '创建人',
  `update_by` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '更新人',
  `remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '岗位表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_post
-- ----------------------------
INSERT INTO `sys_post` VALUES (6, 'PM', '产品经理', 0, 0, '2025-08-14 09:55:16', '2025-08-14 09:55:16', NULL, NULL, NULL);

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `role_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色名',
  `role_key` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '角色权限字符串',
  `sort` int NOT NULL DEFAULT 0 COMMENT '角色排序',
  `status` tinyint(1) NULL DEFAULT 0 COMMENT '状态 0正常 1禁用',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '创建人',
  `update_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '更新人',
  `remark` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `role_name`(`role_name` ASC) USING BTREE,
  UNIQUE INDEX `role_key`(`role_key` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 32 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '超级管理员', 'super_admin', 0, 0, '2025-02-23 21:55:13', '2025-08-16 14:21:32', NULL, NULL, '超级管理员拥有系统全部权限');
INSERT INTO `sys_role` VALUES (23, '管理员1', 'demo', 0, 0, '2025-08-16 14:17:13', '2025-12-11 12:53:08', 'admin', 'demo', '拥有系统权限信息');
INSERT INTO `sys_role` VALUES (29, '测试用户', 'test_user', 0, 0, '2025-08-16 22:15:09', '2025-08-16 22:15:09', 'admin', NULL, '这是一个测试用户');
INSERT INTO `sys_role` VALUES (30, '管理员', 'admindemo', 1, 0, '2025-12-11 11:52:48', '2025-12-11 11:52:48', '2450610522', NULL, NULL);
INSERT INTO `sys_role` VALUES (31, '用户', '222', 0, 0, '2025-12-11 12:53:54', '2025-12-11 12:53:54', 'demo', NULL, NULL);

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  `permission_type` int NULL DEFAULT 1 COMMENT '权限类型',
  UNIQUE INDEX `uk_roleid_menuid`(`role_id` ASC, `menu_id` ASC) USING BTREE COMMENT '角色菜单唯一索引'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色和菜单关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES (1, 1, 1);
INSERT INTO `sys_role_menu` VALUES (1, 4, 1);
INSERT INTO `sys_role_menu` VALUES (1, 5, 1);
INSERT INTO `sys_role_menu` VALUES (1, 6, 1);
INSERT INTO `sys_role_menu` VALUES (1, 7, 1);
INSERT INTO `sys_role_menu` VALUES (1, 8, 1);
INSERT INTO `sys_role_menu` VALUES (1, 9, 1);
INSERT INTO `sys_role_menu` VALUES (1, 10, 1);
INSERT INTO `sys_role_menu` VALUES (1, 11, 1);
INSERT INTO `sys_role_menu` VALUES (1, 12, 1);
INSERT INTO `sys_role_menu` VALUES (1, 13, 1);
INSERT INTO `sys_role_menu` VALUES (1, 17, 1);
INSERT INTO `sys_role_menu` VALUES (1, 152, 1);
INSERT INTO `sys_role_menu` VALUES (1, 153, 1);
INSERT INTO `sys_role_menu` VALUES (1, 154, 1);
INSERT INTO `sys_role_menu` VALUES (1, 189, 1);
INSERT INTO `sys_role_menu` VALUES (1, 191, 1);
INSERT INTO `sys_role_menu` VALUES (1, 221, 1);
INSERT INTO `sys_role_menu` VALUES (1, 222, 1);
INSERT INTO `sys_role_menu` VALUES (1, 223, 1);
INSERT INTO `sys_role_menu` VALUES (1, 224, 1);
INSERT INTO `sys_role_menu` VALUES (1, 225, 1);
INSERT INTO `sys_role_menu` VALUES (1, 226, 1);
INSERT INTO `sys_role_menu` VALUES (1, 227, 1);
INSERT INTO `sys_role_menu` VALUES (1, 228, 1);
INSERT INTO `sys_role_menu` VALUES (1, 229, 1);
INSERT INTO `sys_role_menu` VALUES (1, 230, 1);
INSERT INTO `sys_role_menu` VALUES (1, 231, 1);
INSERT INTO `sys_role_menu` VALUES (1, 232, 1);
INSERT INTO `sys_role_menu` VALUES (1, 237, 1);
INSERT INTO `sys_role_menu` VALUES (1, 238, 1);
INSERT INTO `sys_role_menu` VALUES (1, 239, 1);
INSERT INTO `sys_role_menu` VALUES (1, 240, 1);
INSERT INTO `sys_role_menu` VALUES (1, 241, 1);
INSERT INTO `sys_role_menu` VALUES (1, 242, 1);
INSERT INTO `sys_role_menu` VALUES (1, 243, 1);
INSERT INTO `sys_role_menu` VALUES (1, 244, 1);
INSERT INTO `sys_role_menu` VALUES (1, 245, 1);
INSERT INTO `sys_role_menu` VALUES (1, 246, 1);
INSERT INTO `sys_role_menu` VALUES (1, 247, 1);
INSERT INTO `sys_role_menu` VALUES (1, 248, 1);
INSERT INTO `sys_role_menu` VALUES (1, 249, 1);
INSERT INTO `sys_role_menu` VALUES (1, 250, 1);
INSERT INTO `sys_role_menu` VALUES (1, 251, 1);
INSERT INTO `sys_role_menu` VALUES (1, 252, 1);
INSERT INTO `sys_role_menu` VALUES (1, 253, 1);
INSERT INTO `sys_role_menu` VALUES (1, 254, 1);
INSERT INTO `sys_role_menu` VALUES (1, 255, 1);
INSERT INTO `sys_role_menu` VALUES (1, 256, 1);
INSERT INTO `sys_role_menu` VALUES (1, 257, 1);
INSERT INTO `sys_role_menu` VALUES (1, 258, 1);
INSERT INTO `sys_role_menu` VALUES (1, 259, 1);
INSERT INTO `sys_role_menu` VALUES (1, 260, 1);
INSERT INTO `sys_role_menu` VALUES (1, 261, 1);
INSERT INTO `sys_role_menu` VALUES (1, 262, 1);
INSERT INTO `sys_role_menu` VALUES (1, 263, 1);
INSERT INTO `sys_role_menu` VALUES (1, 264, 1);
INSERT INTO `sys_role_menu` VALUES (1, 265, 1);
INSERT INTO `sys_role_menu` VALUES (1, 266, 1);
INSERT INTO `sys_role_menu` VALUES (1, 267, 1);
INSERT INTO `sys_role_menu` VALUES (1, 268, 1);
INSERT INTO `sys_role_menu` VALUES (1, 269, 1);
INSERT INTO `sys_role_menu` VALUES (1, 270, 1);
INSERT INTO `sys_role_menu` VALUES (1, 271, 1);
INSERT INTO `sys_role_menu` VALUES (1, 272, 1);
INSERT INTO `sys_role_menu` VALUES (1, 273, 1);
INSERT INTO `sys_role_menu` VALUES (1, 274, 1);
INSERT INTO `sys_role_menu` VALUES (1, 275, 1);
INSERT INTO `sys_role_menu` VALUES (1, 276, 1);
INSERT INTO `sys_role_menu` VALUES (1, 277, 1);
INSERT INTO `sys_role_menu` VALUES (1, 278, 1);
INSERT INTO `sys_role_menu` VALUES (1, 279, 1);
INSERT INTO `sys_role_menu` VALUES (1, 280, 1);
INSERT INTO `sys_role_menu` VALUES (1, 281, 1);
INSERT INTO `sys_role_menu` VALUES (1, 282, 1);
INSERT INTO `sys_role_menu` VALUES (1, 283, 1);
INSERT INTO `sys_role_menu` VALUES (1, 284, 1);
INSERT INTO `sys_role_menu` VALUES (1, 285, 1);
INSERT INTO `sys_role_menu` VALUES (1, 286, 1);
INSERT INTO `sys_role_menu` VALUES (1, 287, 1);
INSERT INTO `sys_role_menu` VALUES (1, 288, 1);
INSERT INTO `sys_role_menu` VALUES (1, 289, 1);
INSERT INTO `sys_role_menu` VALUES (1, 290, 1);
INSERT INTO `sys_role_menu` VALUES (1, 291, 1);
INSERT INTO `sys_role_menu` VALUES (1, 292, 1);
INSERT INTO `sys_role_menu` VALUES (1, 293, 1);
INSERT INTO `sys_role_menu` VALUES (1, 294, 1);
INSERT INTO `sys_role_menu` VALUES (1, 295, 1);
INSERT INTO `sys_role_menu` VALUES (1, 296, 1);
INSERT INTO `sys_role_menu` VALUES (1, 297, 1);
INSERT INTO `sys_role_menu` VALUES (1, 298, 1);
INSERT INTO `sys_role_menu` VALUES (1, 299, 1);
INSERT INTO `sys_role_menu` VALUES (1, 300, 1);
INSERT INTO `sys_role_menu` VALUES (1, 301, 1);
INSERT INTO `sys_role_menu` VALUES (1, 302, 1);
INSERT INTO `sys_role_menu` VALUES (1, 303, 1);
INSERT INTO `sys_role_menu` VALUES (1, 304, 1);
INSERT INTO `sys_role_menu` VALUES (1, 305, 1);
INSERT INTO `sys_role_menu` VALUES (1, 306, 1);
INSERT INTO `sys_role_menu` VALUES (1, 307, 1);
INSERT INTO `sys_role_menu` VALUES (1, 308, 1);
INSERT INTO `sys_role_menu` VALUES (1, 309, 1);
INSERT INTO `sys_role_menu` VALUES (1, 310, 1);
INSERT INTO `sys_role_menu` VALUES (1, 311, 1);
INSERT INTO `sys_role_menu` VALUES (1, 312, 1);
INSERT INTO `sys_role_menu` VALUES (1, 313, 1);
INSERT INTO `sys_role_menu` VALUES (1, 314, 1);
INSERT INTO `sys_role_menu` VALUES (1, 315, 1);
INSERT INTO `sys_role_menu` VALUES (1, 325, 1);
INSERT INTO `sys_role_menu` VALUES (1, 370, 1);
INSERT INTO `sys_role_menu` VALUES (1, 372, 1);
INSERT INTO `sys_role_menu` VALUES (22, 1, 1);
INSERT INTO `sys_role_menu` VALUES (22, 2, 1);
INSERT INTO `sys_role_menu` VALUES (22, 3, 1);
INSERT INTO `sys_role_menu` VALUES (22, 4, 1);
INSERT INTO `sys_role_menu` VALUES (22, 5, 1);
INSERT INTO `sys_role_menu` VALUES (22, 6, 1);
INSERT INTO `sys_role_menu` VALUES (22, 7, 1);
INSERT INTO `sys_role_menu` VALUES (22, 8, 1);
INSERT INTO `sys_role_menu` VALUES (22, 9, 1);
INSERT INTO `sys_role_menu` VALUES (22, 10, 1);
INSERT INTO `sys_role_menu` VALUES (22, 11, 1);
INSERT INTO `sys_role_menu` VALUES (22, 12, 1);
INSERT INTO `sys_role_menu` VALUES (22, 13, 1);
INSERT INTO `sys_role_menu` VALUES (22, 14, 1);
INSERT INTO `sys_role_menu` VALUES (22, 15, 1);
INSERT INTO `sys_role_menu` VALUES (22, 16, 1);
INSERT INTO `sys_role_menu` VALUES (22, 17, 1);
INSERT INTO `sys_role_menu` VALUES (22, 18, 1);
INSERT INTO `sys_role_menu` VALUES (22, 19, 1);
INSERT INTO `sys_role_menu` VALUES (22, 20, 1);
INSERT INTO `sys_role_menu` VALUES (22, 21, 1);
INSERT INTO `sys_role_menu` VALUES (22, 22, 1);
INSERT INTO `sys_role_menu` VALUES (22, 23, 1);
INSERT INTO `sys_role_menu` VALUES (22, 24, 1);
INSERT INTO `sys_role_menu` VALUES (22, 104, 1);
INSERT INTO `sys_role_menu` VALUES (22, 105, 1);
INSERT INTO `sys_role_menu` VALUES (22, 110, 1);
INSERT INTO `sys_role_menu` VALUES (22, 111, 1);
INSERT INTO `sys_role_menu` VALUES (22, 116, 1);
INSERT INTO `sys_role_menu` VALUES (22, 117, 1);
INSERT INTO `sys_role_menu` VALUES (22, 122, 1);
INSERT INTO `sys_role_menu` VALUES (22, 123, 1);
INSERT INTO `sys_role_menu` VALUES (22, 128, 1);
INSERT INTO `sys_role_menu` VALUES (22, 129, 1);
INSERT INTO `sys_role_menu` VALUES (22, 134, 1);
INSERT INTO `sys_role_menu` VALUES (22, 135, 1);
INSERT INTO `sys_role_menu` VALUES (22, 138, 1);
INSERT INTO `sys_role_menu` VALUES (22, 139, 1);
INSERT INTO `sys_role_menu` VALUES (22, 143, 1);
INSERT INTO `sys_role_menu` VALUES (22, 144, 1);
INSERT INTO `sys_role_menu` VALUES (22, 145, 1);
INSERT INTO `sys_role_menu` VALUES (22, 149, 1);
INSERT INTO `sys_role_menu` VALUES (22, 153, 1);
INSERT INTO `sys_role_menu` VALUES (22, 154, 1);
INSERT INTO `sys_role_menu` VALUES (22, 157, 1);
INSERT INTO `sys_role_menu` VALUES (22, 166, 1);
INSERT INTO `sys_role_menu` VALUES (22, 167, 1);
INSERT INTO `sys_role_menu` VALUES (22, 169, 1);
INSERT INTO `sys_role_menu` VALUES (22, 170, 1);
INSERT INTO `sys_role_menu` VALUES (22, 171, 1);
INSERT INTO `sys_role_menu` VALUES (22, 172, 1);
INSERT INTO `sys_role_menu` VALUES (22, 173, 1);
INSERT INTO `sys_role_menu` VALUES (22, 174, 1);
INSERT INTO `sys_role_menu` VALUES (22, 175, 1);
INSERT INTO `sys_role_menu` VALUES (22, 176, 1);
INSERT INTO `sys_role_menu` VALUES (22, 177, 1);
INSERT INTO `sys_role_menu` VALUES (22, 178, 1);
INSERT INTO `sys_role_menu` VALUES (22, 179, 1);
INSERT INTO `sys_role_menu` VALUES (22, 182, 1);
INSERT INTO `sys_role_menu` VALUES (22, 183, 1);
INSERT INTO `sys_role_menu` VALUES (22, 184, 1);
INSERT INTO `sys_role_menu` VALUES (22, 185, 1);
INSERT INTO `sys_role_menu` VALUES (22, 186, 1);
INSERT INTO `sys_role_menu` VALUES (22, 189, 1);
INSERT INTO `sys_role_menu` VALUES (22, 194, 1);
INSERT INTO `sys_role_menu` VALUES (22, 195, 1);
INSERT INTO `sys_role_menu` VALUES (22, 204, 1);
INSERT INTO `sys_role_menu` VALUES (22, 205, 1);
INSERT INTO `sys_role_menu` VALUES (22, 206, 1);
INSERT INTO `sys_role_menu` VALUES (22, 207, 1);
INSERT INTO `sys_role_menu` VALUES (22, 208, 1);
INSERT INTO `sys_role_menu` VALUES (22, 209, 1);
INSERT INTO `sys_role_menu` VALUES (23, 1, 1);
INSERT INTO `sys_role_menu` VALUES (23, 2, 1);
INSERT INTO `sys_role_menu` VALUES (23, 3, 1);
INSERT INTO `sys_role_menu` VALUES (23, 4, 1);
INSERT INTO `sys_role_menu` VALUES (23, 5, 1);
INSERT INTO `sys_role_menu` VALUES (23, 6, 1);
INSERT INTO `sys_role_menu` VALUES (23, 7, 1);
INSERT INTO `sys_role_menu` VALUES (23, 8, 1);
INSERT INTO `sys_role_menu` VALUES (23, 9, 1);
INSERT INTO `sys_role_menu` VALUES (23, 10, 1);
INSERT INTO `sys_role_menu` VALUES (23, 11, 1);
INSERT INTO `sys_role_menu` VALUES (23, 12, 1);
INSERT INTO `sys_role_menu` VALUES (23, 13, 1);
INSERT INTO `sys_role_menu` VALUES (23, 14, 1);
INSERT INTO `sys_role_menu` VALUES (23, 15, 1);
INSERT INTO `sys_role_menu` VALUES (23, 16, 1);
INSERT INTO `sys_role_menu` VALUES (23, 17, 1);
INSERT INTO `sys_role_menu` VALUES (23, 18, 1);
INSERT INTO `sys_role_menu` VALUES (23, 19, 1);
INSERT INTO `sys_role_menu` VALUES (23, 20, 1);
INSERT INTO `sys_role_menu` VALUES (23, 21, 1);
INSERT INTO `sys_role_menu` VALUES (23, 22, 1);
INSERT INTO `sys_role_menu` VALUES (23, 23, 1);
INSERT INTO `sys_role_menu` VALUES (23, 24, 1);
INSERT INTO `sys_role_menu` VALUES (23, 25, 1);
INSERT INTO `sys_role_menu` VALUES (23, 101, 1);
INSERT INTO `sys_role_menu` VALUES (23, 102, 1);
INSERT INTO `sys_role_menu` VALUES (23, 103, 1);
INSERT INTO `sys_role_menu` VALUES (23, 104, 1);
INSERT INTO `sys_role_menu` VALUES (23, 105, 1);
INSERT INTO `sys_role_menu` VALUES (23, 106, 1);
INSERT INTO `sys_role_menu` VALUES (23, 107, 1);
INSERT INTO `sys_role_menu` VALUES (23, 108, 1);
INSERT INTO `sys_role_menu` VALUES (23, 109, 1);
INSERT INTO `sys_role_menu` VALUES (23, 110, 1);
INSERT INTO `sys_role_menu` VALUES (23, 111, 1);
INSERT INTO `sys_role_menu` VALUES (23, 112, 1);
INSERT INTO `sys_role_menu` VALUES (23, 113, 1);
INSERT INTO `sys_role_menu` VALUES (23, 114, 1);
INSERT INTO `sys_role_menu` VALUES (23, 115, 1);
INSERT INTO `sys_role_menu` VALUES (23, 116, 1);
INSERT INTO `sys_role_menu` VALUES (23, 117, 1);
INSERT INTO `sys_role_menu` VALUES (23, 118, 1);
INSERT INTO `sys_role_menu` VALUES (23, 119, 1);
INSERT INTO `sys_role_menu` VALUES (23, 120, 1);
INSERT INTO `sys_role_menu` VALUES (23, 121, 1);
INSERT INTO `sys_role_menu` VALUES (23, 122, 1);
INSERT INTO `sys_role_menu` VALUES (23, 123, 1);
INSERT INTO `sys_role_menu` VALUES (23, 124, 1);
INSERT INTO `sys_role_menu` VALUES (23, 125, 1);
INSERT INTO `sys_role_menu` VALUES (23, 126, 1);
INSERT INTO `sys_role_menu` VALUES (23, 127, 1);
INSERT INTO `sys_role_menu` VALUES (23, 128, 1);
INSERT INTO `sys_role_menu` VALUES (23, 129, 1);
INSERT INTO `sys_role_menu` VALUES (23, 130, 1);
INSERT INTO `sys_role_menu` VALUES (23, 131, 1);
INSERT INTO `sys_role_menu` VALUES (23, 132, 1);
INSERT INTO `sys_role_menu` VALUES (23, 133, 1);
INSERT INTO `sys_role_menu` VALUES (23, 134, 1);
INSERT INTO `sys_role_menu` VALUES (23, 135, 1);
INSERT INTO `sys_role_menu` VALUES (23, 136, 1);
INSERT INTO `sys_role_menu` VALUES (23, 137, 1);
INSERT INTO `sys_role_menu` VALUES (23, 138, 1);
INSERT INTO `sys_role_menu` VALUES (23, 139, 1);
INSERT INTO `sys_role_menu` VALUES (23, 140, 1);
INSERT INTO `sys_role_menu` VALUES (23, 141, 1);
INSERT INTO `sys_role_menu` VALUES (23, 142, 1);
INSERT INTO `sys_role_menu` VALUES (23, 143, 1);
INSERT INTO `sys_role_menu` VALUES (23, 144, 1);
INSERT INTO `sys_role_menu` VALUES (23, 145, 1);
INSERT INTO `sys_role_menu` VALUES (23, 146, 1);
INSERT INTO `sys_role_menu` VALUES (23, 147, 1);
INSERT INTO `sys_role_menu` VALUES (23, 148, 1);
INSERT INTO `sys_role_menu` VALUES (23, 149, 1);
INSERT INTO `sys_role_menu` VALUES (23, 150, 1);
INSERT INTO `sys_role_menu` VALUES (23, 151, 1);
INSERT INTO `sys_role_menu` VALUES (23, 152, 1);
INSERT INTO `sys_role_menu` VALUES (23, 153, 1);
INSERT INTO `sys_role_menu` VALUES (23, 154, 1);
INSERT INTO `sys_role_menu` VALUES (23, 156, 1);
INSERT INTO `sys_role_menu` VALUES (23, 157, 1);
INSERT INTO `sys_role_menu` VALUES (23, 158, 1);
INSERT INTO `sys_role_menu` VALUES (23, 159, 1);
INSERT INTO `sys_role_menu` VALUES (23, 160, 1);
INSERT INTO `sys_role_menu` VALUES (23, 161, 1);
INSERT INTO `sys_role_menu` VALUES (23, 162, 1);
INSERT INTO `sys_role_menu` VALUES (23, 163, 1);
INSERT INTO `sys_role_menu` VALUES (23, 164, 1);
INSERT INTO `sys_role_menu` VALUES (23, 165, 1);
INSERT INTO `sys_role_menu` VALUES (23, 166, 1);
INSERT INTO `sys_role_menu` VALUES (23, 167, 1);
INSERT INTO `sys_role_menu` VALUES (23, 168, 1);
INSERT INTO `sys_role_menu` VALUES (23, 169, 1);
INSERT INTO `sys_role_menu` VALUES (23, 170, 1);
INSERT INTO `sys_role_menu` VALUES (23, 171, 1);
INSERT INTO `sys_role_menu` VALUES (23, 172, 1);
INSERT INTO `sys_role_menu` VALUES (23, 173, 1);
INSERT INTO `sys_role_menu` VALUES (23, 174, 1);
INSERT INTO `sys_role_menu` VALUES (23, 175, 1);
INSERT INTO `sys_role_menu` VALUES (23, 176, 1);
INSERT INTO `sys_role_menu` VALUES (23, 177, 1);
INSERT INTO `sys_role_menu` VALUES (23, 178, 1);
INSERT INTO `sys_role_menu` VALUES (23, 179, 1);
INSERT INTO `sys_role_menu` VALUES (23, 181, 1);
INSERT INTO `sys_role_menu` VALUES (23, 182, 1);
INSERT INTO `sys_role_menu` VALUES (23, 183, 1);
INSERT INTO `sys_role_menu` VALUES (23, 184, 1);
INSERT INTO `sys_role_menu` VALUES (23, 185, 1);
INSERT INTO `sys_role_menu` VALUES (23, 186, 1);
INSERT INTO `sys_role_menu` VALUES (23, 189, 1);
INSERT INTO `sys_role_menu` VALUES (23, 191, 1);
INSERT INTO `sys_role_menu` VALUES (23, 192, 1);
INSERT INTO `sys_role_menu` VALUES (23, 193, 1);
INSERT INTO `sys_role_menu` VALUES (23, 194, 1);
INSERT INTO `sys_role_menu` VALUES (23, 195, 1);
INSERT INTO `sys_role_menu` VALUES (23, 196, 1);
INSERT INTO `sys_role_menu` VALUES (23, 198, 1);
INSERT INTO `sys_role_menu` VALUES (23, 199, 1);
INSERT INTO `sys_role_menu` VALUES (23, 200, 1);
INSERT INTO `sys_role_menu` VALUES (23, 201, 1);
INSERT INTO `sys_role_menu` VALUES (23, 202, 1);
INSERT INTO `sys_role_menu` VALUES (23, 203, 1);
INSERT INTO `sys_role_menu` VALUES (23, 204, 1);
INSERT INTO `sys_role_menu` VALUES (23, 205, 1);
INSERT INTO `sys_role_menu` VALUES (23, 206, 1);
INSERT INTO `sys_role_menu` VALUES (23, 207, 1);
INSERT INTO `sys_role_menu` VALUES (23, 208, 1);
INSERT INTO `sys_role_menu` VALUES (23, 209, 1);
INSERT INTO `sys_role_menu` VALUES (23, 210, 1);
INSERT INTO `sys_role_menu` VALUES (23, 211, 1);
INSERT INTO `sys_role_menu` VALUES (23, 212, 1);
INSERT INTO `sys_role_menu` VALUES (23, 213, 1);
INSERT INTO `sys_role_menu` VALUES (23, 214, 1);
INSERT INTO `sys_role_menu` VALUES (23, 215, 1);
INSERT INTO `sys_role_menu` VALUES (23, 216, 1);
INSERT INTO `sys_role_menu` VALUES (23, 217, 1);
INSERT INTO `sys_role_menu` VALUES (23, 218, 1);
INSERT INTO `sys_role_menu` VALUES (23, 219, 1);
INSERT INTO `sys_role_menu` VALUES (23, 220, 1);
INSERT INTO `sys_role_menu` VALUES (23, 281, 1);
INSERT INTO `sys_role_menu` VALUES (23, 286, 1);
INSERT INTO `sys_role_menu` VALUES (23, 292, 1);
INSERT INTO `sys_role_menu` VALUES (23, 294, 1);
INSERT INTO `sys_role_menu` VALUES (23, 295, 1);
INSERT INTO `sys_role_menu` VALUES (23, 296, 1);
INSERT INTO `sys_role_menu` VALUES (23, 297, 1);
INSERT INTO `sys_role_menu` VALUES (23, 298, 1);
INSERT INTO `sys_role_menu` VALUES (23, 299, 1);
INSERT INTO `sys_role_menu` VALUES (23, 300, 1);
INSERT INTO `sys_role_menu` VALUES (23, 301, 1);
INSERT INTO `sys_role_menu` VALUES (23, 302, 1);
INSERT INTO `sys_role_menu` VALUES (23, 303, 1);
INSERT INTO `sys_role_menu` VALUES (23, 304, 1);
INSERT INTO `sys_role_menu` VALUES (23, 305, 1);
INSERT INTO `sys_role_menu` VALUES (23, 306, 1);
INSERT INTO `sys_role_menu` VALUES (23, 307, 1);
INSERT INTO `sys_role_menu` VALUES (23, 308, 1);
INSERT INTO `sys_role_menu` VALUES (23, 309, 1);
INSERT INTO `sys_role_menu` VALUES (23, 310, 1);
INSERT INTO `sys_role_menu` VALUES (23, 311, 1);
INSERT INTO `sys_role_menu` VALUES (23, 312, 1);
INSERT INTO `sys_role_menu` VALUES (23, 313, 1);
INSERT INTO `sys_role_menu` VALUES (23, 314, 1);
INSERT INTO `sys_role_menu` VALUES (23, 315, 1);
INSERT INTO `sys_role_menu` VALUES (23, 316, 1);
INSERT INTO `sys_role_menu` VALUES (23, 317, 1);
INSERT INTO `sys_role_menu` VALUES (23, 318, 1);
INSERT INTO `sys_role_menu` VALUES (23, 319, 1);
INSERT INTO `sys_role_menu` VALUES (23, 320, 1);
INSERT INTO `sys_role_menu` VALUES (23, 321, 1);
INSERT INTO `sys_role_menu` VALUES (23, 322, 1);
INSERT INTO `sys_role_menu` VALUES (23, 323, 1);
INSERT INTO `sys_role_menu` VALUES (23, 324, 1);
INSERT INTO `sys_role_menu` VALUES (23, 325, 1);
INSERT INTO `sys_role_menu` VALUES (23, 326, 1);
INSERT INTO `sys_role_menu` VALUES (23, 327, 1);
INSERT INTO `sys_role_menu` VALUES (23, 328, 1);
INSERT INTO `sys_role_menu` VALUES (23, 329, 1);
INSERT INTO `sys_role_menu` VALUES (23, 330, 1);
INSERT INTO `sys_role_menu` VALUES (23, 331, 1);
INSERT INTO `sys_role_menu` VALUES (23, 343, 1);
INSERT INTO `sys_role_menu` VALUES (23, 344, 1);
INSERT INTO `sys_role_menu` VALUES (23, 345, 1);
INSERT INTO `sys_role_menu` VALUES (23, 346, 1);
INSERT INTO `sys_role_menu` VALUES (23, 347, 1);
INSERT INTO `sys_role_menu` VALUES (23, 348, 1);
INSERT INTO `sys_role_menu` VALUES (23, 349, 1);
INSERT INTO `sys_role_menu` VALUES (23, 350, 1);
INSERT INTO `sys_role_menu` VALUES (23, 351, 1);
INSERT INTO `sys_role_menu` VALUES (23, 352, 1);
INSERT INTO `sys_role_menu` VALUES (23, 361, 1);
INSERT INTO `sys_role_menu` VALUES (23, 362, 1);
INSERT INTO `sys_role_menu` VALUES (23, 363, 1);
INSERT INTO `sys_role_menu` VALUES (23, 364, 1);
INSERT INTO `sys_role_menu` VALUES (23, 365, 1);
INSERT INTO `sys_role_menu` VALUES (23, 366, 1);
INSERT INTO `sys_role_menu` VALUES (23, 370, 1);
INSERT INTO `sys_role_menu` VALUES (23, 371, 1);
INSERT INTO `sys_role_menu` VALUES (23, 372, 1);
INSERT INTO `sys_role_menu` VALUES (29, 211, 1);
INSERT INTO `sys_role_menu` VALUES (29, 212, 1);
INSERT INTO `sys_role_menu` VALUES (29, 215, 1);
INSERT INTO `sys_role_menu` VALUES (29, 217, 1);
INSERT INTO `sys_role_menu` VALUES (31, 211, 2);
INSERT INTO `sys_role_menu` VALUES (31, 212, 1);
INSERT INTO `sys_role_menu` VALUES (31, 214, 1);
INSERT INTO `sys_role_menu` VALUES (31, 215, 1);
INSERT INTO `sys_role_menu` VALUES (31, 281, 1);
INSERT INTO `sys_role_menu` VALUES (31, 282, 1);
INSERT INTO `sys_role_menu` VALUES (31, 283, 1);
INSERT INTO `sys_role_menu` VALUES (31, 284, 1);
INSERT INTO `sys_role_menu` VALUES (31, 285, 1);
INSERT INTO `sys_role_menu` VALUES (31, 286, 1);
INSERT INTO `sys_role_menu` VALUES (31, 287, 1);
INSERT INTO `sys_role_menu` VALUES (31, 288, 1);
INSERT INTO `sys_role_menu` VALUES (31, 289, 1);
INSERT INTO `sys_role_menu` VALUES (31, 290, 1);
INSERT INTO `sys_role_menu` VALUES (31, 291, 1);
INSERT INTO `sys_role_menu` VALUES (31, 292, 1);
INSERT INTO `sys_role_menu` VALUES (31, 293, 1);
INSERT INTO `sys_role_menu` VALUES (31, 294, 1);
INSERT INTO `sys_role_menu` VALUES (31, 295, 1);
INSERT INTO `sys_role_menu` VALUES (31, 341, 1);
INSERT INTO `sys_role_menu` VALUES (31, 342, 1);
INSERT INTO `sys_role_menu` VALUES (31, 360, 1);
INSERT INTO `sys_role_menu` VALUES (31, 371, 1);

-- ----------------------------
-- Table structure for sys_security_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_security_log`;
CREATE TABLE `sys_security_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '日志标题',
  `operation_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '操作类型',
  `operation_region` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '操作区域',
  `operation_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '操作IP',
  `operation_time` datetime NOT NULL COMMENT '操作时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 330 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '安全日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_security_log
-- ----------------------------
INSERT INTO `sys_security_log` VALUES (1, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-10 09:55:19');
INSERT INTO `sys_security_log` VALUES (2, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-10 11:26:31');
INSERT INTO `sys_security_log` VALUES (3, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-10 15:56:02');
INSERT INTO `sys_security_log` VALUES (4, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-10 19:44:23');
INSERT INTO `sys_security_log` VALUES (5, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-10 20:31:43');
INSERT INTO `sys_security_log` VALUES (6, 2, '用户登录', 'LOGIN', '本机', '127.0.0.1', '2025-12-10 20:33:04');
INSERT INTO `sys_security_log` VALUES (7, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-10 21:24:39');
INSERT INTO `sys_security_log` VALUES (8, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-10 21:32:02');
INSERT INTO `sys_security_log` VALUES (9, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-10 21:50:46');
INSERT INTO `sys_security_log` VALUES (10, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-11 09:24:39');
INSERT INTO `sys_security_log` VALUES (11, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-11 10:08:36');
INSERT INTO `sys_security_log` VALUES (12, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-11 10:14:50');
INSERT INTO `sys_security_log` VALUES (13, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-11 10:53:07');
INSERT INTO `sys_security_log` VALUES (14, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-11 11:27:24');
INSERT INTO `sys_security_log` VALUES (15, 6, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-11 11:28:30');
INSERT INTO `sys_security_log` VALUES (16, 6, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-11 11:47:10');
INSERT INTO `sys_security_log` VALUES (17, 6, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-11 11:47:35');
INSERT INTO `sys_security_log` VALUES (18, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-11 11:50:15');
INSERT INTO `sys_security_log` VALUES (19, 7, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-11 11:50:54');
INSERT INTO `sys_security_log` VALUES (20, 7, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-11 11:51:11');
INSERT INTO `sys_security_log` VALUES (21, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-11 11:56:05');
INSERT INTO `sys_security_log` VALUES (22, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-11 12:03:57');
INSERT INTO `sys_security_log` VALUES (23, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-11 14:00:17');
INSERT INTO `sys_security_log` VALUES (24, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-11 14:11:12');
INSERT INTO `sys_security_log` VALUES (25, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-11 14:13:10');
INSERT INTO `sys_security_log` VALUES (26, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-11 14:20:12');
INSERT INTO `sys_security_log` VALUES (27, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-11 14:46:57');
INSERT INTO `sys_security_log` VALUES (28, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-11 14:52:45');
INSERT INTO `sys_security_log` VALUES (29, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-11 14:53:50');
INSERT INTO `sys_security_log` VALUES (30, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-11 14:57:04');
INSERT INTO `sys_security_log` VALUES (31, 8, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-11 14:57:21');
INSERT INTO `sys_security_log` VALUES (32, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-11 14:57:43');
INSERT INTO `sys_security_log` VALUES (33, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-11 14:58:45');
INSERT INTO `sys_security_log` VALUES (34, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-11 14:59:32');
INSERT INTO `sys_security_log` VALUES (35, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-11 15:07:20');
INSERT INTO `sys_security_log` VALUES (36, 8, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-11 15:10:13');
INSERT INTO `sys_security_log` VALUES (37, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-11 15:10:53');
INSERT INTO `sys_security_log` VALUES (38, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-13 22:06:45');
INSERT INTO `sys_security_log` VALUES (39, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-13 22:10:11');
INSERT INTO `sys_security_log` VALUES (40, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-15 20:07:47');
INSERT INTO `sys_security_log` VALUES (41, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-15 22:07:23');
INSERT INTO `sys_security_log` VALUES (42, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-15 22:13:22');
INSERT INTO `sys_security_log` VALUES (43, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-15 22:15:18');
INSERT INTO `sys_security_log` VALUES (44, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-15 22:15:37');
INSERT INTO `sys_security_log` VALUES (45, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-15 22:16:05');
INSERT INTO `sys_security_log` VALUES (46, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-16 09:28:29');
INSERT INTO `sys_security_log` VALUES (47, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-16 11:31:49');
INSERT INTO `sys_security_log` VALUES (48, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-17 11:06:17');
INSERT INTO `sys_security_log` VALUES (49, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-17 21:35:26');
INSERT INTO `sys_security_log` VALUES (50, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-17 21:51:00');
INSERT INTO `sys_security_log` VALUES (51, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-18 21:38:43');
INSERT INTO `sys_security_log` VALUES (52, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-26 14:44:55');
INSERT INTO `sys_security_log` VALUES (53, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-27 20:32:37');
INSERT INTO `sys_security_log` VALUES (54, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-27 21:24:44');
INSERT INTO `sys_security_log` VALUES (55, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-27 22:05:16');
INSERT INTO `sys_security_log` VALUES (56, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 00:07:04');
INSERT INTO `sys_security_log` VALUES (57, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 00:07:32');
INSERT INTO `sys_security_log` VALUES (58, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 00:24:04');
INSERT INTO `sys_security_log` VALUES (59, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 00:53:41');
INSERT INTO `sys_security_log` VALUES (60, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 01:00:45');
INSERT INTO `sys_security_log` VALUES (61, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 01:04:14');
INSERT INTO `sys_security_log` VALUES (62, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 01:05:46');
INSERT INTO `sys_security_log` VALUES (63, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 01:11:01');
INSERT INTO `sys_security_log` VALUES (64, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 01:14:32');
INSERT INTO `sys_security_log` VALUES (65, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 01:22:36');
INSERT INTO `sys_security_log` VALUES (66, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 01:24:04');
INSERT INTO `sys_security_log` VALUES (67, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 01:30:56');
INSERT INTO `sys_security_log` VALUES (68, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 01:35:16');
INSERT INTO `sys_security_log` VALUES (69, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 12:09:41');
INSERT INTO `sys_security_log` VALUES (70, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 12:26:24');
INSERT INTO `sys_security_log` VALUES (71, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 12:31:30');
INSERT INTO `sys_security_log` VALUES (72, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 12:36:14');
INSERT INTO `sys_security_log` VALUES (73, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 12:40:59');
INSERT INTO `sys_security_log` VALUES (74, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 12:48:10');
INSERT INTO `sys_security_log` VALUES (75, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 12:52:32');
INSERT INTO `sys_security_log` VALUES (76, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 12:55:32');
INSERT INTO `sys_security_log` VALUES (77, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 13:08:25');
INSERT INTO `sys_security_log` VALUES (78, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 13:11:29');
INSERT INTO `sys_security_log` VALUES (79, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 13:16:49');
INSERT INTO `sys_security_log` VALUES (80, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 13:25:32');
INSERT INTO `sys_security_log` VALUES (81, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 13:33:39');
INSERT INTO `sys_security_log` VALUES (82, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 14:34:05');
INSERT INTO `sys_security_log` VALUES (83, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 15:07:56');
INSERT INTO `sys_security_log` VALUES (84, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 15:13:47');
INSERT INTO `sys_security_log` VALUES (85, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 15:15:47');
INSERT INTO `sys_security_log` VALUES (86, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 15:17:11');
INSERT INTO `sys_security_log` VALUES (87, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 15:56:55');
INSERT INTO `sys_security_log` VALUES (88, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 16:17:34');
INSERT INTO `sys_security_log` VALUES (89, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 16:20:28');
INSERT INTO `sys_security_log` VALUES (90, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 16:23:38');
INSERT INTO `sys_security_log` VALUES (91, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 16:24:20');
INSERT INTO `sys_security_log` VALUES (92, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 16:36:35');
INSERT INTO `sys_security_log` VALUES (93, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 16:37:25');
INSERT INTO `sys_security_log` VALUES (94, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 16:40:12');
INSERT INTO `sys_security_log` VALUES (95, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 16:41:25');
INSERT INTO `sys_security_log` VALUES (96, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 16:41:37');
INSERT INTO `sys_security_log` VALUES (97, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 16:43:00');
INSERT INTO `sys_security_log` VALUES (98, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 16:43:18');
INSERT INTO `sys_security_log` VALUES (99, 8, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 17:11:00');
INSERT INTO `sys_security_log` VALUES (100, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 17:13:35');
INSERT INTO `sys_security_log` VALUES (101, 8, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 17:18:57');
INSERT INTO `sys_security_log` VALUES (102, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 17:19:52');
INSERT INTO `sys_security_log` VALUES (103, 8, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 17:28:05');
INSERT INTO `sys_security_log` VALUES (104, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 17:34:42');
INSERT INTO `sys_security_log` VALUES (105, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 17:55:55');
INSERT INTO `sys_security_log` VALUES (106, 8, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 18:00:04');
INSERT INTO `sys_security_log` VALUES (107, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 18:01:59');
INSERT INTO `sys_security_log` VALUES (108, 8, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 18:04:43');
INSERT INTO `sys_security_log` VALUES (109, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 18:06:41');
INSERT INTO `sys_security_log` VALUES (110, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 18:10:04');
INSERT INTO `sys_security_log` VALUES (111, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 18:17:42');
INSERT INTO `sys_security_log` VALUES (112, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 18:35:30');
INSERT INTO `sys_security_log` VALUES (113, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 19:07:00');
INSERT INTO `sys_security_log` VALUES (114, 8, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 19:11:12');
INSERT INTO `sys_security_log` VALUES (115, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 19:15:26');
INSERT INTO `sys_security_log` VALUES (116, 8, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 19:17:07');
INSERT INTO `sys_security_log` VALUES (117, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 19:25:27');
INSERT INTO `sys_security_log` VALUES (118, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 19:38:33');
INSERT INTO `sys_security_log` VALUES (119, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 19:42:11');
INSERT INTO `sys_security_log` VALUES (120, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 21:03:20');
INSERT INTO `sys_security_log` VALUES (121, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 21:17:05');
INSERT INTO `sys_security_log` VALUES (122, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 21:23:24');
INSERT INTO `sys_security_log` VALUES (123, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 21:37:20');
INSERT INTO `sys_security_log` VALUES (124, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 21:52:51');
INSERT INTO `sys_security_log` VALUES (125, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 21:58:47');
INSERT INTO `sys_security_log` VALUES (126, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 22:10:44');
INSERT INTO `sys_security_log` VALUES (127, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 22:24:32');
INSERT INTO `sys_security_log` VALUES (128, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 22:26:59');
INSERT INTO `sys_security_log` VALUES (129, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 22:34:29');
INSERT INTO `sys_security_log` VALUES (130, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 22:56:42');
INSERT INTO `sys_security_log` VALUES (131, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 23:08:26');
INSERT INTO `sys_security_log` VALUES (132, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 23:17:46');
INSERT INTO `sys_security_log` VALUES (133, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 23:21:11');
INSERT INTO `sys_security_log` VALUES (134, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 23:26:02');
INSERT INTO `sys_security_log` VALUES (135, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 23:52:12');
INSERT INTO `sys_security_log` VALUES (136, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-28 23:57:03');
INSERT INTO `sys_security_log` VALUES (137, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-29 00:03:25');
INSERT INTO `sys_security_log` VALUES (138, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-29 09:34:58');
INSERT INTO `sys_security_log` VALUES (139, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-29 09:54:23');
INSERT INTO `sys_security_log` VALUES (140, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-29 10:05:34');
INSERT INTO `sys_security_log` VALUES (141, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-29 11:38:41');
INSERT INTO `sys_security_log` VALUES (142, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-29 11:50:01');
INSERT INTO `sys_security_log` VALUES (143, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-29 12:05:44');
INSERT INTO `sys_security_log` VALUES (144, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-29 12:50:58');
INSERT INTO `sys_security_log` VALUES (145, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-29 12:53:39');
INSERT INTO `sys_security_log` VALUES (146, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-29 12:56:59');
INSERT INTO `sys_security_log` VALUES (147, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-29 13:10:33');
INSERT INTO `sys_security_log` VALUES (148, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-29 13:31:54');
INSERT INTO `sys_security_log` VALUES (149, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-29 13:40:46');
INSERT INTO `sys_security_log` VALUES (150, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-29 13:46:48');
INSERT INTO `sys_security_log` VALUES (151, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-29 13:54:56');
INSERT INTO `sys_security_log` VALUES (152, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-29 14:00:53');
INSERT INTO `sys_security_log` VALUES (153, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-29 14:17:17');
INSERT INTO `sys_security_log` VALUES (154, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-29 14:26:19');
INSERT INTO `sys_security_log` VALUES (155, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-29 14:33:36');
INSERT INTO `sys_security_log` VALUES (156, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-29 14:38:23');
INSERT INTO `sys_security_log` VALUES (157, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-29 17:53:14');
INSERT INTO `sys_security_log` VALUES (158, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 09:40:22');
INSERT INTO `sys_security_log` VALUES (159, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 09:54:40');
INSERT INTO `sys_security_log` VALUES (160, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 10:23:34');
INSERT INTO `sys_security_log` VALUES (161, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 10:30:43');
INSERT INTO `sys_security_log` VALUES (162, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 10:46:30');
INSERT INTO `sys_security_log` VALUES (163, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 10:48:55');
INSERT INTO `sys_security_log` VALUES (164, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 10:51:32');
INSERT INTO `sys_security_log` VALUES (165, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 10:52:13');
INSERT INTO `sys_security_log` VALUES (166, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 10:59:46');
INSERT INTO `sys_security_log` VALUES (167, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 11:01:17');
INSERT INTO `sys_security_log` VALUES (168, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 11:04:19');
INSERT INTO `sys_security_log` VALUES (169, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 11:13:50');
INSERT INTO `sys_security_log` VALUES (170, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 11:20:31');
INSERT INTO `sys_security_log` VALUES (171, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 11:30:03');
INSERT INTO `sys_security_log` VALUES (172, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 11:32:38');
INSERT INTO `sys_security_log` VALUES (173, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 11:43:42');
INSERT INTO `sys_security_log` VALUES (174, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 11:49:06');
INSERT INTO `sys_security_log` VALUES (175, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 12:00:30');
INSERT INTO `sys_security_log` VALUES (176, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 12:49:35');
INSERT INTO `sys_security_log` VALUES (177, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 12:55:27');
INSERT INTO `sys_security_log` VALUES (178, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 12:57:10');
INSERT INTO `sys_security_log` VALUES (179, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 13:00:26');
INSERT INTO `sys_security_log` VALUES (180, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 13:04:48');
INSERT INTO `sys_security_log` VALUES (181, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 13:15:21');
INSERT INTO `sys_security_log` VALUES (182, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 13:16:24');
INSERT INTO `sys_security_log` VALUES (183, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 13:19:47');
INSERT INTO `sys_security_log` VALUES (184, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 13:32:44');
INSERT INTO `sys_security_log` VALUES (185, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 13:33:57');
INSERT INTO `sys_security_log` VALUES (186, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 13:36:42');
INSERT INTO `sys_security_log` VALUES (187, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 13:38:14');
INSERT INTO `sys_security_log` VALUES (188, 1, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 13:39:46');
INSERT INTO `sys_security_log` VALUES (189, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 13:41:19');
INSERT INTO `sys_security_log` VALUES (190, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 13:41:42');
INSERT INTO `sys_security_log` VALUES (191, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 13:42:10');
INSERT INTO `sys_security_log` VALUES (192, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 13:54:14');
INSERT INTO `sys_security_log` VALUES (193, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 13:58:05');
INSERT INTO `sys_security_log` VALUES (194, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 13:58:36');
INSERT INTO `sys_security_log` VALUES (195, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 14:00:39');
INSERT INTO `sys_security_log` VALUES (196, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 14:00:59');
INSERT INTO `sys_security_log` VALUES (197, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 14:20:52');
INSERT INTO `sys_security_log` VALUES (198, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 14:32:14');
INSERT INTO `sys_security_log` VALUES (199, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 14:34:39');
INSERT INTO `sys_security_log` VALUES (200, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 14:37:01');
INSERT INTO `sys_security_log` VALUES (201, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 14:37:49');
INSERT INTO `sys_security_log` VALUES (202, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 16:53:43');
INSERT INTO `sys_security_log` VALUES (203, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 17:45:02');
INSERT INTO `sys_security_log` VALUES (204, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 17:48:57');
INSERT INTO `sys_security_log` VALUES (205, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 17:56:24');
INSERT INTO `sys_security_log` VALUES (206, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 18:07:59');
INSERT INTO `sys_security_log` VALUES (207, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 20:30:31');
INSERT INTO `sys_security_log` VALUES (208, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 20:40:46');
INSERT INTO `sys_security_log` VALUES (209, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 20:56:12');
INSERT INTO `sys_security_log` VALUES (210, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 20:56:35');
INSERT INTO `sys_security_log` VALUES (211, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 20:58:19');
INSERT INTO `sys_security_log` VALUES (212, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 21:08:29');
INSERT INTO `sys_security_log` VALUES (213, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 21:15:53');
INSERT INTO `sys_security_log` VALUES (214, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 21:16:59');
INSERT INTO `sys_security_log` VALUES (215, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 21:19:36');
INSERT INTO `sys_security_log` VALUES (216, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 21:27:27');
INSERT INTO `sys_security_log` VALUES (217, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 21:30:26');
INSERT INTO `sys_security_log` VALUES (218, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 21:30:58');
INSERT INTO `sys_security_log` VALUES (219, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-30 21:40:20');
INSERT INTO `sys_security_log` VALUES (220, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-31 09:52:16');
INSERT INTO `sys_security_log` VALUES (221, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-31 10:01:40');
INSERT INTO `sys_security_log` VALUES (222, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-31 10:14:13');
INSERT INTO `sys_security_log` VALUES (223, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-31 10:21:40');
INSERT INTO `sys_security_log` VALUES (224, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-31 10:25:42');
INSERT INTO `sys_security_log` VALUES (225, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-31 10:32:44');
INSERT INTO `sys_security_log` VALUES (226, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-31 10:36:44');
INSERT INTO `sys_security_log` VALUES (227, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-31 10:43:41');
INSERT INTO `sys_security_log` VALUES (228, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-31 10:44:24');
INSERT INTO `sys_security_log` VALUES (229, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-31 11:02:00');
INSERT INTO `sys_security_log` VALUES (230, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-31 11:02:36');
INSERT INTO `sys_security_log` VALUES (231, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-31 11:07:57');
INSERT INTO `sys_security_log` VALUES (232, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-31 11:11:05');
INSERT INTO `sys_security_log` VALUES (233, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-31 11:14:59');
INSERT INTO `sys_security_log` VALUES (234, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-31 11:18:53');
INSERT INTO `sys_security_log` VALUES (235, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-31 11:23:16');
INSERT INTO `sys_security_log` VALUES (236, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-31 11:26:47');
INSERT INTO `sys_security_log` VALUES (237, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-31 11:35:40');
INSERT INTO `sys_security_log` VALUES (238, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-31 11:59:49');
INSERT INTO `sys_security_log` VALUES (239, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-31 13:10:36');
INSERT INTO `sys_security_log` VALUES (240, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-31 13:18:05');
INSERT INTO `sys_security_log` VALUES (241, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-31 13:25:11');
INSERT INTO `sys_security_log` VALUES (242, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-31 13:28:30');
INSERT INTO `sys_security_log` VALUES (243, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-31 13:36:42');
INSERT INTO `sys_security_log` VALUES (244, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-31 13:43:24');
INSERT INTO `sys_security_log` VALUES (245, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-31 13:49:57');
INSERT INTO `sys_security_log` VALUES (246, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-31 13:54:24');
INSERT INTO `sys_security_log` VALUES (247, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-31 13:55:24');
INSERT INTO `sys_security_log` VALUES (248, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-31 14:06:22');
INSERT INTO `sys_security_log` VALUES (249, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-31 14:07:08');
INSERT INTO `sys_security_log` VALUES (250, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-31 14:10:51');
INSERT INTO `sys_security_log` VALUES (251, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-31 15:14:10');
INSERT INTO `sys_security_log` VALUES (252, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-31 15:16:56');
INSERT INTO `sys_security_log` VALUES (253, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-31 15:30:43');
INSERT INTO `sys_security_log` VALUES (254, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-31 15:34:31');
INSERT INTO `sys_security_log` VALUES (255, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-31 16:03:04');
INSERT INTO `sys_security_log` VALUES (256, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-31 16:11:02');
INSERT INTO `sys_security_log` VALUES (257, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-31 16:14:57');
INSERT INTO `sys_security_log` VALUES (258, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-31 16:39:49');
INSERT INTO `sys_security_log` VALUES (259, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-31 16:40:28');
INSERT INTO `sys_security_log` VALUES (260, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-31 16:41:18');
INSERT INTO `sys_security_log` VALUES (261, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-31 16:45:28');
INSERT INTO `sys_security_log` VALUES (262, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-31 16:47:08');
INSERT INTO `sys_security_log` VALUES (263, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-31 16:52:42');
INSERT INTO `sys_security_log` VALUES (264, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2025-12-31 16:54:41');
INSERT INTO `sys_security_log` VALUES (265, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-01-05 17:50:43');
INSERT INTO `sys_security_log` VALUES (266, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-01-06 09:37:47');
INSERT INTO `sys_security_log` VALUES (267, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-01-06 09:45:38');
INSERT INTO `sys_security_log` VALUES (268, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-01-06 09:57:09');
INSERT INTO `sys_security_log` VALUES (269, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-01-06 10:14:08');
INSERT INTO `sys_security_log` VALUES (270, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-01-06 10:21:49');
INSERT INTO `sys_security_log` VALUES (271, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-01-06 10:25:42');
INSERT INTO `sys_security_log` VALUES (272, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-01-06 10:32:19');
INSERT INTO `sys_security_log` VALUES (273, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-01-06 10:36:12');
INSERT INTO `sys_security_log` VALUES (274, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-01-06 10:50:32');
INSERT INTO `sys_security_log` VALUES (275, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-01-06 11:17:21');
INSERT INTO `sys_security_log` VALUES (276, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-01-06 11:27:57');
INSERT INTO `sys_security_log` VALUES (277, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-01-06 11:28:55');
INSERT INTO `sys_security_log` VALUES (278, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-01-06 11:33:36');
INSERT INTO `sys_security_log` VALUES (279, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-01-06 11:35:08');
INSERT INTO `sys_security_log` VALUES (280, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-01-06 11:43:24');
INSERT INTO `sys_security_log` VALUES (281, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-01-06 11:44:25');
INSERT INTO `sys_security_log` VALUES (282, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-01-06 11:48:40');
INSERT INTO `sys_security_log` VALUES (283, 1, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-01-06 11:54:04');
INSERT INTO `sys_security_log` VALUES (284, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-01-06 11:55:02');
INSERT INTO `sys_security_log` VALUES (285, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-01-06 11:59:13');
INSERT INTO `sys_security_log` VALUES (286, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-01-06 14:14:52');
INSERT INTO `sys_security_log` VALUES (287, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-01-06 14:15:38');
INSERT INTO `sys_security_log` VALUES (288, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-01-06 14:18:20');
INSERT INTO `sys_security_log` VALUES (289, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-01-17 15:24:02');
INSERT INTO `sys_security_log` VALUES (290, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-01-17 15:35:52');
INSERT INTO `sys_security_log` VALUES (291, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-01-17 15:36:18');
INSERT INTO `sys_security_log` VALUES (292, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-01-17 15:36:57');
INSERT INTO `sys_security_log` VALUES (293, 8, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-01-17 15:37:49');
INSERT INTO `sys_security_log` VALUES (294, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-01-17 15:44:38');
INSERT INTO `sys_security_log` VALUES (295, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-01-17 15:45:43');
INSERT INTO `sys_security_log` VALUES (296, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-01-17 16:04:37');
INSERT INTO `sys_security_log` VALUES (297, 8, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-01-17 16:05:54');
INSERT INTO `sys_security_log` VALUES (298, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-01-17 16:06:51');
INSERT INTO `sys_security_log` VALUES (299, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-02-01 23:41:41');
INSERT INTO `sys_security_log` VALUES (300, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-02-02 00:04:44');
INSERT INTO `sys_security_log` VALUES (301, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-02-02 00:07:57');
INSERT INTO `sys_security_log` VALUES (302, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-02-02 00:21:26');
INSERT INTO `sys_security_log` VALUES (303, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-02-02 00:22:13');
INSERT INTO `sys_security_log` VALUES (304, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-02-02 09:51:10');
INSERT INTO `sys_security_log` VALUES (305, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-02-02 09:51:44');
INSERT INTO `sys_security_log` VALUES (306, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-02-02 09:52:56');
INSERT INTO `sys_security_log` VALUES (307, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-02-02 09:55:24');
INSERT INTO `sys_security_log` VALUES (308, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-02-02 09:55:47');
INSERT INTO `sys_security_log` VALUES (309, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-02-02 09:56:06');
INSERT INTO `sys_security_log` VALUES (310, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-02-02 09:59:15');
INSERT INTO `sys_security_log` VALUES (311, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-02-02 09:59:55');
INSERT INTO `sys_security_log` VALUES (312, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-02-02 10:00:27');
INSERT INTO `sys_security_log` VALUES (313, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-02-02 10:01:36');
INSERT INTO `sys_security_log` VALUES (314, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-02-02 10:02:44');
INSERT INTO `sys_security_log` VALUES (315, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-02-02 10:05:45');
INSERT INTO `sys_security_log` VALUES (316, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-02-02 10:19:27');
INSERT INTO `sys_security_log` VALUES (317, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-02-02 10:19:38');
INSERT INTO `sys_security_log` VALUES (318, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-02-02 10:29:01');
INSERT INTO `sys_security_log` VALUES (319, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-02-02 10:34:38');
INSERT INTO `sys_security_log` VALUES (320, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-02-02 10:39:24');
INSERT INTO `sys_security_log` VALUES (321, 2, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-02-02 10:40:30');
INSERT INTO `sys_security_log` VALUES (322, 2, '异常登录尝试', 'RISK_ALERT', '中国-上海', '203.0.113.10', '2026-02-02 08:50:15');
INSERT INTO `sys_security_log` VALUES (323, 2, '频繁请求告警', 'RISK_ALERT', '中国-上海', '203.0.113.10', '2026-02-02 09:20:15');
INSERT INTO `sys_security_log` VALUES (324, 9, '可疑设备登录', 'RISK_ALERT', '中国-浙江', '198.51.100.23', '2026-02-02 10:05:15');
INSERT INTO `sys_security_log` VALUES (325, 9, '多次密码错误', 'RISK_ALERT', '中国-浙江', '198.51.100.23', '2026-02-02 10:30:15');
INSERT INTO `sys_security_log` VALUES (326, 2, '异地登录告警', 'RISK_ALERT', '中国-广东', '192.0.2.77', '2026-02-02 10:45:15');
INSERT INTO `sys_security_log` VALUES (327, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-02-02 13:48:04');
INSERT INTO `sys_security_log` VALUES (328, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-02-02 14:00:41');
INSERT INTO `sys_security_log` VALUES (329, 9, '用户登录', 'LOGIN', 'IPv6不支持查询', '0:0:0:0:0:0:0:1', '2026-02-02 14:31:33');

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `user_id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `username` varchar(255) CHARACTER SET ucs2 COLLATE ucs2_general_ci NOT NULL COMMENT '用户名',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '密码',
  `nickname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '昵称',
  `avatar` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '头像',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '邮箱',
  `student_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '学号',
  `clazz` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '班级',
  `points` int NULL DEFAULT 0 COMMENT '积分',
  `reputation` int NULL DEFAULT 0 COMMENT '信誉',
  `level` int NULL DEFAULT 1 COMMENT '等级',
  `verified` tinyint NULL DEFAULT 0 COMMENT '认证状态(0未认证 1已认证)',
  `verified_time` datetime NULL DEFAULT NULL COMMENT '认证时间',
  `verified_student_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '认证的学号',
  `dept_id` bigint NULL DEFAULT NULL COMMENT '部门ID',
  `post_id` bigint NULL DEFAULT NULL COMMENT '职位ID',
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '手机号',
  `gender` tinyint(1) NULL DEFAULT 0 COMMENT '性别',
  `region` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '地区',
  `signature` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '个性签名',
  `status` tinyint NULL DEFAULT 0 COMMENT '状态 0正常 1禁用',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '创建人',
  `update_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '更新人',
  `is_deleted` tinyint NULL DEFAULT 0 COMMENT '是否删除',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 'admin', '$2a$10$vXV.3OcNs3zjcUjkka0J7e96KdE1SautXX0Wd6n9hDA79XiLkz.nG', 'admin', 'https://minio.zhangchuangla.cn/echopro/resource/2025/08/image/original/c16438e613b444b2a15e2f1fa8cd7aae.jpg', NULL, NULL, NULL, 0, 0, 1, 0, NULL, NULL, 1, 6, NULL, 0, '陕西-西安', '唯有热爱可抵岁月漫长', 0, '2025-08-15 12:41:34', '2025-12-30 11:29:36', NULL, NULL, 0, NULL);
INSERT INTO `sys_user` VALUES (2, 'demo', '$2a$10$vXV.3OcNs3zjcUjkka0J7e96KdE1SautXX0Wd6n9hDA79XiLkz.nG', '管理员', 'https://minio.zhangchuangla.cn/echopro/resource/2025/08/image/original/05bd63fe553544388eeb33f63c7e262f.jpg', 'admin@qq.com', NULL, NULL, 0, 0, 1, 0, NULL, NULL, 1, 6, '18888888888', 0, NULL, NULL, 0, '2025-08-15 17:24:26', '2025-12-30 11:29:45', NULL, NULL, 0, NULL);
INSERT INTO `sys_user` VALUES (5, 'admin1', '$2a$10$SlYQmyNdGzin9KZaIB7Jm.WK4M3L3KtXqM8VzYQPNP7F4eVVZi4vG', 'admin1管理员', NULL, 'admin1@qq.com', NULL, NULL, 0, 0, 1, 0, NULL, NULL, 1, 6, NULL, 0, NULL, NULL, 0, '2025-12-10 15:52:55', '2025-12-10 15:54:48', NULL, NULL, 0, NULL);
INSERT INTO `sys_user` VALUES (6, '1113', 'admin123', '1113', NULL, NULL, NULL, NULL, 1, 0, 1, 0, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, 0, '2025-12-11 11:26:44', '2025-12-28 21:03:39', NULL, NULL, 0, NULL);
INSERT INTO `sys_user` VALUES (7, '2450610522', 'admin123', '2450610522', NULL, '2302991552@qq.com', NULL, NULL, 1, 0, 1, 0, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, 0, '2025-12-11 11:49:49', '2025-12-28 19:39:02', NULL, NULL, 0, NULL);
INSERT INTO `sys_user` VALUES (8, '2450610521', '$2a$10$oFR5T/n06ZTyZZqK.GyOduqgMFAAs6KfIEu8Ubttp06RMTd3pafTi', '2450610521', NULL, '2302991222@qq.com', NULL, NULL, 84, 0, 1, 1, '2026-01-17 15:41:11', '2021001001', NULL, NULL, NULL, 1, NULL, NULL, 0, '2025-12-11 14:56:45', '2026-01-17 15:41:10', NULL, NULL, 0, NULL);
INSERT INTO `sys_user` VALUES (9, '11134', '$2a$10$vXV.3OcNs3zjcUjkka0J7e96KdE1SautXX0Wd6n9hDA79XiLkz.nG', '11134', NULL, '2302991572@qq.com', NULL, NULL, 881, 0, 3, 1, '2025-12-31 10:44:07', '2021001002', NULL, NULL, NULL, 1, NULL, NULL, 0, '2025-12-15 22:14:57', '2026-01-06 11:01:39', NULL, NULL, 0, NULL);

-- ----------------------------
-- Table structure for sys_user_message
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_message`;
CREATE TABLE `sys_user_message`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '关联ID',
  `message_id` bigint NOT NULL COMMENT '消息ID',
  `user_id` bigint NOT NULL DEFAULT (-(1)) COMMENT '用户ID',
  `role_id` bigint NULL DEFAULT (-(1)) COMMENT '角色ID',
  `dept_id` bigint NULL DEFAULT (-(1)) COMMENT '部门ID',
  `is_read` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否已读：0-未读 1-已读',
  `read_time` datetime NULL DEFAULT NULL COMMENT '阅读时间',
  `is_starred` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否收藏：0-未收藏 1-已收藏',
  `starred_time` datetime NULL DEFAULT NULL COMMENT '收藏时间',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否删除：0-未删除 1-已删除',
  `delete_time` datetime NULL DEFAULT NULL COMMENT '删除时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_message_user`(`message_id` ASC, `user_id` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_message_id`(`message_id` ASC) USING BTREE,
  INDEX `idx_is_read`(`is_read` ASC) USING BTREE,
  INDEX `idx_is_starred`(`is_starred` ASC) USING BTREE,
  INDEX `idx_is_deleted`(`is_deleted` ASC) USING BTREE,
  INDEX `idx_create_time`(`create_time` ASC) USING BTREE,
  CONSTRAINT `fk_user_message_message` FOREIGN KEY (`message_id`) REFERENCES `sys_message` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户消息关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user_message
-- ----------------------------

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NULL DEFAULT NULL COMMENT '用户id',
  `role_id` bigint NULL DEFAULT NULL COMMENT '角色id',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '创建人',
  `update_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '更新人',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  INDEX `role_id`(`role_id` ASC) USING BTREE,
  CONSTRAINT `sys_user_role_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`user_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `sys_user_role_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `sys_role` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1897100379522416708 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户角色表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (1, 1, 1, '2025-04-15 08:08:31', '2025-04-15 08:08:31', NULL, NULL, NULL);
INSERT INTO `sys_user_role` VALUES (1897100379522416692, 2, 23, '2025-08-16 18:37:28', '2025-12-30 11:17:32', NULL, NULL, NULL);
INSERT INTO `sys_user_role` VALUES (1897100379522416695, 5, 1, '2025-12-10 15:53:27', '2025-12-10 15:53:27', NULL, NULL, NULL);
INSERT INTO `sys_user_role` VALUES (1897100379522416699, 7, 31, '2025-12-11 14:53:08', '2025-12-11 14:53:08', NULL, NULL, NULL);
INSERT INTO `sys_user_role` VALUES (1897100379522416700, 6, 31, '2025-12-11 14:55:21', '2025-12-11 14:55:21', NULL, NULL, NULL);
INSERT INTO `sys_user_role` VALUES (1897100379522416703, 8, 31, '2025-12-11 15:07:29', '2025-12-11 15:07:29', NULL, NULL, NULL);
INSERT INTO `sys_user_role` VALUES (1897100379522416705, 9, 31, '2025-12-28 16:18:51', '2025-12-28 16:18:51', NULL, NULL, NULL);

-- ----------------------------
-- Table structure for user_message_ext
-- ----------------------------
DROP TABLE IF EXISTS `user_message_ext`;
CREATE TABLE `user_message_ext`  (
  `id` bigint NOT NULL COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `message_id` bigint NOT NULL COMMENT '消息ID',
  `is_read` tinyint NULL DEFAULT 0 COMMENT '0代表未读 1代表已读',
  `first_read_time` datetime NULL DEFAULT NULL COMMENT '首次阅读时间',
  `last_read_time` datetime NULL DEFAULT NULL COMMENT '最近一次阅读时间 ',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户-消息扩展表 ' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user_message_ext
-- ----------------------------
INSERT INTO `user_message_ext` VALUES (1956626335045779457, 1, 1, 1, '2025-08-16 15:57:25', '2025-08-16 15:57:25', '2025-08-16 15:57:25', '2025-08-16 15:57:25');
INSERT INTO `user_message_ext` VALUES (1956626502851493890, 1, 2, 1, '2025-08-16 15:58:08', '2025-08-17 13:17:33', '2025-08-16 15:58:05', '2025-08-17 13:17:33');
INSERT INTO `user_message_ext` VALUES (1956636878873980930, 2, 2, 1, '2025-08-16 16:39:19', '2025-12-31 15:14:33', '2025-08-16 16:39:19', '2025-12-31 15:14:33');
INSERT INTO `user_message_ext` VALUES (1956948910819143682, 2, 1, 1, '2025-08-17 13:19:13', '2025-08-17 13:19:13', '2025-08-17 13:19:13', '2025-12-11 10:47:49');
INSERT INTO `user_message_ext` VALUES (2005292523798495233, 9, 2, 1, '2025-12-28 22:59:29', '2025-12-30 13:37:31', '2025-12-28 22:59:29', '2025-12-30 13:37:31');

SET FOREIGN_KEY_CHECKS = 1;
