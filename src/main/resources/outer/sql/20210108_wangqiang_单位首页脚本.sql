--20210104 wq  单位首页url跳转表
-- Create table
create table DSY_T_SYS_ROLE_MENU
(
  guid           VARCHAR2(38) not null,
  menu_code      VARCHAR2(60),
  menu_name      VARCHAR2(60),
  role_id        VARCHAR2(60),
  menu_type      VARCHAR2(10),
  menu_type_name VARCHAR2(60)
);
-- Add comments to the table 
comment on table DSY_T_SYS_ROLE_MENU
  is '单位首页跳转菜单';
-- Add comments to the columns 
comment on column DSY_T_SYS_ROLE_MENU.guid
  is '唯一id';
comment on column DSY_T_SYS_ROLE_MENU.menu_code
  is '菜单编码';
comment on column DSY_T_SYS_ROLE_MENU.menu_name
  is '菜单名称';
comment on column DSY_T_SYS_ROLE_MENU.role_id
  is '所属角色';
comment on column DSY_T_SYS_ROLE_MENU.menu_type
  is '菜单所属类别编码';
comment on column DSY_T_SYS_ROLE_MENU.menu_type_name
  is '菜单所属类别名称';
-- 20210104 wq 单位首页总体情况表
create table DEBT_T_ZQGL_XM_ZTQK
(
  xm_id             VARCHAR2(38),
  ad_code           VARCHAR2(20),
  ag_id             VARCHAR2(38),
  ag_code           VARCHAR2(20),
  ag_name           VARCHAR2(200),
  nd                NUMBER(4),
  plan_total_amt    NUMBER(20,2) default 0,
  act_total_amt     NUMBER(20,2) default 0,
  plan_sjbz_amt     NUMBER(20,2) default 0,
  act_sjbz_amt      NUMBER(20,2) default 0,
  plan_czys_amt     NUMBER(20,2) default 0,
  act_czys_amt      NUMBER(20,2) default 0,
  plan_rz_total_amt NUMBER(20,2) default 0,
  act_rz_total_amt  NUMBER(20,2) default 0,
  act_ybzq_amt      NUMBER(20,2) default 0,
  act_zxzq_amt      NUMBER(20,2) default 0,
  act_zhzq_amt      NUMBER(20,2) default 0,
  act_zrzzq_amt     NUMBER(20,2) default 0,
  plan_scrz_amt     NUMBER(20,2) default 0,
  act_scrz_amt      NUMBER(20,2) default 0,
  plan_dwzc_amt     NUMBER(20,2) default 0,
  act_dwzc_amt      NUMBER(20,2) default 0,
  plan_qt_amt       NUMBER(20,2) default 0,
  act_qt_amt        NUMBER(20,2) default 0,
  xzzq_zc_amt       NUMBER(20,2) default 0,
  xzybzq_zc_amt     NUMBER(20,2) default 0,
  xzzxzq_zc_amt     NUMBER(20,2) default 0,
  zhzq_zc_amt       NUMBER(20,2) default 0,
  zrzzq_zc_amt      NUMBER(20,2) default 0,
  xzzq_sjzc_amt     NUMBER(20,2) default 0,
  xzyb_sjzc_amt     NUMBER(20,2) default 0,
  xzzx_sjzc_amt     NUMBER(20,2) default 0,
  zhzq_sjzc_amt     NUMBER(20,2) default 0,
  zrzzq_sjzc_amt    NUMBER(20,2) default 0,
  szys_sr_amt       NUMBER(20,2) default 0,
  szys_zc_amt       NUMBER(20,2) default 0,
  xm_jdbl           NUMBER(10,2) default 0,
  xm_jszq           NUMBER(10,2) default 0,
  xm_yyzq           NUMBER(10,2) default 0,
  sjsy_total_amt    NUMBER(20,2) default 0,
  sjsy_bj_amt       NUMBER(20,2) default 0,
  sjsy_lx_amt       NUMBER(20,2) default 0,
  sjsy_sxf_amt      NUMBER(20,2) default 0,
  create_date       VARCHAR2(38),
  create_user       VARCHAR2(100),
  wf_name           VARCHAR2(100),
  iscxq             NUMBER(1) default 0
);
-- Add comments to the table 
comment on table DEBT_T_ZQGL_XM_ZTQK
  is '项目分年度总体情况表';
-- Add comments to the columns 
comment on column DEBT_T_ZQGL_XM_ZTQK.xm_id
  is '项目ID';
comment on column DEBT_T_ZQGL_XM_ZTQK.ad_code
  is '所属区划';
comment on column DEBT_T_ZQGL_XM_ZTQK.ag_id
  is '所属单位ID';
comment on column DEBT_T_ZQGL_XM_ZTQK.ag_code
  is '所属单位编码';
comment on column DEBT_T_ZQGL_XM_ZTQK.ag_name
  is '所属单位名称';
comment on column DEBT_T_ZQGL_XM_ZTQK.nd
  is '年度';
comment on column DEBT_T_ZQGL_XM_ZTQK.plan_total_amt
  is '计划总投资';
comment on column DEBT_T_ZQGL_XM_ZTQK.act_total_amt
  is '实际总到位';
comment on column DEBT_T_ZQGL_XM_ZTQK.plan_sjbz_amt
  is '计划投资（上级补助）';
comment on column DEBT_T_ZQGL_XM_ZTQK.act_sjbz_amt
  is '实际到位（上级补助）';
comment on column DEBT_T_ZQGL_XM_ZTQK.plan_czys_amt
  is '计划投资（本级预算资金）';
comment on column DEBT_T_ZQGL_XM_ZTQK.act_czys_amt
  is '实际到位（本级预算资金）';
comment on column DEBT_T_ZQGL_XM_ZTQK.plan_rz_total_amt
  is '计划投资（总融资资金）';
comment on column DEBT_T_ZQGL_XM_ZTQK.act_rz_total_amt
  is '实际投资（总融资资金）';
comment on column DEBT_T_ZQGL_XM_ZTQK.act_ybzq_amt
  is '实际到位（新增一般债券资金）';
comment on column DEBT_T_ZQGL_XM_ZTQK.act_zxzq_amt
  is '实际到位（新增专项债券资金）';
comment on column DEBT_T_ZQGL_XM_ZTQK.act_zhzq_amt
  is '实际到位（置换债券资金）';
comment on column DEBT_T_ZQGL_XM_ZTQK.act_zrzzq_amt
  is '实际到位（再融资债券资金）';
comment on column DEBT_T_ZQGL_XM_ZTQK.plan_scrz_amt
  is '计划投资（市场化配套融资）';
comment on column DEBT_T_ZQGL_XM_ZTQK.act_scrz_amt
  is '实际到位（市场化配套融资）';
comment on column DEBT_T_ZQGL_XM_ZTQK.plan_dwzc_amt
  is '计划投资（单位自筹）';
comment on column DEBT_T_ZQGL_XM_ZTQK.act_dwzc_amt
  is '实际到位（单位自筹）';
comment on column DEBT_T_ZQGL_XM_ZTQK.plan_qt_amt
  is '计划投资（其他资金）';
comment on column DEBT_T_ZQGL_XM_ZTQK.act_qt_amt
  is '实际到位（其他资金）';
comment on column DEBT_T_ZQGL_XM_ZTQK.xzzq_zc_amt
  is '新增债券资金拨付（债券支出）';
comment on column DEBT_T_ZQGL_XM_ZTQK.xzybzq_zc_amt
  is '新增一般债券资金拨付（债券支出）';
comment on column DEBT_T_ZQGL_XM_ZTQK.xzzxzq_zc_amt
  is '新增专项债券资金拨付（债券支出）';
comment on column DEBT_T_ZQGL_XM_ZTQK.zhzq_zc_amt
  is '置换债券资金拨付（债券支出）';
comment on column DEBT_T_ZQGL_XM_ZTQK.zrzzq_zc_amt
  is '再融资债券资金拨付（债券支出）';
comment on column DEBT_T_ZQGL_XM_ZTQK.xzzq_sjzc_amt
  is '新增债券实际支出金额';
comment on column DEBT_T_ZQGL_XM_ZTQK.xzyb_sjzc_amt
  is '新增一般债券实际支出';
