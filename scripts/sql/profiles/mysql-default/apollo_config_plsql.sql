prompt PL/SQL Developer Export User Objects for user APOLLO_CONFIG@APOLLO_CONFIG
prompt Created by xdw78 on 2025年6月15日
set define off
spool apollo_config.log

prompt
prompt Creating table ACCESSKEY
prompt ========================
prompt
create table APOLLO_CONFIG.ACCESSKEY
(
  id                        NUMBER(10) generated always as identity,
  appid                     VARCHAR2(64) default 'default' not null,
  secret                    VARCHAR2(128) default '' not null,
  mode                      NUMBER(3) default 0 not null,
  isenabled                 NUMBER(1) default 0 not null,
  isdeleted                 NUMBER(1) default 0 not null,
  deletedat                 NUMBER(20) default 0 not null,
  datachange_createdby      VARCHAR2(64) default 'default' not null,
  datachange_createdtime    TIMESTAMP(6) default CURRENT_TIMESTAMP not null,
  datachange_lastmodifiedby VARCHAR2(64) default '',
  datachange_lasttime       TIMESTAMP(6) default CURRENT_TIMESTAMP not null
)
tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 1
  maxtrans 255;
comment on table APOLLO_CONFIG.ACCESSKEY
  is '访问密钥';
comment on column APOLLO_CONFIG.ACCESSKEY.id
  is '自增主键';
comment on column APOLLO_CONFIG.ACCESSKEY.appid
  is 'AppID';
comment on column APOLLO_CONFIG.ACCESSKEY.secret
  is 'Secret';
comment on column APOLLO_CONFIG.ACCESSKEY.mode
  is '密钥模式，0: filter，1: observer';
comment on column APOLLO_CONFIG.ACCESSKEY.isenabled
  is '1: enabled, 0: disabled';
comment on column APOLLO_CONFIG.ACCESSKEY.isdeleted
  is '1: deleted, 0: normal';
comment on column APOLLO_CONFIG.ACCESSKEY.deletedat
  is 'Delete timestamp based on milliseconds';
comment on column APOLLO_CONFIG.ACCESSKEY.datachange_createdby
  is '创建人邮箱前缀';
comment on column APOLLO_CONFIG.ACCESSKEY.datachange_createdtime
  is '创建时间';
comment on column APOLLO_CONFIG.ACCESSKEY.datachange_lastmodifiedby
  is '最后修改人邮箱前缀';
comment on column APOLLO_CONFIG.ACCESSKEY.datachange_lasttime
  is '最后修改时间';
create index APOLLO_CONFIG.IDX_ACCESSKEY_DATACHANGE_LASTTIME on APOLLO_CONFIG.ACCESSKEY (DATACHANGE_LASTTIME)
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
alter table APOLLO_CONFIG.ACCESSKEY
  add constraint PK_ACCESSKEY primary key (ID)
  using index 
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
alter table APOLLO_CONFIG.ACCESSKEY
  add constraint UK_APP_SECRET_DEL unique (APPID, SECRET, DELETEDAT)
  using index 
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
alter table APOLLO_CONFIG.ACCESSKEY
  add check (ISDELETED IN (0,1));

prompt
prompt Creating table APP
prompt ==================
prompt
create table APOLLO_CONFIG.APP
(
  id                        NUMBER(10) generated always as identity,
  appid                     VARCHAR2(64) default 'default' not null,
  name                      VARCHAR2(500) default 'default' not null,
  orgid                     VARCHAR2(32) default 'default' not null,
  orgname                   VARCHAR2(64) default 'default' not null,
  ownername                 VARCHAR2(500) default 'default' not null,
  owneremail                VARCHAR2(500) default 'default' not null,
  isdeleted                 NUMBER(1) default 0 not null,
  deletedat                 NUMBER(20) default 0 not null,
  datachange_createdby      VARCHAR2(64) default 'default' not null,
  datachange_createdtime    TIMESTAMP(6) default CURRENT_TIMESTAMP not null,
  datachange_lastmodifiedby VARCHAR2(64) default '',
  datachange_lasttime       TIMESTAMP(6) default CURRENT_TIMESTAMP
)
tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 1
  maxtrans 255;
comment on table APOLLO_CONFIG.APP
  is '应用表';
comment on column APOLLO_CONFIG.APP.id
  is '主键';
comment on column APOLLO_CONFIG.APP.appid
  is 'AppID';
comment on column APOLLO_CONFIG.APP.name
  is '应用名';
comment on column APOLLO_CONFIG.APP.orgid
  is '部门Id';
comment on column APOLLO_CONFIG.APP.orgname
  is '部门名字';
comment on column APOLLO_CONFIG.APP.ownername
  is 'ownerName';
comment on column APOLLO_CONFIG.APP.owneremail
  is 'ownerEmail';
comment on column APOLLO_CONFIG.APP.isdeleted
  is '1: deleted, 0: normal';
comment on column APOLLO_CONFIG.APP.deletedat
  is 'Delete timestamp based on milliseconds';
comment on column APOLLO_CONFIG.APP.datachange_createdby
  is '创建人邮箱前缀';
comment on column APOLLO_CONFIG.APP.datachange_createdtime
  is '创建时间';
comment on column APOLLO_CONFIG.APP.datachange_lastmodifiedby
  is '最后修改人邮箱前缀';
comment on column APOLLO_CONFIG.APP.datachange_lasttime
  is '最后修改时间';
create index APOLLO_CONFIG.IDX_APP_DATACHANGE_LASTTIME on APOLLO_CONFIG.APP (DATACHANGE_LASTTIME)
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
create index APOLLO_CONFIG.IDX_APP_NAME on APOLLO_CONFIG.APP (SUBSTR(NAME,1,191))
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
alter table APOLLO_CONFIG.APP
  add constraint APP_PK primary key (ID)
  using index 
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
alter table APOLLO_CONFIG.APP
  add constraint UK_APPID_DELETEDAT unique (APPID, DELETEDAT)
  using index 
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
alter table APOLLO_CONFIG.APP
  add check (ISDELETED IN (0,1));

prompt
prompt Creating table APPNAMESPACE
prompt ===========================
prompt
create table APOLLO_CONFIG.APPNAMESPACE
(
  id                        NUMBER(10) generated always as identity,
  name                      VARCHAR2(32) default '' not null,
  appid                     VARCHAR2(64) default '' not null,
  format                    VARCHAR2(32) default 'properties' not null,
  ispublic                  NUMBER(1) default 0 not null,
  comment                   VARCHAR2(64) default '' not null,
  isdeleted                 NUMBER(1) default 0 not null,
  deletedat                 NUMBER(20) default 0 not null,
  datachange_createdby      VARCHAR2(64) default 'default' not null,
  datachange_createdtime    TIMESTAMP(6) default CURRENT_TIMESTAMP not null,
  datachange_lastmodifiedby VARCHAR2(64) default '',
  datachange_lasttime       TIMESTAMP(6) default CURRENT_TIMESTAMP
)
tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 1
  maxtrans 255;
comment on table APOLLO_CONFIG.APPNAMESPACE
  is '应用namespace定义';
comment on column APOLLO_CONFIG.APPNAMESPACE.id
  is '自增主键';
comment on column APOLLO_CONFIG.APPNAMESPACE.name
  is 'namespace名字，需要全局唯一';
comment on column APOLLO_CONFIG.APPNAMESPACE.appid
  is 'app id';
comment on column APOLLO_CONFIG.APPNAMESPACE.format
  is 'namespace的format类型';
comment on column APOLLO_CONFIG.APPNAMESPACE.ispublic
  is 'namespace是否为公共';
comment on column APOLLO_CONFIG.APPNAMESPACE.comment
  is '注释';
comment on column APOLLO_CONFIG.APPNAMESPACE.isdeleted
  is '1: deleted, 0: normal';
comment on column APOLLO_CONFIG.APPNAMESPACE.deletedat
  is 'Delete timestamp based on milliseconds';
comment on column APOLLO_CONFIG.APPNAMESPACE.datachange_createdby
  is '创建人邮箱前缀';
comment on column APOLLO_CONFIG.APPNAMESPACE.datachange_createdtime
  is '创建时间';
comment on column APOLLO_CONFIG.APPNAMESPACE.datachange_lastmodifiedby
  is '最后修改人邮箱前缀';
