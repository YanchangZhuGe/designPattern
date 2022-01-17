package com.bgd.api.jcyh.services;

import com.bgd.api.ApiLogService;
import com.bgd.api.ApiService;
import com.bgd.api.common.enums.ApiEnum;
import com.bgd.api.common.exceptions.ApiException;
import com.bgd.api.common.utils.EnumUtil;
import com.bgd.api.common.utils.JSONUtil;
import com.bgd.api.common.utils.QueryDBUtil;
import com.bgd.platform.util.dao.BgdDataSource;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import java.util.List;
import java.util.Map;

/**
 * @author guodg
 * @date 2021/5/12 14:15
 * @description 银行账户信息
 * 查询银行账户信息并返回
 */
public class YhzhApiServiceImpl implements ApiService {
    private BgdDataSource bgdDataSource;
    private ApiLogService apiLogService;

    public void setApiLogService(ApiLogService apiLogService) {
        this.apiLogService = apiLogService;
    }

    public void setBgdDataSource(BgdDataSource bgdDataSource) {
        this.bgdDataSource = bgdDataSource;
    }

    /**
     * @param message 请求报文
     * @param apiEnum 业务接口
     * @param xchCode 报文编码
     * @return
     * @throws Exception
     */
    @Override
    public JSONArray handle(JSONObject message, ApiEnum apiEnum, String xchCode) throws Exception {
        String queryTable = EnumUtil.getQueryTableByXchCode(xchCode, apiEnum);
        String storageTable = EnumUtil.getStorageTableByXchCode(xchCode, apiEnum);
        // 增量查询参数，数据更新时间
        String updateTime = QueryDBUtil.queryMaxUpdateTime(storageTable);
        String userCode = JSONUtil.getString(message, "USER_CODE");
        // 2.查询数据
        StringBuilder sql = new StringBuilder();
        sql.append(" SELECT T.* FROM ").append(queryTable).append(" T ");
        sql.append(" LEFT JOIN DEBT_T_JCYH_USER_BANK_AUTH AU ON T.ACC_BANK_ZH = AU.ACC_BANK_ZH ");
        sql.append(" WHERE 1=1 ");
        // 用户对银行总行访问授权过滤
        sql.append(" AND AU.USER_CODE = ? ");
        // 根据数据更新时间增量查询
        sql.append(" AND T.UPDATE_TIME > ?");
        List<Map> list = null;
        try {
            list = bgdDataSource.findBySql(sql.toString(), new Object[]{userCode, updateTime});
        } catch (Exception e) {
            throw new ApiException("银行账户信息查询失败", e);
        }
        // 先存接口表
        apiLogService.saveApiXchData(list, storageTable);
        // 构造报文返回
        return JSONArray.fromObject(list);
    }
}
