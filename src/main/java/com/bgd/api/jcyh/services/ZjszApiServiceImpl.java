package com.bgd.api.jcyh.services;

import com.bgd.api.ApiLogService;
import com.bgd.api.ApiService;
import com.bgd.api.common.enums.ApiEnum;
import com.bgd.api.common.exceptions.ApiException;
import com.bgd.api.common.utils.EnumUtil;
import com.bgd.api.common.utils.JSONUtil;
import com.bgd.platform.util.dao.BgdDataSource;
import net.sf.json.JSONObject;

import java.util.List;
import java.util.Map;

/**
 * @author guodg
 * @date 2021/5/12 16:20
 * @description 账户资金收支明细接收业务
 */
public class ZjszApiServiceImpl implements ApiService {
    private BgdDataSource bgdDataSource;
    private ApiLogService apiLogService;

    public void setApiLogService(ApiLogService apiLogService) {
        this.apiLogService = apiLogService;
    }

    public void setBgdDataSource(BgdDataSource bgdDataSource) {
        this.bgdDataSource = bgdDataSource;
    }

    @Override
    public JSONObject handle(JSONObject message, ApiEnum apiEnum, String xchCode) throws Exception {
        // 数据保存接口表
        String storageTable = EnumUtil.getStorageTableByXchCode(xchCode, apiEnum);
        List<Map> mapList = JSONUtil.getMapList(message, "DATA");
        if (mapList == null || mapList.isEmpty()) {
            throw new ApiException("账户资金收支明细数据为空！");
        }
        // 数据保存到接口表
        apiLogService.saveApiXchData(mapList, storageTable);
        return null;
    }
}