comment on column APOLLO_CONFIG.APPNAMESPACE.datachange_lasttime
  is '最后修改时间';
create index APOLLO_CONFIG.IDX_APPSPACE_DATACHANGE_LASTTIME on APOLLO_CONFIG.APPNAMESPACE (DATACHANGE_LASTTIME)
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
create index APOLLO_CONFIG.IDX_APPSPACE_NAME_APPID on APOLLO_CONFIG.APPNAMESPACE (NAME, APPID)
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
alter table APOLLO_CONFIG.APPNAMESPACE
  add constraint PK_APPSPACE primary key (ID)
  using index 
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
alter table APOLLO_CONFIG.APPNAMESPACE
  add constraint UK_APPID_NAME_DELETEDAT unique (APPID, NAME, DELETEDAT)
  using index 
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
alter table APOLLO_CONFIG.APPNAMESPACE
  add check (ISPUBLIC IN (0,1));
alter table APOLLO_CONFIG.APPNAMESPACE
  add check (ISDELETED IN (0,1));

prompt
prompt Creating table AUDIT
prompt ====================
prompt
create table APOLLO_CONFIG.AUDIT
(
  id                        NUMBER(10) generated always as identity,
  entityname                VARCHAR2(50) default 'default' not null,
  entityid                  NUMBER(10),
  opname                    VARCHAR2(50) default 'default' not null,
  comment                   VARCHAR2(500),
  isdeleted                 NUMBER(1) default 0 not null,
  deletedat                 NUMBER(20) default 0 not null,
  datachange_createdby      VARCHAR2(64) default 'default' not null,
  datachange_createdtime    TIMESTAMP(6) default SYSTIMESTAMP not null,
  datachange_lastmodifiedby VARCHAR2(64) default '',
  datachange_lasttime       TIMESTAMP(6) default SYSTIMESTAMP
)
tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 1
  maxtrans 255;
comment on table APOLLO_CONFIG.AUDIT
  is '日志审计表';
comment on column APOLLO_CONFIG.AUDIT.id
  is '主键';
comment on column APOLLO_CONFIG.AUDIT.entityname
  is '表名';
comment on column APOLLO_CONFIG.AUDIT.entityid
  is '记录ID';
comment on column APOLLO_CONFIG.AUDIT.opname
  is '操作类型';
comment on column APOLLO_CONFIG.AUDIT.comment
  is '备注';
comment on column APOLLO_CONFIG.AUDIT.isdeleted
  is '1: deleted, 0: normal';
comment on column APOLLO_CONFIG.AUDIT.deletedat
  is 'Delete timestamp based on milliseconds';
comment on column APOLLO_CONFIG.AUDIT.datachange_createdby
  is '创建人邮箱前缀';
comment on column APOLLO_CONFIG.AUDIT.datachange_createdtime
  is '创建时间';
comment on column APOLLO_CONFIG.AUDIT.datachange_lastmodifiedby
  is '最后修改人邮箱前缀';
comment on column APOLLO_CONFIG.AUDIT.datachange_lasttime
  is '最后修改时间';
create index APOLLO_CONFIG.IDX_AUDIT_LASTTIME on APOLLO_CONFIG.AUDIT (DATACHANGE_LASTTIME)
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
alter table APOLLO_CONFIG.AUDIT
  add primary key (ID)
  using index 
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
alter table APOLLO_CONFIG.AUDIT
  add check (ISDELETED IN (0, 1));

prompt
prompt Creating table AUDITLOG
prompt =======================
prompt
create table APOLLO_CONFIG.AUDITLOG
(
  id                        NUMBER(10) generated always as identity,
  traceid                   VARCHAR2(32) default '' not null,
  spanid                    VARCHAR2(32) default '' not null,
  parentspanid              VARCHAR2(32),
  followsfromspanid         VARCHAR2(32),
  operator                  VARCHAR2(64) default 'anonymous' not null,
  optype                    VARCHAR2(50) default 'default' not null,
  opname                    VARCHAR2(150) default 'default' not null,
  description               VARCHAR2(200),
  isdeleted                 NUMBER(1) default 0 not null,
  deletedat                 NUMBER(20) default 0 not null,
  datachange_createdby      VARCHAR2(64),
  datachange_createdtime    TIMESTAMP(6) default CURRENT_TIMESTAMP not null,
  datachange_lastmodifiedby VARCHAR2(64) default '',
  datachange_lasttime       TIMESTAMP(6) default CURRENT_TIMESTAMP
)
tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 1
  maxtrans 255;
comment on table APOLLO_CONFIG.AUDITLOG
  is '审计日志表';
comment on column APOLLO_CONFIG.AUDITLOG.id
  is '主键';
comment on column APOLLO_CONFIG.AUDITLOG.traceid
  is '链路全局唯一ID';
comment on column APOLLO_CONFIG.AUDITLOG.spanid
  is '跨度ID';
comment on column APOLLO_CONFIG.AUDITLOG.parentspanid
  is '父跨度ID';
comment on column APOLLO_CONFIG.AUDITLOG.followsfromspanid
  is '上一个兄弟跨度ID';
comment on column APOLLO_CONFIG.AUDITLOG.operator
  is '操作人';
comment on column APOLLO_CONFIG.AUDITLOG.optype
  is '操作类型';
comment on column APOLLO_CONFIG.AUDITLOG.opname
  is '操作名称';
comment on column APOLLO_CONFIG.AUDITLOG.description
  is '备注';
comment on column APOLLO_CONFIG.AUDITLOG.isdeleted
  is '1: deleted, 0: normal';
comment on column APOLLO_CONFIG.AUDITLOG.deletedat
  is 'Delete timestamp based on milliseconds';
comment on column APOLLO_CONFIG.AUDITLOG.datachange_createdby
  is '创建人邮箱前缀';
comment on column APOLLO_CONFIG.AUDITLOG.datachange_createdtime
  is '创建时间';
comment on column APOLLO_CONFIG.AUDITLOG.datachange_lastmodifiedby
  is '最后修改人邮箱前缀';
comment on column APOLLO_CONFIG.AUDITLOG.datachange_lasttime
  is '最后修改时间';
create index APOLLO_CONFIG.IDX_AUDITLOG_DATACHANGE_CREATEDTIME on APOLLO_CONFIG.AUDITLOG (DATACHANGE_CREATEDTIME)
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
create index APOLLO_CONFIG.IDX_AUDITLOG_OPERATOR on APOLLO_CONFIG.AUDITLOG (OPERATOR)
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
create index APOLLO_CONFIG.IDX_AUDITLOG_OPNAME on APOLLO_CONFIG.AUDITLOG (OPNAME)
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
create index APOLLO_CONFIG.IDX_AUDITLOG_TRACEID on APOLLO_CONFIG.AUDITLOG (TRACEID)
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
alter table APOLLO_CONFIG.AUDITLOG
  add constraint PK_AUDITLOG primary key (ID)
  using index 
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
alter table APOLLO_CONFIG.AUDITLOG
  add check (ISDELETED IN (0,1));

prompt
prompt Creating table AUDITLOGDATAINFLUENCE
prompt ====================================
prompt
create table APOLLO_CONFIG.AUDITLOGDATAINFLUENCE
(
  id                        NUMBER(10) generated always as identity,
  spanid                    CHAR(32) default '' not null,
  influenceentityid         VARCHAR2(50) default '0' not null,
  influenceentityname       VARCHAR2(50) default 'default' not null,
  fieldname                 VARCHAR2(50),
  fieldoldvalue             VARCHAR2(500),
  fieldnewvalue             VARCHAR2(500),
  isdeleted                 NUMBER(1) default 0 not null,
  deletedat                 NUMBER(20) default 0 not null,
  datachange_createdby      VARCHAR2(64),
  datachange_createdtime    TIMESTAMP(6) default CURRENT_TIMESTAMP not null,
  datachange_lastmodifiedby VARCHAR2(64) default '',
  datachange_lasttime       TIMESTAMP(6) default CURRENT_TIMESTAMP
)
tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 1
  maxtrans 255;
comment on table APOLLO_CONFIG.AUDITLOGDATAINFLUENCE
  is '审计日志数据变动表';
comment on column APOLLO_CONFIG.AUDITLOGDATAINFLUENCE.id
  is '主键';
