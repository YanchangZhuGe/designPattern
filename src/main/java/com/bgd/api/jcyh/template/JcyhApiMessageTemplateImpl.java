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
public class JcyhApiMessageTemplateImpl implements ApiMessageTemplate {
    @Override
    public JSONObject getSuccessResponseMessageTemplate() {
        String jsonStr = "{\"SBP\":{\"HEAD\":{\"GUID\":\"\",\"XCH_CODE\":\"\"},\"RESULT\":{\"CODE\":\"\",\"MESSAGE\":\"\"}}}";
        return JSONObject.fromObject(jsonStr);
    }

    @Override
    public JSONObject getQuerySuccessResponseMessageTemplate() {
        String jsonStr = "{\"SBP\":{\"HEAD\":{\"GUID\":\"\",\"XCH_CODE\":\"\"},\"DATA\":{},\"RESULT\":{\"CODE\":\"\",\"MESSAGE\":\"\"}}}";
        return JSONObject.fromObject(jsonStr);
    }

    @Override
    public JSONObject getFailureResponseMessageTemplate() {
        String jsonStr = "{\"SBP\":{\"HEAD\":{\"GUID\":\"\",\"XCH_CODE\":\"\"},\"RESULT\":{\"CODE\":\"\",\"MESSAGE\":\"\"}}}";
        return JSONObject.fromObject(jsonStr);
    }

    @Override
    public JSONObject getRequestMessageTemplate() {
        String jsonStr = "{\"SBP\":{\"HEAD\":{\"GUID\":\"\",\"XCH_CODE\":\"\",\"USER_CODE\":\"\",\"PSD\":\"\",\"TIMESTAMP\":\"\"},\"DATA\":{}}}";
        return JSONObject.fromObject(jsonStr);
    }
}
