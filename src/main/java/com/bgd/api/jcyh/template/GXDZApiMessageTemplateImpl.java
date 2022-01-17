package com.bgd.api.jcyh.template;

import com.bgd.api.ApiMessageTemplate;
import net.sf.json.JSONObject;

/**
 * @author guodg
 * @date 2021/5/18 10:59
 * @description 监测银行业务接口报文结构
 * sbp/head
 * sbp/result
 * sbp/data
 */
public class GXDZApiMessageTemplateImpl implements ApiMessageTemplate {
    @Override
    public JSONObject getSuccessResponseMessageTemplate()
    {
        String jsonStr = "{\"DATA\":[],\"resultCode\":\"\",\"resultMessage\":\"\"}";
        return JSONObject.fromObject(jsonStr);
    }

    @Override
    public JSONObject getQuerySuccessResponseMessageTemplate()
    {
        String jsonStr = "{\"DATA\":[],\"resultCode\":\"\",\"resultMessage\":\"\"}";
        return JSONObject.fromObject(jsonStr);
    }

    @Override
    public JSONObject getFailureResponseMessageTemplate()
    {
        String jsonStr = "{\"DATA\":[],\"resultCode\":\"\",\"resultMessage\":\"\"}";
        return JSONObject.fromObject(jsonStr);
    }

    @Override
    public JSONObject getRequestMessageTemplate()
    {
        String jsonStr = "{\"DATA\":[],\"resultCode\":\"\",\"resultMessage\":\"\"}";
        return JSONObject.fromObject(jsonStr);
    }
}
