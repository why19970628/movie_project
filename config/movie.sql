/*
Navicat MySQL Data Transfer

Source Server         : 本地数据库
Source Server Version : 80017
Source Host           : localhost:3306
Source Database       : movie

Target Server Type    : MYSQL
Target Server Version : 80017
File Encoding         : 65001

Date: 2020-01-11 16:54:27
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of admin
-- ----------------------------
INSERT INTO `admin` VALUES ('1', 'wang', 'pbkdf2:sha256:50000$HaHef9Rg$27114e74bad67205dcaeefa9a6ed27b17d9f0c29c82f240b1d43684ecae7c3cb', '0', '5', '2019-10-20 21:53:17');
INSERT INTO `admin` VALUES ('3', 'biaoqian', 'pbkdf2:sha256:50000$ZLbe3kMo$6501e614ecf20848f82aaefdbd80704f5324fa459d76d46eabe5238050bbe6c6', '1', '3', '2020-01-10 21:39:25');

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
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;

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
INSERT INTO `adminlog` VALUES ('13', '1', '127.0.0.1', '2020-01-09 20:39:19');
INSERT INTO `adminlog` VALUES ('14', '1', '127.0.0.1', '2020-01-10 20:55:22');
INSERT INTO `adminlog` VALUES ('15', '1', '127.0.0.1', '2020-01-10 21:36:35');
INSERT INTO `adminlog` VALUES ('16', '3', '127.0.0.1', '2020-01-10 23:08:29');
INSERT INTO `adminlog` VALUES ('17', '1', '127.0.0.1', '2020-01-10 23:22:57');
INSERT INTO `adminlog` VALUES ('18', '1', '127.0.0.1', '2020-01-10 23:24:53');
INSERT INTO `adminlog` VALUES ('19', '1', '127.0.0.1', '2020-01-10 23:25:49');
INSERT INTO `adminlog` VALUES ('20', '1', '127.0.0.1', '2020-01-10 23:26:15');
INSERT INTO `adminlog` VALUES ('21', '1', '127.0.0.1', '2020-01-10 23:27:11');
INSERT INTO `adminlog` VALUES ('22', '1', '127.0.0.1', '2020-01-11 15:07:41');

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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of auth
-- ----------------------------
INSERT INTO `auth` VALUES ('1', '添加标签', '/admin/tag/add', '2020-01-09 23:02:21');
INSERT INTO `auth` VALUES ('2', '编辑标签', '/tag/edit/<int:id>', '2020-01-09 23:03:43');
INSERT INTO `auth` VALUES ('3', '标签列表', '/admin/tag/list/<int:page>/', '2020-01-09 23:04:27');
INSERT INTO `auth` VALUES ('4', '删除标签', '/admin/tag/del/<int:id>/', '2020-01-09 23:04:59');

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
INSERT INTO `comment` VALUES ('12', '好看', null, null, '2019-12-26 16:59:40');
INSERT INTO `comment` VALUES ('13', '不错', null, null, '2019-12-26 16:59:40');
INSERT INTO `comment` VALUES ('16', '好看', null, null, '2019-12-26 16:59:53');
INSERT INTO `comment` VALUES ('17', '不错', null, null, '2019-12-26 16:59:53');
INSERT INTO `comment` VALUES ('18', '经典', null, null, '2019-12-26 16:59:53');
INSERT INTO `comment` VALUES ('20', '好看', null, null, '2019-12-26 17:00:02');
INSERT INTO `comment` VALUES ('21', '不错', null, null, '2019-12-26 17:00:02');
INSERT INTO `comment` VALUES ('22', '经典', null, null, '2019-12-26 17:00:02');
INSERT INTO `comment` VALUES ('24', '好看', null, null, '2019-12-26 17:01:38');
INSERT INTO `comment` VALUES ('25', '不错', null, null, '2019-12-26 17:01:38');
INSERT INTO `comment` VALUES ('26', '经典', null, null, '2019-12-26 17:01:38');
INSERT INTO `comment` VALUES ('28', '好看', null, null, '2019-12-26 17:01:41');
INSERT INTO `comment` VALUES ('29', '不错', null, null, '2019-12-26 17:01:41');
INSERT INTO `comment` VALUES ('30', '经典', null, null, '2019-12-26 17:01:41');
INSERT INTO `comment` VALUES ('32', '好看', null, null, '2019-12-26 17:01:42');
INSERT INTO `comment` VALUES ('33', '不错', null, null, '2019-12-26 17:01:42');
INSERT INTO `comment` VALUES ('34', '经典', null, null, '2019-12-26 17:01:42');
INSERT INTO `comment` VALUES ('36', '好看', null, null, '2019-12-26 17:01:43');
INSERT INTO `comment` VALUES ('37', '不错', null, null, '2019-12-26 17:01:43');
INSERT INTO `comment` VALUES ('38', '经典', null, null, '2019-12-26 17:01:43');
INSERT INTO `comment` VALUES ('40', '好看', null, null, '2019-12-26 17:01:44');
INSERT INTO `comment` VALUES ('41', '不错', null, null, '2019-12-26 17:01:44');
INSERT INTO `comment` VALUES ('42', '经典', null, null, '2019-12-26 17:01:44');
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
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of movie
-- ----------------------------
INSERT INTO `movie` VALUES ('39', '情话', '202001050003481d576b00df8549e0833b7950d2f69540.mp4', '你明知道，我知道你知道。 ——徐志摩', '20200105011243c9e44481c426404ea5c7866027ecafdb.png', '5', '48', '2', '2', '中国', '2019-11-27', '5', '2020-01-05 00:03:49');

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
INSERT INTO `moviecol` VALUES ('2', null, null, '2019-12-26 17:10:14');
INSERT INTO `moviecol` VALUES ('4', null, null, '2019-12-26 17:10:15');
INSERT INTO `moviecol` VALUES ('6', null, null, '2019-12-26 17:40:45');
INSERT INTO `moviecol` VALUES ('7', null, null, '2019-12-26 17:40:45');
INSERT INTO `moviecol` VALUES ('8', null, null, '2019-12-26 17:40:46');
INSERT INTO `moviecol` VALUES ('10', null, null, '2019-12-26 22:40:02');
INSERT INTO `moviecol` VALUES ('12', null, null, '2019-12-26 22:40:05');
INSERT INTO `moviecol` VALUES ('13', null, null, '2019-12-26 22:40:06');
INSERT INTO `moviecol` VALUES ('14', null, null, '2019-12-26 22:40:06');
INSERT INTO `moviecol` VALUES ('16', null, null, '2019-12-26 22:40:07');
INSERT INTO `moviecol` VALUES ('17', null, null, '2019-12-26 22:40:08');
INSERT INTO `moviecol` VALUES ('18', null, null, '2019-12-26 22:40:08');
INSERT INTO `moviecol` VALUES ('20', null, null, '2019-12-26 22:40:08');
INSERT INTO `moviecol` VALUES ('21', null, null, '2019-12-26 22:40:08');
INSERT INTO `moviecol` VALUES ('22', null, null, '2019-12-26 22:40:09');
INSERT INTO `moviecol` VALUES ('24', null, null, '2019-12-26 22:40:20');
INSERT INTO `moviecol` VALUES ('25', null, null, '2019-12-26 22:40:20');
INSERT INTO `moviecol` VALUES ('26', null, null, '2019-12-26 22:40:20');
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of oplog
-- ----------------------------
INSERT INTO `oplog` VALUES ('1', '1', '127.0.0.1', '添加标签恐怖', '2019-12-26 21:58:13');
INSERT INTO `oplog` VALUES ('2', '1', '127.0.0.1', '添加标签喜剧', '2019-12-26 21:58:20');
INSERT INTO `oplog` VALUES ('3', '1', '127.0.0.1', '添加标签家庭', '2020-01-04 13:33:53');
INSERT INTO `oplog` VALUES ('4', '1', '127.0.0.1', '添加标签test', '2020-01-10 23:27:24');

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
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of preview
-- ----------------------------
INSERT INTO `preview` VALUES ('25', '良医', '202001111535583a8e0c1322bd4288be2aba5741e30069.jpg', '2020-01-11 15:35:58');
INSERT INTO `preview` VALUES ('26', '情话', '202001111536147333d0314c9748fdb18410ed9d3ae0a9.png', '2020-01-11 15:36:14');
INSERT INTO `preview` VALUES ('27', '流浪地球', '20200111153632a028485e2866479d886bc00fc3332eae.jpg', '2020-01-11 15:36:33');
INSERT INTO `preview` VALUES ('28', '误杀 (2019)', '202001111536457947676dcb54485a8d9c9bd845b88daf.jpg', '2020-01-11 15:36:46');
INSERT INTO `preview` VALUES ('29', '鬼刀风铃公主', '20200111153959074dd69f4e6740c0ae09c5be97897973.jpg', '2020-01-11 15:40:00');

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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of role
-- ----------------------------
INSERT INTO `role` VALUES ('3', '标签管理员', '1,2,3,4', '2020-01-10 21:12:53');
INSERT INTO `role` VALUES ('4', '添加标签管理员', '1', '2020-01-10 21:31:09');
INSERT INTO `role` VALUES ('5', '超级管理员', '', '2020-01-10 21:31:09');

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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tag
-- ----------------------------
INSERT INTO `tag` VALUES ('2', '情感', '2019-11-29 19:13:21');
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
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of userlog
-- ----------------------------
INSERT INTO `userlog` VALUES ('1', null, '192.168.4.1', '2019-12-26 22:39:17');
INSERT INTO `userlog` VALUES ('2', null, '192.168.4.2', '2019-12-26 22:39:18');
INSERT INTO `userlog` VALUES ('3', null, '192.168.4.3', '2019-12-26 22:39:18');
INSERT INTO `userlog` VALUES ('5', null, '192.168.4.1', '2019-12-26 22:41:03');
INSERT INTO `userlog` VALUES ('6', null, '192.168.4.2', '2019-12-26 22:41:03');
INSERT INTO `userlog` VALUES ('7', null, '192.168.4.3', '2019-12-26 22:41:03');
INSERT INTO `userlog` VALUES ('9', null, '192.168.4.1', '2019-12-26 22:41:05');
INSERT INTO `userlog` VALUES ('10', null, '192.168.4.2', '2019-12-26 22:41:05');
INSERT INTO `userlog` VALUES ('11', null, '192.168.4.3', '2019-12-26 22:41:05');
INSERT INTO `userlog` VALUES ('13', null, '192.168.4.1', '2019-12-26 22:41:06');
INSERT INTO `userlog` VALUES ('14', null, '192.168.4.2', '2019-12-26 22:41:06');
INSERT INTO `userlog` VALUES ('15', null, '192.168.4.3', '2019-12-26 22:41:06');
INSERT INTO `userlog` VALUES ('17', null, '192.168.4.1', '2019-12-26 22:41:07');
INSERT INTO `userlog` VALUES ('18', null, '192.168.4.2', '2019-12-26 22:41:07');
INSERT INTO `userlog` VALUES ('19', null, '192.168.4.3', '2019-12-26 22:41:07');
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
INSERT INTO `userlog` VALUES ('43', '22', '127.0.0.1', '2020-01-09 20:35:46');