comment on column DEBT_T_ZQGL_XM_ZTQK.xzzx_sjzc_amt
  is '新增专项债券实际支出';
comment on column DEBT_T_ZQGL_XM_ZTQK.zhzq_sjzc_amt
  is '置换债券实际支出';
comment on column DEBT_T_ZQGL_XM_ZTQK.zrzzq_sjzc_amt
  is '再融资债券实际支出';
comment on column DEBT_T_ZQGL_XM_ZTQK.szys_sr_amt
  is '收支预算-收入';
comment on column DEBT_T_ZQGL_XM_ZTQK.szys_zc_amt
  is '收支预算-支出';
comment on column DEBT_T_ZQGL_XM_ZTQK.xm_jdbl
  is '项目建设进度比例，百分比';
comment on column DEBT_T_ZQGL_XM_ZTQK.xm_jszq
  is '项目建设周期（不分年度）';
comment on column DEBT_T_ZQGL_XM_ZTQK.xm_yyzq
  is '项目运营周期（不分年度）';
comment on column DEBT_T_ZQGL_XM_ZTQK.sjsy_total_amt
  is '项目实际收益（收益缴库）总金额';
comment on column DEBT_T_ZQGL_XM_ZTQK.sjsy_bj_amt
  is '项目实际收益（收益缴库）本金金额';
comment on column DEBT_T_ZQGL_XM_ZTQK.sjsy_lx_amt
  is '项目实际收益（收益缴库）付息金额';
comment on column DEBT_T_ZQGL_XM_ZTQK.sjsy_sxf_amt
  is '项目实际收益（收益缴库）手续费金额';
comment on column DEBT_T_ZQGL_XM_ZTQK.create_date
  is '创建日期';
comment on column DEBT_T_ZQGL_XM_ZTQK.create_user
  is '创建人';
comment on column DEBT_T_ZQGL_XM_ZTQK.wf_name
  is '项目状态';
comment on column DEBT_T_ZQGL_XM_ZTQK.iscxq
  is '是否存续期 0 不是 1是';
