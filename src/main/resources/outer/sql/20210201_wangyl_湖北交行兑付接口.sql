--20210119_wangyl_主页查询视图分组修改
CREATE OR REPLACE VIEW DEBT_V_ZQGL_ZQZJDFXX_MAIN AS
SELECT
    T.HKD_ID,
    T.HK_DATE,
    T.IS_CONFIRM,
    T.CREATE_USER,
    T.IS_END,
    T.WF_ID,
    T.NODE_CURRENT_ID,
    T.NODE_NEXT_ID,
    T.WF_STATUS,
    T.REMARK,
	T.SJ_AD_CODE AD_CODE,
    SUM(T.TOTAL_PAY_AMT) TOTAL_PAY_AMT,
    SUM(T.DFF_AMT) DFF_AMT,
    SUM(CASE WHEN T.HK_TYPE=0 THEN NVL(T.HK_AMT,0) ELSE 0 END) BJ_HK_AMT,
    SUM(CASE WHEN T.HK_TYPE=1 THEN NVL(T.HK_AMT,0) ELSE 0 END) LX_HK_AMT,
    SUM(CASE WHEN T.HK_TYPE=2 THEN NVL(T.HK_AMT,0) ELSE 0 END) fxf_HK_AMT,
    SUM(CASE WHEN T.HK_TYPE=3 THEN NVL(T.HK_AMT,0) ELSE 0 END) tgf_HK_AMT,
    SUM(CASE WHEN T.HK_TYPE=4 THEN NVL(T.HK_AMT,0) ELSE 0 END) fx_HK_AMT
  FROM DEBT_T_ZQGL_ZQZJDF T
  LEFT JOIN DSY_V_ELE_AD AD
    ON T.AD_CODE = AD.CODE
  GROUP BY
    T.HKD_ID,
    T.HK_DATE,
    T.IS_CONFIRM,
    T.CREATE_USER,
    T.IS_END,
    T.WF_ID,
    T.NODE_CURRENT_ID,
    T.NODE_NEXT_ID,
    T.WF_STATUS,
	T.SJ_AD_CODE,
    T.REMARK;

--20210119_wangyl_追加推送数据区划字段
Alter table DEBT_T_ZQGL_ZQZJDF add SJ_AD_CODE VARCHAR2(20) null;

--20210119_wangyl_追加实际还款区划字段
alter table DEBT_T_ZQGL_ZDHKXX add SJ_HK_AD_CODE varchar2(20) null;


