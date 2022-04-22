--2020102217_LIYUE_限额视图修改
CREATE OR REPLACE VIEW DEBT_V_ZQGL_ZQXE_CZB AS
SELECT
       XE_ID,
       AD_CODE,
       AD_NAME,
       SET_YEAR,
       BATCH_NO,
       XEPC.NAME    AS BATCH_NAME,
       XZ_YBZQ_AMT,
       XZ_ZXZQ_AMT,
       XZ_WZ_AMT,
       ZRZ_ZXZQ_AMT,
       ZRZ_QTZQ_AMT,
       ZRZ_HYZW_AMT,
       YBZQ_AMT,
       ZXZQ_AMT,
       TZ_REASON,
       XZ_YBZQ_AMT-XZ_YBZQ_TZQ_AMT XZ_YBZQ_AMT_TZ,
       XZ_ZXZQ_AMT-XZ_ZXZQ_TZQ_AMT XZ_ZXZQ_AMT_TZ,
       XZ_WZ_AMT-XZ_WZ_TZQ_AMT XZ_WZ_AMT_TZ,
       ZRZ_ZXZQ_AMT-ZRZ_ZXZQ_TZQ_AMT ZRZ_ZXZQ_AMT_TZ,
       ZRZ_QTZQ_AMT-ZRZ_QTZQ_TZQ_AMT ZRZ_QTZQ_AMT_TZ,
       ZRZ_HYZW_AMT-ZRZ_HYZW_TZQ_AMT ZRZ_HYZW_AMT_TZ,
       YBZQ_AMT-YBZQ_TZQ_AMT YBZQ_AMT_TZ,
       ZXZQ_AMT-ZXZQ_TZQ_AMT ZXZQ_AMT_TZ,
       ZBWJ_NO,
       ZBWJ_NAME,
       XQ_BATCH_NO,
       FXPC.NAME    AS XQ_BATCH_NAME
  FROM (select REGEXP_SUBSTR(czb.XQ_BATCH_NO, '[^,]+', 1, L) AS XQ_BATCH_NO,
               XE_ID,
               AD_CODE,
               AD_NAME,
               SET_YEAR,
               BATCH_NO,
               NVL(XZ_YBZQ_AMT, 0) / 10000 AS XZ_YBZQ_AMT,
               NVL(XZ_ZXZQ_AMT, 0) / 10000 AS XZ_ZXZQ_AMT,
               NVL(XZ_WZ_AMT, 0) / 10000 AS XZ_WZ_AMT,
               NVL(ZRZ_ZXZQ_AMT, 0) / 10000 AS ZRZ_ZXZQ_AMT,
               NVL(ZRZ_QTZQ_AMT, 0) / 10000 AS ZRZ_QTZQ_AMT,
               NVL(ZRZ_HYZW_AMT, 0) / 10000 AS ZRZ_HYZW_AMT,
               NVL(YBZQ_AMT, 0) / 10000 AS YBZQ_AMT,
               NVL(ZXZQ_AMT, 0) / 10000 AS ZXZQ_AMT,
               TZ_REASON,
               NVL(XZ_YBZQ_TZQ_AMT, 0) / 10000 AS XZ_YBZQ_TZQ_AMT,
               NVL(XZ_ZXZQ_TZQ_AMT, 0) / 10000 AS XZ_ZXZQ_TZQ_AMT,
               NVL(XZ_WZ_TZQ_AMT, 0) / 10000 AS XZ_WZ_TZQ_AMT,
               NVL(ZRZ_ZXZQ_TZQ_AMT, 0) / 10000 AS ZRZ_ZXZQ_TZQ_AMT,
               NVL(ZRZ_QTZQ_TZQ_AMT, 0) / 10000 AS ZRZ_QTZQ_TZQ_AMT,
               NVL(ZRZ_HYZW_TZQ_AMT, 0) / 10000 AS ZRZ_HYZW_TZQ_AMT,
               NVL(YBZQ_TZQ_AMT, 0) / 10000 AS YBZQ_TZQ_AMT,
               NVL(ZXZQ_TZQ_AMT, 0) / 10000 AS ZXZQ_TZQ_AMT,
               ZBWJ_NO,
               ZBWJ_NAME
          from DEBT_T_BDJH_ZQXE_CZB czb,
               (SELECT LEVEL L FROM DUAL CONNECT BY LEVEL <= 1000)
         WHERE L(+) <=
               LENGTH(XQ_BATCH_NO) - LENGTH(REPLACE(XQ_BATCH_NO, ',')) + 1) ZQXE
  LEFT JOIN DSY_V_ELE_FXPC FXPC
    ON ZQXE.XQ_BATCH_NO = FXPC.GUID
  LEFT JOIN DSY_V_ELE_XEPC XEPC
    ON ZQXE.BATCH_NO = XEPC.GUID;