-- Create/Recreate indexes 
create index XM_ZTQK_AD_CODE on DEBT_T_ZQGL_XM_ZTQK (AD_CODE);
create index XM_ZTQK_AG_CODE on DEBT_T_ZQGL_XM_ZTQK (AG_CODE);
create index XM_ZTQK_AG_ID on DEBT_T_ZQGL_XM_ZTQK (AG_ID);
create index XM_ZTQK_ND on DEBT_T_ZQGL_XM_ZTQK (ND);
create index XM_ZTQK_XM_ID on DEBT_T_ZQGL_XM_ZTQK (XM_ID);
-- 20210104 wq 投资计划表加再融资债券字段
ALTER TABLE DEBT_T_ZQGL_XM_PLAN ADD RZZJ_ZRZ_AMT NUMBER(16,2);
COMMENT ON COLUMN DEBT_T_ZQGL_XM_PLAN.RZZJ_ZRZ_AMT IS '再融资债券资金';
-- 20210104 wq 单位首页跳转菜单配置
delete from DSY_T_SYS_ROLE_MENU ;
insert into DSY_T_SYS_ROLE_MENU (GUID, MENU_CODE, MENU_NAME, ROLE_ID, MENU_TYPE, MENU_TYPE_NAME)
values ('981C552C7E664A548334CE167DF2A2E7', '211310100020015', '融资协议', null, 'schrz', '市场化融资');
insert into DSY_T_SYS_ROLE_MENU (GUID, MENU_CODE, MENU_NAME, ROLE_ID, MENU_TYPE, MENU_TYPE_NAME)
values ('42D5F27FEF604481A751FA861220484E', '211310100020025', '举借提款', null, 'schrz', '市场化融资');
insert into DSY_T_SYS_ROLE_MENU (GUID, MENU_CODE, MENU_NAME, ROLE_ID, MENU_TYPE, MENU_TYPE_NAME)
values ('5549CABF9DEE4DEFA1BDBDE29BC330BB', '211310100020035', '还本付息', null, 'schrz', '市场化融资');
insert into DSY_T_SYS_ROLE_MENU (GUID, MENU_CODE, MENU_NAME, ROLE_ID, MENU_TYPE, MENU_TYPE_NAME)
values ('1741BAF51F2D48DB98174E012593613F', '211310100020045', '借新还旧', null, 'schrz', '市场化融资');
insert into DSY_T_SYS_ROLE_MENU (GUID, MENU_CODE, MENU_NAME, ROLE_ID, MENU_TYPE, MENU_TYPE_NAME)
values ('E6F7536DE4334BFD90501D8A214415B9', '211310100020055', '债务支出', null, 'schrz', '市场化融资');
insert into DSY_T_SYS_ROLE_MENU (GUID, MENU_CODE, MENU_NAME, ROLE_ID, MENU_TYPE, MENU_TYPE_NAME)
values ('649D5D3789DB41EA9BB3CFAB53633EF0', '211310100015050', '项目资金到位情况', null, 'zjdw', '资金到位');
insert into DSY_T_SYS_ROLE_MENU (GUID, MENU_CODE, MENU_NAME, ROLE_ID, MENU_TYPE, MENU_TYPE_NAME)
values ('B4C998ADD06647739D604FE0FEF4D5E7', '211310100015056', '债券资金实际使用', null, 'zjsy', '资金使用');
insert into DSY_T_SYS_ROLE_MENU (GUID, MENU_CODE, MENU_NAME, ROLE_ID, MENU_TYPE, MENU_TYPE_NAME)
values ('7F81296DA69540C18759C6AEBEFF9F03', '211310100015060', '项目招投标情况', null, 'jsjd', '建设进度');
insert into DSY_T_SYS_ROLE_MENU (GUID, MENU_CODE, MENU_NAME, ROLE_ID, MENU_TYPE, MENU_TYPE_NAME)
values ('82A86C4540BA46C4A6F8D1CAD8E684C3', '211310100015040', '项目建设进度情况', null, 'jsjd', '建设进度');
insert into DSY_T_SYS_ROLE_MENU (GUID, MENU_CODE, MENU_NAME, ROLE_ID, MENU_TYPE, MENU_TYPE_NAME)
values ('95FF69B3D135486E8AAEB4448FFE3591', '211310100015030', '项目资产情况', null, 'xmsy', '项目收益');
insert into DSY_T_SYS_ROLE_MENU (GUID, MENU_CODE, MENU_NAME, ROLE_ID, MENU_TYPE, MENU_TYPE_NAME)
values ('06EA1F466ABC432498940F8F3A04CDFE', '211310100015015', '项目年度收支决算编制', null, 'xmsy', '项目收益');
insert into DSY_T_SYS_ROLE_MENU (GUID, MENU_CODE, MENU_NAME, ROLE_ID, MENU_TYPE, MENU_TYPE_NAME)
values ('A0CF7279F49D4A3693C02CC18EFF0FEA', '211310100001025', '项目变更录入', null, 'xmbg', '项目变更');
insert into DSY_T_SYS_ROLE_MENU (GUID, MENU_CODE, MENU_NAME, ROLE_ID, MENU_TYPE, MENU_TYPE_NAME)
values ('3EFC2DF572384246BFED0964D31767C0', '211310100015070', '专项债券收入缴库', null, 'hbfx', '还本付息');
insert into DSY_T_SYS_ROLE_MENU (GUID, MENU_CODE, MENU_NAME, ROLE_ID, MENU_TYPE, MENU_TYPE_NAME)
values ('A3671BFF52F04031A92CD214CCD987C3', '211310100015005', '预算调整录入', null, 'cxq', '存续期');
insert into DSY_T_SYS_ROLE_MENU (GUID, MENU_CODE, MENU_NAME, ROLE_ID, MENU_TYPE, MENU_TYPE_NAME)
values ('24D497E0968841CFB59BAE578E94916B', '211310100005005', '储备项目申报', null, 'cbk', '储备库');
insert into DSY_T_SYS_ROLE_MENU (GUID, MENU_CODE, MENU_NAME, ROLE_ID, MENU_TYPE, MENU_TYPE_NAME)
values ('63FF37BEB1184E94BAD508AF44C72158', '211310003001005', '限额需求申报', null, 'xqk', '需求库');
insert into DSY_T_SYS_ROLE_MENU (GUID, MENU_CODE, MENU_NAME, ROLE_ID, MENU_TYPE, MENU_TYPE_NAME)
values ('81E9392E760445C496C0F24110D13D7C', '211310100010015005', '遴选发行申报', null, 'fxk', '发行库');
insert into DSY_T_SYS_ROLE_MENU (GUID, MENU_CODE, MENU_NAME, ROLE_ID, MENU_TYPE, MENU_TYPE_NAME)
values ('B77388D6C8C84E458C8CC6388D9C4163', '211310100015090', '资产处置填报', null, 'xmsy', '项目收益');
-- 20210104 单位首页总体情况表存储过程
CREATE OR REPLACE PROCEDURE DEBT_P_ZTQK_CALBYXMID(VXMID  VARCHAR2,VOPUSER VARCHAR2)
IS  P_OP_DATE  VARCHAR2(20);
BEGIN
    if VXMID is null or VXMID = '' then
       dbms_output.put_line('项目ID不允许为空!');
       return;
    end if;
    P_OP_DATE:=TO_CHAR(SYSDATE,'YYYY-MM-DD  HH24:MI:SS');
    DELETE  FROM  DEBT_T_ZQGL_XM_ZTQK  WHERE XM_ID=VXMID;
    INSERT INTO DEBT_T_ZQGL_XM_ZTQK(XM_ID,AD_CODE,AG_ID,AG_CODE,AG_NAME,ND,PLAN_TOTAL_AMT,ACT_TOTAL_AMT,PLAN_SJBZ_AMT,ACT_SJBZ_AMT,
    PLAN_CZYS_AMT,ACT_CZYS_AMT,PLAN_RZ_TOTAL_AMT,ACT_RZ_TOTAL_AMT,ACT_YBZQ_AMT,ACT_ZXZQ_AMT,ACT_ZHZQ_AMT,ACT_ZRZZQ_AMT,PLAN_SCRZ_AMT,
    ACT_SCRZ_AMT,PLAN_DWZC_AMT,ACT_DWZC_AMT,PLAN_QT_AMT,ACT_QT_AMT,XZZQ_ZC_AMT,XZYBZQ_ZC_AMT,XZZXZQ_ZC_AMT,ZHZQ_ZC_AMT,ZRZZQ_ZC_AMT,
    XZZQ_SJZC_AMT,XZYB_SJZC_AMT,XZZX_SJZC_AMT,ZHZQ_SJZC_AMT,ZRZZQ_SJZC_AMT,SZYS_SR_AMT,SZYS_ZC_AMT,XM_JDBL,XM_JSZQ,XM_YYZQ,SJSY_TOTAL_AMT,
    SJSY_BJ_AMT,SJSY_LX_AMT,SJSY_SXF_AMT,CREATE_DATE,CREATE_USER,WF_NAME,ISCXQ)
    select INFO.XM_ID,
       INFO.AD_CODE,
       INFO.AG_ID,
       INFO.AG_CODE,
       INFO.AG_NAME,
       XM_ZJ.ND,
       NVL(XM_ZJ.PLAN_TOTAL_AMT, 0) PLAN_TOTAL_AMT, --计划总投资
       NVL(XM_ZJ.ACT_TOTAL_AMT, 0) ACT_TOTAL_AMT, --实际总到位
       NVL(XM_ZJ.PLAN_SJBZ_AMT, 0) PLAN_SJBZ_AMT, --上级补助计划投资
       NVL(XM_ZJ.ACT_SJBZ_AMT, 0) ACT_SJBZ_AMT, --上级补助实际到位
       NVL(XM_ZJ.PLAN_CZYS_AMT, 0) PLAN_CZYS_AMT, --本级财政预算资金计划投资
       NVL(XM_ZJ.ACT_CZYS_AMT, 0) ACT_CZYS_AMT, --本级财政预算资金实际到位
       NVL(XM_ZJ.PLAN_RZ_TOTAL_AMT, 0) PLAN_RZ_TOTAL_AMT, --融资计划总资金
       NVL(XM_ZJ.ACT_RZ_TOTAL_AMT, 0) ACT_RZ_TOTAL_AMT, --融资到位总资金
       NVL(XM_ZJ.ACT_YBZQ_AMT, 0) ACT_YBZQ_AMT, --新增一般债券资金实际到位
       NVL(XM_ZJ.ACT_ZXZQ_AMT, 0) ACT_ZXZQ_AMT, --新增专项债券资金实际到位
       NVL(XM_ZJ.ACT_ZHZQ_AMT, 0) ACT_ZHZQ_AMT, --置换债券资金实际到位
       NVL(XM_ZJ.ACT_ZRZZQ_AMT, 0) ACT_ZRZZQ_AMT, --再融资债券资金实际到位
       NVL(XM_ZJ.PLAN_SCRZ_AMT, 0) PLAN_SCRZ_AMT, --市场化配套融资计划投资
       NVL(XM_ZJ.ACT_SCRZ_AMT, 0) ACT_SCRZ_AMT, --市场化配套融资实际到位
       NVL(XM_ZJ.PLAN_DWZC_AMT, 0) PLAN_DWZC_AMT, --单位自筹计划投资
       NVL(XM_ZJ.ACT_DWZC_AMT, 0) ACT_DWZC_AMT, --单位自筹实际到位
       NVL(XM_ZJ.PLAN_QT_AMT, 0) PLAN_QT_AMT, --其他计划投资
       NVL(XM_ZJ.ACT_QI_AMT, 0) ACT_QI_AMT, --其他实际到位资金
       NVL(XM_ZJ.XZZQ_ZC_AMT, 0) XZZQ_ZC_AMT, --新增债券资金拨付（债券支出）
       NVL(XM_ZJ.XZYBZQ_ZC_AMT, 0) XZYBZQ_ZC_AMT, --新增一般债券资金拨付（债券支出）
       NVL(XM_ZJ.XZZXZQ_ZC_AMT, 0) XZZXZQ_ZC_AMT, --新增专项债券资金拨付（债券支出）
       NVL(XM_ZJ.ZHZQ_ZC_AMT, 0) ZHZQ_ZC_AMT, --置换债券资金拨付（债券支出）
       NVL(XM_ZJ.ZRZZQ_ZC_AMT, 0) ZRZZQ_ZC_AMT, --再融资债券资金拨付（债券支出）
       NVL(XM_ZJ.XZZQ_SJZC_AMT, 0) XZZQ_SJZC_AMT, --新增债券实际支出金额
       NVL(XM_ZJ.XZYB_SJZC_AMT, 0) XZYB_SJZC_AMT, --新增一般债券实际支出
       NVL(XM_ZJ.XZZX_SJZC_AMT, 0) XZZX_SJZC_AMT, --新增专项债券实际支出
       NVL(XM_ZJ.ZHZQ_SJZC_AMT, 0) ZHZQ_SJZC_AMT, --置换债券实际支出
       NVL(XM_ZJ.ZRZZQ_SJZC_AMT, 0) ZRZZQ_SJZC_AMT, --再融资债券实际支出
       NVL(XM_ZJ.SZYS_SR_AMT, 0) SZYS_SR_AMT, --收支预算-收入
       NVL(XM_ZJ.SZYS_ZC_AMT, 0) SZYS_ZC_AMT, --收支预算-支出
       JD.XM_JDBL, --进度比例
       round(months_between(to_date((case
                                      when INFO.end_date_actual is not null then
                                       INFO.end_date_actual
                                      else
                                       INFO.end_date_plan
                                    end),
                                    'yyyy-mm-dd'),
                            to_date((case
                                      when INFO.start_date_actual is not null then
                                       INFO.start_date_actual
                                      else
                                       INFO.start_date_plan
                                    end),
                                    'yyyy-mm-dd')) / 12,
             2) XM_JSZQ, --建设期限（年）
       XM_ZJ.XM_YYZQ, --项目运营周期（年）
       NVL(XM_ZJ.SJSY_TOTAL_AMT, 0) SJSY_TOTAL_AMT, --项目实际收益（收益缴库）总金额
       NVL(XM_ZJ.SJSY_BJ_AMT, 0) SJSY_BJ_AMT, --项目实际收益（收益缴库）本金金额
       NVL(XM_ZJ.SJSY_LX_AMT, 0) SJSY_LX_AMT, --项目实际收益（收益缴库）付息金额
       NVL(XM_ZJ.SJSY_SXF_AMT, 0) SJSY_SXF_AMT, --项目实际收益（收益缴库）手续费金额
       P_OP_DATE,
       VOPUSER,
       WF.WF_NAME,
       WF.ISCXQ
  from DEBT_T_PROJECT_INFO INFO
  LEFT JOIN (SELECT T.XM_ID,
                    T.ND,
                    MAX(XM_YYZQ) XM_YYZQ, --运营周期
                    SUM(NVL(PLAN_TOTAL_AMT, 0)) PLAN_TOTAL_AMT, --计划总投资
                    SUM(NVL(ACT_TOTAL_AMT, 0)) ACT_TOTAL_AMT, --实际总到位
                    SUM(NVL(PLAN_SJBZ_AMT, 0)) PLAN_SJBZ_AMT, --上级补助计划投资
                    SUM(NVL(ACT_SJBZ_AMT, 0)) ACT_SJBZ_AMT, --上级补助实际到位
                    SUM(NVL(PLAN_CZYS_AMT, 0)) PLAN_CZYS_AMT, --本级财政预算资金计划投资
                    SUM(NVL(ACT_CZYS_AMT, 0)) ACT_CZYS_AMT, --本级财政预算资金实际到位
                    SUM(NVL(PLAN_RZ_TOTAL_AMT, 0)) PLAN_RZ_TOTAL_AMT, --融资计划总资金
                    SUM(NVL(ACT_RZ_TOTAL_AMT, 0)) ACT_RZ_TOTAL_AMT, --融资到位总资金
                    SUM(NVL(ACT_YBZQ_AMT, 0)) ACT_YBZQ_AMT, --新增一般债券资金实际到位
                    SUM(NVL(ACT_ZXZQ_AMT, 0)) ACT_ZXZQ_AMT, --新增专项债券资金实际到位
                    SUM(NVL(ACT_ZHZQ_AMT, 0)) ACT_ZHZQ_AMT, --置换债券资金实际到位
                    SUM(NVL(ACT_ZRZZQ_AMT, 0)) ACT_ZRZZQ_AMT, --再融资债券资金实际到位
                    SUM(NVL(PLAN_SCRZ_AMT, 0)) PLAN_SCRZ_AMT, --市场化配套融资计划投资
                    SUM(NVL(ACT_SCRZ_AMT, 0)) ACT_SCRZ_AMT, --市场化配套融资实际到位
                    SUM(NVL(PLAN_DWZC_AMT, 0)) PLAN_DWZC_AMT, --单位自筹计划投资
                    SUM(NVL(ACT_DWZC_AMT, 0)) ACT_DWZC_AMT, --单位自筹实际到位
                    SUM(NVL(PLAN_QT_AMT, 0)) PLAN_QT_AMT, --其他计划投资
                    SUM(NVL(ACT_QI_AMT, 0)) ACT_QI_AMT, --其他实际到位资金
                    SUM(NVL(XZZQ_ZC_AMT, 0)) XZZQ_ZC_AMT, --新增债券资金拨付（债券支出）
                    SUM(NVL(XZYBZQ_ZC_AMT, 0)) XZYBZQ_ZC_AMT, --新增一般债券资金拨付（债券支出）
                    SUM(NVL(XZZXZQ_ZC_AMT, 0)) XZZXZQ_ZC_AMT, --新增专项债券资金拨付（债券支出）
                    SUM(NVL(ZHZQ_ZC_AMT, 0)) ZHZQ_ZC_AMT, --置换债券资金拨付（债券支出）
                    SUM(NVL(ZRZZQ_ZC_AMT, 0)) ZRZZQ_ZC_AMT, --再融资债券资金拨付（债券支出）
                    SUM(NVL(XZZQ_SJZC_AMT, 0)) XZZQ_SJZC_AMT, --新增债券实际支出金额
                    SUM(NVL(XZYB_SJZC_AMT, 0)) XZYB_SJZC_AMT, --新增一般债券实际支出
                    SUM(NVL(XZZX_SJZC_AMT, 0)) XZZX_SJZC_AMT, --新增专项债券实际支出
                    SUM(NVL(ZHZQ_SJZC_AMT, 0)) ZHZQ_SJZC_AMT, --置换债券实际支出
                    SUM(NVL(ZRZZQ_SJZC_AMT, 0)) ZRZZQ_SJZC_AMT, --再融资债券实际支出
                    SUM(NVL(SZYS_SR_AMT, 0)) SZYS_SR_AMT, --收支预算-收入
                    SUM(NVL(SZYS_ZC_AMT, 0)) SZYS_ZC_AMT, --收支预算-支出
                    SUM(NVL(SJSY_TOTAL_AMT, 0)) SJSY_TOTAL_AMT, --项目实际收益（收益缴库）总金额
                    SUM(NVL(SJSY_BJ_AMT, 0)) SJSY_BJ_AMT, --项目实际收益（收益缴库）本金金额
                    SUM(NVL(SJSY_LX_AMT, 0)) SJSY_LX_AMT, --项目实际收益（收益缴库）付息金额
                    SUM(NVL(SJSY_SXF_AMT, 0)) SJSY_SXF_AMT --项目实际收益（收益缴库）手续费金额
               FROM (SELECT XM_PLAN.XM_ID,
                            '' || XM_PLAN.ND ND,
                            0 XM_YYZQ, --运营周期
                            nvl(XM_PLAN.SJBZ_PLAN_AMT, 0) +
                            nvl(XM_PLAN.CZYS_PLAN_AMT, 0) +
                            nvl(XM_PLAN.RZZJ_PLAN_AMT, 0) +
                            nvl(XM_PLAN.SCRZ_PLAN_AMT, 0) +
                            nvl(XM_PLAN.DWZC_PLAN_AMT, 0) +
                            nvl(XM_PLAN.QT_PLAN_AMT, 0) PLAN_TOTAL_AMT, --计划总投资
                            nvl(XM_PLAN.SJBZ_ACTUAL_AMT, 0) +
                            nvl(XM_PLAN.CZYS_ACTUAL_AMT, 0) +
                            nvl(XM_PLAN.RZZJ_ACTUAL_AMT, 0) +
                            nvl(XM_PLAN.XY_AMT_RMB, 0) +
                            nvl(XM_PLAN.DWZC_ACTUAL_AMT, 0) +
                            nvl(XM_PLAN.QT_ACTUAL_AMT, 0) ACT_TOTAL_AMT,
                            nvl(XM_PLAN.SJBZ_PLAN_AMT, 0) PLAN_SJBZ_AMT, --上级补助计划投资
                            nvl(XM_PLAN.SJBZ_ACTUAL_AMT, 0) ACT_SJBZ_AMT, --上级补助实际到位
                            nvl(XM_PLAN.CZYS_PLAN_AMT, 0) PLAN_CZYS_AMT, --本级财政预算资金计划投资
                            nvl(XM_PLAN.CZYS_ACTUAL_AMT, 0) ACT_CZYS_AMT, --本级财政预算资金实际到位
                            nvl(XM_PLAN.RZZJ_PLAN_AMT, 0) PLAN_RZ_TOTAL_AMT, --融资计划总资金
                            nvl(XM_PLAN.RZZJ_ACTUAL_AMT, 0) ACT_RZ_TOTAL_AMT, --融资到位总资金
                            nvl(XM_PLAN.RZZJ_YBZQ_AMT, 0) ACT_YBZQ_AMT, --新增一般债券资金实际到位
                            nvl(XM_PLAN.RZZJ_ZXZQ_AMT, 0) ACT_ZXZQ_AMT, --新增专项债券资金实际到位
                            nvl(XM_PLAN.RZZJ_ZHZQ_AMT, 0) ACT_ZHZQ_AMT, --置换债券资金实际到位
                            nvl(XM_PLAN.RZZJ_ZRZ_AMT, 0) ACT_ZRZZQ_AMT, --再融资债券资金实际到位
                            nvl(XM_PLAN.SCRZ_PLAN_AMT, 0) PLAN_SCRZ_AMT, --市场化配套融资计划投资
                            nvl(XM_PLAN.XY_AMT_RMB, 0) ACT_SCRZ_AMT, --市场化配套融资实际到位
                            nvl(XM_PLAN.DWZC_PLAN_AMT, 0) PLAN_DWZC_AMT, --单位自筹计划投资
                            nvl(XM_PLAN.DWZC_ACTUAL_AMT, 0) ACT_DWZC_AMT, --单位自筹实际到位
                            nvl(XM_PLAN.QT_PLAN_AMT, 0) PLAN_QT_AMT, --其他计划投资
                            nvl(XM_PLAN.QT_ACTUAL_AMT, 0) ACT_QI_AMT, --其他实际到位资金
                            0 XZZQ_ZC_AMT, --新增债券资金拨付（债券支出）
                            0 XZYBZQ_ZC_AMT, --新增一般债券资金拨付（债券支出）
                            0 XZZXZQ_ZC_AMT, --新增专项债券资金拨付（债券支出）
                            0 ZHZQ_ZC_AMT, --置换债券资金拨付（债券支出）
                            0 ZRZZQ_ZC_AMT, --再融资债券资金拨付（债券支出）
                            0 XZZQ_SJZC_AMT, --新增债券实际支出金额
                            0 XZYB_SJZC_AMT, --新增一般债券实际支出
                            0 XZZX_SJZC_AMT, --新增专项债券实际支出
                            0 ZHZQ_SJZC_AMT, --置换债券实际支出
                            0 ZRZZQ_SJZC_AMT, --再融资债券实际支出
                            0 SZYS_SR_AMT, --收支预算-收入
                            0 SZYS_ZC_AMT, --收支预算-支出
                            0 SJSY_TOTAL_AMT, --项目实际收益（收益缴库）总金额
                            0 SJSY_BJ_AMT, --项目实际收益（收益缴库）本金金额
                            0 SJSY_LX_AMT, --项目实际收益（收益缴库）付息金额
                            0 SJSY_SXF_AMT --项目实际收益（收益缴库）手续费金额
                       FROM DEBT_T_ZQGL_XM_PLAN XM_PLAN WHERE XM_PLAN.XM_ID=VXMID
                     UNION ALL
                     SELECT ZCXX.XM_ID,
                            SUBSTR(ZCXX.PAY_DATE, 1, 4) ND,
                            0 XM_YYZQ, --运营周期
                            0 PLAN_TOTAL_AMT, --计划总投资
                            0 ACT_TOTAL_AMT,
                            0 PLAN_SJBZ_AMT, --上级补助计划投资
                            0 ACT_SJBZ_AMT, --上级补助实际到位
                            0 PLAN_CZYS_AMT, --本级财政预算资金计划投资
                            0 ACT_CZYS_AMT, --本级财政预算资金实际到位
                            0 PLAN_RZ_TOTAL_AMT, --融资计划总资金
                            0 ACT_RZ_TOTAL_AMT, --融资到位总资金
                            0 ACT_YBZQ_AMT, --新增一般债券资金实际到位
                            0 ACT_ZXZQ_AMT, --新增专项债券资金实际到位
                            0 ACT_ZHZQ_AMT, --置换债券资金实际到位
                            0 ACT_ZRZZQ_AMT, --再融资债券资金实际到位
                            0 PLAN_SCRZ_AMT, --市场化配套融资计划投资
                            0 ACT_SCRZ_AMT, --市场化配套融资实际到位
                            0 PLAN_DWZC_AMT, --单位自筹计划投资
                            0 ACT_DWZC_AMT, --单位自筹实际到位
                            0 PLAN_QT_AMT, --其他计划投资
                            0 ACT_QI_AMT, --其他实际到位资金
                            CASE
                              WHEN ZCXX.ZC_TYPE = 0 THEN
                               ZCXX.PAY_AMT
                              ELSE
                               0
                            END XZZQ_ZC_AMT, --新增债券资金拨付（债券支出）
                            CASE
                              WHEN ZCXX.ZC_TYPE = 0 AND
                                   ZQXX.ZQLB_ID LIKE '01%' THEN
                               ZCXX.PAY_AMT
                              ELSE
                               0
                            END XZYBZQ_ZC_AMT, --新增一般债券资金拨付（债券支出）
                            CASE
                              WHEN ZCXX.ZC_TYPE = 0 AND
                                   ZQXX.ZQLB_ID LIKE '02%' THEN
                               ZCXX.PAY_AMT
                              ELSE
                               0
                            END XZZXZQ_ZC_AMT, --新增专项债券资金拨付（债券支出）
                            CASE
                              WHEN ZCXX.ZC_TYPE = 1 THEN
                               ZCXX.PAY_AMT
                              ELSE
                               0
                            END ZHZQ_ZC_AMT, --置换债券资金拨付（债券支出）
                            CASE
                              WHEN ZCXX.ZC_TYPE = 2 THEN
                               ZCXX.PAY_AMT
                              ELSE
                               0
                            END ZRZZQ_ZC_AMT, --再融资债券资金拨付（债券支出）
                            0 XZZQ_SJZC_AMT, --新增债券实际支出金额
                            0 XZYB_SJZC_AMT, --新增一般债券实际支出
                            0 XZZX_SJZC_AMT, --新增专项债券实际支出
                            0 ZHZQ_SJZC_AMT, --置换债券实际支出
                            0 ZRZZQ_SJZC_AMT, --再融资债券实际支出
                            0 SZYS_SR_AMT, --收支预算-收入
                            0 SZYS_ZC_AMT, --收支预算-支出
                            0 SJSY_TOTAL_AMT, --项目实际收益（收益缴库）总金额
                            0 SJSY_BJ_AMT, --项目实际收益（收益缴库）本金金额
                            0 SJSY_LX_AMT, --项目实际收益（收益缴库）付息金额
                            0 SJSY_SXF_AMT --项目实际收益（收益缴库）手续费金额
                       FROM DEBT_T_ZQGL_ZCXX ZCXX, DEBT_T_ZQGL_ZQXX ZQXX
                      WHERE ZCXX.ZQ_ID = ZQXX.ZQ_ID
                        AND ZCXX.IS_END = 1 AND ZCXX.XM_ID=VXMID
                     UNION ALL
                     SELECT SJZC.XM_ID,
                            SUBSTR(SJZC.SJZC_DATE, 1, 4) ND,
                            0 XM_YYZQ, --运营周期
                            0 PLAN_TOTAL_AMT, --计划总投资
                            0 ACT_TOTAL_AMT,
                            0 PLAN_SJBZ_AMT, --上级补助计划投资
                            0 ACT_SJBZ_AMT, --上级补助实际到位
                            0 PLAN_CZYS_AMT, --本级财政预算资金计划投资
                            0 ACT_CZYS_AMT, --本级财政预算资金实际到位
                            0 PLAN_RZ_TOTAL_AMT, --融资计划总资金
                            0 ACT_RZ_TOTAL_AMT, --融资到位总资金
                            0 ACT_YBZQ_AMT, --新增一般债券资金实际到位
                            0 ACT_ZXZQ_AMT, --新增专项债券资金实际到位
                            0 ACT_ZHZQ_AMT, --置换债券资金实际到位
                            0 ACT_ZRZZQ_AMT, --再融资债券资金实际到位
                            0 PLAN_SCRZ_AMT, --市场化配套融资计划投资
                            0 ACT_SCRZ_AMT, --市场化配套融资实际到位
                            0 PLAN_DWZC_AMT, --单位自筹计划投资
                            0 ACT_DWZC_AMT, --单位自筹实际到位
                            0 PLAN_QT_AMT, --其他计划投资
                            0 ACT_QI_AMT, --其他实际到位资金
                            0 XZZQ_ZC_AMT, --新增债券资金拨付（债券支出）
                            0 XZYBZQ_ZC_AMT, --新增一般债券资金拨付（债券支出）
                            0 XZZXZQ_ZC_AMT, --新增专项债券资金拨付（债券支出）
                            0 ZHZQ_ZC_AMT, --置换债券资金拨付（债券支出）
                            0 ZRZZQ_ZC_AMT, --再融资债券资金拨付（债券支出）
                            CASE
                              WHEN SJZC.SJZC_TYPE = 0 THEN
                               SJZC.SJZC_AMT
                              ELSE
                               0
                            END XZZQ_SJZC_AMT, --新增债券实际支出
                            CASE
                              WHEN SJZC.SJZC_TYPE = 0 AND
                                   ZQXX.ZQLB_ID LIKE '01%' THEN
                               SJZC.SJZC_AMT
                              ELSE
                               0
                            END XZYB_SJZC_AMT, --新增一般债券实际支出
                            CASE
                              WHEN SJZC.SJZC_TYPE = 0 AND
                                   ZQXX.ZQLB_ID LIKE '02%' THEN
                               SJZC.SJZC_AMT
                              ELSE
                               0
                            END XZZX_SJZC_AMT, --新增专项债券实际支出
                            CASE
                              WHEN SJZC.SJZC_TYPE = 1 THEN
                               SJZC.SJZC_AMT
                              ELSE
                               0
                            END ZHZQ_SJZC_AMT, --置换债券实际支出
                            CASE
                              WHEN SJZC.SJZC_TYPE = 2 THEN
                               SJZC.SJZC_AMT
                              ELSE
                               0
                            END ZRZZQ_SJZC_AMT, --再融资债券实际支出
                            0 SZYS_SR_AMT, --收支预算-收入
                            0 SZYS_ZC_AMT, --收支预算-支出
                            0 SJSY_TOTAL_AMT, --项目实际收益（收益缴库）总金额
                            0 SJSY_BJ_AMT, --项目实际收益（收益缴库）本金金额
                            0 SJSY_LX_AMT, --项目实际收益（收益缴库）付息金额
                            0 SJSY_SXF_AMT --项目实际收益（收益缴库）手续费金额
                       FROM DEBT_T_ZQGL_ZCXX_SJZC SJZC, DEBT_T_ZQGL_ZQXX ZQXX
                      WHERE SJZC.ZQ_ID = ZQXX.ZQ_ID
                        AND SJZC.IS_END = 1 AND SJZC.XM_ID=VXMID
                     UNION ALL
                     SELECT SJSY.XM_ID,
                            SUBSTR(SJSY.JK_DATE, 1, 4) ND,
                            0 XM_YYZQ, --运营周期
                            0 PLAN_TOTAL_AMT, --计划总投资
                            0 ACT_TOTAL_AMT,
                            0 PLAN_SJBZ_AMT, --上级补助计划投资
                            0 ACT_SJBZ_AMT, --上级补助实际到位
                            0 PLAN_CZYS_AMT, --本级财政预算资金计划投资
                            0 ACT_CZYS_AMT, --本级财政预算资金实际到位
                            0 PLAN_RZ_TOTAL_AMT, --融资计划总资金
                            0 ACT_RZ_TOTAL_AMT, --融资到位总资金
                            0 ACT_YBZQ_AMT, --新增一般债券资金实际到位
                            0 ACT_ZXZQ_AMT, --新增专项债券资金实际到位
                            0 ACT_ZHZQ_AMT, --置换债券资金实际到位
                            0 ACT_ZRZZQ_AMT, --再融资债券资金实际到位
                            0 PLAN_SCRZ_AMT, --市场化配套融资计划投资
                            0 ACT_SCRZ_AMT, --市场化配套融资实际到位
                            0 PLAN_DWZC_AMT, --单位自筹计划投资
                            0 ACT_DWZC_AMT, --单位自筹实际到位
                            0 PLAN_QT_AMT, --其他计划投资
                            0 ACT_QI_AMT, --其他实际到位资金
                            0 XZZQ_ZC_AMT, --新增债券资金拨付（债券支出）
                            0 XZYBZQ_ZC_AMT, --新增一般债券资金拨付（债券支出）
                            0 XZZXZQ_ZC_AMT, --新增专项债券资金拨付（债券支出）
                            0 ZHZQ_ZC_AMT, --置换债券资金拨付（债券支出）
                            0 ZRZZQ_ZC_AMT, --再融资债券资金拨付（债券支出）
                            0 XZZQ_SJZC_AMT, --新增债券实际支出
                            0 XZYB_SJZC_AMT, --新增一般债券实际支出
                            0 XZZX_SJZC_AMT, --新增专项债券实际支出
                            0 ZHZQ_SJZC_AMT, --置换债券实际支出
                            0 ZRZZQ_SJZC_AMT, --再融资债券实际支出
                            0 SZYS_SR_AMT, --收支预算-收入
                            0 SZYS_ZC_AMT, --收支预算-支出
                            SJSY.JK_AMT SJSY_TOTAL_AMT, --项目实际收益（收益缴库）总金额
                            SJSY.JK_BJ_AMT SJSY_BJ_AMT, --项目实际收益（收益缴库）本金金额
                            SJSY.JK_LX_AMT SJSY_LX_AMT, --项目实际收益（收益缴库）付息金额
                            SJSY.JK_FY_AMT SJSY_SXF_AMT --项目实际收益（收益缴库）手续费金额                           
                       FROM DEBT_T_ZQGL_XM_SJSY SJSY
                       WHERE SJSY.JK_AMT > 0 AND SJSY.IS_END=1 AND SJSY.XM_ID=VXMID
                       UNION ALL
                       SELECT SZYS.XM_ID,
                            TO_CHAR(SZYS.SET_YEAR) ND,
                            SZYS.XM_USED_LIMIT XM_YYZQ, --运营周期
                            0 PLAN_TOTAL_AMT, --计划总投资
                            0 ACT_TOTAL_AMT,
                            0 PLAN_SJBZ_AMT, --上级补助计划投资
                            0 ACT_SJBZ_AMT, --上级补助实际到位
                            0 PLAN_CZYS_AMT, --本级财政预算资金计划投资
                            0 ACT_CZYS_AMT, --本级财政预算资金实际到位
                            0 PLAN_RZ_TOTAL_AMT, --融资计划总资金
                            0 ACT_RZ_TOTAL_AMT, --融资到位总资金
                            0 ACT_YBZQ_AMT, --新增一般债券资金实际到位
                            0 ACT_ZXZQ_AMT, --新增专项债券资金实际到位
                            0 ACT_ZHZQ_AMT, --置换债券资金实际到位
                            0 ACT_ZRZZQ_AMT, --再融资债券资金实际到位
                            0 PLAN_SCRZ_AMT, --市场化配套融资计划投资
                            0 ACT_SCRZ_AMT, --市场化配套融资实际到位
                            0 PLAN_DWZC_AMT, --单位自筹计划投资
                            0 ACT_DWZC_AMT, --单位自筹实际到位
                            0 PLAN_QT_AMT, --其他计划投资
                            0 ACT_QI_AMT, --其他实际到位资金
                            0 XZZQ_ZC_AMT, --新增债券资金拨付（债券支出）
                            0 XZYBZQ_ZC_AMT, --新增一般债券资金拨付（债券支出）
                            0 XZZXZQ_ZC_AMT, --新增专项债券资金拨付（债券支出）
                            0 ZHZQ_ZC_AMT, --置换债券资金拨付（债券支出）
                            0 ZRZZQ_ZC_AMT, --再融资债券资金拨付（债券支出）
                            0 XZZQ_SJZC_AMT, --新增债券实际支出
                            0 XZYB_SJZC_AMT, --新增一般债券实际支出
                            0 XZZX_SJZC_AMT, --新增专项债券实际支出
                            0 ZHZQ_SJZC_AMT, --置换债券实际支出
                            0 ZRZZQ_SJZC_AMT, --再融资债券实际支出
                            CASE WHEN SZYS.SZLB_ID='01' THEN SZYS.SR_AMT ELSE 0 END SZYS_SR_AMT, --收支预算-收入
                            CASE WHEN (SZYS.XMLX_ID = '00' AND SZYS.SZLB_ID='04') OR (SZYS.XMLX_ID = '05' AND SZYS.SZLB_ID='03') THEN SZYS.ZC_AMT ELSE 0 END SZYS_ZC_AMT, --收支预算-支出
                            0 SJSY_TOTAL_AMT, --项目实际收益（收益缴库）总金额
                            0 SJSY_BJ_AMT, --项目实际收益（收益缴库）本金金额
                            0 SJSY_LX_AMT, --项目实际收益（收益缴库）付息金额
                            0 SJSY_SXF_AMT --项目实际收益（收益缴库）手续费金额                           
                       FROM DEBT_V_ZQGL_XM_SZYS_NEW SZYS WHERE SZYS.XM_ID=VXMID) T
              GROUP BY T.XM_ID, T.ND) XM_ZJ
    ON INFO.XM_ID = XM_ZJ.XM_ID
  LEFT JOIN (SELECT JSJD.XM_ID, MAX(JSJD.JDBL) XM_JDBL
               FROM DEBT_T_ZQGL_XM_JSJD JSJD
              WHERE JSJD.IS_END = 1 AND JSJD.XM_ID=VXMID
              GROUP BY JSJD.XM_ID) JD
    ON INFO.XM_ID = JD.XM_ID
      LEFT JOIN (SELECT ZQXM.XM_ID,
                        CASE
                          WHEN NVL(CH.SY_AMT, 1) = 0 THEN
                           '结束'
                          WHEN JSJD.XM_ID IS NOT NULL THEN
                           '已完工'
                          WHEN SJZC.XM_ID IS NOT NULL THEN
                           '建设中'
                          WHEN ZCXX.XM_ID IS NOT NULL THEN
                           '资金下达'
                          ELSE
                           '已发行'
                        END WF_NAME,
                        1 ISCXQ
                   FROM DEBT_T_ZQGL_ZQXM ZQXM
                   LEFT JOIN DEBT_T_ZQGL_ZQXX ZQXX
                     ON ZQXM.ZQ_ID = ZQXX.ZQ_ID
                   LEFT JOIN (SELECT ZQ_ID, XM_ID --资金下达
                               FROM DEBT_T_ZQGL_ZCXX
                              WHERE IS_END = '1'
                                AND XM_ID = VXMID
                              GROUP BY ZQ_ID, XM_ID) ZCXX
                     ON ZQXM.XM_ID = ZCXX.XM_ID
                    AND ZQXX.ZQ_ID = ZCXX.ZQ_ID
                   LEFT JOIN (SELECT ZQ_ID, XM_ID --建设中
                               FROM DEBT_T_ZQGL_ZCXX_SJZC
                              WHERE IS_END = '1'
                                AND XM_ID = VXMID
                              GROUP BY ZQ_ID, XM_ID) SJZC
                     ON ZQXM.XM_ID = SJZC.XM_ID
                    AND ZQXX.ZQ_ID = SJZC.ZQ_ID
                   LEFT JOIN (SELECT XM_ID --已完工
                               FROM DEBT_T_ZQGL_XM_JSJD
                              WHERE SCJD = '03'
                                AND IS_END = '1'
                                AND XM_ID = VXMID
                              GROUP BY XM_ID) JSJD
                     ON ZQXM.XM_ID = JSJD.XM_ID
                   LEFT JOIN (SELECT ZQXM.XM_ID, SUM(SY_AMT) SY_AMT --结束
                               FROM DEBT_T_ZQGL_ZQXM ZQXM
                               LEFT JOIN DEBT_V_ZQGL_DFJH_ZQXX ZQXX
                                 ON ZQXM.ZQ_ID = ZQXX.ZQ_ID
                              WHERE PLAN_TYPE = '0'
                                AND SY_AMT > 0
                                AND ZQXM.XM_ID = VXMID
                              GROUP BY ZQXM.XM_ID) CH
                     ON ZQXM.XM_ID = CH.XM_ID
                  WHERE ZQXX.FX_START_DATE =
                        (SELECT MAX(ZQXX2.FX_START_DATE) FX_START_DATE
                           FROM DEBT_T_ZQGL_ZQXM ZQXM2
                           LEFT JOIN DEBT_T_ZQGL_ZQXX ZQXX2
                             ON ZQXM2.ZQ_ID = ZQXX2.ZQ_ID
                          WHERE ZQXM.XM_ID = ZQXM2.XM_ID
                            AND ZQXX2.IS_COMPLETE = '1'
                            AND SUBSTR(ZQXX2.FX_START_DATE, 1, 4) >= '2020'
                            AND ZQXM2.XM_ID = VXMID)
                    AND ZQXX.IS_COMPLETE = '1'
                    AND SUBSTR(ZQXX.FX_START_DATE, 1, 4) >= '2020'
                    AND ZQXM.XM_ID = VXMID
                 UNION ALL
                 SELECT ZCXX.XM_ID,
                        CASE
                          WHEN NVL(CH.SY_AMT, 1) = 0 THEN
                           '结束'
                          WHEN JSJD.XM_ID IS NOT NULL THEN
                           '已完工'
                          WHEN SJZC.XM_ID IS NOT NULL THEN
                           '建设中'
                          ELSE
                           '资金下达'
                        END WF_NAME,
                        1 ISCXQ
                   FROM (SELECT ZQ_ID, XM_ID --资金下达
                           FROM DEBT_T_ZQGL_ZCXX
                          WHERE IS_END = '1'
                            AND XM_ID = VXMID
                          GROUP BY ZQ_ID, XM_ID) ZCXX
                   LEFT JOIN DEBT_T_ZQGL_ZQXX ZQXX
                     ON ZCXX.ZQ_ID = ZQXX.ZQ_ID
                   LEFT JOIN (SELECT ZQ_ID, XM_ID --建设中
                               FROM DEBT_T_ZQGL_ZCXX_SJZC
                              WHERE IS_END = '1'
                                AND XM_ID = VXMID
                              GROUP BY ZQ_ID, XM_ID) SJZC
                     ON ZCXX.XM_ID = SJZC.XM_ID
                    AND ZQXX.ZQ_ID = SJZC.ZQ_ID
                   LEFT JOIN (SELECT XM_ID --已完工
                               FROM DEBT_T_ZQGL_XM_JSJD
                              WHERE SCJD = '03'
                                AND IS_END = '1'
                                AND XM_ID = VXMID
                              GROUP BY XM_ID) JSJD
                     ON ZCXX.XM_ID = JSJD.XM_ID
                   LEFT JOIN (SELECT ZCXX.XM_ID, SUM(SY_AMT) SY_AMT --结束
                               FROM DEBT_T_ZQGL_ZCXX ZCXX
                               LEFT JOIN DEBT_V_ZQGL_DFJH_ZQXX ZQXX
                                 ON ZCXX.ZQ_ID = ZQXX.ZQ_ID
                              WHERE PLAN_TYPE = '0'
                                AND SY_AMT > 0
                                AND ZCXX.XM_ID = VXMID
                              GROUP BY ZCXX.XM_ID) CH
                     ON ZCXX.XM_ID = CH.XM_ID
                  WHERE ZQXX.FX_START_DATE =
                        (SELECT MAX(ZQXX2.FX_START_DATE) FX_START_DATE
                           FROM (SELECT ZQ_ID, XM_ID
                                   FROM DEBT_T_ZQGL_ZCXX
                                  WHERE IS_END = '1'
                                    AND XM_ID = VXMID
                                  GROUP BY ZQ_ID, XM_ID) ZCXX2
                           LEFT JOIN DEBT_T_ZQGL_ZQXX ZQXX2
                             ON ZCXX2.ZQ_ID = ZQXX2.ZQ_ID
                          WHERE ZCXX.XM_ID = ZCXX2.XM_ID
                            AND ZQXX2.IS_COMPLETE = '1'
                            AND SUBSTR(ZQXX2.FX_START_DATE, 1, 4) < '2020'
                            AND ZCXX2.XM_ID = VXMID)
                    AND ZQXX.IS_COMPLETE = '1'
                    AND SUBSTR(ZQXX.FX_START_DATE, 1, 4) < '2020'
                    AND ZCXX.XM_ID = VXMID) WF
        ON INFO.XM_ID = WF.XM_ID 
 WHERE INFO.IS_END = 1
   AND INFO.XM_ID = VXMID;