--20210119_wangyl_修改罚息视图
CREATE OR REPLACE VIEW DEBT_V_ZQGL_FXTJ_42 AS
SELECT HK.HK_ID DF_PLAN_ID,
       DFJH.ZQ_ID,
       DFJH.AD_CODE,
       CASE
         WHEN SGX.LEVELNO = '4' THEN
          SUBSTR(DFJH.AD_CODE, 1, 4)
         WHEN SGX.LEVELNO = '3' THEN
          SUBSTR(DFJH.AD_CODE, 1, 2)
         ELSE
          NULL
       END AS U_AD_CODE,
       4 PLAN_TYPE,
       '罚息' PLAN_TYPE_NAME,
       DFJH.YDF_DATE AS DF_END_DATE,
       HK.HK_DATE PAY_DATE, --实际还款日期
       TO_NUMBER(ZNJ.PM_RATE) AS ZNJ_RATE,
       ROUND(SUM(NVL(HK.HK_AMT, 0) * ZNJ.PM_RATE / 100 * 2  / 365 * (TO_DATE(HK.HK_DATE, 'YYYY-MM-DD') - TO_DATE(DFJH.DF_END_DATE, 'YYYY-MM-DD'))),2) AS CD_AMT, -- 逾期罚息
       0 AS DFF_AMT, -- 逾期兑付费
       ROUND(SUM(CASE WHEN DFJH.PLAN_TYPE = '0' THEN NVL(HK.HK_AMT, 0) * ZNJ.PM_RATE / 100 * 2 / 365 * (TO_DATE(HK.HK_DATE, 'YYYY-MM-DD') - TO_DATE(DFJH.DF_END_DATE, 'YYYY-MM-DD')) ELSE 0 END),2) AS FXBJ_AMT, -- 逾期罚息本金
       ROUND(SUM(CASE WHEN DFJH.PLAN_TYPE = '1' THEN NVL(HK.HK_AMT, 0) * ZNJ.PM_RATE / 100 * 2 / 365 * (TO_DATE(HK.HK_DATE, 'YYYY-MM-DD') - TO_DATE(DFJH.DF_END_DATE, 'YYYY-MM-DD')) ELSE 0 END),2) AS FXLX_AMT, -- 逾期利息罚息
       TO_DATE(HK.HK_DATE, 'YYYY-MM-DD') - TO_DATE(DFJH.DF_END_DATE, 'YYYY-MM-DD') AS YQ_DAYS, -- 逾期天数
       SUM(CASE WHEN DFJH.PLAN_TYPE = 0 THEN NVL(DFJH.CD_AMT,0) ELSE 0 END) AS DQBJ_AMT, -- 到期本金
       SUM(CASE WHEN DFJH.PLAN_TYPE = 1 THEN NVL(DFJH.CD_AMT,0) ELSE 0 END) AS DQLX_AMT, -- 到期利息
       SUM(CASE WHEN DFJH.PLAN_TYPE = 0 THEN NVL(HK.HK_AMT,0) ELSE 0 END) AS YQBJ_AMT,  -- 逾期本金
       SUM(CASE WHEN DFJH.PLAN_TYPE = 1 THEN NVL(HK.HK_AMT,0) ELSE 0 END) AS YQLX_AMT -- 逾期利息
  FROM (SELECT ZQ_ID,AD_CODE,PLAN_TYPE,DEBT_GET_WORK_DAY(DF_END_DATE, -10) AS DF_END_DATE, DF_END_DATE AS YDF_DATE,CD_AMT
          FROM DEBT_V_ZQGL_FXDF_HBJ WHERE LENGTH(AD_CODE) = 6) DFJH
  LEFT JOIN DSY_V_ELE_AD_SGX SGX
    ON DFJH.AD_CODE = SGX.CODE
  LEFT JOIN (SELECT T.ZQ_ID,
                    T.AD_CODE,
                    T.HK_TYPE,
                    HK_NO,
                    HK_ID,
                    HK_DATE,
                    HK_AMT,
                    T.DFF_AMT,
                    JH.DF_END_DATE,
                    IS_END,
                    IS_CONFIRM
               FROM DEBT_T_ZQGL_ZDHKXX T
               LEFT JOIN DEBT_T_ZQGL_DFJH JH
                 ON T.PLAN_ID = JH.DF_PLAN_ID
              WHERE LENGTH(T.AD_CODE) = 6
             UNION ALL
             SELECT T.ZQ_ID,
                    T.AD_CODE || '00' AS AD_CODE,
                    T.HK_TYPE,
                    HK_NO,
                    HK_ID,
                    HK_DATE,
                    HK_AMT,
                    T.DFF_AMT,
                    JH.DF_END_DATE,
                    IS_END,
                    IS_CONFIRM
               FROM DEBT_T_ZQGL_ZDHKXX T
               LEFT JOIN DEBT_T_ZQGL_DFJH JH
                 ON T.PLAN_ID = JH.DF_PLAN_ID
              WHERE T.SJ_HK_AD_CODE=T.AD_CODE) HK
    ON DFJH.ZQ_ID = HK.ZQ_ID
   AND DFJH.PLAN_TYPE = HK.HK_TYPE
   AND DFJH.AD_CODE = HK.AD_CODE
   AND DFJH.YDF_DATE = HK.DF_END_DATE
  LEFT JOIN DEBT_t_ZQGL_ZQXX ZNJ
    ON  DFJH.ZQ_ID = ZNJ.ZQ_ID
  LEFT JOIN (SELECT ZQ_ID, AD_CODE, HK_TYPE, DF_END_DATE, SUM(HK_AMT) HK_AMT
               FROM (SELECT T.ZQ_ID,
                            T.AD_CODE,
                            T.HK_TYPE,
                            HK_NO,
                            HK_ID,
                            HK_DATE,
                            HK_AMT,
                            JH.DF_END_DATE,
                            IS_END,
                            IS_CONFIRM
                       FROM DEBT_T_ZQGL_ZDHKXX T
                       LEFT JOIN DEBT_T_ZQGL_DFJH JH
                         ON T.PLAN_ID = JH.DF_PLAN_ID
                      WHERE LENGTH(T.AD_CODE) = 6
                     UNION ALL
                     SELECT T.ZQ_ID,
                            T.AD_CODE || '00' AS AD_CODE,
                            T.HK_TYPE,
                            HK_NO,
                            HK_ID,
                            HK_DATE,
                            HK_AMT,
                            JH.DF_END_DATE,
                            IS_END,
                            IS_CONFIRM
                       FROM DEBT_T_ZQGL_ZDHKXX T
                       LEFT JOIN DEBT_T_ZQGL_DFJH JH
                         ON T.PLAN_ID = JH.DF_PLAN_ID
                      WHERE T.SJ_HK_AD_CODE=T.AD_CODE) HK_HBJ
              WHERE HK_HBJ.IS_CONFIRM = '1'
                AND HK_HBJ.IS_END = '1 '
              GROUP BY ZQ_ID, AD_CODE, HK_TYPE, DF_END_DATE) YH
    ON DFJH.ZQ_ID = YH.ZQ_ID
   AND DFJH.AD_CODE = YH.AD_CODE
   AND DFJH.PLAN_TYPE = YH.HK_TYPE
   AND DFJH.YDF_DATE = YH.DF_END_DATE
 WHERE LENGTH(DFJH.AD_CODE) = 6
   AND HK.IS_CONFIRM = '1'
   AND (HK.HK_AMT IS NOT NULL OR HK.DFF_AMT IS NOT NULL)
   AND (HK.HK_AMT > 0 OR HK.DFF_AMT > 0)
   AND YH.HK_AMT = DFJH.CD_AMT
   AND TO_DATE(DFJH.DF_END_DATE, 'YYYY-MM-DD')  < TO_DATE(HK.HK_DATE, 'YYYY-MM-DD')
 GROUP BY DFJH.AD_CODE,
          DFJH.ZQ_ID,
          CASE
            WHEN SGX.LEVELNO = '4' THEN
             SUBSTR(DFJH.AD_CODE, 1, 4)
            WHEN SGX.LEVELNO = '3' THEN
             SUBSTR(DFJH.AD_CODE, 1, 2)
            ELSE
             NULL
          END,
          HK.HK_ID,
          DFJH.YDF_DATE,
          HK.HK_DATE,
          ZNJ.PM_RATE,
          TO_DATE(HK.HK_DATE, 'YYYY-MM-DD') - TO_DATE(DFJH.DF_END_DATE, 'YYYY-MM-DD');



