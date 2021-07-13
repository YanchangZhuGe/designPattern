--部端交互授权用户配置表
DROP TABLE DEBT_T_BDJH_CONFIG_VISITOR;
create table DEBT_T_BDJH_CONFIG_VISITOR
(
  id        VARCHAR2(38) not null,
  ad_code   VARCHAR2(38),
  ip_address VARCHAR2(50),
  ip_main   VARCHAR2(50),
  port      VARCHAR2(10),
  domain_name VARCHAR2(100),
  user_code VARCHAR2(38),
  password  VARCHAR2(38),
  create_date VARCHAR2(30),
  enc_sf    VARCHAR2(30),
  enc_key   VARCHAR2(100),
  remark    VARCHAR2(38),
  is_valid  VARCHAR2(1)
);
-- Add comments to the table
comment on table DEBT_T_BDJH_CONFIG_VISITOR is '部端交互授权用户配置表';
-- Add comments to the columns
comment on column DEBT_T_BDJH_CONFIG_VISITOR.id is '主键ID';
comment on column DEBT_T_BDJH_CONFIG_VISITOR.ad_code IS '用户区划';
comment on column DEBT_T_BDJH_CONFIG_VISITOR.ip_address is '服务提供方子IP地址';
comment on column DEBT_T_BDJH_CONFIG_VISITOR.ip_main is '服务提供方主IP地址';
comment on column DEBT_T_BDJH_CONFIG_VISITOR.port IS '服务提供方端口号';
comment on column DEBT_T_BDJH_CONFIG_VISITOR.domain_name IS '服务提供方域名';
comment on column DEBT_T_BDJH_CONFIG_VISITOR.user_code IS '请求方授权用户编码';
comment on column DEBT_T_BDJH_CONFIG_VISITOR.password is '请求方授权用户密码';
comment on column DEBT_T_BDJH_CONFIG_VISITOR.create_date IS '授权日期';
comment on column DEBT_T_BDJH_CONFIG_VISITOR.enc_sf is '请求方数据加密算法';
comment on column DEBT_T_BDJH_CONFIG_VISITOR.enc_key is '请求方数据加密密钥';
comment on column DEBT_T_BDJH_CONFIG_VISITOR.remark is '备注';
comment on column DEBT_T_BDJH_CONFIG_VISITOR.is_valid is '是否有效1有效，0无效';
-- Create/Recreate primary, unique and foreign key constraints
alter table DEBT_T_BDJH_CONFIG_VISITOR add constraint PK_BDJH_ID primary key (ID);
-- 部端接口日志表
DROP TABLE DEBT_T_BDJH_LOG_INF;
create table DEBT_T_BDJH_LOG_INF
(
  log_id        VARCHAR2(38) not null,
  ad_code   VARCHAR2(38),
  user_code VARCHAR2(38),
  inf_id    VARCHAR2(38),
  inf_code  VARCHAR2(38),
  inf_type  NUMBER(2),
  inf_status NUMBER(2),
  data_msg   VARCHAR2(1500),
  response_msg VARCHAR2(1500),
  exception_msg VARCHAR2(1500),
  create_date VARCHAR2(30)
);
-- 部端接口日志表
comment on table DEBT_T_BDJH_LOG_INF is '部端接口日志表';
-- Add comments to the columns
comment on column DEBT_T_BDJH_LOG_INF.log_id is '日志ID';
comment on column DEBT_T_BDJH_LOG_INF.ad_code IS '请求方用户区划';
comment on column DEBT_T_BDJH_LOG_INF.user_code is '请求方用户编码';
comment on column DEBT_T_BDJH_LOG_INF.inf_id is '报文id';
comment on column DEBT_T_BDJH_LOG_INF.inf_code IS '接口编码';
comment on column DEBT_T_BDJH_LOG_INF.inf_type IS '接口类型（0：推送，1：接收）';
comment on column DEBT_T_BDJH_LOG_INF.inf_status IS '接口状态（1：发送/接收成功；99：发送/接收异常）';
comment on column DEBT_T_BDJH_LOG_INF.data_msg is '报文信息（报文头）';
comment on column DEBT_T_BDJH_LOG_INF.response_msg IS '响应报文信息（报文头）';
comment on column DEBT_T_BDJH_LOG_INF.exception_msg is '异常信息';
comment on column DEBT_T_BDJH_LOG_INF.create_date is '创建日期';
-- Create/Recreate primary, unique and foreign key constraints
alter table DEBT_T_BDJH_LOG_INF add constraint PK_LOG_ID primary key (log_id);
-- 申报批次 接口日志表Create table
create table DEBT_T_BDJH_SBPC_LOC_INF
(
  loc_inf_id  VARCHAR2(38) DEFAULT sys_guid() not null,
  admdiv      VARCHAR2(32),
  guid        VARCHAR2(32),
  name        VARCHAR2(255),
  isleaf      NUMBER(1),
  desguid     VARCHAR2(32),
  levelno     NUMBER(1),
  srcscale    NUMBER(18,4),
  remark      VARCHAR2(500),
  starttime   VARCHAR2(17),
  createtime  VARCHAR2(17),
  pinyin      VARCHAR2(200),
  alias       VARCHAR2(100),
  version     NUMBER(9),
  superguid   VARCHAR2(32),
  endtime     VARCHAR2(17),
  srcguid     VARCHAR2(32),
  code        VARCHAR2(200),
  dbversion   TIMESTAMP(6),
  status      CHAR(1) default '1',
  year        CHAR(4),
  province    VARCHAR2(9),
  extend1     VARCHAR2(180),
  extend2     VARCHAR2(180),
  extend3     VARCHAR2(180),
  extend4     VARCHAR2(180),
  extend5     VARCHAR2(180),
  create_date VARCHAR2(20),
  ad_code     VARCHAR2(30),
  ad_name     VARCHAR2(100)
);
-- Add comments to the table
comment on table DEBT_T_BDJH_SBPC_LOC_INF
is '存储地方端系统已删除的需求申报批次信息';
-- Add comments to the columns
comment on column DEBT_T_BDJH_SBPC_LOC_INF.loc_inf_id
is '主键ID';
comment on column DEBT_T_BDJH_SBPC_LOC_INF.create_date
is '创建日期';
comment on column DEBT_T_BDJH_SBPC_LOC_INF.ad_code
is '区划编码';
comment on column DEBT_T_BDJH_SBPC_LOC_INF.ad_name
is '区划名称';
-- Create/Recreate primary, unique and foreign key constraints
alter table DEBT_T_BDJH_SBPC_LOC_INF add constraint PK_LOC_INF_ID primary key (LOC_INF_ID);
--20200824将添加限额后的数据存入基础数据表
insert into fasp_t_diccolumn (DEID, CSID, EXP, ISSYS, DBCOLUMNCODE, ISUSES, YEAR, PROVINCE, COLUMNID, COLUMNCODE, TABLECODE, NAME, DATATYPE, DATALENGTH, SCALE, VERSION, NULLABLE, DEFAULTVALUE)
values ('EXTEND1', null, null, '1', 'EXTEND1', '1', '2020', '8700', 'FASP_T_PUBDEBT_XEPCEXTEND1', 'EXTEND1', 'FASP_T_PUBDEBT_XEPC', '限额批次类别01新增02再融资03总限额', 'S', '180', null, 1, 0, null);
insert into fasp_t_diccolumn (DEID, CSID, EXP, ISSYS, DBCOLUMNCODE, ISUSES, YEAR, PROVINCE, COLUMNID, COLUMNCODE, TABLECODE, NAME, DATATYPE, DATALENGTH, SCALE, VERSION, NULLABLE, DEFAULTVALUE)
values ('EXTEND2', null, null, '1', 'EXTEND2', '1', '2020', '8700', 'FASP_T_PUBDEBT_XEPCEXTEND2', 'EXTEND2', 'FASP_T_PUBDEBT_XEPC', '', 'S', '180', null, 1, 0, null);
insert into fasp_t_diccolumn (DEID, CSID, EXP, ISSYS, DBCOLUMNCODE, ISUSES, YEAR, PROVINCE, COLUMNID, COLUMNCODE, TABLECODE, NAME, DATATYPE, DATALENGTH, SCALE, VERSION, NULLABLE, DEFAULTVALUE)
values ('EXTEND3', null, null, '1', 'EXTEND3', '1', '2020', '8700', 'FASP_T_PUBDEBT_XEPCEXTEND3', 'EXTEND3', 'FASP_T_PUBDEBT_XEPC', '', 'S', '180', null, 1, 0, null);
insert into fasp_t_diccolumn (DEID, CSID, EXP, ISSYS, DBCOLUMNCODE, ISUSES, YEAR, PROVINCE, COLUMNID, COLUMNCODE, TABLECODE, NAME, DATATYPE, DATALENGTH, SCALE, VERSION, NULLABLE, DEFAULTVALUE)
values ('EXTEND4', null, null, '1', 'EXTEND4', '1', '2020', '8700', 'FASP_T_PUBDEBT_XEPCEXTEND4', 'EXTEND4', 'FASP_T_PUBDEBT_XEPC', '', 'S', '180', null, 1, 0, null);
insert into fasp_t_diccolumn (DEID, CSID, EXP, ISSYS, DBCOLUMNCODE, ISUSES, YEAR, PROVINCE, COLUMNID, COLUMNCODE, TABLECODE, NAME, DATATYPE, DATALENGTH, SCALE, VERSION, NULLABLE, DEFAULTVALUE)
values ('EXTEND5', null, null, '1', 'EXTEND5', '1', '2020', '8700', 'FASP_T_PUBDEBT_XEPCEXTEND5', 'EXTEND5', 'FASP_T_PUBDEBT_XEPC', '', 'S', '180', null, 1, 0, null);
--20200824liyue限额批次基础表添加限额批次类型扩展字段
alter table P#FASP_T_PUBDEBT_XEPC add EXTEND1 varchar2(20);
comment on column P#FASP_T_PUBDEBT_XEPC.EXTEND1 is '限额批次类型（01新增02再融资03总限额）';
alter table P#FASP_T_PUBDEBT_XEPC add EXTEND2 varchar2(50);
comment on column P#FASP_T_PUBDEBT_XEPC.EXTEND2 is '扩展字段';
alter table P#FASP_T_PUBDEBT_XEPC add EXTEND3 varchar2(50);
comment on column P#FASP_T_PUBDEBT_XEPC.EXTEND3 is '扩展字段';
alter table P#FASP_T_PUBDEBT_XEPC add EXTEND4 varchar2(50);
comment on column P#FASP_T_PUBDEBT_XEPC.EXTEND4 is '扩展字段';
alter table P#FASP_T_PUBDEBT_XEPC add EXTEND5 varchar2(50);
comment on column P#FASP_T_PUBDEBT_XEPC.EXTEND5 is '扩展字段';
-- 地方限额表添加字段
alter table DEBT_T_ZQGL_ZQXE add ZQXE_TYPE VARCHAR2(2) ;
comment on column DEBT_T_ZQGL_ZQXE.ZQXE_TYPE  is '限额类型';
alter table DEBT_T_ZQGL_ZQXE add ZRZ_HYZW_AMT NUMBER(16,2) ;
comment on column DEBT_T_ZQGL_ZQXE.ZRZ_HYZW_AMT  is '或有债务';
-- 存储部端系统导入的新增债券项目需求审核结果数据
DROP TABLE DEBT_T_BDJH_NDJH_LOC_RET;
CREATE TABLE DEBT_T_BDJH_NDJH_LOC_RET(
  CZB_RET_ID VARCHAR2(38) DEFAULT SYS_GUID() NOT NULL,
  PROVINCE_CODE VARCHAR2(38),
  PROVINCE_NAME VARCHAR2(120),
  BILL_ID  VARCHAR2(38),
  BILL_YEAR  VARCHAR2(4),
  BATCH_NO   VARCHAR2(38),
  AD_CODE    VARCHAR2(38),
  AD_NAME    VARCHAR2(100),
  XM_ID      VARCHAR2(38),
  XM_NAME    VARCHAR2(500),
  AG_NAME    VARCHAR2(200),
  APPLY_AMOUNT            NUMBER(16,2),
  ZQQX                    VARCHAR2(38),
  CZB_STATUS              VARCHAR2(1),
  FGW_STATUS              VARCHAR2(1),
  CHECK_DATE              VARCHAR2(30),
  CHECK_REMARK            VARCHAR2(500),
  CREATE_DATE             VARCHAR2(30) DEFAULT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS'),
  XE_ID                   VARCHAR2(38)
);
COMMENT ON COLUMN DEBT_T_BDJH_NDJH_LOC_RET.CZB_RET_ID IS '主键ID';
COMMENT ON COLUMN DEBT_T_BDJH_NDJH_LOC_RET.PROVINCE_CODE IS '省份编码';
COMMENT ON COLUMN DEBT_T_BDJH_NDJH_LOC_RET.PROVINCE_NAME IS '省份';
COMMENT ON COLUMN DEBT_T_BDJH_NDJH_LOC_RET.BILL_ID IS '申报ID';
COMMENT ON COLUMN DEBT_T_BDJH_NDJH_LOC_RET.BILL_YEAR IS '申报年度';
COMMENT ON COLUMN DEBT_T_BDJH_NDJH_LOC_RET.BATCH_NO IS '申报批次';
COMMENT ON COLUMN DEBT_T_BDJH_NDJH_LOC_RET.AD_CODE IS '区划编码';
COMMENT ON COLUMN DEBT_T_BDJH_NDJH_LOC_RET.AD_NAME IS '区划名称';
COMMENT ON COLUMN DEBT_T_BDJH_NDJH_LOC_RET.XM_ID IS '项目ID';
COMMENT ON COLUMN DEBT_T_BDJH_NDJH_LOC_RET.XM_NAME IS '项目名称';
COMMENT ON COLUMN DEBT_T_BDJH_NDJH_LOC_RET.AG_NAME IS '项目单位';
COMMENT ON COLUMN DEBT_T_BDJH_NDJH_LOC_RET.APPLY_AMOUNT IS '需求规模';
COMMENT ON COLUMN DEBT_T_BDJH_NDJH_LOC_RET.ZQQX IS '拟发债期限';
COMMENT ON COLUMN DEBT_T_BDJH_NDJH_LOC_RET.CZB_STATUS IS '财政部审核状态 0通过，1不通过';
COMMENT ON COLUMN DEBT_T_BDJH_NDJH_LOC_RET.FGW_STATUS IS '发改委审核状态 0通过，1不通过';
COMMENT ON COLUMN DEBT_T_BDJH_NDJH_LOC_RET.CHECK_DATE IS '财政部项目检查日期';
COMMENT ON COLUMN DEBT_T_BDJH_NDJH_LOC_RET.CHECK_REMARK IS '财政部项目检查备注';
COMMENT ON COLUMN DEBT_T_BDJH_NDJH_LOC_RET.CREATE_DATE IS '导入时间';
COMMENT ON COLUMN DEBT_T_BDJH_NDJH_LOC_RET.XE_ID IS '债务限额ID（限额与项目关系）';
--添加主键
ALTER TABLE DEBT_T_BDJH_NDJH_LOC_RET ADD CONSTRAINT PK_LOC_RET_ID PRIMARY KEY(CZB_RET_ID);
-- 再融资需求审核项目表
DROP TABLE DEBT_T_BDJH_ZRZJH_LOC_RET;
create table DEBT_T_BDJH_ZRZJH_LOC_RET
(
  czb_ret_id    VARCHAR2(38) DEFAULT SYS_GUID() not NULL,
  province_code VARCHAR2(38),
  province_name VARCHAR2(120),
  bill_year     VARCHAR2(4),
  batch_no      VARCHAR2(38),
  zq_id         VARCHAR2(38),
  zq_code       VARCHAR2(50),
  zq_name       VARCHAR2(200),
  fx_amt        NUMBER(16,2),
  dqdf_date     VARCHAR2(20),
  dqdf_amt      NUMBER(16,2),
  apply_amount  NUMBER(16,2),
  reply_amount  NUMBER(16,2),
  check_date    VARCHAR2(20),
  check_remark  VARCHAR2(500),
  create_date   VARCHAR2(20) default TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS'),
  xe_id         VARCHAR2(38)
);
-- Add comments to the table
comment on table DEBT_T_BDJH_ZRZJH_LOC_RET
is '再融资需求审核结果表';
-- Add comments to the columns
comment on column DEBT_T_BDJH_ZRZJH_LOC_RET.czb_ret_id
is '主键';
comment on column DEBT_T_BDJH_ZRZJH_LOC_RET.province_code
is '省份编码';
comment on column DEBT_T_BDJH_ZRZJH_LOC_RET.province_name
is '省份';
comment on column DEBT_T_BDJH_ZRZJH_LOC_RET.bill_year
is '申报年度';
comment on column DEBT_T_BDJH_ZRZJH_LOC_RET.batch_no
is '申报批次';
comment on column DEBT_T_BDJH_ZRZJH_LOC_RET.zq_id
is '债券id';
comment on column DEBT_T_BDJH_ZRZJH_LOC_RET.zq_code
is '债券编码';
comment on column DEBT_T_BDJH_ZRZJH_LOC_RET.zq_name
is '债券名称';
comment on column DEBT_T_BDJH_ZRZJH_LOC_RET.fx_amt
is '债券金额';
comment on column DEBT_T_BDJH_ZRZJH_LOC_RET.dqdf_date
is '到期兑付日';
comment on column DEBT_T_BDJH_ZRZJH_LOC_RET.dqdf_amt
is '到期兑付金额';
comment on column DEBT_T_BDJH_ZRZJH_LOC_RET.apply_amount
is '再融资需求规模';
comment on column DEBT_T_BDJH_ZRZJH_LOC_RET.reply_amount
is '财政部审核金额';
comment on column DEBT_T_BDJH_ZRZJH_LOC_RET.check_date
is '财政部审核日期';
comment on column DEBT_T_BDJH_ZRZJH_LOC_RET.check_remark
is '财政部审核备注';
comment on column DEBT_T_BDJH_ZRZJH_LOC_RET.create_date
is '导入时间';
comment on column DEBT_T_BDJH_ZRZJH_LOC_RET.xe_id
is '债务限额id（限额与项目关系）';
-- Create/Recreate primary, unique and foreign key constraints
alter table DEBT_T_BDJH_ZRZJH_LOC_RET add constraint PK_LOC_ZRZJH_ID primary key (CZB_RET_ID);