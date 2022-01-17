package com.bgd.api;

import com.bgd.api.common.enums.ApiEnum;
import net.sf.json.JSONObject;

/**
 * @author guodg
 * @date 2021/5/12 16:52
 * @description
 */
public class NotFoundApiServiceImpl implements ApiService {

    @Override
    public JSONObject handle(JSONObject message, ApiEnum apiEnum, String xchCode) {
        return MessageUtil.generalFailureResultMessage(apiEnum, xchCode, "不存在的业务接口服务！");
    }
}