comment on column APOLLO_CONFIG.AUDITLOGDATAINFLUENCE.spanid
  is '跨度ID';
comment on column APOLLO_CONFIG.AUDITLOGDATAINFLUENCE.influenceentityid
  is '记录ID';
comment on column APOLLO_CONFIG.AUDITLOGDATAINFLUENCE.influenceentityname
  is '表名';
comment on column APOLLO_CONFIG.AUDITLOGDATAINFLUENCE.fieldname
  is '字段名称';
comment on column APOLLO_CONFIG.AUDITLOGDATAINFLUENCE.fieldoldvalue
  is '字段旧值';
comment on column APOLLO_CONFIG.AUDITLOGDATAINFLUENCE.fieldnewvalue
  is '字段新值';
comment on column APOLLO_CONFIG.AUDITLOGDATAINFLUENCE.isdeleted
  is '1: deleted, 0: normal';
comment on column APOLLO_CONFIG.AUDITLOGDATAINFLUENCE.deletedat
  is 'Delete timestamp based on milliseconds';
comment on column APOLLO_CONFIG.AUDITLOGDATAINFLUENCE.datachange_createdby
  is '创建人邮箱前缀';
comment on column APOLLO_CONFIG.AUDITLOGDATAINFLUENCE.datachange_createdtime
  is '创建时间';
comment on column APOLLO_CONFIG.AUDITLOGDATAINFLUENCE.datachange_lastmodifiedby
  is '最后修改人邮箱前缀';
comment on column APOLLO_CONFIG.AUDITLOGDATAINFLUENCE.datachange_lasttime
  is '最后修改时间';
create index APOLLO_CONFIG.IDX_AUDITLOGDATAINFLUENCE_DATACHANGE_CREATEDTIME on APOLLO_CONFIG.AUDITLOGDATAINFLUENCE (DATACHANGE_CREATEDTIME)
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
create index APOLLO_CONFIG.IDX_AUDITLOGDATAINFLUENCE_ENTITYID on APOLLO_CONFIG.AUDITLOGDATAINFLUENCE (INFLUENCEENTITYID)
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
create index APOLLO_CONFIG.IDX_AUDITLOGDATAINFLUENCE_SPANID on APOLLO_CONFIG.AUDITLOGDATAINFLUENCE (SPANID)
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
alter table APOLLO_CONFIG.AUDITLOGDATAINFLUENCE
  add constraint PK_AUDITDATALOG primary key (ID)
  using index 
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
alter table APOLLO_CONFIG.AUDITLOGDATAINFLUENCE
  add check (ISDELETED IN (0,1));

prompt
prompt Creating table CLUSTER
prompt ======================
prompt
create table APOLLO_CONFIG.CLUSTER
(
  id                        NUMBER(10) generated always as identity,
  name                      VARCHAR2(32) default '' not null,
  appid                     VARCHAR2(64) default '' not null,
  parentclusterid           NUMBER(10) default 0 not null,
  comment                   VARCHAR2(64),
  isdeleted                 NUMBER(1) default 0 not null,
  deletedat                 NUMBER(20) default 0 not null,
  datachange_createdby      VARCHAR2(64) default 'default' not null,
  datachange_createdtime    TIMESTAMP(6) default CURRENT_TIMESTAMP not null,
  datachange_lastmodifiedby VARCHAR2(64) default '',
  datachange_lasttime       TIMESTAMP(6) default CURRENT_TIMESTAMP
)
tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 1
  maxtrans 255;
comment on table APOLLO_CONFIG.CLUSTER
  is '集群';
comment on column APOLLO_CONFIG.CLUSTER.id
  is '自增主键';
comment on column APOLLO_CONFIG.CLUSTER.name
  is '集群名字';
comment on column APOLLO_CONFIG.CLUSTER.appid
  is 'App id';
comment on column APOLLO_CONFIG.CLUSTER.parentclusterid
  is '父cluster';
comment on column APOLLO_CONFIG.CLUSTER.comment
  is '备注';
comment on column APOLLO_CONFIG.CLUSTER.isdeleted
  is '1: deleted, 0: normal';
comment on column APOLLO_CONFIG.CLUSTER.deletedat
  is 'Delete timestamp based on milliseconds';
comment on column APOLLO_CONFIG.CLUSTER.datachange_createdby
  is '创建人邮箱前缀';
comment on column APOLLO_CONFIG.CLUSTER.datachange_createdtime
  is '创建时间';
comment on column APOLLO_CONFIG.CLUSTER.datachange_lastmodifiedby
  is '最后修改人邮箱前缀';
comment on column APOLLO_CONFIG.CLUSTER.datachange_lasttime
  is '最后修改时间';
create index APOLLO_CONFIG.IDX_CLUSTER_DATACHANGE_LASTTIME on APOLLO_CONFIG.CLUSTER (DATACHANGE_LASTTIME)
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
create index APOLLO_CONFIG.IDX_CLUSTER_PARENTCLUSTERID on APOLLO_CONFIG.CLUSTER (PARENTCLUSTERID)
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
alter table APOLLO_CONFIG.CLUSTER
  add constraint PK_APP_CLUSTER primary key (ID)
  using index 
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
alter table APOLLO_CONFIG.CLUSTER
  add constraint UK_APPID_NAME_DEL_AT unique (APPID, NAME, DELETEDAT)
  using index 
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
alter table APOLLO_CONFIG.CLUSTER
  add check (ISDELETED IN (0,1));

prompt
prompt Creating table COMMIT
prompt =====================
prompt
create table APOLLO_CONFIG.COMMIT
(
  id                        NUMBER(10) generated always as identity,
  changesets                CLOB not null,
  appid                     VARCHAR2(64) default 'default' not null,
  clustername               VARCHAR2(32) default 'default' not null,
  namespacename             VARCHAR2(32) default 'default' not null,
  comment                   VARCHAR2(500),
  isdeleted                 NUMBER(1) default 0 not null,
  deletedat                 NUMBER(20) default 0 not null,
  datachange_createdby      VARCHAR2(64) default 'default' not null,
  datachange_createdtime    TIMESTAMP(6) default CURRENT_TIMESTAMP not null,
  datachange_lastmodifiedby VARCHAR2(64) default '',
  datachange_lasttime       TIMESTAMP(6) default CURRENT_TIMESTAMP
)
tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 1
  maxtrans 255;
comment on table APOLLO_CONFIG.COMMIT
  is 'commit 历史表';
comment on column APOLLO_CONFIG.COMMIT.id
  is '主键';
comment on column APOLLO_CONFIG.COMMIT.changesets
  is '修改变更集';
comment on column APOLLO_CONFIG.COMMIT.appid
  is 'AppID';
comment on column APOLLO_CONFIG.COMMIT.clustername
  is 'ClusterName';
comment on column APOLLO_CONFIG.COMMIT.namespacename
  is 'namespaceName';
comment on column APOLLO_CONFIG.COMMIT.comment
  is '备注';
comment on column APOLLO_CONFIG.COMMIT.isdeleted
  is '1: deleted, 0: normal';
comment on column APOLLO_CONFIG.COMMIT.deletedat
  is 'Delete timestamp based on milliseconds';
comment on column APOLLO_CONFIG.COMMIT.datachange_createdby
  is '创建人邮箱前缀';
comment on column APOLLO_CONFIG.COMMIT.datachange_createdtime
  is '创建时间';
comment on column APOLLO_CONFIG.COMMIT.datachange_lastmodifiedby
  is '最后修改人邮箱前缀';
comment on column APOLLO_CONFIG.COMMIT.datachange_lasttime
  is '最后修改时间';
create index APOLLO_CONFIG.IDX_COMMIT_APPID on APOLLO_CONFIG.COMMIT (APPID)
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
create index APOLLO_CONFIG.IDX_COMMIT_CLUSTERNAME on APOLLO_CONFIG.COMMIT (CLUSTERNAME)
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
create index APOLLO_CONFIG.IDX_COMMIT_DATACHANGE_LASTTIME on APOLLO_CONFIG.COMMIT (DATACHANGE_LASTTIME)
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
create index APOLLO_CONFIG.IDX_COMMIT_NAMESPACENAME on APOLLO_CONFIG.COMMIT (NAMESPACENAME)
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
alter table APOLLO_CONFIG.COMMIT
  add constraint PK_APP_COMMIT primary key (ID)
  using index 
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
alter table APOLLO_CONFIG.COMMIT
  add check (ISDELETED IN (0,1));

