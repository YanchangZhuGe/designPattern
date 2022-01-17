package com.bgd.api.common.security.check;

import com.bgd.api.common.enums.ApiEnum;
import com.bgd.api.common.exceptions.ApiException;
import net.sf.json.JSONObject;

/**
 * @author guodg
 * @date 2021/5/19 17:52
 * @description 请求校验服务接口
 */
public interface ApiCheckService {
    /**
     * @param message 请求报文
     * @param ipAddr  ip地址
     * @param apiEnum 业务接口枚举
     * @throws ApiException
     */
    void messageSecurityVerification(JSONObject message, String ipAddr, ApiEnum apiEnum) throws ApiException;
}