END DEBT_P_ZTQK_CALBYXMID;
/
-- 20210104 单条跑批存储过程修改
create or replace procedure DEBT_P_DC_CALBYID(vzw_id varchar2,vch_date varchar2,vop_code varchar2,vad_code varchar2,vuser_name varchar2)
is
/*
--cgq 2017-02-23 优化债券计算
cgq 业务处理驱动数据准备引擎 2016-10-15，
           业务驱动，在债券和债务相关单据终审环节进行调用，支持债务按zw_id，债券按ZQ_ID和AD_CODE驱动,
      通过业务发生时间、业务类别精准定位要计算的数据。
      --vzw_id 债务ID或债券ID   必需传入
      --vch_date  业务发生日期，允许为空，计算所有期间。
      --vop_code 业务类别，允许为空，这种情况债券和债务都进行计算。
      --vad_code 区划,债券计算时需要，允许为空。
      --vuser_name 用户名称
      在业务终审或取消终审时，调用该存储过程。两种典型场景：
              1、债务传入  zw_id有值，vop_code必须‘0’开头，vad_code不用
              2、债券传入  zw_id有值为债券ID，vop_code必须‘1’开头,vad_code为债券业务所在区划
              3、业务传入   vop_code必须'2'开头，201 项目(xm_id)、202单位(ag_id);lixy 2016-12-23
 */
