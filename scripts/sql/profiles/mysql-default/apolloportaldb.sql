--
-- Copyright 2024 Apollo Authors
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
-- http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--
-- ===============================================================================
-- 【重要】本文件是 MySQL 方言的母版脚本，仅供 apollo-build-sql-converter 生成
--   scripts/sql/profiles/{mysql-default,mysql-database-not-specified,h2-default}
--   使用，不能直接在 Oracle 上执行（反引号 / AUTO_INCREMENT / unsigned
--   会导致 ORA-00911: invalid character）。
--   Oracle 部署请执行：scripts/sql/oracle/apolloportaldb_oracle.sql
-- ===============================================================================
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- 
-- ===============================================================================
-- ==                                                                           ==
-- ==                     Generated from 'scripts/sql/src/'                     ==
-- == by running 'mvn compile -pl apollo-build-sql-converter -Psql-converter'.  ==
-- ==                              DO NOT EDIT !!!                              ==
-- ==                                                                           ==
-- ===============================================================================
-- 
-- 
-- Create Database
-- ------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS ApolloPortalDB DEFAULT CHARACTER SET = utf8mb4;

Use ApolloPortalDB;

-- Dump of table app
-- ------------------------------------------------------------

CREATE TABLE `App` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `AppId` varchar(64) NOT NULL DEFAULT 'default' COMMENT 'AppID',
  `NAME` varchar(500) NOT NULL DEFAULT 'default' COMMENT '应用名',
  `OrgId` varchar(32) NOT NULL DEFAULT 'default' COMMENT '部门ID',
  `OrgName` varchar(64) NOT NULL DEFAULT 'default' COMMENT '部门名字',
  `OwnerName` varchar(500) NOT NULL DEFAULT 'default' COMMENT 'ownerName',
  `OwnerEmail` varchar(500) NOT NULL DEFAULT 'default' COMMENT 'ownerEmail',
  `IsDeleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '1: deleted, 0: normal',
  `DeletedAt` BIGINT(20) NOT NULL DEFAULT '0' COMMENT 'Delete timestamp based on milliseconds',
  `DataChange_CreatedBy` varchar(64) NOT NULL DEFAULT 'default' COMMENT '创建人邮箱前缀',
  `DataChange_CreatedTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `DataChange_LastModifiedBy` varchar(64) DEFAULT '' COMMENT '最后修改人邮箱前缀',
  `DataChange_LastTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UK_AppId_DeletedAt` (`AppId`,`DeletedAt`),
  KEY `DataChange_LastTime` (`DataChange_LastTime`),
  KEY `IX_Name` (`NAME`(191))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='应用表';



-- Dump of table appnamespace
-- ------------------------------------------------------------