--2020102214_LIYUE_限额审核岗工作流节点修改
UPDATE  dsy_t_wf_node_role SET ROLE_ID='debt_sheng_001' WHERE NODE_ID='1002552'
--2020102214添加再融资或有债
CREATE OR REPLACE VIEW DEBT_V_ZQGL_XEGL_XZZQ_ALL AS
select decode(zsxe.ad_code,null,tqxd.ad_code,zsxe.ad_code) ad_code,
       decode(zsxe.ad_code,null,tqxd.AD_NAME,zsxe.AD_NAME) AD_NAME,
       decode(zsxe.ad_code,null,tqxd.SET_YEAR,zsxe.SET_YEAR) SET_YEAR,
       decode(zsxe.ad_code,null,nvl(tqxd.YBZQ_AMT,0),nvl(zsxe.YBZQ_AMT,0)) YBZQ_AMT,
       decode(zsxe.ad_code,null,nvl(tqxd.ZXZQ_AMT,0),nvl(zsxe.ZXZQ_AMT,0)) ZXZQ_AMT,
       decode(zsxe.ad_code,null,nvl(tqxd.ZHZQ_AMT,0),nvl(zsxe.ZHZQ_AMT,0)) ZHZQ_AMT,
       decode(zsxe.ad_code,null,nvl(tqxd.XZ_YBZQ_AMT,0),nvl(zsxe.XZ_YBZQ_AMT,0)) XZ_YBZQ_AMT,
       decode(zsxe.ad_code,null,nvl(tqxd.XZ_ZXZQ_AMT,0),nvl(zsxe.XZ_ZXZQ_AMT,0)) XZ_ZXZQ_AMT,
       decode(zsxe.ad_code,null,nvl(tqxd.XZ_TCZX_AMT,0),nvl(zsxe.XZ_TCZX_AMT,0)) XZ_TCZX_AMT,
       decode(zsxe.ad_code,null,nvl(tqxd.XZ_GLZX_AMT,0),nvl(zsxe.XZ_GLZX_AMT,0)) XZ_GLZX_AMT,
       decode(zsxe.ad_code,null,nvl(tqxd.XZ_PGZX_AMT,0),nvl(zsxe.XZ_PGZX_AMT,0)) XZ_PGZX_AMT,
       decode(zsxe.ad_code,null,nvl(tqxd.XZ_QTZX_AMT,0),nvl(zsxe.XZ_QTZX_AMT,0)) XZ_QTZX_AMT,
       -----20200924 fzd 增加中小银行额度
       decode(zsxe.ad_code,null,nvl(tqxd.XZ_ZXYH_AMT,0),nvl(zsxe.XZ_ZXYH_AMT,0)) XZ_ZXYH_AMT,
      decode(zsxe.ad_code,null,nvl(tqxd.YB_YSY_FH,0),nvl(zsxe.YB_YSY_FH,0)) YB_YSY_FH,--新增债券一般已使用额度
       decode(zsxe.ad_code,null,nvl(tqxd.ZX_YSY_FH,0),nvl(zsxe.ZX_YSY_FH,0)) ZX_YSY_FH, --新增债券专项已使用额度
       decode(zsxe.ad_code,null,nvl(tqxd.ZX_TC_YSY_FH,0),nvl(zsxe.ZX_TC_YSY_FH,0)) ZX_TC_YSY_FH, --新增债券土储专项已使用额度
       decode(zsxe.ad_code,null,nvl(tqxd.ZX_GL_YSY_FH,0),nvl(zsxe.ZX_GL_YSY_FH,0)) ZX_GL_YSY_FH, --新增债券公路专项已使用额度
       decode(zsxe.ad_code,null,nvl(tqxd.ZX_PG_YSY_FH,0),nvl(zsxe.ZX_PG_YSY_FH,0)) ZX_PG_YSY_FH, --新增债券棚改专项已使用额度
       decode(zsxe.ad_code,null,nvl(tqxd.ZX_QT_YSY_FH,0),nvl(zsxe.ZX_QT_YSY_FH,0)) ZX_QT_YSY_FH, --新增债券其他专项已使用额度
       decode(zsxe.ad_code,null,nvl(tqxd.ZX_ZXYH_YSY_FH,0),nvl(zsxe.ZX_ZXYH_YSY_FH,0)) ZX_ZXYH_YSY_FH, --新增债券中小银行专项已使用额度
       decode(zsxe.ad_code,null,nvl(tqxd.YB_SY_AMT,0),nvl(zsxe.YB_SY_AMT,0)) YB_SY_AMT,--新增债券一般未审核已使用额度
       decode(zsxe.ad_code,null,nvl(tqxd.ZX_SY_AMT,0),nvl(zsxe.ZX_SY_AMT,0)) ZX_SY_AMT, --新增债券专项未审核已使用额度
       decode(zsxe.ad_code,null,nvl(tqxd.ZX_TC_SY_AMT,0),nvl(zsxe.ZX_TC_SY_AMT,0)) ZX_TC_SY_AMT, --新增债券土储专项未审核已使用额度
       decode(zsxe.ad_code,null,nvl(tqxd.ZX_GL_SY_AMT,0),nvl(zsxe.ZX_GL_SY_AMT,0)) ZX_GL_SY_AMT, --新增债券公路专项未审核已使用额度
       decode(zsxe.ad_code,null,nvl(tqxd.ZX_PG_SY_AMT,0),nvl(zsxe.ZX_PG_SY_AMT,0)) ZX_PG_SY_AMT, --新增债券棚改专项未审核已使用额度
       decode(zsxe.ad_code,null,nvl(tqxd.ZX_QT_SY_AMT,0),nvl(zsxe.ZX_QT_SY_AMT,0)) ZX_QT_SY_AMT, --新增债券其他专项未审核已使用额度
       decode(zsxe.ad_code,null,nvl(tqxd.ZX_ZXYH_SY_AMT,0),nvl(zsxe.ZX_ZXYH_SY_AMT,0)) ZX_ZXYH_SY_AMT, --新增债券中小银行专项未审核已使用额度
       decode(zsxe.ad_code,null,nvl(tqxd.YB_WSS_SY_AMT,0),nvl(zsxe.YB_WSS_SY_AMT,0)) YB_WSS_SY_AMT, -- 新增债券一般未送审已使用额度
       decode(zsxe.ad_code,null,nvl(tqxd.ZX_WSS_SY_AMT,0),nvl(zsxe.ZX_WSS_SY_AMT,0)) ZX_WSS_SY_AMT, -- 新增债券专项未送审已使用额度
       decode(zsxe.ad_code,null,nvl(tqxd.ZX_TC_WSS_SY_AMT,0),nvl(zsxe.ZX_TC_WSS_SY_AMT,0)) ZX_TC_WSS_SY_AMT, -- 新增债券土储专项未送审已使用额度
       decode(zsxe.ad_code,null,nvl(tqxd.ZX_GL_WSS_SY_AMT,0),nvl(zsxe.ZX_GL_WSS_SY_AMT,0)) ZX_GL_WSS_SY_AMT, -- 新增债券公路专项未送审已使用额度
       decode(zsxe.ad_code,null,nvl(tqxd.ZX_PG_WSS_SY_AMT,0),nvl(zsxe.ZX_PG_WSS_SY_AMT,0)) ZX_PG_WSS_SY_AMT, -- 新增债券棚改专项未送审已使用额度
       decode(zsxe.ad_code,null,nvl(tqxd.ZX_QT_WSS_SY_AMT,0),nvl(zsxe.ZX_QT_WSS_SY_AMT,0)) ZX_QT_WSS_SY_AMT, -- 新增债券其他专项未送审已使用额度
       decode(zsxe.ad_code,null,nvl(tqxd.ZX_ZXYH_WSS_SY_AMT,0),nvl(zsxe.ZX_ZXYH_WSS_SY_AMT,0)) ZX_ZXYH_WSS_SY_AMT, -- 新增债券中小银行专项未送审已使用额度
       decode(zsxe.ad_code,null,nvl(tqxd.YB_WES_SY_AMT,0),nvl(zsxe.YB_WES_SY_AMT,0)) YB_WES_SY_AMT, -- 新增债券一般未二审已使用额度
       decode(zsxe.ad_code,null,nvl(tqxd.ZX_WES_SY_AMT,0),nvl(zsxe.ZX_WES_SY_AMT,0)) ZX_WES_SY_AMT, -- 新增债券专项未二审已使用额度
       decode(zsxe.ad_code,null,nvl(tqxd.ZX_TC_WES_SY_AMT,0),nvl(zsxe.ZX_TC_WES_SY_AMT,0)) ZX_TC_WES_SY_AMT, -- 新增债券土储专项未二审已使用额度
       decode(zsxe.ad_code,null,nvl(tqxd.ZX_GL_WES_SY_AMT,0),nvl(zsxe.ZX_GL_WES_SY_AMT,0)) ZX_GL_WES_SY_AMT, -- 新增债券公路专项未二审已使用额度
       decode(zsxe.ad_code,null,nvl(tqxd.ZX_PG_WES_SY_AMT,0),nvl(zsxe.ZX_PG_WES_SY_AMT,0)) ZX_PG_WES_SY_AMT, -- 新增债券棚改专项未二审已使用额度
       decode(zsxe.ad_code,null,nvl(tqxd.ZX_QT_WES_SY_AMT,0),nvl(zsxe.ZX_QT_WES_SY_AMT,0)) ZX_QT_WES_SY_AMT, -- 新增债券其他专项未二审已使用额度
       decode(zsxe.ad_code,null,nvl(tqxd.YB_SY_FH,0),nvl(zsxe.YB_SY_FH,0)) YB_SY_FH, --新增债券一般未使用额度
       decode(zsxe.ad_code,null,nvl(tqxd.ZX_SY_FH,0),nvl(zsxe.ZX_SY_FH,0)) ZX_SY_FH,  --新增债券专项未使用额度
       decode(zsxe.ad_code,null,nvl(tqxd.ZX_TC_SY_FH,0),nvl(zsxe.ZX_TC_SY_FH,0)) ZX_TC_SY_FH,  --新增债券土储专项未使用额度
       decode(zsxe.ad_code,null,nvl(tqxd.ZX_GL_SY_FH,0),nvl(zsxe.ZX_GL_SY_FH,0)) ZX_GL_SY_FH,  --新增债券公路专项未使用额度
       decode(zsxe.ad_code,null,nvl(tqxd.ZX_PG_SY_FH,0),nvl(zsxe.ZX_PG_SY_FH,0)) ZX_PG_SY_FH,  --新增债券棚改专项未使用额度
       decode(zsxe.ad_code,null,nvl(tqxd.ZX_QT_SY_FH,0),nvl(zsxe.ZX_QT_SY_FH,0)) ZX_QT_SY_FH,  --新增债券其他专项未使用额度
       decode(zsxe.ad_code,null,nvl(tqxd.ZX_ZXYH_SY_FH,0),nvl(zsxe.ZX_ZXYH_SY_FH,0)) ZX_ZXYH_SY_FH,  --新增债券中小银行专项未使用额度
       decode(zsxe.ad_code,null,nvl(tqxd.YB_WSH_AMT,0),nvl(zsxe.YB_WSH_AMT,0)) YB_WSH_AMT, --新增债券一般未审核未使用额度
       decode(zsxe.ad_code,null,nvl(tqxd.ZX_WSH_AMT,0),nvl(zsxe.ZX_WSH_AMT,0)) ZX_WSH_AMT, --新增债券专项未审核未使用额度
       decode(zsxe.ad_code,null,nvl(tqxd.ZX_TC_WSH_AMT,0),nvl(zsxe.ZX_TC_WSH_AMT,0)) ZX_TC_WSH_AMT, --新增债券土储专项未审核未使用额度
       decode(zsxe.ad_code,null,nvl(tqxd.ZX_GL_WSH_AMT,0),nvl(zsxe.ZX_GL_WSH_AMT,0)) ZX_GL_WSH_AMT, --新增债券公路专项未审核未使用额度
       decode(zsxe.ad_code,null,nvl(tqxd.ZX_PG_WSH_AMT,0),nvl(zsxe.ZX_PG_WSH_AMT,0)) ZX_PG_WSH_AMT, --新增债券棚改专项未审核未使用额度
       decode(zsxe.ad_code,null,nvl(tqxd.ZX_QT_WSH_AMT,0),nvl(zsxe.ZX_QT_WSH_AMT,0)) ZX_QT_WSH_AMT, --新增债券其他专项未审核未使用额度
       decode(zsxe.ad_code,null,nvl(tqxd.ZX_ZXYH_WSH_AMT,0),nvl(zsxe.ZX_ZXYH_WSH_AMT,0)) ZX_ZXYH_WSH_AMT, --新增债券中小银行专项未审核未使用额度
       decode(zsxe.ad_code,null,nvl(tqxd.YB_WSS_AMT,0),nvl(zsxe.YB_WSS_AMT,0)) YB_WSS_AMT, -- 新增债券一般未送审未使用额度
       decode(zsxe.ad_code,null,nvl(tqxd.ZX_WSS_AMT,0),nvl(zsxe.ZX_WSS_AMT,0)) ZX_WSS_AMT, -- 新增债券专项未送审未使用额度
       decode(zsxe.ad_code,null,nvl(tqxd.ZX_TC_WSS_AMT,0),nvl(zsxe.ZX_TC_WSS_AMT,0)) ZX_TC_WSS_AMT, -- 新增债券土储专项未送审未使用额度
       decode(zsxe.ad_code,null,nvl(tqxd.ZX_GL_WSS_AMT,0),nvl(zsxe.ZX_GL_WSS_AMT,0)) ZX_GL_WSS_AMT, -- 新增债券公路专项未送审未使用额度
       decode(zsxe.ad_code,null,nvl(tqxd.ZX_PG_WSS_AMT,0),nvl(zsxe.ZX_PG_WSS_AMT,0)) ZX_PG_WSS_AMT, -- 新增债券棚改专项未送审未使用额度
       decode(zsxe.ad_code,null,nvl(tqxd.ZX_QT_WSS_AMT,0),nvl(zsxe.ZX_QT_WSS_AMT,0)) ZX_QT_WSS_AMT, -- 新增债券其他专项未送审未使用额度
       decode(zsxe.ad_code,null,nvl(tqxd.ZX_ZXYH_WSS_AMT,0),nvl(zsxe.ZX_ZXYH_WSS_AMT,0)) ZX_ZXYH_WSS_AMT, -- 新增债券中小银行专项未送审未使用额度
       decode(zsxe.ad_code,null,nvl(tqxd.YB_WES_AMT,0),nvl(zsxe.YB_WES_AMT,0)) YB_WES_AMT, -- 新增债券一般未二审未使用额度
       decode(zsxe.ad_code,null,nvl(tqxd.ZX_WES_AMT,0),nvl(zsxe.ZX_WES_AMT,0)) ZX_WES_AMT, -- 新增债券专项未二审未使用额度
       decode(zsxe.ad_code,null,nvl(tqxd.ZX_TC_WES_AMT,0),nvl(zsxe.ZX_TC_WES_AMT,0)) ZX_TC_WES_AMT, -- 新增债券土储专项未二审未使用额度
       decode(zsxe.ad_code,null,nvl(tqxd.ZX_GL_WES_AMT,0),nvl(zsxe.ZX_GL_WES_AMT,0)) ZX_GL_WES_AMT, -- 新增债券公路专项未二审未使用额度
       decode(zsxe.ad_code,null,nvl(tqxd.ZX_PG_WES_AMT,0),nvl(zsxe.ZX_PG_WES_AMT,0)) ZX_PG_WES_AMT, -- 新增债券棚改专项未二审未使用额度
       decode(zsxe.ad_code,null,nvl(tqxd.ZX_QT_WES_AMT,0),nvl(zsxe.ZX_QT_WES_AMT,0)) ZX_QT_WES_AMT, -- 新增债券其他专项未二审未使用额度
       decode(zsxe.ad_code,null,nvl(tqxd.YB_SY_AMT,0),nvl(zsxe.YB_SY_AMT,0)) YSY_XZ_YBZQ_AMT,
       decode(zsxe.ad_code,null,nvl(tqxd.ZX_SY_AMT,0),nvl(zsxe.ZX_SY_AMT,0)) YSY_XZ_ZXZQ_AMT,
       decode(zsxe.ad_code,null,nvl(tqxd.ZX_TC_SY_AMT,0),nvl(zsxe.ZX_TC_SY_AMT,0)) YSY_XZ_ZXZQ_TC_AMT,
       decode(zsxe.ad_code,null,nvl(tqxd.ZX_GL_SY_AMT,0),nvl(zsxe.ZX_GL_SY_AMT,0)) YSY_XZ_ZXZQ_GL_AMT,
       decode(zsxe.ad_code,null,nvl(tqxd.ZX_PG_SY_AMT,0),nvl(zsxe.ZX_PG_SY_AMT,0)) YSY_XZ_ZXZQ_PG_AMT,
       decode(zsxe.ad_code,null,nvl(tqxd.ZX_QT_SY_AMT,0),nvl(zsxe.ZX_QT_SY_AMT,0)) YSY_XZ_ZXZQ_QT_AMT,
       decode(zsxe.ad_code,null,nvl(tqxd.ZX_ZXYH_SY_AMT,0),nvl(zsxe.ZX_ZXYH_SY_AMT,0)) YSY_XZ_ZXZQ_ZXYH_AMT,
       NVL(T.JJ_AMT,0) YSY_XZ_WZ_AMT, -- 新增外债已使用限额
       0 AS YSY_ZRZ_ZXZQ_AMT, --再融资专项债券已使用限额
       0 AS YSY_ZRZ_QTZQ_AMT,  --再融资其他债券已使用限额
       0 AS YSY_ZRZ_HYZW_AMT  --再融资或有债券已使用限额
