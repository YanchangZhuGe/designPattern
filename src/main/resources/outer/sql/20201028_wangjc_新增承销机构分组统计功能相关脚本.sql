-- 2020102815_wangjc_新增承销机构分组统计功能相关脚本(zj)
create table DEBT_T_ZQGL_CXJG_GROUP
(
  cxjg_group_id   VARCHAR2(38) not null,
  GROUP_id   VARCHAR2(38),
  cxjg_group_code VARCHAR2(38),
  cxjg_group_name VARCHAR2(100),
  cxjg_code       VARCHAR2(38),
  cxjg_name       VARCHAR2(100),
  create_user     VARCHAR2(30),
  create_date     VARCHAR2(20),
  l_op_user       VARCHAR2(30),
  l_op_date       VARCHAR2(20)
);
comment on table DEBT_T_ZQGL_CXJG_GROUP
  is '承销机构分组统计表';
comment on column DEBT_T_ZQGL_CXJG_GROUP.cxjg_group_id
  is '承销机构分组ID';
comment on column DEBT_T_ZQGL_CXJG_GROUP.GROUP_ID
  is '虚拟主单';
comment on column DEBT_T_ZQGL_CXJG_GROUP.cxjg_group_code
  is '承销机构分组编码';
comment on column DEBT_T_ZQGL_CXJG_GROUP.cxjg_group_name
  is '承销机构分组名称';
comment on column DEBT_T_ZQGL_CXJG_GROUP.cxjg_code
  is '承销机构编码';
comment on column DEBT_T_ZQGL_CXJG_GROUP.cxjg_name
  is '承销机构名称';
comment on column DEBT_T_ZQGL_CXJG_GROUP.create_user
  is '创建用户';
comment on column DEBT_T_ZQGL_CXJG_GROUP.create_date
  is '创建时间';
comment on column DEBT_T_ZQGL_CXJG_GROUP.l_op_user
  is '最后修改用户';
comment on column DEBT_T_ZQGL_CXJG_GROUP.l_op_date
  is '最后修改时间';
alter table DEBT_T_ZQGL_CXJG_GROUP add constraint PK_DEBT_T_ZQGL_CXJG_GROUP primary key (CXJG_GROUP_ID);

DELETE FROM FASP_t_PUBMENU WHERE GUID = '211315015105';
insert into FASP_t_PUBMENU (GUID, LEVELNO, ISLEAF, STATUS, CODE, NAME, PARENTID, URL, MENUORDER, REMARK, DBVERSION, APPSYSID, PROVINCE, YEAR, APPID, PARAM1, PARAM2, PARAM3, PARAM4, PARAM5, SSOFLAG, ADMINTYPE, ALIAS)
values ('211315015105', 2, 1, '1', '211315015105', '承销机构分组维护', '211315015', '/page/debt/zqgl/cxtgl/cxjgGroupMain.jsp', 11232, null, null, null, (SELECT D_VALUE FROM Dsy_t_Sys_Param WHERE D_CODE = 'ELE_AD_CODE'), '2020', 'debt', null, null, null, '0', null, null, 1, null);
COMMIT;