prompt
prompt Creating table GRAYRELEASERULE
prompt ==============================
prompt
create table APOLLO_CONFIG.GRAYRELEASERULE
(
  id                        NUMBER(11) generated always as identity,
  appid                     VARCHAR2(64) default 'default' not null,
  clustername               VARCHAR2(32) default 'default' not null,
  namespacename             VARCHAR2(32) default 'default' not null,
  branchname                VARCHAR2(32) default 'default' not null,
  rules                     CLOB default '[]',
  releaseid                 NUMBER(11) default 0 not null,
  branchstatus              NUMBER(2) default 1,
  isdeleted                 NUMBER(1) default 0 not null,
  deletedat                 NUMBER(20) default 0 not null,
  datachange_createdby      VARCHAR2(64) default 'default' not null,
  datachange_createdtime    TIMESTAMP(6) default CURRENT_TIMESTAMP not null,
  datachange_lastmodifiedby VARCHAR2(64) default '',
  datachange_lasttime       TIMESTAMP(6) default CURRENT_TIMESTAMP
)
tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 1
  maxtrans 255;
comment on table APOLLO_CONFIG.GRAYRELEASERULE
  is '灰度规则表';
comment on column APOLLO_CONFIG.GRAYRELEASERULE.id
  is '主键';
comment on column APOLLO_CONFIG.GRAYRELEASERULE.appid
  is 'AppID';
comment on column APOLLO_CONFIG.GRAYRELEASERULE.clustername
  is 'Cluster Name';
comment on column APOLLO_CONFIG.GRAYRELEASERULE.namespacename
  is 'Namespace Name';
comment on column APOLLO_CONFIG.GRAYRELEASERULE.branchname
  is 'branch name';
comment on column APOLLO_CONFIG.GRAYRELEASERULE.rules
  is '灰度规则';
comment on column APOLLO_CONFIG.GRAYRELEASERULE.releaseid
  is '灰度对应的release';
comment on column APOLLO_CONFIG.GRAYRELEASERULE.branchstatus
  is '灰度分支状态: 0:删除分支,1:正在使用的规则 2：全量发布';
comment on column APOLLO_CONFIG.GRAYRELEASERULE.isdeleted
  is '1: deleted, 0: normal';
comment on column APOLLO_CONFIG.GRAYRELEASERULE.deletedat
  is 'Delete timestamp based on milliseconds';
comment on column APOLLO_CONFIG.GRAYRELEASERULE.datachange_createdby
  is '创建人邮箱前缀';
comment on column APOLLO_CONFIG.GRAYRELEASERULE.datachange_createdtime
  is '创建时间';
comment on column APOLLO_CONFIG.GRAYRELEASERULE.datachange_lastmodifiedby
  is '最后修改人邮箱前缀';
comment on column APOLLO_CONFIG.GRAYRELEASERULE.datachange_lasttime
  is '最后修改时间';
create index APOLLO_CONFIG.IDX_GRAYRELEASERULE_APP_CLUSTER_NAMESPACE on APOLLO_CONFIG.GRAYRELEASERULE (APPID, CLUSTERNAME, NAMESPACENAME)
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
create index APOLLO_CONFIG.IDX_GRAYRELEASERULE_DATACHANGE_LASTTIME on APOLLO_CONFIG.GRAYRELEASERULE (DATACHANGE_LASTTIME)
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
alter table APOLLO_CONFIG.GRAYRELEASERULE
  add constraint PK_GRAYRELEASERULE primary key (ID)
  using index 
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
alter table APOLLO_CONFIG.GRAYRELEASERULE
  add check (ISDELETED IN (0,1));

prompt
prompt Creating table INSTANCE
prompt =======================
prompt
create table APOLLO_CONFIG.INSTANCE
(
  id                     NUMBER(11) generated always as identity,
  appid                  VARCHAR2(64) default 'default' not null,
  clustername            VARCHAR2(32) default 'default' not null,
  datacenter             VARCHAR2(64) default 'default' not null,
  ip                     VARCHAR2(32) default '' not null,
  datachange_createdtime TIMESTAMP(6) default CURRENT_TIMESTAMP not null,
  datachange_lasttime    TIMESTAMP(6) default CURRENT_TIMESTAMP not null
)
tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 1
  maxtrans 255;
comment on table APOLLO_CONFIG.INSTANCE
  is '使用配置的应用实例';
comment on column APOLLO_CONFIG.INSTANCE.id
  is '自增Id';
comment on column APOLLO_CONFIG.INSTANCE.appid
  is 'AppID';
comment on column APOLLO_CONFIG.INSTANCE.clustername
  is 'ClusterName';
comment on column APOLLO_CONFIG.INSTANCE.datacenter
  is 'Data Center Name';
comment on column APOLLO_CONFIG.INSTANCE.ip
  is 'instance ip';
comment on column APOLLO_CONFIG.INSTANCE.datachange_createdtime
  is '创建时间';
comment on column APOLLO_CONFIG.INSTANCE.datachange_lasttime
  is '最后修改时间';
create index APOLLO_CONFIG.IDX_INSTANCE_DATACHANGE_LASTTIME on APOLLO_CONFIG.INSTANCE (DATACHANGE_LASTTIME)
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
create index APOLLO_CONFIG.IDX_INSTANCE_IP on APOLLO_CONFIG.INSTANCE (IP)
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
alter table APOLLO_CONFIG.INSTANCE
  add constraint PK_INSTANCE primary key (ID)
  using index 
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
alter table APOLLO_CONFIG.INSTANCE
  add constraint UK_APP_CLUSTER_IP_DC unique (APPID, CLUSTERNAME, IP, DATACENTER)
  using index 
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;

prompt
prompt Creating table INSTANCECONFIG
prompt =============================
prompt
create table APOLLO_CONFIG.INSTANCECONFIG
(
  id                     NUMBER(10) generated always as identity,
  instanceid             NUMBER(11),
  configappid            VARCHAR2(64) default 'default' not null,
  configclustername      VARCHAR2(32) default 'default' not null,
  confignamespacename    VARCHAR2(32) default 'default' not null,
  releasekey             VARCHAR2(64) default '' not null,
  releasedeliverytime    TIMESTAMP(6),
  datachange_createdtime TIMESTAMP(6) default CURRENT_TIMESTAMP not null,
  datachange_lasttime    TIMESTAMP(6) default CURRENT_TIMESTAMP not null
)
tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 1
  maxtrans 255;
comment on table APOLLO_CONFIG.INSTANCECONFIG
  is '应用实例的配置信息';
comment on column APOLLO_CONFIG.INSTANCECONFIG.id
  is '自增Id';
comment on column APOLLO_CONFIG.INSTANCECONFIG.instanceid
  is 'Instance Id';
comment on column APOLLO_CONFIG.INSTANCECONFIG.configappid
  is 'Config App Id';
comment on column APOLLO_CONFIG.INSTANCECONFIG.configclustername
  is 'Config Cluster Name';
comment on column APOLLO_CONFIG.INSTANCECONFIG.confignamespacename
  is 'Config Namespace Name';
comment on column APOLLO_CONFIG.INSTANCECONFIG.releasekey
  is '发布的Key';
comment on column APOLLO_CONFIG.INSTANCECONFIG.releasedeliverytime
  is '配置获取时间';
comment on column APOLLO_CONFIG.INSTANCECONFIG.datachange_createdtime
  is '创建时间';
comment on column APOLLO_CONFIG.INSTANCECONFIG.datachange_lasttime
  is '最后修改时间';
create index APOLLO_CONFIG.IDX_INSTANCECONFIG_DATACHANGE_LASTTIME on APOLLO_CONFIG.INSTANCECONFIG (DATACHANGE_LASTTIME)
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
create index APOLLO_CONFIG.IDX_INSTANCECONFIG_RELEASEKEY on APOLLO_CONFIG.INSTANCECONFIG (RELEASEKEY)
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
create index APOLLO_CONFIG.IDX_INSTANCECONFIG_VALID_NAMESPACE on APOLLO_CONFIG.INSTANCECONFIG (CONFIGAPPID, CONFIGCLUSTERNAME, CONFIGNAMESPACENAME, DATACHANGE_LASTTIME)
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
create unique index APOLLO_CONFIG.IX_UNIQUE_KEY on APOLLO_CONFIG.INSTANCECONFIG (INSTANCEID, CONFIGAPPID, CONFIGNAMESPACENAME)
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
alter table APOLLO_CONFIG.INSTANCECONFIG
  add constraint PK_INSTANCECONFIG primary key (ID)
  using index 
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;

