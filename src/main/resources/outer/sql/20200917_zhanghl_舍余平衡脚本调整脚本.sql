--20200916 zhanghl 单位舍余平衡存储过程调整(单位,财政)
CREATE OR REPLACE PROCEDURE DEBT_P_BALANC_CAPITAL_DW(V_ZQ_ID   IN DEBT_T_ZQGL_DFJH.ZQ_ID%TYPE,
                                                     V_AD_CODE DEBT_T_ZQGL_DFJH.AD_CODE%TYPE) AS
  /*20200614-wjc  修改逻辑：根据转贷的债券和区划 计算转贷到下级时生成的尾插，在第一个单位进行尾差处理*/
  V_MINUS_AMT   DEBT_T_ZQGL_DFJH.PLAN_AMT%TYPE; --用于校验是否完成转贷 0：完全转贷、大于0 未完全转贷
  V_ORDER_STR   VARCHAR2(10); -- update语句获取金额最大最小值字符串
  V_THRESHOLD   NUMBER := 10; --调整记录的阈值
  V_STR_DFF_SQL VARCHAR2(3000);
  V_STR_CD_SQL  VARCHAR2(3000);
  V_STR_XZ_SQL  VARCHAR2(3000);
  V_STR_ZH_SQL  VARCHAR2(3000);
  V_STR_HB_SQL  VARCHAR2(3000);
  --以下是处理未完全转贷情况下兑付费尾差不在本级体现，体现在第一个区划
  V_BJDFF_MINUS_AMT      NUMBER(16, 2); --本级兑付费差额（本金资金计算得出 与 上级减下级相比较）
  V_STR_BJDFF_SQL        VARCHAR2(3000);
  V_STR_BJDFF_SQL_NOLOOP VARCHAR2(3000);
  -- 定义游标：查询当前地区所有转贷下级的兑付计划信息，并计算向下转贷时出现的尾插
  CURSOR CHECK_EQUALS IS
    SELECT ZQXX.DFSXF_RATE,
           T.PLAN_TYPE,
           T.CD_AMT AS CD_AMT,
           T.DFF_AMT,
           T.DF_END_DATE,
          nvl( T.CD_AMT,0) - nvl(TMP.CD_AMT,0) AS MINUS_CD_AMT,
           nvl(T.DFF_AMT,0) - nvl(TMP.DFF_AMT,0) AS MINUS_DFF_AMT,
           nvl(T.PLAN_XZ_AMT,0) - nvl(TMP.PLAN_XZ_AMT,0) AS MINUS_XZ_AMT,
           nvl(T.PLAN_ZH_AMT,0) - nvl(TMP.PLAN_ZH_AMT,0) AS MINUS_ZH_AMT,
           nvl(T.PLAN_HB_AMT,0) - nvl(TMP.PLAN_HB_AMT,0) AS MINUS_HB_AMT
      FROM DEBT_V_ZQGL_FXDF_HBJ T
      LEFT JOIN DEBT_T_ZQGL_ZQXX ZQXX
        ON ZQXX.ZQ_ID = T.ZQ_ID
      LEFT JOIN (SELECT SUM(PLAN_AMT) CD_AMT,
                        SUM(DFF_AMT) DFF_AMT,
                        SUM(PLAN_XZ_AMT) PLAN_XZ_AMT,
                        SUM(PLAN_ZH_AMT) PLAN_ZH_AMT,
                        SUM(PLAN_ZRZ_AMT) PLAN_HB_AMT,
                        PLAN_TYPE,
                        DF_END_DATE,
                        ZQ_ID,
                        AD_CODE AS U_AD_CODE
                   FROM DEBT_T_ZWGL_QYJT_ZQHKJH T
                  GROUP BY PLAN_TYPE, DF_END_DATE, ZQ_ID, AD_CODE) TMP
        ON T.PLAN_TYPE = TMP.PLAN_TYPE
       AND T.DF_END_DATE = TMP.DF_END_DATE
       AND T.ZQ_ID = TMP.ZQ_ID
       AND T.AD_CODE = TMP.U_AD_CODE
     WHERE T.ZQ_ID = V_ZQ_ID
       AND T.AD_CODE = V_AD_CODE;
  CHECK_EQUALS_REC CHECK_EQUALS%ROWTYPE;