---选择转贷视图
CREATE OR REPLACE VIEW DEBT_V_ZQGL_SQDMX_HUBEI AS
SELECT A.HK_ID,
       A.HK_NO,
       A.PLAN_ID,
       SGX.LEVELNO,
       A.AD_CODE,
       A.SJ_AD_CODE,
       A.DF_END_DATE,
       A.HK_NO AS U_HK_NO,
       SUBSTR(A.AD_CODE, 0, 4) AS U_AD_CODE,
       CASE
         WHEN A.HK_TYPE = '0' OR A.HK_TYPE = '1' OR A.HK_TYPE = '4' THEN
          D.DF_PLAN_ID
         WHEN A.HK_TYPE = '2' OR A.HK_TYPE = '3' THEN
          P.ID
       END U_PLAN_ID,
       CASE
         WHEN A.HK_TYPE = '0' OR A.HK_TYPE = '1' OR A.HK_TYPE = '4' THEN
          D.DF_END_DATE
         WHEN A.HK_TYPE = '2' OR A.HK_TYPE = '3' THEN
          P.PLAN_PAY_DATE
       END UPDF_END_DATE,
       A.HK_TYPE,
       A.HK_DATE,
       A.REMARK,
       A.ZQ_ID,
       A.SET_YEAR,
       A.ZJLY_ID,
       A.PAY_DATE,
       A.TQHK_DAYS,
       A.YFFX_AMT,
       A.YQBJ_AMT,
       A.YQLX_AMT,
       A.ZNJ_RATE,
       A.WF_ID,
       A.NODE_CURRENT_ID,
       A.NODE_NEXT_ID,
       A.WF_STATUS,
       A.IS_END
  FROM DEBT_T_ZQGL_ZQZJDF A
  LEFT JOIN DEBT_T_ZQGL_DFJH D
    ON A.ZQ_ID = D.ZQ_ID
   AND SUBSTR(A.AD_CODE, 0, 4) = D.AD_CODE
   AND CASE
         WHEN A.HK_TYPE = 4 AND A.YQBJ_AMT > 0 THEN
          0
         WHEN A.HK_TYPE = 4 AND A.YQLX_AMT > 0 THEN
          1
         ELSE
          A.HK_TYPE
       END = D.PLAN_TYPE
   AND A.DF_END_DATE = D.DF_END_DATE
  LEFT JOIN DEBT_T_ZQGL_XJFEE_PLAN P
    ON A.ZQ_ID = P.ZQ_ID
   AND SUBSTR(A.AD_CODE, 0, 4) = P.AD_CODE
   AND (A.HK_TYPE = '2' OR A.HK_TYPE = '3')
   AND A.DF_END_DATE = P.PLAN_PAY_DATE
  left join DSY_V_ELE_AD_SGX SGX ON SGX.CODE = A.AD_CODE
 WHERE 1 = 1