prompt
prompt Creating table ITEM
prompt ===================
prompt
create table APOLLO_CONFIG.ITEM
(
  id                        NUMBER(10) generated always as identity,
  namespaceid               NUMBER(10) default 0 not null,
  key                  VARCHAR2(128) default 'default' not null,
  type                 NUMBER(3) default 0 not null,
  value                CLOB not null,
  comment              VARCHAR2(1024) default '',
  linenum                   NUMBER(10) default 0,
  isdeleted                 NUMBER(1) default 0 not null,
  deletedat                 NUMBER(20) default 0 not null,
  datachange_createdby      VARCHAR2(64) default 'default' not null,
  datachange_createdtime    TIMESTAMP(6) default CURRENT_TIMESTAMP not null,
  datachange_lastmodifiedby VARCHAR2(64) default '',
  datachange_lasttime       TIMESTAMP(6) default CURRENT_TIMESTAMP
)
tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 1
  maxtrans 255;
comment on table APOLLO_CONFIG.ITEM
  is '配置项目';
comment on column APOLLO_CONFIG.ITEM.id
  is '自增Id';
comment on column APOLLO_CONFIG.ITEM.namespaceid
  is '集群NamespaceId';
comment on column APOLLO_CONFIG.ITEM.key
  is '配置项Key';
comment on column APOLLO_CONFIG.ITEM.type
  is '配置项类型，0: String，1: Number，2: Boolean，3: JSON';
comment on column APOLLO_CONFIG.ITEM.value
  is '配置项值';
comment on column APOLLO_CONFIG.ITEM.comment
  is '注释';
comment on column APOLLO_CONFIG.ITEM.linenum
  is '行号';
comment on column APOLLO_CONFIG.ITEM.isdeleted
  is '1: deleted, 0: normal';
comment on column APOLLO_CONFIG.ITEM.deletedat
  is 'Delete timestamp based on milliseconds';
comment on column APOLLO_CONFIG.ITEM.datachange_createdby
  is '创建人邮箱前缀';
comment on column APOLLO_CONFIG.ITEM.datachange_createdtime
  is '创建时间';
comment on column APOLLO_CONFIG.ITEM.datachange_lastmodifiedby
  is '最后修改人邮箱前缀';
comment on column APOLLO_CONFIG.ITEM.datachange_lasttime
  is '最后修改时间';
create index APOLLO_CONFIG.IDX_ITEM_DATACHANGE_LASTTIME on APOLLO_CONFIG.ITEM (DATACHANGE_LASTTIME)
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
create index APOLLO_CONFIG.IDX_ITEM_NAMESPACEID on APOLLO_CONFIG.ITEM (NAMESPACEID)
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
alter table APOLLO_CONFIG.ITEM
  add constraint PK_CONFIG_ITEM primary key (ID)
  using index 
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
alter table APOLLO_CONFIG.ITEM
  add check (ISDELETED IN (0,1));

prompt
prompt Creating table NAMESPACE
prompt ========================
prompt
create table APOLLO_CONFIG.NAMESPACE
(
  id                        NUMBER(10) generated always as identity,
  appid                     VARCHAR2(64) default 'default' not null,
  clustername               VARCHAR2(32) default 'default' not null,
  namespacename             VARCHAR2(32) default 'default' not null,
  isdeleted                 NUMBER(1) default 0 not null,
  deletedat                 NUMBER(20) default 0 not null,
  datachange_createdby      VARCHAR2(64) default 'default' not null,
  datachange_createdtime    TIMESTAMP(6) default CURRENT_TIMESTAMP not null,
  datachange_lastmodifiedby VARCHAR2(64) default '',
  datachange_lasttime       TIMESTAMP(6) default CURRENT_TIMESTAMP
)
tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 1
  maxtrans 255;
comment on table APOLLO_CONFIG.NAMESPACE
  is '命名空间';
comment on column APOLLO_CONFIG.NAMESPACE.id
  is '自增主键';
comment on column APOLLO_CONFIG.NAMESPACE.appid
  is 'AppID';
comment on column APOLLO_CONFIG.NAMESPACE.clustername
  is 'Cluster Name';
comment on column APOLLO_CONFIG.NAMESPACE.namespacename
  is 'Namespace Name';
comment on column APOLLO_CONFIG.NAMESPACE.isdeleted
  is '1: deleted, 0: normal';
comment on column APOLLO_CONFIG.NAMESPACE.deletedat
  is 'Delete timestamp based on milliseconds';
comment on column APOLLO_CONFIG.NAMESPACE.datachange_createdby
  is '创建人邮箱前缀';
comment on column APOLLO_CONFIG.NAMESPACE.datachange_createdtime
  is '创建时间';
comment on column APOLLO_CONFIG.NAMESPACE.datachange_lastmodifiedby
  is '最后修改人邮箱前缀';
comment on column APOLLO_CONFIG.NAMESPACE.datachange_lasttime
  is '最后修改时间';
create index APOLLO_CONFIG.IDX_NAMESPACE_DATACHANGE_LASTTIME on APOLLO_CONFIG.NAMESPACE (DATACHANGE_LASTTIME)
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
create index APOLLO_CONFIG.IDX_NAMESPACE_NAMESPACENAME on APOLLO_CONFIG.NAMESPACE (NAMESPACENAME)
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
alter table APOLLO_CONFIG.NAMESPACE
  add constraint PK_NAMESPACE primary key (ID)
  using index 
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
alter table APOLLO_CONFIG.NAMESPACE
  add constraint UK_APP_CLUSTER_NS_DEL unique (APPID, CLUSTERNAME, NAMESPACENAME, DELETEDAT)
  using index 
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
alter table APOLLO_CONFIG.NAMESPACE
  add check (ISDELETED IN (0,1));

prompt
prompt Creating table NAMESPACELOCK
prompt ============================
prompt
create table APOLLO_CONFIG.NAMESPACELOCK
(
  id                        NUMBER(11) generated always as identity,
  namespaceid               NUMBER(10) default 0 not null,
  datachange_createdby      VARCHAR2(64) default 'default' not null,
  datachange_createdtime    TIMESTAMP(6) default CURRENT_TIMESTAMP not null,
  datachange_lastmodifiedby VARCHAR2(64) default '',
  datachange_lasttime       TIMESTAMP(6) default CURRENT_TIMESTAMP,
  isdeleted                 NUMBER(1) default 0 not null,
  deletedat                 NUMBER(20) default 0 not null
)
tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 1
  maxtrans 255;
comment on table APOLLO_CONFIG.NAMESPACELOCK
  is 'namespace的编辑锁';
comment on column APOLLO_CONFIG.NAMESPACELOCK.id
  is '自增id';
comment on column APOLLO_CONFIG.NAMESPACELOCK.namespaceid
  is '集群NamespaceId';
comment on column APOLLO_CONFIG.NAMESPACELOCK.datachange_createdby
  is '创建人邮箱前缀';
comment on column APOLLO_CONFIG.NAMESPACELOCK.datachange_createdtime
  is '创建时间';
comment on column APOLLO_CONFIG.NAMESPACELOCK.datachange_lastmodifiedby
  is '最后修改人邮箱前缀';
comment on column APOLLO_CONFIG.NAMESPACELOCK.datachange_lasttime
  is '最后修改时间';
comment on column APOLLO_CONFIG.NAMESPACELOCK.isdeleted
  is '软删除';
comment on column APOLLO_CONFIG.NAMESPACELOCK.deletedat
  is 'Delete timestamp based on milliseconds';