CREATE TABLE `AppNamespace` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `NAME` varchar(32) NOT NULL DEFAULT '' COMMENT 'namespace名字，注意，需要全局唯一',
  `AppId` varchar(64) NOT NULL DEFAULT '' COMMENT 'app id',
  `Format` varchar(32) NOT NULL DEFAULT 'properties' COMMENT 'namespace的format类型',
  `IsPublic` bit(1) NOT NULL DEFAULT b'0' COMMENT 'namespace是否为公共',
  `COMMENT` varchar(64) NOT NULL DEFAULT '' COMMENT '注释',
  `IsDeleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '1: deleted, 0: normal',
  `DeletedAt` BIGINT(20) NOT NULL DEFAULT '0' COMMENT 'Delete timestamp based on milliseconds',
  `DataChange_CreatedBy` varchar(64) NOT NULL DEFAULT 'default' COMMENT '创建人邮箱前缀',
  `DataChange_CreatedTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `DataChange_LastModifiedBy` varchar(64) DEFAULT '' COMMENT '最后修改人邮箱前缀',
  `DataChange_LastTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UK_AppId_Name_DeletedAt` (`AppId`,`NAME`,`DeletedAt`),
  KEY `Name_AppId` (`NAME`,`AppId`),
  KEY `DataChange_LastTime` (`DataChange_LastTime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='应用namespace定义';



-- Dump of table consumer
-- ------------------------------------------------------------

CREATE TABLE `Consumer` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `AppId` varchar(64) NOT NULL DEFAULT 'default' COMMENT 'AppID',
  `NAME` varchar(500) NOT NULL DEFAULT 'default' COMMENT '应用名',
  `OrgId` varchar(32) NOT NULL DEFAULT 'default' COMMENT '部门ID',
  `OrgName` varchar(64) NOT NULL DEFAULT 'default' COMMENT '部门名字',
  `OwnerName` varchar(500) NOT NULL DEFAULT 'default' COMMENT 'ownerName',
  `OwnerEmail` varchar(500) NOT NULL DEFAULT 'default' COMMENT 'ownerEmail',
  `IsDeleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '1: deleted, 0: normal',
  `DeletedAt` BIGINT(20) NOT NULL DEFAULT '0' COMMENT 'Delete timestamp based on milliseconds',
  `DataChange_CreatedBy` varchar(64) NOT NULL DEFAULT 'default' COMMENT '创建人邮箱前缀',
  `DataChange_CreatedTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `DataChange_LastModifiedBy` varchar(64) DEFAULT '' COMMENT '最后修改人邮箱前缀',
  `DataChange_LastTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UK_AppId_DeletedAt` (`AppId`,`DeletedAt`),
  KEY `DataChange_LastTime` (`DataChange_LastTime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='开放API消费者';



-- Dump of table consumeraudit
-- ------------------------------------------------------------

CREATE TABLE `ConsumerAudit` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `ConsumerId` int(11) unsigned DEFAULT NULL COMMENT 'Consumer ID',
  `Uri` varchar(1024) NOT NULL DEFAULT '' COMMENT '访问的Uri',
  `Method` varchar(16) NOT NULL DEFAULT '' COMMENT '访问的Method',
  `DataChange_CreatedTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `DataChange_LastTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
  PRIMARY KEY (`ID`),
  KEY `IX_DataChange_LastTime` (`DataChange_LastTime`),
  KEY `IX_ConsumerId` (`ConsumerId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='consumer审计表';



-- Dump of table consumerrole
-- ------------------------------------------------------------

CREATE TABLE `ConsumerRole` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `ConsumerId` int(11) unsigned DEFAULT NULL COMMENT 'Consumer ID',
  `RoleId` int(10) unsigned DEFAULT NULL COMMENT 'Role ID',
  `IsDeleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '1: deleted, 0: normal',
  `DeletedAt` BIGINT(20) NOT NULL DEFAULT '0' COMMENT 'Delete timestamp based on milliseconds',
  `DataChange_CreatedBy` varchar(64) NOT NULL DEFAULT 'default' COMMENT '创建人邮箱前缀',
  `DataChange_CreatedTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `DataChange_LastModifiedBy` varchar(64) DEFAULT '' COMMENT '最后修改人邮箱前缀',
  `DataChange_LastTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UK_ConsumerId_RoleId_DeletedAt` (`ConsumerId`,`RoleId`,`DeletedAt`),
  KEY `IX_DataChange_LastTime` (`DataChange_LastTime`),
  KEY `IX_RoleId` (`RoleId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='consumer和role的绑定表';



-- Dump of table consumertoken
-- ------------------------------------------------------------

CREATE TABLE `ConsumerToken` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `ConsumerId` int(11) unsigned DEFAULT NULL COMMENT 'ConsumerId',
  `Token` varchar(128) NOT NULL DEFAULT '' COMMENT 'token',
  `RateLimit` int NOT NULL DEFAULT '0' COMMENT '限流值',
  `Expires` datetime NOT NULL DEFAULT '2099-01-01 00:00:00' COMMENT 'token失效时间',
  `IsDeleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '1: deleted, 0: normal',
  `DeletedAt` BIGINT(20) NOT NULL DEFAULT '0' COMMENT 'Delete timestamp based on milliseconds',
  `DataChange_CreatedBy` varchar(64) NOT NULL DEFAULT 'default' COMMENT '创建人邮箱前缀',
  `DataChange_CreatedTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `DataChange_LastModifiedBy` varchar(64) DEFAULT '' COMMENT '最后修改人邮箱前缀',
  `DataChange_LastTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UK_Token_DeletedAt` (`Token`,`DeletedAt`),
  KEY `DataChange_LastTime` (`DataChange_LastTime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='consumer token表';

-- Dump of table favorite
-- ------------------------------------------------------------

CREATE TABLE `Favorite` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `UserId` varchar(32) NOT NULL DEFAULT 'default' COMMENT '收藏的用户',
  `AppId` varchar(64) NOT NULL DEFAULT 'default' COMMENT 'AppID',
  `Position` int(32) NOT NULL DEFAULT '10000' COMMENT '收藏顺序',
  `IsDeleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '1: deleted, 0: normal',
  `DeletedAt` BIGINT(20) NOT NULL DEFAULT '0' COMMENT 'Delete timestamp based on milliseconds',
  `DataChange_CreatedBy` varchar(64) NOT NULL DEFAULT 'default' COMMENT '创建人邮箱前缀',
  `DataChange_CreatedTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `DataChange_LastModifiedBy` varchar(64) DEFAULT '' COMMENT '最后修改人邮箱前缀',
  `DataChange_LastTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UK_UserId_AppId_DeletedAt` (`UserId`,`AppId`,`DeletedAt`),
  KEY `AppId` (`AppId`),
  KEY `DataChange_LastTime` (`DataChange_LastTime`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COMMENT='应用收藏表';

-- Dump of table permission
-- ------------------------------------------------------------

CREATE TABLE `Permission` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `PermissionType` varchar(32) NOT NULL DEFAULT '' COMMENT '权限类型',
  `TargetId` varchar(256) NOT NULL DEFAULT '' COMMENT '权限对象类型',
  `IsDeleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '1: deleted, 0: normal',
  `DeletedAt` BIGINT(20) NOT NULL DEFAULT '0' COMMENT 'Delete timestamp based on milliseconds',
  `DataChange_CreatedBy` varchar(64) NOT NULL DEFAULT 'default' COMMENT '创建人邮箱前缀',
  `DataChange_CreatedTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `DataChange_LastModifiedBy` varchar(64) DEFAULT '' COMMENT '最后修改人邮箱前缀',
  `DataChange_LastTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UK_TargetId_PermissionType_DeletedAt` (`TargetId`,`PermissionType`,`DeletedAt`),
  KEY `IX_DataChange_LastTime` (`DataChange_LastTime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='permission表';



-- Dump of table role
-- ------------------------------------------------------------

CREATE TABLE `Role` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `RoleName` varchar(256) NOT NULL DEFAULT '' COMMENT 'Role name',
  `IsDeleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '1: deleted, 0: normal',
  `DeletedAt` BIGINT(20) NOT NULL DEFAULT '0' COMMENT 'Delete timestamp based on milliseconds',
  `DataChange_CreatedBy` varchar(64) NOT NULL DEFAULT 'default' COMMENT '创建人邮箱前缀',
  `DataChange_CreatedTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `DataChange_LastModifiedBy` varchar(64) DEFAULT '' COMMENT '最后修改人邮箱前缀',
  `DataChange_LastTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UK_RoleName_DeletedAt` (`RoleName`,`DeletedAt`),
  KEY `IX_DataChange_LastTime` (`DataChange_LastTime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色表';



-- Dump of table rolepermission
-- ------------------------------------------------------------

CREATE TABLE `RolePermission` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `RoleId` int(10) unsigned DEFAULT NULL COMMENT 'Role ID',
  `PermissionId` int(10) unsigned DEFAULT NULL COMMENT 'Permission ID',
  `IsDeleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '1: deleted, 0: normal',
  `DeletedAt` BIGINT(20) NOT NULL DEFAULT '0' COMMENT 'Delete timestamp based on milliseconds',
  `DataChange_CreatedBy` varchar(64) NOT NULL DEFAULT 'default' COMMENT '创建人邮箱前缀',
  `DataChange_CreatedTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `DataChange_LastModifiedBy` varchar(64) DEFAULT '' COMMENT '最后修改人邮箱前缀',
  `DataChange_LastTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UK_RoleId_PermissionId_DeletedAt` (`RoleId`,`PermissionId`,`DeletedAt`),
  KEY `IX_DataChange_LastTime` (`DataChange_LastTime`),
  KEY `IX_PermissionId` (`PermissionId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色和权限的绑定表';



-- Dump of table serverconfig
-- ------------------------------------------------------------

CREATE TABLE `ServerConfig` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `Key` varchar(64) NOT NULL DEFAULT 'default' COMMENT '配置项Key',
  `Value` varchar(2048) NOT NULL DEFAULT 'default' COMMENT '配置项值',
  `COMMENT` varchar(1024) DEFAULT '' COMMENT '注释',
  `IsDeleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '1: deleted, 0: normal',
  `DeletedAt` BIGINT(20) NOT NULL DEFAULT '0' COMMENT 'Delete timestamp based on milliseconds',
  `DataChange_CreatedBy` varchar(64) NOT NULL DEFAULT 'default' COMMENT '创建人邮箱前缀',
  `DataChange_CreatedTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `DataChange_LastModifiedBy` varchar(64) DEFAULT '' COMMENT '最后修改人邮箱前缀',
  `DataChange_LastTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UK_Key_DeletedAt` (`Key`,`DeletedAt`),
  KEY `DataChange_LastTime` (`DataChange_LastTime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='配置服务自身配置';



-- Dump of table userrole
-- ------------------------------------------------------------

CREATE TABLE `UserRole` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `UserId` varchar(128) DEFAULT '' COMMENT '用户身份标识',
  `RoleId` int(10) unsigned DEFAULT NULL COMMENT 'Role ID',
  `IsDeleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '1: deleted, 0: normal',
  `DeletedAt` BIGINT(20) NOT NULL DEFAULT '0' COMMENT 'Delete timestamp based on milliseconds',
  `DataChange_CreatedBy` varchar(64) NOT NULL DEFAULT 'default' COMMENT '创建人邮箱前缀',
  `DataChange_CreatedTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `DataChange_LastModifiedBy` varchar(64) DEFAULT '' COMMENT '最后修改人邮箱前缀',
  `DataChange_LastTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UK_UserId_RoleId_DeletedAt` (`UserId`,`RoleId`,`DeletedAt`),
  KEY `IX_DataChange_LastTime` (`DataChange_LastTime`),
  KEY `IX_RoleId` (`RoleId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户和role的绑定表';

-- Dump of table Users
-- ------------------------------------------------------------

CREATE TABLE `Users` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `Username` varchar(64) NOT NULL DEFAULT 'default' COMMENT '用户登录账户',
  `Password` varchar(512) NOT NULL DEFAULT 'default' COMMENT '密码',
  `UserDisplayName` varchar(512) NOT NULL DEFAULT 'default' COMMENT '用户名称',
  `Email` varchar(64) NOT NULL DEFAULT 'default' COMMENT '邮箱地址',
  `Enabled` tinyint(4) DEFAULT NULL COMMENT '是否有效',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UK_Username` (`Username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';


-- Dump of table Authorities
-- ------------------------------------------------------------

CREATE TABLE `Authorities` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `Username` varchar(64) NOT NULL,
  `Authority` varchar(50) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- spring session (https://github.com/spring-projects/spring-session/blob/faee8f1bdb8822a5653a81eba838dddf224d92d6/spring-session-jdbc/src/main/resources/org/springframework/session/jdbc/schema-mysql.sql)
-- Dump of table SPRING_SESSION
-- ------------------------------------------------------------

CREATE TABLE `SPRING_SESSION` (
  `PRIMARY_ID` char(36) NOT NULL,
  `SESSION_ID` char(36) NOT NULL,
  `CREATION_TIME` bigint NOT NULL,
  `LAST_ACCESS_TIME` bigint NOT NULL,
  `MAX_INACTIVE_INTERVAL` int NOT NULL,
  `EXPIRY_TIME` bigint NOT NULL,
  `PRINCIPAL_NAME` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`PRIMARY_ID`),
  UNIQUE KEY `SPRING_SESSION_IX1` (`SESSION_ID`),
  KEY `SPRING_SESSION_IX2` (`EXPIRY_TIME`),
  KEY `SPRING_SESSION_IX3` (`PRINCIPAL_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- Dump of table SPRING_SESSION_ATTRIBUTES
-- ------------------------------------------------------------

CREATE TABLE `SPRING_SESSION_ATTRIBUTES` (
  `SESSION_PRIMARY_ID` char(36) NOT NULL,
  `ATTRIBUTE_NAME` varchar(200) NOT NULL,
  `ATTRIBUTE_BYTES` blob NOT NULL,
  PRIMARY KEY (`SESSION_PRIMARY_ID`,`ATTRIBUTE_NAME`),
  CONSTRAINT `SPRING_SESSION_ATTRIBUTES_FK` FOREIGN KEY (`SESSION_PRIMARY_ID`) REFERENCES `SPRING_SESSION` (`PRIMARY_ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- Dump of table AuditLog
-- ------------------------------------------------------------

CREATE TABLE `AuditLog` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `TraceId` varchar(32) NOT NULL DEFAULT '' COMMENT '链路全局唯一ID',
  `SpanId` varchar(32) NOT NULL DEFAULT '' COMMENT '跨度ID',
  `ParentSpanId` varchar(32) DEFAULT NULL COMMENT '父跨度ID',
  `FollowsFromSpanId` varchar(32) DEFAULT NULL COMMENT '上一个兄弟跨度ID',
  `Operator` varchar(64) NOT NULL DEFAULT 'anonymous' COMMENT '操作人',
  `OpType` varchar(50) NOT NULL DEFAULT 'default' COMMENT '操作类型',
  `OpName` varchar(150) NOT NULL DEFAULT 'default' COMMENT '操作名称',
  `Description` varchar(200) DEFAULT NULL COMMENT '备注',
  `IsDeleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '1: deleted, 0: normal',
  `DeletedAt` BIGINT(20) NOT NULL DEFAULT '0' COMMENT 'Delete timestamp based on milliseconds',
  `DataChange_CreatedBy` varchar(64) DEFAULT NULL COMMENT '创建人邮箱前缀',
  `DataChange_CreatedTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `DataChange_LastModifiedBy` varchar(64) DEFAULT '' COMMENT '最后修改人邮箱前缀',
  `DataChange_LastTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
  PRIMARY KEY (`ID`),
  KEY `IX_TraceId` (`TraceId`),
  KEY `IX_OpName` (`OpName`),
  KEY `IX_DataChange_CreatedTime` (`DataChange_CreatedTime`),
  KEY `IX_Operator` (`Operator`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='审计日志表';

-- Dump of table AuditLogDataInfluence
-- ------------------------------------------------------------

CREATE TABLE `AuditLogDataInfluence` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `SpanId` char(32) NOT NULL DEFAULT '' COMMENT '跨度ID',
  `InfluenceEntityId` varchar(50) NOT NULL DEFAULT '0' COMMENT '记录ID',
  `InfluenceEntityName` varchar(50) NOT NULL DEFAULT 'default' COMMENT '表名',
  `FieldName` varchar(50) DEFAULT NULL COMMENT '字段名称',
  `FieldOldValue` varchar(500) DEFAULT NULL COMMENT '字段旧值',
  `FieldNewValue` varchar(500) DEFAULT NULL COMMENT '字段新值',
  `IsDeleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '1: deleted, 0: normal',
  `DeletedAt` BIGINT(20) NOT NULL DEFAULT '0' COMMENT 'Delete timestamp based on milliseconds',
  `DataChange_CreatedBy` varchar(64) DEFAULT NULL COMMENT '创建人邮箱前缀',
  `DataChange_CreatedTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `DataChange_LastModifiedBy` varchar(64) DEFAULT '' COMMENT '最后修改人邮箱前缀',
  `DataChange_LastTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
  PRIMARY KEY (`ID`),
  KEY `IX_SpanId` (`SpanId`),
  KEY `IX_DataChange_CreatedTime` (`DataChange_CreatedTime`),
  KEY `IX_EntityId` (`InfluenceEntityId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='审计日志数据变动表';

-- Config
-- ------------------------------------------------------------
INSERT INTO `ServerConfig` (`Key`, `Value`, `COMMENT`)
VALUES
    ('apollo.portal.envs', 'dev', '可支持的环境列表'),
    ('organizations', '[{"orgId":"TEST1","orgName":"样例部门1"},{"orgId":"TEST2","orgName":"样例部门2"}]', '部门列表'),
    ('superAdmin', 'apollo', 'Portal超级管理员'),
    ('api.readTimeout', '10000', 'http接口read timeout'),
    ('consumer.token.salt', 'someSalt', 'consumer token salt'),
    ('admin.createPrivateNamespace.switch', 'true', '是否允许项目管理员创建私有namespace'),
    ('configView.memberOnly.envs', 'pro', '只对项目成员显示配置信息的环境列表，多个env以英文逗号分隔'),
    ('apollo.portal.meta.servers', '{}', '各环境Meta Service列表');


INSERT INTO `Users` (`Username`, `Password`, `UserDisplayName`, `Email`, `Enabled`)
VALUES
	('apollo', '$2a$10$7r20uS.BQ9uBpf3Baj3uQOZvMVvB1RN3PYoKE94gtz2.WAOuiiwXS', 'apollo', 'apollo@acme.com', 1);

INSERT INTO `Authorities` (`Username`, `Authority`) VALUES ('apollo', 'ROLE_user');

-- 
-- ===============================================================================
-- ==                                                                           ==
-- ==                     Generated from 'scripts/sql/src/'                     ==
-- == by running 'mvn compile -pl apollo-build-sql-converter -Psql-converter'.  ==
-- ==                              DO NOT EDIT !!!                              ==
-- ==                                                                           ==
-- ===============================================================================

/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