BEGIN
  -- 20200611-wangjc-更新该地区管辖范围内区划的尾插值，重新进行筛选最小区划
  UPDATE DEBT_T_ZWGL_QYJT_ZQHKJH DFJH
     SET DFJH.DFF_AMT     = DFJH.DFF_AMT - DFJH.DFF_BAL_AMT,
         DFJH.DFF_BAL_AMT = 0
   WHERE DFJH.ZQ_ID = V_ZQ_ID
     AND DFJH.AD_CODE = V_AD_CODE;
  --判断是否完成转贷
  SELECT T.CD_AMT - XJ.PLAN_AMT MINUS_AMT INTO V_MINUS_AMT
    FROM DEBT_V_ZQGL_FXDF_HBJ T
    LEFT JOIN (SELECT PLAN_TYPE, AD_CODE AS U_AD_CODE, ZQ_ID, SUM(PLAN_AMT) PLAN_AMT
                 FROM DEBT_T_ZWGL_QYJT_ZQHKJH
                GROUP BY PLAN_TYPE, AD_CODE, ZQ_ID) XJ
      ON T.ZQ_ID = XJ.ZQ_ID
     AND T.AD_CODE = XJ.U_AD_CODE
     AND T.PLAN_TYPE = XJ.PLAN_TYPE
   WHERE T.ZQ_ID = V_ZQ_ID
     AND T.AD_CODE = V_AD_CODE
     AND T.PLAN_TYPE = 0;
  --当前地区向下转贷全部完成
  IF V_MINUS_AMT = 0 THEN
    OPEN CHECK_EQUALS;
    LOOP
      FETCH CHECK_EQUALS
        INTO CHECK_EQUALS_REC;
      EXIT WHEN CHECK_EQUALS%NOTFOUND;
      --调整兑付费
      IF CHECK_EQUALS_REC.MINUS_DFF_AMT > 0 AND
         ABS(CHECK_EQUALS_REC.MINUS_DFF_AMT) < V_THRESHOLD THEN
        V_ORDER_STR := '';
      ELSIF CHECK_EQUALS_REC.MINUS_DFF_AMT < 0 AND
            ABS(CHECK_EQUALS_REC.MINUS_DFF_AMT) < V_THRESHOLD THEN
        V_ORDER_STR := '  ';
      END IF;
      -- 当存在承担兑付费不平衡数据时调整数据
      IF CHECK_EQUALS_REC.MINUS_DFF_AMT <> 0 AND ABS(CHECK_EQUALS_REC.MINUS_DFF_AMT) < V_THRESHOLD THEN
        V_STR_DFF_SQL := 'UPDATE DEBT_T_ZWGL_QYJT_ZQHKJH T SET T.DFF_BAL_AMT = ' || CHECK_EQUALS_REC.MINUS_DFF_AMT -- 兑付费尾插值
            || ', T.DFF_AMT = T.DFF_AMT + ' || CHECK_EQUALS_REC.MINUS_DFF_AMT
            || ' WHERE T.QYZQ_HKJH_ID = (SELECT QYZQ_HKJH_ID FROM (SELECT ROW_NUMBER() OVER(ORDER BY AG.CODE ' || V_ORDER_STR
            || ') AS ROW_NUM, T.* FROM DEBT_T_ZWGL_QYJT_ZQHKJH T LEFT JOIN DSY_V_ELE_AG AG ON T.QYJT_ID = AG.GUID WHERE T.AD_CODE = ''' || V_AD_CODE
            || ''' AND T.ZQ_ID = ''' || V_ZQ_ID || ''' AND PLAN_TYPE = ''' || CHECK_EQUALS_REC.PLAN_TYPE
            || ''' AND DF_END_DATE = ''' || CHECK_EQUALS_REC.DF_END_DATE || ''') WHERE ROW_NUM = 1)';
        EXECUTE IMMEDIATE V_STR_DFF_SQL;
      END IF;
      --当存在承担利息不平衡数据时调整数据
      IF CHECK_EQUALS_REC.MINUS_CD_AMT > 0 AND
         ABS(CHECK_EQUALS_REC.MINUS_CD_AMT) < V_THRESHOLD THEN
        V_ORDER_STR := '';
      ELSIF CHECK_EQUALS_REC.MINUS_CD_AMT < 0 AND
            ABS(CHECK_EQUALS_REC.MINUS_CD_AMT) < V_THRESHOLD THEN
        V_ORDER_STR := '  ';
      END IF;
      --当存在承担金额不平衡数据时调整数据
      IF CHECK_EQUALS_REC.MINUS_CD_AMT <> 0 AND
         ABS(CHECK_EQUALS_REC.MINUS_CD_AMT) < V_THRESHOLD THEN
        V_STR_CD_SQL := 'UPDATE DEBT_T_ZWGL_QYJT_ZQHKJH T SET T.CD_BAL_AMT = ' || CHECK_EQUALS_REC.MINUS_CD_AMT
            || ',T.CD_AMT = T.CD_AMT + ' || CHECK_EQUALS_REC.MINUS_CD_AMT
            || ' WHERE T.QYZQ_HKJH_ID = (SELECT QYZQ_HKJH_ID FROM (SELECT ROW_NUMBER() OVER(ORDER BY AG.CODE ' || V_ORDER_STR
            || ') AS ROW_NUM, T.* FROM DEBT_T_ZWGL_QYJT_ZQHKJH T LEFT JOIN DSY_V_ELE_AG AG ON T.QYJT_ID = AG.GUID WHERE T.AD_CODE = ''' || V_AD_CODE
            || ''' AND T.ZQ_ID = ''' || V_ZQ_ID || ''' AND PLAN_TYPE = ''' || CHECK_EQUALS_REC.PLAN_TYPE
            || ''' AND DF_END_DATE = ''' || CHECK_EQUALS_REC.DF_END_DATE || ''') WHERE ROW_NUM = 1)';
        EXECUTE IMMEDIATE V_STR_CD_SQL;
      END IF;
      --调整新增债券金额
      IF CHECK_EQUALS_REC.MINUS_XZ_AMT > 0 AND
         ABS(CHECK_EQUALS_REC.MINUS_XZ_AMT) < V_THRESHOLD THEN
        V_ORDER_STR := '';
      ELSIF CHECK_EQUALS_REC.MINUS_XZ_AMT < 0 AND
            ABS(CHECK_EQUALS_REC.MINUS_XZ_AMT) < V_THRESHOLD THEN
        V_ORDER_STR := '  ';
      END IF;
      --当存在新增债券金额不平衡数据时调整数据
      IF CHECK_EQUALS_REC.MINUS_XZ_AMT <> 0 AND
         ABS(CHECK_EQUALS_REC.MINUS_XZ_AMT) < V_THRESHOLD THEN
        V_STR_XZ_SQL := 'UPDATE DEBT_T_ZWGL_QYJT_ZQHKJH T SET T.XZ_BAL_AMT = ' || CHECK_EQUALS_REC.MINUS_XZ_AMT
            || ', T.PLAN_AMT = T.PLAN_AMT + ' || CHECK_EQUALS_REC.MINUS_XZ_AMT
            || ', T.PLAN_XZ_AMT = T.PLAN_XZ_AMT + ' || CHECK_EQUALS_REC.MINUS_XZ_AMT
            || ' WHERE T.QYZQ_HKJH_ID = (SELECT QYZQ_HKJH_ID FROM (SELECT ROW_NUMBER() OVER(ORDER BY AG.CODE ' || V_ORDER_STR
            || ') AS ROW_NUM, T.* FROM DEBT_T_ZWGL_QYJT_ZQHKJH T LEFT JOIN DSY_V_ELE_AG AG ON T.QYJT_ID = AG.GUID WHERE T.AD_CODE = ''' || V_AD_CODE
            || ''' AND T.ZQ_ID = ''' || V_ZQ_ID || ''' AND PLAN_TYPE = ''' || CHECK_EQUALS_REC.PLAN_TYPE
            || ''' AND DF_END_DATE = ''' || CHECK_EQUALS_REC.DF_END_DATE || ''') WHERE ROW_NUM = 1)';
        EXECUTE IMMEDIATE V_STR_XZ_SQL;
        COMMIT;
      END IF;
      --调整置换债券金额
      IF CHECK_EQUALS_REC.MINUS_ZH_AMT > 0 AND
         ABS(CHECK_EQUALS_REC.MINUS_ZH_AMT) < V_THRESHOLD THEN
        V_ORDER_STR := '';
      ELSIF CHECK_EQUALS_REC.MINUS_ZH_AMT < 0 AND
            ABS(CHECK_EQUALS_REC.MINUS_ZH_AMT) < V_THRESHOLD THEN
        V_ORDER_STR := '  ';
      END IF;
      --当存在置换债券金额不平衡数据时调整数据
      IF CHECK_EQUALS_REC.MINUS_ZH_AMT <> 0 AND
         ABS(CHECK_EQUALS_REC.MINUS_ZH_AMT) < V_THRESHOLD THEN
        V_STR_ZH_SQL := 'UPDATE DEBT_T_ZWGL_QYJT_ZQHKJH T SET T.ZH_BAL_AMT = ' || CHECK_EQUALS_REC.MINUS_ZH_AMT
            || ', T.PLAN_AMT = T.PLAN_AMT + ' || CHECK_EQUALS_REC.MINUS_ZH_AMT
            || ',T.PLAN_ZH_AMT = T.PLAN_ZH_AMT + ' || CHECK_EQUALS_REC.MINUS_ZH_AMT
            || ' WHERE T.QYZQ_HKJH_ID = (SELECT QYZQ_HKJH_ID FROM (SELECT ROW_NUMBER() OVER(ORDER BY AG.CODE ' || V_ORDER_STR
            || ') AS ROW_NUM, T.* FROM DEBT_T_ZWGL_QYJT_ZQHKJH T LEFT JOIN DSY_V_ELE_AG AG ON T.QYJT_ID = AG.GUID WHERE T.AD_CODE = ''' || V_AD_CODE
            || ''' AND T.ZQ_ID = ''' || V_ZQ_ID || ''' AND PLAN_TYPE = ''' || CHECK_EQUALS_REC.PLAN_TYPE
            || ''' AND DF_END_DATE = ''' || CHECK_EQUALS_REC.DF_END_DATE || ''') WHERE ROW_NUM = 1)';
        EXECUTE IMMEDIATE V_STR_ZH_SQL;
        COMMIT;
      END IF;
      --调整再融资债券金额
      IF CHECK_EQUALS_REC.MINUS_HB_AMT > 0 AND
         ABS(CHECK_EQUALS_REC.MINUS_HB_AMT) < V_THRESHOLD THEN
        V_ORDER_STR := '';
      ELSIF CHECK_EQUALS_REC.MINUS_HB_AMT < 0 AND
            ABS(CHECK_EQUALS_REC.MINUS_HB_AMT) < V_THRESHOLD THEN
        V_ORDER_STR := '  ';
      END IF;
      --当存在再融资债券金额不平衡数据时调整数据
      IF CHECK_EQUALS_REC.MINUS_HB_AMT <> 0 AND
         ABS(CHECK_EQUALS_REC.MINUS_HB_AMT) < V_THRESHOLD THEN
        V_STR_HB_SQL := 'UPDATE DEBT_T_ZWGL_QYJT_ZQHKJH T SET T.HB_BAL_AMT = ' || CHECK_EQUALS_REC.MINUS_HB_AMT
            || ', T.PLAN_AMT = T.PLAN_AMT + ' || CHECK_EQUALS_REC.MINUS_HB_AMT
            || ', T.PLAN_HB_AMT = T.PLAN_HB_AMT + ' || CHECK_EQUALS_REC.MINUS_HB_AMT
            || ' WHERE T.QYZQ_HKJH_ID = (SELECT QYZQ_HKJH_ID FROM (SELECT ROW_NUMBER() OVER(ORDER BY AG.CODE ' || V_ORDER_STR
            || ') AS ROW_NUM, T.* FROM DEBT_T_ZWGL_QYJT_ZQHKJH T LEFT JOIN DSY_V_ELE_AG AG ON T.QYJT_ID = AG.GUID WHERE T.AD_CODE = ''' || V_AD_CODE
            || ''' AND T.ZQ_ID = ''' || V_ZQ_ID || ''' AND PLAN_TYPE = ''' || CHECK_EQUALS_REC.PLAN_TYPE
            || ''' AND DF_END_DATE = ''' || CHECK_EQUALS_REC.DF_END_DATE || ''') WHERE ROW_NUM = 1)';
        EXECUTE IMMEDIATE V_STR_HB_SQL;
        COMMIT;
      END IF;
    END LOOP;
      ELSIF V_MINUS_AMT > 0 THEN
    /*在没有完全转贷的情况下，对发生的兑付费进行尾差平衡，将本级兑付费金额校准，误差值添加到转贷的市县*/
    OPEN CHECK_EQUALS;
    LOOP
      FETCH CHECK_EQUALS
        INTO CHECK_EQUALS_REC;
      EXIT WHEN CHECK_EQUALS%NOTFOUND;
      -- wjc 本级兑付费差额：本级承担金额 * 兑付费率 / 100 - 本金承担兑付费  6720.68 - 6720.67  0.01
      V_BJDFF_MINUS_AMT := CHECK_EQUALS_REC.DFSXF_RATE * CHECK_EQUALS_REC.MINUS_CD_AMT / 100 -
                           CHECK_EQUALS_REC.MINUS_DFF_AMT;
      -- wjc 通过循环解决 上级承担金额计算的本级承担兑付费 - （上级承担兑付费-下级兑付费合计）金额 计算出的结果更新到 除本级外第一个区划中
      V_STR_BJDFF_SQL := ' UPDATE DEBT_T_ZWGL_QYJT_ZQHKJH T SET T.DFF_AMT = NVL(T.DFF_AMT,0) -  NVL(' || V_BJDFF_MINUS_AMT  ||
                         ',0), T.DFF_BAL_AMT =  0 - NVL(' || V_BJDFF_MINUS_AMT ||
                         ',0) WHERE T.QYZQ_HKJH_ID = (SELECT QYZQ_HKJH_ID FROM (SELECT ROW_NUMBER() OVER(ORDER BY AG.CODE ' || V_ORDER_STR
            || ') AS ROW_NUM, T.* FROM DEBT_T_ZWGL_QYJT_ZQHKJH T LEFT JOIN DSY_V_ELE_AG AG ON T.QYJT_ID = AG.GUID WHERE T.AD_CODE = ''' || V_AD_CODE
            || ''' AND T.ZQ_ID = ''' || V_ZQ_ID || ''' AND PLAN_TYPE = ''' || CHECK_EQUALS_REC.PLAN_TYPE
            || ''' AND DF_END_DATE = ''' || CHECK_EQUALS_REC.DF_END_DATE || ''') WHERE ROW_NUM = 1)';
      EXECUTE IMMEDIATE V_STR_BJDFF_SQL;
    END LOOP;
    COMMIT;
  END IF;
END DEBT_P_BALANC_CAPITAL_DW;
/
CREATE OR REPLACE PROCEDURE DEBT_P_BALANC_CAPITAL(V_ZQ_ID   IN DEBT_T_ZQGL_DFJH.ZQ_ID%TYPE,
                                                       V_AD_CODE DEBT_T_ZQGL_DFJH.AD_CODE%TYPE) AS
  /*2019-07-26 gy
  修改逻辑，由原来的每次转贷出现尾差问题时在最多的地区调减，在最少的地区调增
  调整为：在第一个区划进行尾差处理。废弃参数 V_ORDER_STR*/
  V_MINUS_AMT   DEBT_T_ZQGL_DFJH.PLAN_AMT%TYPE; --用于校验是否完成转贷 0：完成
  V_ORDER_STR   VARCHAR2(10); --update语句获取金额最大最小值字符串
  V_THRESHOLD   NUMBER := 10; --调整记录的阈值
  V_STR_DFF_SQL VARCHAR2(3000);
  V_STR_CD_SQL  VARCHAR2(3000);
  V_STR_XZ_SQL  VARCHAR2(3000);
  V_STR_ZH_SQL  VARCHAR2(3000);
  V_STR_HB_SQL  VARCHAR2(3000);
  --以下是处理未完全转贷情况下兑付费尾差不在本级体现，体现在第一个区划
  V_BJDFF_MINUS_AMT      NUMBER(16, 2); --本级兑付费差额（本金资金计算得出 与 上级减下级相比较）
  V_STR_BJDFF_SQL        VARCHAR2(3000);
  V_STR_BJDFF_SQL_NOLOOP VARCHAR2(3000);
  --校验是否相等游标数据 查询
  CURSOR CHECK_EQUALS IS
    SELECT ZQXX.DFSXF_RATE,  -- 兑付手续费率
           T.PLAN_TYPE, -- 资金类型 0：本金、1：利息
           T.CD_AMT, -- 承担金额（发行金额）
           T.DFF_AMT, -- 承担兑付费
           T.DF_END_DATE, -- 兑付日期（应缴日期）
           NVL(T.CD_AMT,0) - NVL(TMP.CD_AMT,0) MINUS_CD_AMT,  -- 本级承担金额（上级-下级汇总金额）
           NVL(T.DFF_AMT,0) - NVL(TMP.DFF_AMT,0) MINUS_DFF_AMT, -- 本级承担兑付费 （上级 - 下级汇总金额）
           NVL(T.PLAN_XZ_AMT,0) - NVL(TMP.PLAN_XZ_AMT,0) MINUS_XZ_AMT, -- 本级承担新增金额
           NVL(T.PLAN_ZH_AMT,0) - NVL(TMP.PLAN_ZH_AMT,0) MINUS_ZH_AMT, -- 本级承担置换金额
           NVL(T.PLAN_HB_AMT,0) - NVL(TMP.PLAN_HB_AMT,0) MINUS_HB_AMT  -- 本级承担再融资金额
      FROM DEBT_T_ZQGL_DFJH T
      LEFT JOIN DEBT_T_ZQGL_ZQXX ZQXX
        ON ZQXX.ZQ_ID = T.ZQ_ID
      LEFT JOIN (SELECT SUM(CD_AMT) CD_AMT,
                        SUM(DFF_AMT) DFF_AMT,
                        SUM(PLAN_XZ_AMT) PLAN_XZ_AMT,
                        SUM(PLAN_ZH_AMT) PLAN_ZH_AMT,
                        SUM(PLAN_HB_AMT) PLAN_HB_AMT,
                        PLAN_TYPE,
                        DF_END_DATE,
                        ZQ_ID,
                        U_AD_CODE
                   FROM DEBT_T_ZQGL_DFJH T
                  GROUP BY PLAN_TYPE, DF_END_DATE, ZQ_ID, U_AD_CODE) TMP
        ON T.PLAN_TYPE = TMP.PLAN_TYPE
       AND T.DF_END_DATE = TMP.DF_END_DATE
       AND T.ZQ_ID = TMP.ZQ_ID
       AND T.AD_CODE = TMP.U_AD_CODE
     WHERE T.ZQ_ID = V_ZQ_ID
       AND T.AD_CODE = V_AD_CODE;
  CHECK_EQUALS_REC CHECK_EQUALS%ROWTYPE;
BEGIN
  -- 20200611-wangjc-更新该地区管辖范围内区划的尾插值，重新进行筛选最小区划
  UPDATE DEBT_T_ZQGL_DFJH DFJH
     SET DFJH.DFF_AMT     = NVL(DFJH.DFF_AMT,0) - NVL(DFJH.DFF_BAL_AMT,0),
         DFJH.DFF_BAL_AMT = 0
   WHERE DFJH.ZQ_ID = V_ZQ_ID
     AND DFJH.U_AD_CODE = V_AD_CODE;
  --判断是否完成转贷
  SELECT NVL(T.PLAN_AMT,0) - NVL(XJ.PLAN_AMT,0) MINUS_AMT
    INTO V_MINUS_AMT
    FROM DEBT_T_ZQGL_DFJH T
    LEFT JOIN (SELECT SUM(PLAN_AMT) PLAN_AMT, PLAN_TYPE, U_AD_CODE, ZQ_ID
                 FROM DEBT_T_ZQGL_DFJH
                GROUP BY PLAN_TYPE, U_AD_CODE, ZQ_ID) XJ
      ON T.ZQ_ID = XJ.ZQ_ID
     AND T.AD_CODE = XJ.U_AD_CODE
     AND T.PLAN_TYPE = XJ.PLAN_TYPE
   WHERE T.ZQ_ID = V_ZQ_ID
     AND T.AD_CODE = V_AD_CODE
     AND T.PLAN_TYPE = 0;
  --当前地区向下转贷全部完成
  IF V_MINUS_AMT = 0 THEN
    OPEN CHECK_EQUALS;
    LOOP
      FETCH CHECK_EQUALS
        INTO CHECK_EQUALS_REC;
      EXIT WHEN CHECK_EQUALS%NOTFOUND;
      --调整对付费
      IF CHECK_EQUALS_REC.MINUS_DFF_AMT > 0 AND
         ABS(CHECK_EQUALS_REC.MINUS_DFF_AMT) < V_THRESHOLD THEN
        V_ORDER_STR := '';
      ELSIF CHECK_EQUALS_REC.MINUS_DFF_AMT < 0 AND
            ABS(CHECK_EQUALS_REC.MINUS_DFF_AMT) < V_THRESHOLD THEN
        V_ORDER_STR := '  ';
      END IF;
      --当存在对付费不平衡数据时调整数据
      IF CHECK_EQUALS_REC.MINUS_DFF_AMT <> 0 AND
         ABS(CHECK_EQUALS_REC.MINUS_DFF_AMT) < V_THRESHOLD THEN
        V_STR_DFF_SQL := 'UPDATE DEBT_T_ZQGL_DFJH T SET T.DFF_BAL_AMT = ' ||
                         CHECK_EQUALS_REC.MINUS_DFF_AMT || ' ,
                            T.DFF_AMT = T.DFF_AMT + ' ||
                         CHECK_EQUALS_REC.MINUS_DFF_AMT ||
                         ' WHERE DF_PLAN_ID = (' ||
                         'SELECT DF_PLAN_ID FROM (SELECT ROW_NUMBER() OVER(ORDER BY AD_CODE ' ||
                         V_ORDER_STR || ') AS ROW_NUM, T.* ' ||
                         'FROM DEBT_T_ZQGL_DFJH T WHERE T.U_AD_CODE = ''' ||
                         V_AD_CODE || ''' AND T.ZQ_ID = ''' || V_ZQ_ID ||
                         ''' AND PLAN_TYPE = ''' ||
                         CHECK_EQUALS_REC.PLAN_TYPE ||
                         ''' AND DF_END_DATE = ''' ||
                         CHECK_EQUALS_REC.DF_END_DATE ||
                         ''') WHERE ROW_NUM = 1)';
        EXECUTE IMMEDIATE V_STR_DFF_SQL;
      END IF;
      --调整承担利息
      IF CHECK_EQUALS_REC.MINUS_CD_AMT > 0 AND
         ABS(CHECK_EQUALS_REC.MINUS_CD_AMT) < V_THRESHOLD THEN
        V_ORDER_STR := '';
      ELSIF CHECK_EQUALS_REC.MINUS_CD_AMT < 0 AND
            ABS(CHECK_EQUALS_REC.MINUS_CD_AMT) < V_THRESHOLD THEN
        V_ORDER_STR := '  ';
      END IF;
      --当存在承担利息不平衡数据时调整数据
      IF CHECK_EQUALS_REC.MINUS_CD_AMT <> 0 AND
         ABS(CHECK_EQUALS_REC.MINUS_CD_AMT) < V_THRESHOLD THEN
        V_STR_CD_SQL := 'UPDATE DEBT_T_ZQGL_DFJH T SET T.CD_BAL_AMT = ' ||
                        CHECK_EQUALS_REC.MINUS_CD_AMT || ' ,
                            T.CD_AMT = T.CD_AMT + ' ||
                        CHECK_EQUALS_REC.MINUS_CD_AMT ||
                        ' WHERE DF_PLAN_ID = (' ||
                        'SELECT DF_PLAN_ID FROM (SELECT ROW_NUMBER() OVER(ORDER BY AD_CODE' ||
                        V_ORDER_STR || ') AS ROW_NUM, T.* ' ||
                        'FROM DEBT_T_ZQGL_DFJH T WHERE T.U_AD_CODE = ''' ||
                        V_AD_CODE || ''' AND T.ZQ_ID = ''' || V_ZQ_ID ||
                        ''' AND PLAN_TYPE = ''' ||
                        CHECK_EQUALS_REC.PLAN_TYPE ||
                        ''' AND DF_END_DATE = ''' ||
                        CHECK_EQUALS_REC.DF_END_DATE ||
                        ''') WHERE ROW_NUM = 1)';
        EXECUTE IMMEDIATE V_STR_CD_SQL;
      END IF;
      --调整新增债券金额
      IF CHECK_EQUALS_REC.MINUS_XZ_AMT > 0 AND
         ABS(CHECK_EQUALS_REC.MINUS_XZ_AMT) < V_THRESHOLD THEN
        V_ORDER_STR := '';
      ELSIF CHECK_EQUALS_REC.MINUS_XZ_AMT < 0 AND
            ABS(CHECK_EQUALS_REC.MINUS_XZ_AMT) < V_THRESHOLD THEN
        V_ORDER_STR := '  ';
      END IF;
      --当存在新增债券金额不平衡数据时调整数据
      IF CHECK_EQUALS_REC.MINUS_XZ_AMT <> 0 AND
         ABS(CHECK_EQUALS_REC.MINUS_XZ_AMT) < V_THRESHOLD THEN
        V_STR_XZ_SQL := 'UPDATE DEBT_T_ZQGL_DFJH T SET T.XZ_BAL_AMT = ' ||
                        CHECK_EQUALS_REC.MINUS_XZ_AMT || ',
                            T.PLAN_AMT = T.PLAN_AMT + ' ||
                        CHECK_EQUALS_REC.MINUS_XZ_AMT || ' ,
                            T.PLAN_XZ_AMT = T.PLAN_XZ_AMT + ' ||
                        CHECK_EQUALS_REC.MINUS_XZ_AMT ||
                        ' WHERE DF_PLAN_ID = (' ||
                        'SELECT DF_PLAN_ID FROM (SELECT ROW_NUMBER() OVER(ORDER BY AD_CODE' ||
                        V_ORDER_STR || ') AS ROW_NUM, T.* ' ||
                        'FROM DEBT_T_ZQGL_DFJH T WHERE T.U_AD_CODE = ''' ||
                        V_AD_CODE || ''' AND T.ZQ_ID = ''' || V_ZQ_ID ||
                        ''' AND PLAN_TYPE = ''' ||
                        CHECK_EQUALS_REC.PLAN_TYPE ||
                        ''' AND DF_END_DATE = ''' ||
                        CHECK_EQUALS_REC.DF_END_DATE ||
                        ''') WHERE ROW_NUM = 1)';
        EXECUTE IMMEDIATE V_STR_XZ_SQL;
        COMMIT;
      END IF;
      --调整置换债券金额
      IF CHECK_EQUALS_REC.MINUS_ZH_AMT > 0 AND
         ABS(CHECK_EQUALS_REC.MINUS_ZH_AMT) < V_THRESHOLD THEN
        V_ORDER_STR := '';
      ELSIF CHECK_EQUALS_REC.MINUS_ZH_AMT < 0 AND
            ABS(CHECK_EQUALS_REC.MINUS_ZH_AMT) < V_THRESHOLD THEN
        V_ORDER_STR := '  ';
      END IF;
      --当存在置换债券金额不平衡数据时调整数据
      IF CHECK_EQUALS_REC.MINUS_ZH_AMT <> 0 AND
         ABS(CHECK_EQUALS_REC.MINUS_ZH_AMT) < V_THRESHOLD THEN
        V_STR_ZH_SQL := 'UPDATE DEBT_T_ZQGL_DFJH T SET T.ZH_BAL_AMT = ' ||
                        CHECK_EQUALS_REC.MINUS_ZH_AMT || ' ,
                            T.PLAN_AMT = T.PLAN_AMT + ' ||
                        CHECK_EQUALS_REC.MINUS_ZH_AMT || ' ,
                            T.PLAN_ZH_AMT = T.PLAN_ZH_AMT + ' ||
                        CHECK_EQUALS_REC.MINUS_ZH_AMT ||
                        ' WHERE DF_PLAN_ID = (' ||
                        'SELECT DF_PLAN_ID FROM (SELECT ROW_NUMBER() OVER(ORDER BY AD_CODE' ||
                        V_ORDER_STR || ') AS ROW_NUM, T.* ' ||
                        'FROM DEBT_T_ZQGL_DFJH T WHERE T.U_AD_CODE = ''' ||
                        V_AD_CODE || ''' AND T.ZQ_ID = ''' || V_ZQ_ID ||
                        ''' AND PLAN_TYPE = ''' ||
                        CHECK_EQUALS_REC.PLAN_TYPE ||
                        ''' AND DF_END_DATE = ''' ||
                        CHECK_EQUALS_REC.DF_END_DATE ||
                        ''') WHERE ROW_NUM = 1)';
        EXECUTE IMMEDIATE V_STR_ZH_SQL;
        COMMIT;
      END IF;
      --调整置换债券金额
      IF CHECK_EQUALS_REC.MINUS_HB_AMT > 0 AND
         ABS(CHECK_EQUALS_REC.MINUS_HB_AMT) < V_THRESHOLD THEN
        V_ORDER_STR := '';
      ELSIF CHECK_EQUALS_REC.MINUS_HB_AMT < 0 AND
            ABS(CHECK_EQUALS_REC.MINUS_HB_AMT) < V_THRESHOLD THEN
        V_ORDER_STR := '  ';
      END IF;
      --当存在置换债券金额不平衡数据时调整数据
      IF CHECK_EQUALS_REC.MINUS_HB_AMT <> 0 AND
         ABS(CHECK_EQUALS_REC.MINUS_HB_AMT) < V_THRESHOLD THEN
        V_STR_HB_SQL := 'UPDATE DEBT_T_ZQGL_DFJH T SET T.HB_BAL_AMT = ' ||
                        CHECK_EQUALS_REC.MINUS_HB_AMT || ' ,
                            T.PLAN_AMT = T.PLAN_AMT + ' ||
                        CHECK_EQUALS_REC.MINUS_HB_AMT || ' ,
                            T.PLAN_HB_AMT = T.PLAN_HB_AMT + ' ||
                        CHECK_EQUALS_REC.MINUS_HB_AMT ||
                        ' WHERE DF_PLAN_ID = (' ||
                        'SELECT DF_PLAN_ID FROM (SELECT ROW_NUMBER() OVER(ORDER BY AD_CODE' ||
                        V_ORDER_STR || ') AS ROW_NUM, T.* ' ||
                        'FROM DEBT_T_ZQGL_DFJH T WHERE T.U_AD_CODE = ''' ||
                        V_AD_CODE || ''' AND T.ZQ_ID = ''' || V_ZQ_ID ||
                        ''' AND PLAN_TYPE = ''' ||
                        CHECK_EQUALS_REC.PLAN_TYPE ||
                        ''' AND DF_END_DATE = ''' ||
                        CHECK_EQUALS_REC.DF_END_DATE ||
                        ''') WHERE ROW_NUM = 1)';
        EXECUTE IMMEDIATE V_STR_HB_SQL;
        COMMIT;
      END IF;
    END LOOP;
  ELSIF V_MINUS_AMT > 0 THEN
    /*在没有完全转贷的情况下，对发生的兑付费进行尾差平衡，将本级兑付费金额校准，误差值添加到转贷的市县*/
    OPEN CHECK_EQUALS;
    LOOP
      FETCH CHECK_EQUALS
        INTO CHECK_EQUALS_REC;
      EXIT WHEN CHECK_EQUALS%NOTFOUND;
      -- wjc 本级兑付费差额：本级承担金额 * 兑付费率 / 100 - 本金承担兑付费  6720.68 - 6720.67  0.01
      V_BJDFF_MINUS_AMT := CHECK_EQUALS_REC.DFSXF_RATE * CHECK_EQUALS_REC.MINUS_CD_AMT / 100 -
                           CHECK_EQUALS_REC.MINUS_DFF_AMT;
      -- wjc 通过循环解决 上级承担金额计算的本级承担兑付费 - （上级承担兑付费-下级兑付费合计）金额 计算出的结果更新到 除本级外第一个区划中
      V_STR_BJDFF_SQL := ' UPDATE DEBT_T_ZQGL_DFJH T SET T.DFF_AMT = NVL(T.DFF_AMT,0) -  NVL(' || V_BJDFF_MINUS_AMT  ||
                         ',0), T.DFF_BAL_AMT =  0 - NVL(' || V_BJDFF_MINUS_AMT ||
                         ',0) WHERE T.DF_PLAN_ID = (SELECT DF_PLAN_ID FROM (SELECT ROW_NUMBER() OVER(ORDER BY AD_CODE) AS RN,' ||
                         ' DF_PLAN_ID FROM DEBT_T_ZQGL_DFJH WHERE ZQ_ID = ''' || V_ZQ_ID || ''' AND U_AD_CODE = ''' || V_AD_CODE ||
                         ''' AND PLAN_TYPE = ''' || CHECK_EQUALS_REC.PLAN_TYPE || ''' AND DF_END_DATE = ''' || CHECK_EQUALS_REC.DF_END_DATE ||
                         ''' ) WHERE RN = 1) ';
      EXECUTE IMMEDIATE V_STR_BJDFF_SQL; -- 浙江个性
      COMMIT;
    END LOOP;
    -- 通过一个sql解决 该循环暂时停用
    V_STR_BJDFF_SQL_NOLOOP := 'UPDATE DEBT_T_ZQGL_DFJH DFJH SET DFJH.DFF_AMT =
       DFJH.DFF_AMT - NVL(
       (SELECT BAL_DFF
          FROM (
             SELECT T.AD_CODE,
                    T.ZQ_ID,
                    T.PLAN_TYPE,
                    T.DF_END_DATE,
                    ZQXX.DFSXF_RATE * (T.CD_AMT - TMP.CD_AMT) / 100 - (T.DFF_AMT - TMP.DFF_AMT) BAL_DFF
               FROM DEBT_T_ZQGL_DFJH T
               LEFT JOIN DEBT_T_ZQGL_ZQXX ZQXX
                 ON ZQXX.ZQ_ID = T.ZQ_ID
               LEFT JOIN (SELECT SUM(CD_AMT) CD_AMT,
                                 SUM(DFF_AMT) DFF_AMT,
                                 SUM(PLAN_XZ_AMT) PLAN_XZ_AMT,
                                 SUM(PLAN_ZH_AMT) PLAN_ZH_AMT,
                                 SUM(PLAN_HB_AMT) PLAN_HB_AMT,
                                 PLAN_TYPE,
                                 DF_END_DATE,
                                 ZQ_ID,
                                 U_AD_CODE
                            FROM DEBT_T_ZQGL_DFJH T
                           GROUP BY PLAN_TYPE, DF_END_DATE, ZQ_ID, U_AD_CODE) TMP
                 ON T.PLAN_TYPE = TMP.PLAN_TYPE
                AND T.DF_END_DATE = TMP.DF_END_DATE
                AND T.ZQ_ID = TMP.ZQ_ID
                AND T.AD_CODE = TMP.U_AD_CODE
       ) TMP WHERE DFJH.ZQ_ID = TMP.ZQ_ID AND DFJH.U_AD_CODE = TMP.AD_CODE AND DFJH.PLAN_TYPE = TMP.PLAN_TYPE AND DFJH.DF_END_DATE = TMP.DF_END_DATE),0)
       WHERE DFJH.ZQ_ID = ''' || V_ZQ_ID || '''
         AND DFJH.AD_CODE = (SELECT MIN(AD_CODE) FROM DEBT_T_ZQGL_DFJH WHERE ZQ_ID = ''' ||
                              V_ZQ_ID || ''' AND U_AD_CODE = ''' ||
                              V_AD_CODE || ''')';
    --EXECUTE IMMEDIATE V_STR_BJDFF_SQL_NOLOOP; --暂时使用循环处理
    COMMIT;
  END IF;
END DEBT_P_BALANC_CAPITAL;
/