create index APOLLO_CONFIG.IDX_NAMESPACELOCK_DATACHANGE_LASTTIME on APOLLO_CONFIG.NAMESPACELOCK (DATACHANGE_LASTTIME)
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
alter table APOLLO_CONFIG.NAMESPACELOCK
  add constraint PK_NAMESPACELOCK primary key (ID)
  using index 
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
alter table APOLLO_CONFIG.NAMESPACELOCK
  add constraint UK_NSID_DELETEDAT unique (NAMESPACEID, DELETEDAT)
  using index 
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
alter table APOLLO_CONFIG.NAMESPACELOCK
  add check (ISDELETED IN (0,1));

prompt
prompt Creating table RELEASE
prompt ======================
prompt
create table APOLLO_CONFIG.RELEASE
(
  id                        NUMBER(10) generated always as identity,
  releasekey                VARCHAR2(64) default '' not null,
  name                      VARCHAR2(64) default 'default' not null,
  comment                   VARCHAR2(256),
  appid                     VARCHAR2(64) default 'default' not null,
  clustername               VARCHAR2(32) default 'default' not null,
  namespacename             VARCHAR2(32) default 'default' not null,
  configurations            CLOB not null,
  isabandoned               NUMBER(1) default 0 not null,
  isdeleted                 NUMBER(1) default 0 not null,
  deletedat                 NUMBER(20) default 0 not null,
  datachange_createdby      VARCHAR2(64) default 'default' not null,
  datachange_createdtime    TIMESTAMP(6) default CURRENT_TIMESTAMP not null,
  datachange_lastmodifiedby VARCHAR2(64) default '',
  datachange_lasttime       TIMESTAMP(6) default CURRENT_TIMESTAMP
)
tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 1
  maxtrans 255;
comment on table APOLLO_CONFIG.RELEASE
  is '发布';
comment on column APOLLO_CONFIG.RELEASE.id
  is '自增主键';
comment on column APOLLO_CONFIG.RELEASE.releasekey
  is '发布的Key';
comment on column APOLLO_CONFIG.RELEASE.name
  is '发布名字';
comment on column APOLLO_CONFIG.RELEASE.comment
  is '发布说明';
comment on column APOLLO_CONFIG.RELEASE.appid
  is 'AppID';
comment on column APOLLO_CONFIG.RELEASE.clustername
  is 'ClusterName';
comment on column APOLLO_CONFIG.RELEASE.namespacename
  is 'namespaceName';
comment on column APOLLO_CONFIG.RELEASE.configurations
  is '发布配置';
comment on column APOLLO_CONFIG.RELEASE.isabandoned
  is '是否废弃';
comment on column APOLLO_CONFIG.RELEASE.isdeleted
  is '1: deleted, 0: normal';
comment on column APOLLO_CONFIG.RELEASE.deletedat
  is 'Delete timestamp based on milliseconds';
comment on column APOLLO_CONFIG.RELEASE.datachange_createdby
  is '创建人邮箱前缀';
comment on column APOLLO_CONFIG.RELEASE.datachange_createdtime
  is '创建时间';
comment on column APOLLO_CONFIG.RELEASE.datachange_lastmodifiedby
  is '最后修改人邮箱前缀';
comment on column APOLLO_CONFIG.RELEASE.datachange_lasttime
  is '最后修改时间';
create index APOLLO_CONFIG.IDX_RELEASE_APP_CLUSTER_NS on APOLLO_CONFIG.RELEASE (APPID, CLUSTERNAME, NAMESPACENAME)
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
create index APOLLO_CONFIG.IDX_RELEASE_DATACHANGE_LASTTIME on APOLLO_CONFIG.RELEASE (DATACHANGE_LASTTIME)
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
alter table APOLLO_CONFIG.RELEASE
  add constraint PK_RELEASE primary key (ID)
  using index 
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
alter table APOLLO_CONFIG.RELEASE
  add constraint UK_RELEASEKEY_DEL_AT unique (RELEASEKEY, DELETEDAT)
  using index 
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
alter table APOLLO_CONFIG.RELEASE
  add check (ISDELETED IN (0,1));

prompt
prompt Creating table RELEASEHISTORY
prompt =============================
prompt
create table APOLLO_CONFIG.RELEASEHISTORY
(
  id                        NUMBER(11) generated always as identity,
  appid                     VARCHAR2(64) default 'default' not null,
  clustername               VARCHAR2(32) default 'default' not null,
  namespacename             VARCHAR2(32) default 'default' not null,
  branchname                VARCHAR2(32) default 'default' not null,
  releaseid                 NUMBER(11) default 0 not null,
  previousreleaseid         NUMBER(11) default 0 not null,
  operation                 NUMBER(3) default 0 not null,
  operationcontext          CLOB not null,
  isdeleted                 NUMBER(1) default 0 not null,
  deletedat                 NUMBER(20) default 0 not null,
  datachange_createdby      VARCHAR2(64) default 'default' not null,
  datachange_createdtime    TIMESTAMP(6) default CURRENT_TIMESTAMP not null,
  datachange_lastmodifiedby VARCHAR2(64) default '',
  datachange_lasttime       TIMESTAMP(6) default CURRENT_TIMESTAMP
)
tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 1
  maxtrans 255;
comment on table APOLLO_CONFIG.RELEASEHISTORY
  is '发布历史';
comment on column APOLLO_CONFIG.RELEASEHISTORY.id
  is '自增Id';
comment on column APOLLO_CONFIG.RELEASEHISTORY.appid
  is 'AppID';
comment on column APOLLO_CONFIG.RELEASEHISTORY.clustername
  is 'ClusterName';
comment on column APOLLO_CONFIG.RELEASEHISTORY.namespacename
  is 'namespaceName';
comment on column APOLLO_CONFIG.RELEASEHISTORY.branchname
  is '发布分支名';
comment on column APOLLO_CONFIG.RELEASEHISTORY.releaseid
  is '关联的Release Id';
comment on column APOLLO_CONFIG.RELEASEHISTORY.previousreleaseid
  is '前一次发布的ReleaseId';
comment on column APOLLO_CONFIG.RELEASEHISTORY.operation
  is '发布类型，0: 普通发布，1: 回滚，2: 灰度发布，3: 灰度规则更新，4: 灰度合并回主分支发布，5: 主分支发布灰度自动发布，6: 主分支回滚灰度自动发布，7: 放弃灰度';
comment on column APOLLO_CONFIG.RELEASEHISTORY.operationcontext
  is '发布上下文信息';
comment on column APOLLO_CONFIG.RELEASEHISTORY.isdeleted
  is '1: deleted, 0: normal';
comment on column APOLLO_CONFIG.RELEASEHISTORY.deletedat
  is 'Delete timestamp based on milliseconds';
comment on column APOLLO_CONFIG.RELEASEHISTORY.datachange_createdby
  is '创建人邮箱前缀';
comment on column APOLLO_CONFIG.RELEASEHISTORY.datachange_createdtime
  is '创建时间';
comment on column APOLLO_CONFIG.RELEASEHISTORY.datachange_lastmodifiedby
  is '最后修改人邮箱前缀';
comment on column APOLLO_CONFIG.RELEASEHISTORY.datachange_lasttime
  is '最后修改时间';
create index APOLLO_CONFIG.IDX_RELEASEHISTORY_APP_CLUSTER_NS_BR on APOLLO_CONFIG.RELEASEHISTORY (APPID, CLUSTERNAME, NAMESPACENAME, BRANCHNAME)
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
create index APOLLO_CONFIG.IDX_RELEASEHISTORY_DATACHANGE_LASTTIME on APOLLO_CONFIG.RELEASEHISTORY (DATACHANGE_LASTTIME)
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
create index APOLLO_CONFIG.IDX_RELEASEHISTORY_PREVRELEASEID on APOLLO_CONFIG.RELEASEHISTORY (PREVIOUSRELEASEID)
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
create index APOLLO_CONFIG.IDX_RELEASEHISTORY_RELEASEID on APOLLO_CONFIG.RELEASEHISTORY (RELEASEID)
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
alter table APOLLO_CONFIG.RELEASEHISTORY
  add constraint PK_RELEASEHISTORY primary key (ID)
  using index 
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
alter table APOLLO_CONFIG.RELEASEHISTORY
  add check (ISDELETED IN (0,1));

prompt
prompt Creating table RELEASEMESSAGE
prompt =============================
prompt
create table APOLLO_CONFIG.RELEASEMESSAGE
(
  id                  NUMBER(11) generated always as identity,
  message             VARCHAR2(1024) default '' not null,
  datachange_lasttime TIMESTAMP(6) default CURRENT_TIMESTAMP not null
)
tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 1
  maxtrans 255;
