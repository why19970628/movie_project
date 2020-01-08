/*
Navicat MySQL Data Transfer

Source Server         : 本地数据库
Source Server Version : 80017
Source Host           : localhost:3306
Source Database       : movie

Target Server Type    : MYSQL
Target Server Version : 80017
File Encoding         : 65001

Date: 2020-01-08 20:17:59
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for admin
-- ----------------------------
DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `pwd` varchar(100) DEFAULT NULL,
  `is_super` tinyint(1) DEFAULT NULL,
  `role_id` int(11) DEFAULT NULL,
  `addtime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `role_id` (`role_id`),
  KEY `ix_admin_addtime` (`addtime`),
  CONSTRAINT `admin_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`),
  CONSTRAINT `admin_chk_1` CHECK ((`is_super` in (0,1)))
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of admin
-- ----------------------------
INSERT INTO `admin` VALUES ('1', 'wang', 'pbkdf2:sha256:50000$HaHef9Rg$27114e74bad67205dcaeefa9a6ed27b17d9f0c29c82f240b1d43684ecae7c3cb', '0', '1', '2019-10-20 21:53:17');

-- ----------------------------
-- Table structure for adminlog
-- ----------------------------
DROP TABLE IF EXISTS `adminlog`;
CREATE TABLE `adminlog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `ip` varchar(100) DEFAULT NULL,
  `addtime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `admin_id` (`admin_id`),
  KEY `ix_adminlog_addtime` (`addtime`),
  CONSTRAINT `adminlog_ibfk_1` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of adminlog
-- ----------------------------
INSERT INTO `adminlog` VALUES ('1', '1', '127.0.0.1', '2019-12-26 21:40:20');
INSERT INTO `adminlog` VALUES ('2', '1', '127.0.0.1', '2019-12-26 22:13:20');
INSERT INTO `adminlog` VALUES ('3', '1', '127.0.0.1', '2019-12-26 22:27:13');
INSERT INTO `adminlog` VALUES ('4', '1', '127.0.0.1', '2020-01-01 13:06:06');
INSERT INTO `adminlog` VALUES ('5', '1', '127.0.0.1', '2020-01-01 18:40:46');
INSERT INTO `adminlog` VALUES ('6', '1', '127.0.0.1', '2020-01-01 18:44:19');
INSERT INTO `adminlog` VALUES ('7', '1', '127.0.0.1', '2020-01-03 21:55:52');
INSERT INTO `adminlog` VALUES ('8', '1', '127.0.0.1', '2020-01-04 13:21:48');
INSERT INTO `adminlog` VALUES ('9', '1', '127.0.0.1', '2020-01-04 19:59:39');
INSERT INTO `adminlog` VALUES ('10', '1', '127.0.0.1', '2020-01-04 23:18:40');
INSERT INTO `adminlog` VALUES ('11', '1', '127.0.0.1', '2020-01-04 23:20:14');
INSERT INTO `adminlog` VALUES ('12', '1', '127.0.0.1', '2020-01-07 19:53:06');

-- ----------------------------
-- Table structure for auth
-- ----------------------------
DROP TABLE IF EXISTS `auth`;
CREATE TABLE `auth` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `addtime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `url` (`url`),
  KEY `ix_auth_addtime` (`addtime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of auth
-- ----------------------------

-- ----------------------------
-- Table structure for comment
-- ----------------------------
DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content` text,
  `movie_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `addtime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `movie_id` (`movie_id`),
  KEY `user_id` (`user_id`),
  KEY `ix_comment_addtime` (`addtime`),
  CONSTRAINT `comment_ibfk_1` FOREIGN KEY (`movie_id`) REFERENCES `movie` (`id`),
  CONSTRAINT `comment_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of comment
-- ----------------------------
INSERT INTO `comment` VALUES ('7', '给力', null, null, '2019-12-26 14:45:08');
INSERT INTO `comment` VALUES ('12', '好看', null, '1', '2019-12-26 16:59:40');
INSERT INTO `comment` VALUES ('13', '不错', null, '2', '2019-12-26 16:59:40');
INSERT INTO `comment` VALUES ('16', '好看', null, '1', '2019-12-26 16:59:53');
INSERT INTO `comment` VALUES ('17', '不错', null, '2', '2019-12-26 16:59:53');
INSERT INTO `comment` VALUES ('18', '经典', null, '3', '2019-12-26 16:59:53');
INSERT INTO `comment` VALUES ('20', '好看', null, '1', '2019-12-26 17:00:02');
INSERT INTO `comment` VALUES ('21', '不错', null, '2', '2019-12-26 17:00:02');
INSERT INTO `comment` VALUES ('22', '经典', null, '3', '2019-12-26 17:00:02');
INSERT INTO `comment` VALUES ('24', '好看', null, '1', '2019-12-26 17:01:38');
INSERT INTO `comment` VALUES ('25', '不错', null, '2', '2019-12-26 17:01:38');
INSERT INTO `comment` VALUES ('26', '经典', null, '3', '2019-12-26 17:01:38');
INSERT INTO `comment` VALUES ('28', '好看', null, '1', '2019-12-26 17:01:41');
INSERT INTO `comment` VALUES ('29', '不错', null, '2', '2019-12-26 17:01:41');
INSERT INTO `comment` VALUES ('30', '经典', null, '3', '2019-12-26 17:01:41');
INSERT INTO `comment` VALUES ('32', '好看', null, '1', '2019-12-26 17:01:42');
INSERT INTO `comment` VALUES ('33', '不错', null, '2', '2019-12-26 17:01:42');
INSERT INTO `comment` VALUES ('34', '经典', null, '3', '2019-12-26 17:01:42');
INSERT INTO `comment` VALUES ('36', '好看', null, '1', '2019-12-26 17:01:43');
INSERT INTO `comment` VALUES ('37', '不错', null, '2', '2019-12-26 17:01:43');
INSERT INTO `comment` VALUES ('38', '经典', null, '3', '2019-12-26 17:01:43');
INSERT INTO `comment` VALUES ('40', '好看', null, '1', '2019-12-26 17:01:44');
INSERT INTO `comment` VALUES ('41', '不错', null, '2', '2019-12-26 17:01:44');
INSERT INTO `comment` VALUES ('42', '经典', null, '3', '2019-12-26 17:01:44');
INSERT INTO `comment` VALUES ('45', '好看', null, '22', '2020-01-01 14:30:54');
INSERT INTO `comment` VALUES ('46', '第一次评论 好激动', null, '22', '2020-01-01 14:31:05');
INSERT INTO `comment` VALUES ('47', '999', null, '22', '2020-01-01 14:35:19');
INSERT INTO `comment` VALUES ('48', '777', null, '22', '2020-01-01 14:35:24');
INSERT INTO `comment` VALUES ('49', '888', null, '22', '2020-01-01 14:35:27');
INSERT INTO `comment` VALUES ('51', '7', null, '22', '2020-01-01 14:37:02');
INSERT INTO `comment` VALUES ('52', '6', null, '22', '2020-01-01 16:02:24');
INSERT INTO `comment` VALUES ('53', '8', null, '22', '2020-01-01 16:30:36');
INSERT INTO `comment` VALUES ('54', '6', null, '22', '2020-01-01 17:59:25');
INSERT INTO `comment` VALUES ('55', '<p>666</p>', null, '22', '2020-01-03 21:21:16');
INSERT INTO `comment` VALUES ('56', '<p>666</p>', null, '22', '2020-01-03 21:21:22');
INSERT INTO `comment` VALUES ('57', '<p>666</p>', null, '22', '2020-01-03 21:21:38');
INSERT INTO `comment` VALUES ('58', '<p>4</p>', null, '22', '2020-01-04 14:36:13');
INSERT INTO `comment` VALUES ('59', '<p><img src=\"http://img.baidu.com/hi/jx2/j_0001.gif\"/></p>', null, '22', '2020-01-04 14:37:42');
INSERT INTO `comment` VALUES ('60', '<p>7777<br/></p>', null, '22', '2020-01-04 14:38:16');
INSERT INTO `comment` VALUES ('61', '<p>999</p>', null, '22', '2020-01-04 18:48:07');
INSERT INTO `comment` VALUES ('62', '<p>777</p>', '39', '22', '2020-01-07 19:32:37');
INSERT INTO `comment` VALUES ('63', '<p>999</p>', '39', '22', '2020-01-07 21:36:38');

-- ----------------------------
-- Table structure for movie
-- ----------------------------
DROP TABLE IF EXISTS `movie`;
CREATE TABLE `movie` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `info` text,
  `logo` varchar(255) DEFAULT NULL,
  `star` smallint(6) DEFAULT NULL,
  `playnum` bigint(20) DEFAULT NULL,
  `commentnum` bigint(20) DEFAULT NULL,
  `tag_id` int(11) DEFAULT NULL,
  `area` varchar(255) DEFAULT NULL,
  `release_time` date DEFAULT NULL,
  `length` varchar(100) DEFAULT NULL,
  `addtime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `title` (`title`),
  UNIQUE KEY `url` (`url`),
  UNIQUE KEY `logo` (`logo`),
  KEY `tag_id` (`tag_id`),
  KEY `ix_movie_addtime` (`addtime`),
  CONSTRAINT `movie_ibfk_1` FOREIGN KEY (`tag_id`) REFERENCES `tag` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of movie
-- ----------------------------
INSERT INTO `movie` VALUES ('38', '原创投稿须知6', '20200105000110572f162452ed453c9666ce734d4ce062.mp4', 'If I should see you，after long year. How should I greet,with tears, with silence 若我会见到你，事隔经年。 我该如何向你致意，以眼泪，以沉默。 ——拜伦\r\n我们应该早些相遇 但别是灼人的夏 刚落停的春雨  青草提腰的梦呓 最好是这时候  ——顾城\r\n遇见你，而后有悬崖，而后有夜晚与夜晚之分别，有烛火惺忪和万物生长，又凋落。    ——丝绒陨\r\n我们总是不知足的，不满于现状，想拥有更多，无意从墙角瞥见的一眼，到靠拢的温柔和可爱，再得到一个吻，我们历过万乡才遇见，务必让我为你关掉月亮。   ——郑裘\r\n我宁可让自己因有所为而后悔，而不是后悔着自己一再犹豫却步；我宁可让自己因一场真实的人生体验而后悔，也不要让自己病态地揣想着事情的种种可能。    ——拜雅特\r\n你明知道，我知道你知道。 ——徐志摩', '20200105000110b11393ca97664428b05f2531ee6a759f.jpg', '1', '21', '0', '2', '中国', '2019-11-14', '5', '2020-01-05 00:01:11');
INSERT INTO `movie` VALUES ('39', '情话', '202001050003481d576b00df8549e0833b7950d2f69540.mp4', '你明知道，我知道你知道。 ——徐志摩', '20200105011243c9e44481c426404ea5c7866027ecafdb.png', '5', '31', '2', '2', '中国', '2019-11-27', '5', '2020-01-05 00:03:49');

-- ----------------------------
-- Table structure for moviecol
-- ----------------------------
DROP TABLE IF EXISTS `moviecol`;
CREATE TABLE `moviecol` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `movie_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `addtime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `movie_id` (`movie_id`),
  KEY `user_id` (`user_id`),
  KEY `ix_moviecol_addtime` (`addtime`),
  CONSTRAINT `moviecol_ibfk_1` FOREIGN KEY (`movie_id`) REFERENCES `movie` (`id`),
  CONSTRAINT `moviecol_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of moviecol
-- ----------------------------
INSERT INTO `moviecol` VALUES ('2', null, '1', '2019-12-26 17:10:14');
INSERT INTO `moviecol` VALUES ('4', null, '3', '2019-12-26 17:10:15');
INSERT INTO `moviecol` VALUES ('6', null, '1', '2019-12-26 17:40:45');
INSERT INTO `moviecol` VALUES ('7', null, '2', '2019-12-26 17:40:45');
INSERT INTO `moviecol` VALUES ('8', null, '3', '2019-12-26 17:40:46');
INSERT INTO `moviecol` VALUES ('10', null, '3', '2019-12-26 22:40:02');
INSERT INTO `moviecol` VALUES ('12', null, '1', '2019-12-26 22:40:05');
INSERT INTO `moviecol` VALUES ('13', null, '2', '2019-12-26 22:40:06');
INSERT INTO `moviecol` VALUES ('14', null, '3', '2019-12-26 22:40:06');
INSERT INTO `moviecol` VALUES ('16', null, '1', '2019-12-26 22:40:07');
INSERT INTO `moviecol` VALUES ('17', null, '2', '2019-12-26 22:40:08');
INSERT INTO `moviecol` VALUES ('18', null, '3', '2019-12-26 22:40:08');
INSERT INTO `moviecol` VALUES ('20', null, '1', '2019-12-26 22:40:08');
INSERT INTO `moviecol` VALUES ('21', null, '2', '2019-12-26 22:40:08');
INSERT INTO `moviecol` VALUES ('22', null, '3', '2019-12-26 22:40:09');
INSERT INTO `moviecol` VALUES ('24', null, '1', '2019-12-26 22:40:20');
INSERT INTO `moviecol` VALUES ('25', null, '2', '2019-12-26 22:40:20');
INSERT INTO `moviecol` VALUES ('26', null, '3', '2019-12-26 22:40:20');
INSERT INTO `moviecol` VALUES ('28', null, '22', '2020-01-01 22:25:41');
INSERT INTO `moviecol` VALUES ('29', null, '22', '2020-01-03 21:37:52');
INSERT INTO `moviecol` VALUES ('30', null, '22', '2020-01-04 18:48:09');
INSERT INTO `moviecol` VALUES ('31', '39', '22', '2020-01-07 19:50:45');

-- ----------------------------
-- Table structure for oplog
-- ----------------------------
DROP TABLE IF EXISTS `oplog`;
CREATE TABLE `oplog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `ip` varchar(100) DEFAULT NULL,
  `reason` varchar(600) DEFAULT NULL,
  `addtime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `admin_id` (`admin_id`),
  KEY `ix_oplog_addtime` (`addtime`),
  CONSTRAINT `oplog_ibfk_1` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of oplog
-- ----------------------------
INSERT INTO `oplog` VALUES ('1', '1', '127.0.0.1', '添加标签恐怖', '2019-12-26 21:58:13');
INSERT INTO `oplog` VALUES ('2', '1', '127.0.0.1', '添加标签喜剧', '2019-12-26 21:58:20');
INSERT INTO `oplog` VALUES ('3', '1', '127.0.0.1', '添加标签家庭', '2020-01-04 13:33:53');

-- ----------------------------
-- Table structure for preview
-- ----------------------------
DROP TABLE IF EXISTS `preview`;
CREATE TABLE `preview` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `logo` varchar(255) DEFAULT NULL,
  `addtime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `title` (`title`),
  UNIQUE KEY `logo` (`logo`),
  KEY `ix_preview_addtime` (`addtime`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of preview
-- ----------------------------

-- ----------------------------
-- Table structure for role
-- ----------------------------
DROP TABLE IF EXISTS `role`;
CREATE TABLE `role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `auths` varchar(600) DEFAULT NULL,
  `addtime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `ix_role_addtime` (`addtime`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of role
-- ----------------------------
INSERT INTO `role` VALUES ('1', '超级管理员', '', '2019-10-20 21:52:42');

-- ----------------------------
-- Table structure for tag
-- ----------------------------
DROP TABLE IF EXISTS `tag`;
CREATE TABLE `tag` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `addtime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `ix_tag_addtime` (`addtime`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tag
-- ----------------------------
INSERT INTO `tag` VALUES ('2', '爱情', '2019-11-29 19:13:21');
INSERT INTO `tag` VALUES ('3', '科幻', '2019-11-29 20:12:34');
INSERT INTO `tag` VALUES ('4', '悬疑', '2019-11-29 20:12:43');
INSERT INTO `tag` VALUES ('6', '战争', '2019-12-26 21:39:43');
INSERT INTO `tag` VALUES ('7', '恐怖', '2019-12-26 21:58:12');
INSERT INTO `tag` VALUES ('8', '喜剧', '2019-12-26 21:58:20');
INSERT INTO `tag` VALUES ('9', '家庭', '2020-01-04 13:33:52');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `pwd` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `phone` varchar(11) DEFAULT NULL,
  `info` text,
  `face` varchar(255) DEFAULT NULL,
  `addtime` datetime DEFAULT NULL,
  `uuid` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `phone` (`phone`),
  UNIQUE KEY `face` (`face`),
  UNIQUE KEY `uuid` (`uuid`),
  KEY `ix_user_addtime` (`addtime`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES ('1', '鼠', '1231', '1231@123.com', '13888888881', '鼠', '1f401.png', '2019-12-26 14:43:53', 'd32a72bdac524478b7e4f6dfc8394fc0');
INSERT INTO `user` VALUES ('2', '牛', '1232', '1232@123.com', '13888888882', '牛', '1f402.png', '2019-12-26 14:43:53', 'd32a72bdac524478b7e4f6dfc8394fc1');
INSERT INTO `user` VALUES ('3', '虎', '1233', '1233@123.com', '13888888883', '虎', '1f405.png', '2019-12-26 14:43:53', 'd32a72bdac524478b7e4f6dfc8394fc2');
INSERT INTO `user` VALUES ('5', '龙', '1235', '1235@123.com', '13888888885', '龙', '1f409.png', '2019-12-26 14:43:54', 'd32a72bdac524478b7e4f6dfc8394fc4');
INSERT INTO `user` VALUES ('6', '蛇', '1236', '1236@123.com', '13888888886', '蛇', '1f40d.png', '2019-12-26 14:43:54', 'd32a72bdac524478b7e4f6dfc8394fc5');
INSERT INTO `user` VALUES ('7', '马', '1237', '1237@123.com', '13888888887', '马', '1f434.png', '2019-12-26 14:43:54', 'd32a72bdac524478b7e4f6dfc8394fc6');
INSERT INTO `user` VALUES ('8', '羊', '1238', '1238@123.com', '13888888888', '羊', '1f411.png', '2019-12-26 14:43:54', 'd32a72bdac524478b7e4f6dfc8394fc7');
INSERT INTO `user` VALUES ('9', '猴', '1239', '1239@123.com', '13888888889', '猴', '1f412.png', '2019-12-26 14:43:54', 'd32a72bdac524478b7e4f6dfc8394fc8');
INSERT INTO `user` VALUES ('22', 'wang', 'pbkdf2:sha256:50000$tKiarvpY$bd4db080aeff0e87453d742b48ef2f29833e6f5705fb7fdfbebdfc1a777a6b3f', 'wang@qq.com', '13661408267', '88895', '202001010102534baf875f21e74144a4403be0700cbcbc.jpg', '2020-01-01 00:27:13', 'dd12d1352e63426dbaaac5bb2dce291d');
INSERT INTO `user` VALUES ('23', 'hua', 'pbkdf2:sha256:50000$HMq8DGA5$749f0a6cf7bd5248ff4cd1981c04f9efe0f7e5f23b1ce13274cf594d2d37b710', 'hua@qq.com', '13183107921', '666', '20200107214349ba6e5af39af24c02a31c2301398f28f3', '2020-01-07 21:43:10', 'b63ef96d0dc84a05b9ed9ab155650953');

-- ----------------------------
-- Table structure for userlog
-- ----------------------------
DROP TABLE IF EXISTS `userlog`;
CREATE TABLE `userlog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `ip` varchar(100) DEFAULT NULL,
  `addtime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `ix_userlog_addtime` (`addtime`),
  CONSTRAINT `userlog_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of userlog
-- ----------------------------
INSERT INTO `userlog` VALUES ('1', '1', '192.168.4.1', '2019-12-26 22:39:17');
INSERT INTO `userlog` VALUES ('2', '2', '192.168.4.2', '2019-12-26 22:39:18');
INSERT INTO `userlog` VALUES ('3', '3', '192.168.4.3', '2019-12-26 22:39:18');
INSERT INTO `userlog` VALUES ('5', '1', '192.168.4.1', '2019-12-26 22:41:03');
INSERT INTO `userlog` VALUES ('6', '2', '192.168.4.2', '2019-12-26 22:41:03');
INSERT INTO `userlog` VALUES ('7', '3', '192.168.4.3', '2019-12-26 22:41:03');
INSERT INTO `userlog` VALUES ('9', '1', '192.168.4.1', '2019-12-26 22:41:05');
INSERT INTO `userlog` VALUES ('10', '2', '192.168.4.2', '2019-12-26 22:41:05');
INSERT INTO `userlog` VALUES ('11', '3', '192.168.4.3', '2019-12-26 22:41:05');
INSERT INTO `userlog` VALUES ('13', '1', '192.168.4.1', '2019-12-26 22:41:06');
INSERT INTO `userlog` VALUES ('14', '2', '192.168.4.2', '2019-12-26 22:41:06');
INSERT INTO `userlog` VALUES ('15', '3', '192.168.4.3', '2019-12-26 22:41:06');
INSERT INTO `userlog` VALUES ('17', '1', '192.168.4.1', '2019-12-26 22:41:07');
INSERT INTO `userlog` VALUES ('18', '2', '192.168.4.2', '2019-12-26 22:41:07');
INSERT INTO `userlog` VALUES ('19', '3', '192.168.4.3', '2019-12-26 22:41:07');
INSERT INTO `userlog` VALUES ('21', null, '127.0.0.1', '2019-12-29 22:33:52');
INSERT INTO `userlog` VALUES ('22', null, '127.0.0.1', '2019-12-29 22:34:25');
INSERT INTO `userlog` VALUES ('23', null, '127.0.0.1', '2019-12-29 22:36:49');
INSERT INTO `userlog` VALUES ('24', null, '127.0.0.1', '2019-12-29 22:38:48');
INSERT INTO `userlog` VALUES ('25', null, '127.0.0.1', '2020-01-01 00:21:36');
INSERT INTO `userlog` VALUES ('26', '22', '127.0.0.1', '2020-01-01 00:41:37');
INSERT INTO `userlog` VALUES ('27', null, '127.0.0.1', '2020-01-01 00:57:49');
INSERT INTO `userlog` VALUES ('28', '22', '127.0.0.1', '2020-01-01 01:00:46');
INSERT INTO `userlog` VALUES ('29', '22', '127.0.0.1', '2020-01-01 01:01:08');
INSERT INTO `userlog` VALUES ('30', '22', '127.0.0.1', '2020-01-01 13:05:16');
INSERT INTO `userlog` VALUES ('31', '22', '127.0.0.1', '2020-01-01 14:04:15');
INSERT INTO `userlog` VALUES ('32', '22', '127.0.0.1', '2020-01-01 16:08:47');
INSERT INTO `userlog` VALUES ('33', '22', '127.0.0.1', '2020-01-01 16:24:04');
INSERT INTO `userlog` VALUES ('34', '22', '127.0.0.1', '2020-01-01 17:17:55');
INSERT INTO `userlog` VALUES ('35', '22', '127.0.0.1', '2020-01-01 17:56:43');
INSERT INTO `userlog` VALUES ('36', '22', '127.0.0.1', '2020-01-01 21:20:13');
INSERT INTO `userlog` VALUES ('37', '22', '127.0.0.1', '2020-01-03 21:21:04');
INSERT INTO `userlog` VALUES ('38', '22', '127.0.0.1', '2020-01-04 13:19:43');
INSERT INTO `userlog` VALUES ('39', '22', '127.0.0.1', '2020-01-04 18:47:40');
INSERT INTO `userlog` VALUES ('40', '22', '127.0.0.1', '2020-01-05 01:14:19');
INSERT INTO `userlog` VALUES ('41', '22', '127.0.0.1', '2020-01-07 19:32:19');
INSERT INTO `userlog` VALUES ('42', '23', '127.0.0.1', '2020-01-07 21:43:35');
