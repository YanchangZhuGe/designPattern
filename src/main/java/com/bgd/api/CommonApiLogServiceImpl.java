package com.bgd.api;

import com.bgd.api.common.enums.ApiEnum;
import com.bgd.api.common.exceptions.ApiException;
import com.bgd.api.common.utils.JSONUtil;
import com.bgd.api.common.utils.QueryDBUtil;
import com.bgd.platform.util.common.StringTool;
import com.bgd.platform.util.dao.BgdDataSource;
import net.sf.json.JSONObject;

import java.util.List;
import java.util.Map;

/**
 * @author guodg
 * @date 2021/5/12 16:35
 * @description 接口日志记录服务
 */
public class CommonApiLogServiceImpl implements ApiLogService {
    private BgdDataSource bgdDataSource;

    public void setBgdDataSource(BgdDataSource bgdDataSource) {
        this.bgdDataSource = bgdDataSource;
    }

    /**
     * 保存接口访问日志
     *
     * @param reqMessage 请求报文
     * @param resMessage 响应报文
     * @param expMessage 异常信息
     * @param apiEnum    提供服务的业务接口
     */
    @Override
    public void saveLog(JSONObject reqMessage, JSONObject resMessage, String expMessage, ApiEnum apiEnum) {
        StringBuilder sql = new StringBuilder();
        sql.append(" INSERT INTO DEBT_T_API_ACCESS_LOG(LOG_ID,USER_CODE,API_CODE,XCH_CODE,REQ_MESSAGE,RES_MESSAGE,EXP_MESSAGE,CREATE_TIME,UPDATE_TIME,IS_DELETED) ");
        sql.append(" VALUES(SYS_GUID(),?,?,?,?,?,?,TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS'),TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS'),2) ");
        try {
            String userCode = JSONUtil.getString(reqMessage, "USER_CODE");
            String xchCode = JSONUtil.getString(reqMessage, "XCH_CODE");
            String apiCode = apiEnum.getCode();
            String reqHead = JSONUtil.getString(reqMessage, "HEAD");
            String resResult = JSONUtil.getString(resMessage, "RESULT");
            bgdDataSource.updateBySql(sql.toString(), new Object[]{userCode, apiCode, xchCode, reqHead, resResult, expMessage});
        } catch (Exception e) {
            try {
                bgdDataSource.updateBySql(sql.toString(), new Object[]{"", "", "", "", "", e.toString()});
            } catch (Exception e2) {
                e2.printStackTrace();
            }
        }
    }

    /**
     * 保存接口要发送的数据到接口表
     *
     * @param inputList 数据集
     * @param table     表名
     * @return
     * @throws ApiException
     */
    @Override
    public void saveApiXchData(List<Map> inputList, String table) throws ApiException {
        if (!inputList.isEmpty() && !StringTool.isNull(table)) {
            try {
                Object[] fields = QueryDBUtil.getMaxRowFields(inputList);
                if (fields.length > 0) {
                    // 拼接sql
                    String sql = QueryDBUtil.spliceInsertStatement(table, fields);
                    // 入库
                    bgdDataSource.updateByBatchParamSqlTransformEmpty(sql, inputList, fields);
                    // 打印日志
                    System.out.println("操作表：" + table + "，插入" + inputList.size() + "数据！");
                }
            } catch (Exception e) {
                e.printStackTrace();
                throw new ApiException("数据入库失败！", e);
            }
        }
    }
}