TYPE type_pelist IS TABLE OF DEBT_T_PERIOD%rowtype index by binary_integer;
 pelist type_pelist;
     i number;
     npeid varchar2(100);
     nsdate varchar2(20);
     nedate varchar2(20);
     P_AD_CODE varchar2(50);
     P_I number;
begin
--债务ID必需传入，否则不处理。
 if vzw_id is null then
      return;
 end if ;
 if substr(nvl(vop_code,'2'),1,1)='2' then  --cgq 2018-01-13 原则上项目变更及单位变更只影响新业务，老业务不变，确实需要刷新，需要批量跑
              if vop_code= '211' then --yf 2020-12-24 项目总体情况计算
                 DEBT_P_ZTQK_CALBYXMID(vzw_id,vuser_name);
                 return;
              else
                 return;
              end if;
     elsif  vop_code= '105'  then  --cgq 2018-01-13 转贷还款不参与计算
            return;
     elsif  vop_code= '104'  then  --cgq 2018-01-13 为避免影响性能，利息和费用驱动时不计算，仅在分期间跑时支持。
             SELECT count(1) INTO P_I FROM DEBT_V_ZQGLTOZW_CHBJ_V2 where zq_id=vzw_id;
              if P_I = 0 then
                 return;
              end if;
     end if;
     P_AD_CODE := vad_code;