comment on table APOLLO_CONFIG.RELEASEMESSAGE
  is '发布消息';
comment on column APOLLO_CONFIG.RELEASEMESSAGE.id
  is '自增主键';
comment on column APOLLO_CONFIG.RELEASEMESSAGE.message
  is '发布的消息内容';
comment on column APOLLO_CONFIG.RELEASEMESSAGE.datachange_lasttime
  is '最后修改时间';
create index APOLLO_CONFIG.IDX_RELEASEMESSAGE_DATACHANGE_LASTTIME on APOLLO_CONFIG.RELEASEMESSAGE (DATACHANGE_LASTTIME)
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
create index APOLLO_CONFIG.IDX_RELEASEMESSAGE_MESSAGE_PREFIX on APOLLO_CONFIG.RELEASEMESSAGE (SUBSTR(MESSAGE,1,191))
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
alter table APOLLO_CONFIG.RELEASEMESSAGE
  add constraint PK_RELEASEMESSAGE primary key (ID)
  using index 
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;

prompt
prompt Creating table SERVERCONFIG
prompt ===========================
prompt
create table APOLLO_CONFIG.SERVERCONFIG
(
  id                        NUMBER(10) generated always as identity,
  key                       VARCHAR2(64) default 'default' not null,
  cluster                   VARCHAR2(32) default 'default' not null,
  value                     VARCHAR2(2048) default 'default' not null,
  comment                   VARCHAR2(1024) default '',
  isdeleted                 NUMBER(1) default 0 not null,
  deletedat                 NUMBER(20) default 0 not null,
  datachange_createdby      VARCHAR2(64) default 'default' not null,
  datachange_createdtime    TIMESTAMP(6) default CURRENT_TIMESTAMP not null,
  datachange_lastmodifiedby VARCHAR2(64) default '',
  datachange_lasttime       TIMESTAMP(6) default CURRENT_TIMESTAMP
)
tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
comment on table APOLLO_CONFIG.SERVERCONFIG
  is '配置服务自身配置';
comment on column APOLLO_CONFIG.SERVERCONFIG.id
  is '自增Id';
comment on column APOLLO_CONFIG.SERVERCONFIG.key
  is '配置项Key';
comment on column APOLLO_CONFIG.SERVERCONFIG.cluster
  is '配置对应的集群，default为不针对特定的集群';
comment on column APOLLO_CONFIG.SERVERCONFIG.value
  is '配置项值';
comment on column APOLLO_CONFIG.SERVERCONFIG.comment
  is '注释';
comment on column APOLLO_CONFIG.SERVERCONFIG.isdeleted
  is '1: deleted, 0: normal';
comment on column APOLLO_CONFIG.SERVERCONFIG.deletedat
  is 'Delete timestamp based on milliseconds';
comment on column APOLLO_CONFIG.SERVERCONFIG.datachange_createdby
  is '创建人邮箱前缀';
comment on column APOLLO_CONFIG.SERVERCONFIG.datachange_createdtime
  is '创建时间';
comment on column APOLLO_CONFIG.SERVERCONFIG.datachange_lastmodifiedby
  is '最后修改人邮箱前缀';
comment on column APOLLO_CONFIG.SERVERCONFIG.datachange_lasttime
  is '最后修改时间';
create index APOLLO_CONFIG.IDX_SERVERCONFIG_DATACHANGE_LASTTIME on APOLLO_CONFIG.SERVERCONFIG (DATACHANGE_LASTTIME)
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table APOLLO_CONFIG.SERVERCONFIG
  add constraint PK_SERVERCONFIG primary key (ID)
  using index 
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table APOLLO_CONFIG.SERVERCONFIG
  add constraint UK_KEY_CLUSTER_DEL unique (KEY, CLUSTER, DELETEDAT)
  using index 
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table APOLLO_CONFIG.SERVERCONFIG
  add check (ISDELETED IN (0,1));

prompt
prompt Creating table SERVICEREGISTRY
prompt ==============================
prompt
create table APOLLO_CONFIG.SERVICEREGISTRY
(
  id                     NUMBER(11) generated always as identity,
  servicename            VARCHAR2(64) not null,
  uri                    VARCHAR2(64) not null,
  cluster                VARCHAR2(64) not null,
  metadata               VARCHAR2(1024) default '{}' not null,
  datachange_createdtime TIMESTAMP(6) default CURRENT_TIMESTAMP not null,
  datachange_lasttime    TIMESTAMP(6) default CURRENT_TIMESTAMP not null
)
tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 1
  maxtrans 255;
comment on table APOLLO_CONFIG.SERVICEREGISTRY
  is '注册中心';
comment on column APOLLO_CONFIG.SERVICEREGISTRY.id
  is '自增Id';
comment on column APOLLO_CONFIG.SERVICEREGISTRY.servicename
  is '服务名';
comment on column APOLLO_CONFIG.SERVICEREGISTRY.uri
  is '服务地址';
comment on column APOLLO_CONFIG.SERVICEREGISTRY.cluster
  is '集群，可以用来标识apollo.cluster或者网络分区';
comment on column APOLLO_CONFIG.SERVICEREGISTRY.metadata
  is '元数据，key value结构的json object，为了方面后面扩展功能而不需要修改表结构';
comment on column APOLLO_CONFIG.SERVICEREGISTRY.datachange_createdtime
  is '创建时间';
comment on column APOLLO_CONFIG.SERVICEREGISTRY.datachange_lasttime
  is '最后修改时间';
create index APOLLO_CONFIG.IDX_SERVICEREGISTRY_DATACHANGE_LASTTIME on APOLLO_CONFIG.SERVICEREGISTRY (DATACHANGE_LASTTIME)
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
alter table APOLLO_CONFIG.SERVICEREGISTRY
  add constraint PK_SERVICEREGISTRY primary key (ID)
  using index 
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;
alter table APOLLO_CONFIG.SERVICEREGISTRY
  add constraint UK_SERVICE_URI unique (SERVICENAME, URI)
  using index 
  tablespace APOLLO_CONFIG_TABLESPACE
  pctfree 10
  initrans 2
  maxtrans 255;

prompt
prompt Creating trigger APOLLO_CONFIG_ACCESSKEY_UPDATE_TIMESTAMP
prompt =========================================================
prompt
CREATE OR REPLACE TRIGGER APOLLO_CONFIG.APOLLO_CONFIG_ACCESSKEY_UPDATE_TIMESTAMP
BEFORE UPDATE ON APOLLO_CONFIG.ACCESSKEY
    FOR EACH ROW
BEGIN
  :new.DATACHANGE_LASTTIME := CURRENT_TIMESTAMP;
END;
/

prompt
prompt Creating trigger APOLLO_CONFIG_APPSPACE_UPDATE_TIMESTAMP
prompt ========================================================
prompt
CREATE OR REPLACE TRIGGER APOLLO_CONFIG.APOLLO_CONFIG_APPSPACE_UPDATE_TIMESTAMP
BEFORE UPDATE ON APOLLO_CONFIG.APPNAMESPACE
 FOR EACH ROW
BEGIN
  :new.DATACHANGE_LASTTIME := CURRENT_TIMESTAMP;
END;
/

prompt
prompt Creating trigger APOLLO_CONFIG_APP_UPDATE_TIMESTAMP
prompt ===================================================
prompt
CREATE OR REPLACE TRIGGER APOLLO_CONFIG.APOLLO_CONFIG_APP_UPDATE_TIMESTAMP
BEFORE UPDATE ON APOLLO_CONFIG.APP
  FOR EACH ROW
BEGIN
  :new.DATACHANGE_LASTTIME := CURRENT_TIMESTAMP;
END;
/

prompt
prompt Creating trigger APOLLO_CONFIG_AUDITLOGDATAINFLUENCE_UPDATE_TIMESTAMP
prompt =====================================================================
prompt
CREATE OR REPLACE TRIGGER APOLLO_CONFIG.APOLLO_CONFIG_AUDITLOGDATAINFLUENCE_UPDATE_TIMESTAMP
BEFORE UPDATE ON APOLLO_CONFIG.AUDITLOGDATAINFLUENCE
    FOR EACH ROW