UNION ALL
SELECT GKSJ.GKSJDTL_ID AS HK_ID,
       GKSJ.GKZJSJ_NO AS HK_NO,
       D.DF_PLAN_ID AS PLAN_ID,
       SGX.LEVELNO,
       GKSJ.AD_CODE,
       '' SJ_AD_CODE,
       D.DF_END_DATE,
       GKSJ.GKZJSJ_NO AS U_HK_NO,
       D.DF_PLAN_ID AS U_PLAN_ID,
       GKSJ.AD_CODE AS U_AD_CODE,
       D.DF_END_DATE AS UPDF_END_DATE,
       D.PLAN_TYPE AS HK_TYPE,
       GKSJ.SJ_DATE AS HK_DATE,
       GKSJ.REMARK,
       GKSJ.ZQ_ID,
       TO_NUMBER(SUBSTR(GKSJ.SJ_DATE, 0, 4)) AS SET_YEAR,
       ZQ.ZJLY_ID,
       GKSJ.SJ_DATE AS PAY_DATE,
       ZQ.TQHK_DAYS,
       0 AS YFFX_AMT,
       0 AS YQBJ_AMT,
       0 AS YQLX_AMT,
       0 AS ZNJ_RATE,
       GKSJ.WF_ID,
       GKSJ.NODE_CURRENT_ID,
       GKSJ.NODE_NEXT_ID,
       GKSJ.WF_STATUS,
       GKSJ.IS_END
  FROM DEBT_T_ZQGL_GKZJSJ GKSJ
  LEFT JOIN DEBT_T_ZQGL_ZQXX ZQ
    ON GKSJ.ZQ_ID = ZQ.ZQ_ID
  LEFT JOIN DEBT_T_ZQGL_DFJH D
    ON GKSJ.ZQ_ID = D.ZQ_ID
   AND GKSJ.AD_CODE = D.AD_CODE
   AND D.PLAN_TYPE = 0
  left join DSY_V_ELE_AD_SGX SGX ON SGX.CODE = GKSJ.AD_CODE
 WHERE 1 = 1;