from DEBT_V_ZQGL_XEGL_XZZQ_TQXD tqxd
full join DEBT_V_ZQGL_XEGL_XZZQ zsxe on zsxe.ad_code=tqxd.ad_code and zsxe.set_year=tqxd.set_year
LEFT JOIN (
     SELECT JJ.AD_CODE, JJ.SET_YEAR, SUM(JJ.FETCH_AMT_RMB) AS JJ_AMT
     FROM (
          SELECT JJXX.AD_CODE, SUBSTR(JJXX.FETCH_DATE, 1, 4) AS SET_YEAR, JJXX.FETCH_AMT_RMB
          FROM DEBT_T_ZWGL_JJXX JJXX
          INNER JOIN DEBT_T_ZWGL_ZWXX ZWXX ON JJXX.ZW_ID = ZWXX.ZW_ID
          WHERE ZWXX.IS_WZ = 1 AND ZWXX.ZWLB_ID LIKE '01%'
     ) JJ
     GROUP BY JJ.AD_CODE, JJ.SET_YEAR
) T ON DECODE(zsxe.ad_code,NULL,tqxd.ad_code,zsxe.ad_code) = T.AD_CODE AND DECODE(zsxe.ad_code,NULL,tqxd.SET_YEAR,zsxe.SET_YEAR) = T.SET_YEAR
order by ad_code,set_year;
2020102215_LIYUE_各表限额类型字段备注
comment on column fasp_T_pubdebt_xepc.EXTEND1 is '(01 新增 03再融资 04总限额)';
comment on column fasp_T_pubdebt_fxpc.EXTEND1 is '(01 新增 03再融资 04总限额)';
comment on column debt_t_bdjh_zqxe_czb.zqxe_type is '(01 新增 03再融资 04总限额)';
comment on column debt_t_zqgl_zqxe.zqxe_type is '(01 新增 03再融资 04总限额)';