--取得该业务日期后面未锁定的所有期间。
 select * bulk collect
   INTO pelist
   from DEBT_T_PERIOD t
  where t.is_tj = 1
       --该日期前的期间不参与计算
    and t.end_date >= nvl(vch_date, t.end_date)
       --锁定期不能计算
    and t.end_date >
        (select max(end_date) from DEBT_T_PERIOD where is_updata = 1)
  ORDER BY set_year, pe_type desc, PE_ID;
--债务业务的债券准备表，为提高计算效率。
 if substr(nvl(vop_code,'1'),1,1)='1' then
   --cgq 2017-02-22 采用新的本级计算方法,简化债券的转化,支持4为编码作为低级
    update dsy_t_ele_ad set BJ_CODE= decode(isleaf,1,code,code || '00')
        where  nvL(BJ_CODE,' ')<>decode(isleaf,1,code,code || '00');
        --cgq 2018-01-13省级还本付息操作时，不转化为区划，实现债券本金及利息余额只依赖于省级财政的还款需求,
        if vop_code <> '104' then
           SELECT BJ_CODE INTO P_AD_CODE FROM dsy_v_ele_ad where code=nvl(vad_code,(select D_VALUE from dsy_t_sys_param  where D_code='ELE_AD_CODE'));
        end if;
       Delete  from DEBT_T_ZQGL_TOZD Where ZQ_ID=vzw_id and  ad_code = P_AD_CODE   ;
       insert into DEBT_T_ZQGL_TOZD (ZW_ID,ZQ_ID,AD_CODE,ZD_DETAIL_ID,FETCH_DATE,FETCH_AMT
                                    ,xz_amt,zh_amt,hb_amt,sum_zd_amt,sum_xz_amt,sum_zh_amt,sum_hb_amt,AD_CODE_zq
                                    ,In_Amt,In_Xz_Amt,in_zh_amt,in_hb_amt,Inzd_Amt,Inzd_Xz_Amt,Inzd_Zh_Amt,Inzd_hb_amt,Hkjh_Date,Ag_Id
                                    ,u_Ad_Code,DFSXF_RATE,ZNJ_RATE,TQHK_DAYS)
    SELECT ZW_ID,ZQ_ID,AD_CODE,ZD_DETAIL_ID,FETCH_DATE,FETCH_AMT
                                    ,xz_amt,zh_amt,hb_amt,sum_zd_amt,sum_xz_amt,sum_zh_amt,sum_hb_amt,AD_CODE_zq
                                    ,In_Amt,In_Xz_Amt,in_zh_amt,in_hb_amt,Inzd_Amt,Inzd_Xz_Amt,Inzd_Zh_Amt,Inzd_hb_amt,Hkjh_Date,Ag_Id,u_Ad_Code,DFSXF_RATE,ZNJ_RATE,TQHK_DAYS
                                    from debt_v_zqgltozw_jjxx
                                    where ZQ_ID=vzw_id and  ad_code = P_AD_CODE
                                    ;
 end if ;
 --循环计算每个期间的数据，生成ODS层的数据。
 for i in 1..pelist.count loop
     npeid:= pelist(i).pe_id;
     nsdate:= pelist(i).START_DATE;
     nedate:= pelist(i).END_DATE;
     --债务业务，分别准备余额、利息和偿还
     if substr(nvl(vop_code,'0'),1,1)='0' then
         DEBT_P_DC_CAL_ZWYE(npeid,nsdate,nedate,P_AD_CODE,vzw_id,vuser_name);  --债务余额
         DEBT_P_DC_CAL_ZWLX(npeid,nsdate,nedate,P_AD_CODE,vzw_id,vuser_name);  --债务利息
         DEBT_P_DC_CAL_ZWCH(npeid,nsdate,nedate,P_AD_CODE,vzw_id,vuser_name);  --债务偿还
         --lixy 2017-03-20 当期偿还
         DEBT_P_DC_CAL_ZWJJ(npeid,nsdate,nedate,P_AD_CODE,vzw_id,vuser_name);  --债务举借
      end if ;
     --债券业务，分别计算余额和支出
      if substr(nvl(vop_code,'1'),1,1)='1'  then
         DEBT_P_DC_CAL_ZQYE_V2(npeid,nsdate,nedate,P_AD_CODE,vzw_id,vuser_name);  --债券余额
      end if;
      --guodg 2019-11-27 债券偿还计算
      IF nvl(vop_code,'1')='104' THEN
         DEBT_P_ZWTJ_ZQCH_V2(npeid,nsdate,nedate,P_AD_CODE,vzw_id,vuser_name);
      END IF;
      --2018-01-11 弃用中间过程表,改进项目计算
 end loop;
       --生成事实表(FACT)的数据，批量计算
       debt_p_dc_fact_calzqzwye_V2(null,p_ad_code,vzw_id,vch_date,vop_code,vuser_name);  --余额立方体
       --lixy 2017-03-22 当月举借、当年举借
      if substr(nvl(vop_code,'1'),1,1)<>'2'  then  --cgq 2018-01-11 不计算余额外业务
          DEBT_P_DC_FACT_CALZWJJ(null,p_ad_code,vzw_id,vch_date,vop_code,vuser_name);  --举借立方体
          debt_p_dc_fact_calzqzwch(null,p_ad_code,vzw_id,vch_date,vop_code,vuser_name);  --利息立方体、偿还立方体
        end if;
        --生成聚合层(AGGR)的数据，批量计算
      DEBT_P_DC_AGGR_CALYE(null,p_ad_code,vzw_id,vch_date,vop_code,vuser_name);--聚合表运算
   --风险预警聚合表计算，效率原因，暂不刷新
   --    DEBT_P_DC_AGGR_RISKALERT();
   --债务总体情况表数据重新计算
    if substr(nvl(vop_code,'0'),1,1)='0' then
       DEBT_P_ZTQK_CALBYZWID(vzw_id, vuser_name);
    end if;
      commit;
EXCEPTION
  when too_many_rows then
   rollback;
   dbms_output.put_line('执行错误');
end DEBT_P_DC_CALBYID;
/
-- 20210106 wq  单位首页授权
delete from dsy_t_sys_role_login;
insert into dsy_t_sys_role_login (GUID, ROLE_GUID, LOGIN_URL)
values ('2100999001', 'debt_dw_222', '/page/frame/role_dw_index.jsp');