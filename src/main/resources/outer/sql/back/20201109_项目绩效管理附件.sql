-- Create table
create table DEBT_T_XMJXFJGL
(
xm_id       VARCHAR2(38) not null,
  jx_year    VARCHAR2(200),
  xm_name     VARCHAR2(200),
  ad_code     VARCHAR2(38),
  ag_code     VARCHAR2(38),
  create_date VARCHAR2(30),
  create_user VARCHAR2(100),
  l_op_date   VARCHAR2(30),
  l_op_user   VARCHAR2(100)
);
-- Add comments to the table 
comment on table DEBT_T_XMJXFJGL
  is '项目绩效附件管理表';
-- Add comments to the columns
comment on column DEBT_T_XMJXFJGL.xm_id
  is '项目ID';
comment on column DEBT_T_XMJXFJGL.jx_year
  is '绩效年度';
comment on column DEBT_T_XMJXFJGL.xm_name
  is '项目名称';
comment on column DEBT_T_XMJXFJGL.ad_code
  is '区划编码';
comment on column DEBT_T_XMJXFJGL.ag_code
  is '单位编码';
comment on column DEBT_T_XMJXFJGL.create_date
  is '创建时间';
comment on column DEBT_T_XMJXFJGL.create_user
  is '创建人';
comment on column DEBT_T_XMJXFJGL.l_op_date
  is '修改时间';
comment on column DEBT_T_XMJXFJGL.l_op_user
  is '修改人';
-- Create/Recreate primary, unique and foreign key constraints 
alter table DEBT_T_XMJXFJGL
  add constraint PK_XM_ID primary key (XM_ID);