BEGIN
  :new.DATACHANGE_LASTTIME := CURRENT_TIMESTAMP;
END;
/

prompt
prompt Creating trigger APOLLO_CONFIG_AUDITLOG_UPDATE_TIMESTAMP
prompt ========================================================
prompt
CREATE OR REPLACE TRIGGER APOLLO_CONFIG.APOLLO_CONFIG_AUDITLOG_UPDATE_TIMESTAMP
BEFORE UPDATE ON APOLLO_CONFIG.AUDITLOG
    FOR EACH ROW
BEGIN
  :new.DATACHANGE_LASTTIME := CURRENT_TIMESTAMP;
END;
/

prompt
prompt Creating trigger APOLLO_CONFIG_AUDIT_UPDATE_TIMESTAMP
prompt =====================================================
prompt
CREATE OR REPLACE TRIGGER APOLLO_CONFIG.APOLLO_CONFIG_AUDIT_UPDATE_TIMESTAMP
BEFORE UPDATE ON APOLLO_CONFIG."AUDIT"
    FOR EACH ROW
BEGIN
  :new.DATACHANGE_LASTTIME := SYSTIMESTAMP;
END;
/

prompt
prompt Creating trigger APOLLO_CONFIG_CLUSTER_UPDATE_TIMESTAMP
prompt =======================================================
prompt
CREATE OR REPLACE TRIGGER APOLLO_CONFIG.APOLLO_CONFIG_CLUSTER_UPDATE_TIMESTAMP
BEFORE UPDATE ON APOLLO_CONFIG."CLUSTER"
  FOR EACH ROW
BEGIN
  :new.DATACHANGE_LASTTIME := CURRENT_TIMESTAMP;
END;
/

prompt
prompt Creating trigger APOLLO_CONFIG_COMMIT_UPDATE_TIMESTAMP
prompt ======================================================
prompt
CREATE OR REPLACE TRIGGER APOLLO_CONFIG.APOLLO_CONFIG_COMMIT_UPDATE_TIMESTAMP
BEFORE UPDATE ON APOLLO_CONFIG.COMMIT
    FOR EACH ROW
BEGIN
  :new.DATACHANGE_LASTTIME := CURRENT_TIMESTAMP;
END;
/

prompt
prompt Creating trigger APOLLO_CONFIG_GRAYRELEASERULE_UPDATE_TIMESTAMP
prompt ===============================================================
prompt
CREATE OR REPLACE TRIGGER APOLLO_CONFIG.APOLLO_CONFIG_GRAYRELEASERULE_UPDATE_TIMESTAMP
BEFORE UPDATE ON APOLLO_CONFIG.GRAYRELEASERULE
  FOR EACH ROW
BEGIN
  :new.DATACHANGE_LASTTIME := CURRENT_TIMESTAMP;
END;
/

prompt
prompt Creating trigger APOLLO_CONFIG_INSTANCECONFIG_UPDATE_TIMESTAMP
prompt ==============================================================
prompt
CREATE OR REPLACE TRIGGER APOLLO_CONFIG.APOLLO_CONFIG_INSTANCECONFIG_UPDATE_TIMESTAMP
    BEFORE UPDATE ON APOLLO_CONFIG.INSTANCECONFIG
    FOR EACH ROW
BEGIN
    :new.DATACHANGE_LASTTIME := CURRENT_TIMESTAMP;
END;
/

prompt
prompt Creating trigger APOLLO_CONFIG_INSTANCE_UPDATE_TIMESTAMP
prompt ========================================================
prompt
CREATE OR REPLACE TRIGGER APOLLO_CONFIG.APOLLO_CONFIG_INSTANCE_UPDATE_TIMESTAMP
BEFORE UPDATE ON APOLLO_CONFIG.INSTANCE
  FOR EACH ROW
BEGIN
  :new.DATACHANGE_LASTTIME := CURRENT_TIMESTAMP;
END;
/

prompt
prompt Creating trigger APOLLO_CONFIG_ITEM_UPDATE_TIMESTAMP
prompt ====================================================
prompt
CREATE OR REPLACE TRIGGER APOLLO_CONFIG.APOLLO_CONFIG_ITEM_UPDATE_TIMESTAMP
BEFORE UPDATE ON APOLLO_CONFIG.ITEM
    FOR EACH ROW
BEGIN
  :new.DATACHANGE_LASTTIME := CURRENT_TIMESTAMP;
END;
/

prompt
prompt Creating trigger APOLLO_CONFIG_NAMESPACELOCK_UPDATE_TIMESTAMP
prompt =============================================================
prompt
CREATE OR REPLACE TRIGGER APOLLO_CONFIG.APOLLO_CONFIG_NAMESPACELOCK_UPDATE_TIMESTAMP
BEFORE UPDATE ON APOLLO_CONFIG.NAMESPACELOCK
    FOR EACH ROW
BEGIN
  :new.DATACHANGE_LASTTIME := CURRENT_TIMESTAMP;
END;
/

prompt
prompt Creating trigger APOLLO_CONFIG_NAMESPACE_UPDATE_TIMESTAMP
prompt =========================================================
prompt
CREATE OR REPLACE TRIGGER APOLLO_CONFIG.APOLLO_CONFIG_NAMESPACE_UPDATE_TIMESTAMP
BEFORE UPDATE ON APOLLO_CONFIG.NAMESPACE
    FOR EACH ROW
BEGIN
  :new.DATACHANGE_LASTTIME := CURRENT_TIMESTAMP;
END;
/

prompt
prompt Creating trigger APOLLO_CONFIG_RELEASEHISTORY_UPDATE_TIMESTAMP
prompt ==============================================================
prompt
CREATE OR REPLACE TRIGGER APOLLO_CONFIG.APOLLO_CONFIG_RELEASEHISTORY_UPDATE_TIMESTAMP
BEFORE UPDATE ON APOLLO_CONFIG.RELEASEHISTORY
    FOR EACH ROW
BEGIN
  :new.DATACHANGE_LASTTIME := CURRENT_TIMESTAMP;
END;
/

prompt
prompt Creating trigger APOLLO_CONFIG_RELEASEMESSAGE_UPDATE_TIMESTAMP
prompt ==============================================================
prompt
CREATE OR REPLACE TRIGGER APOLLO_CONFIG.APOLLO_CONFIG_RELEASEMESSAGE_UPDATE_TIMESTAMP
BEFORE UPDATE ON APOLLO_CONFIG.RELEASEMESSAGE
    FOR EACH ROW
BEGIN
  :new.DATACHANGE_LASTTIME := CURRENT_TIMESTAMP;
END;
/

prompt
prompt Creating trigger APOLLO_CONFIG_RELEASE_UPDATE_TIMESTAMP
prompt =======================================================
prompt
CREATE OR REPLACE TRIGGER APOLLO_CONFIG.APOLLO_CONFIG_RELEASE_UPDATE_TIMESTAMP
BEFORE UPDATE ON APOLLO_CONFIG.RELEASE
    FOR EACH ROW
BEGIN
  :new.DATACHANGE_LASTTIME := CURRENT_TIMESTAMP;
END;
/

prompt
prompt Creating trigger APOLLO_CONFIG_SERVERCONFIG_UPDATE_TIMESTAMP
prompt ============================================================
prompt
CREATE OR REPLACE TRIGGER APOLLO_CONFIG.APOLLO_CONFIG_SERVERCONFIG_UPDATE_TIMESTAMP
BEFORE UPDATE ON APOLLO_CONFIG.SERVERCONFIG
    FOR EACH ROW
BEGIN
  :new.DATACHANGE_LASTTIME := CURRENT_TIMESTAMP;
END;
/

prompt
prompt Creating trigger APOLLO_CONFIG_SERVICEREGISTRY_UPDATE_TIMESTAMP
prompt ===============================================================
prompt
CREATE OR REPLACE TRIGGER APOLLO_CONFIG.APOLLO_CONFIG_SERVICEREGISTRY_UPDATE_TIMESTAMP
BEFORE UPDATE ON APOLLO_CONFIG.SERVICEREGISTRY
    FOR EACH ROW
BEGIN
  :new.DATACHANGE_LASTTIME := CURRENT_TIMESTAMP;
END;
/


prompt Done
spool off
set define on
