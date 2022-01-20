package com.bgd.api.common.utils;

import com.bgd.api.common.enums.ApiEnum;
import com.bgd.api.common.enums.ApiStatusEnum;
import com.bgd.api.common.exceptions.ApiException;
import com.bgd.api.common.security.arithmetic.EncDecUtils;
import net.sf.json.JSON;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.apache.commons.collections.MapUtils;

import java.util.Map;

/**
 * @author : guodg
 * @date : 2020/7/10
 */
public class MessageUtil {
    /**
     * 校验类失败报文
     *
     * @param xchCode
     * @param code
     * @param message
     * @return
     */
    public static JSONObject failureResultMessage(ApiEnum apiEnum, String xchCode, String code, String message) {
        JSONObject messageTemplate = apiEnum.getApiMessageTemplate().getFailureResponseMessageTemplate();
        assignValues(messageTemplate, xchCode, "", "", null, code, message);
        return messageTemplate;
    }

    /**
     * 通用类失败报文
     *
     * @param xchCode
     * @param errorMsg
     * @return
     */
    public static JSONObject generalFailureResultMessage(ApiEnum apiEnum, String xchCode, String errorMsg) {
        return failureResultMessage(apiEnum, xchCode, ApiStatusEnum.RES_FAILURE.getCode(), errorMsg);
    }

    /**
     * 简单成功报文
     *
     * @param xchCode
     * @return
     */
    public static JSONObject successResultMessage(ApiEnum apiEnum, String xchCode) {
        JSONObject messageTemplate = apiEnum.getApiMessageTemplate().getSuccessResponseMessageTemplate();
        assignValues(messageTemplate, xchCode, "", "", null, ApiStatusEnum.RES_SUCCESS.getCode(), ApiStatusEnum.RES_SUCCESS.getMessage());
        return messageTemplate;
    }

    /**
     * 查询结果成功报文
     *
     * @param xchCode
     * @param JSONdata    若是查询业务，则表示查询结果集，若是其它业务，可以为null
     * @return
     */
    public static JSONObject querySuccessResultMessage(ApiEnum apiEnum, String xchCode, JSON JSONdata) {
        JSONObject messageTemplate = apiEnum.getApiMessageTemplate().getQuerySuccessResponseMessageTemplate();
        assignValues(messageTemplate, JSONdata, ApiStatusEnum.RES_SUCCESS.getCode(), ApiStatusEnum.RES_SUCCESS.getMessage());
        return messageTemplate;
    }

    /**
     * 返回数据部分加密后的成功报文
     *
     * @param xchCode  报文编码
     * @param userCode 访问用户编码
     * @param data     数据
     * @return
     */
    public static JSONObject encryptQuerySuccessResultMessage(ApiEnum apiEnum, String xchCode, String userCode, JSON data) throws ApiException {
        JSONObject resultMessage = querySuccessResultMessage(apiEnum, xchCode, data);
        return encryptMessage(resultMessage, userCode);
    }

    /**
     * 返回数据部分加密后的成功报文
     *
     * @param xchCode  报文编码
     * @param data     数据
     * @return
     */
    public static JSONObject GXDZQuerySuccessResultMessage(ApiEnum apiEnum, String xchCode, JSON data) throws ApiException {
        // 暂定不做加密处理
        JSONObject resultMessage = querySuccessResultMessage(apiEnum, xchCode, data);
        return resultMessage;
    }

    /**
     * 报文解密 根据报文中的用户加密信息配置，解密数据部分，如果有的话
     * 只加密报文中的DATA部分，如果有则加密，否则不加密
     *
     * @param message
     * @return
     */
    public static JSONObject encryptMessage(JSONObject message, String userCode) throws ApiException {
        // 只对数据部分加密
        if (JSONUtil.containsKey(message, "DATA")) {
            try {
                // 报文数据体
                String data = JSONUtil.getString(message, "DATA");
                // 用户配置
                Map userConfig = QueryDBUtil.queryUserConfig(userCode);
                // 加密要素
                String encSf = MapUtils.getString(userConfig, "ENC_SF");
                String encKey = MapUtils.getString(userConfig, "ENC_KEY");
                // 加密
                String encData = EncDecUtils.getEncString(encKey, encSf, data);
                // 将加密后数据替换
                JSONUtil.updateIfExists(message, "DATA", encData);
            } catch (Exception e) {
                throw new ApiException("报文加密失败！", e);
            }
        }
        return message;
    }

    /**
     * 解密报文
     * 只解密报文中的DATA部分，如果有则解密，否则不解密
     *
     * @param message
     * @param userCode
     * @return
     */
    public static JSONObject decryptMessage(JSONObject message, String userCode) throws ApiException {
        // 只对数据部分加密
        if (JSONUtil.containsKey(message, "DATA")) {
            try {
                // 报文数据体
                String data = JSONUtil.getString(message, "DATA");
                // 用户配置
                Map userConfig = QueryDBUtil.queryUserConfig(userCode);
                // 解密要素
                String encSf = MapUtils.getString(userConfig, "ENC_SF");
                String decKey = MapUtils.getString(userConfig, "DEC_KEY");
                // 解密
                String decData = EncDecUtils.getDecString(decKey, encSf, data);
                // 将解密后数据替换
                JSONUtil.updateIfExists(message, "DATA", decData);
            } catch (Exception e) {
                throw new ApiException("报文解密失败！", e);
            }
        }
        return message;

    }

    /**
     * 为报文对象中的一些元素赋值
     *
     * @param jsonObject
     * @param xchCode    报文编码
     * @param userCode   用户编码
     * @param password   用户密码
     * @param data       返回数据
     * @param code       返回结果编码
     * @param message    返回结果描述
     */
    public static void assignValues(JSONObject jsonObject, String xchCode, String userCode, String password, JSON data, String code, String message) {
        // 报文id
        JSONUtil.updateIfExists(jsonObject, "GUID", QueryDBUtil.createMessageId());
        JSONUtil.updateIfExists(jsonObject, "XCH_CODE", xchCode);
        JSONUtil.updateIfExists(jsonObject, "USER_CODE", userCode);
        JSONUtil.updateIfExists(jsonObject, "PSD", password);
        // 报文时间戳
        JSONUtil.updateIfExists(jsonObject, "TIMESTAMP", QueryDBUtil.createTimeStamp());
        if (data != null) {
            JSONUtil.updateIfExists(jsonObject, "DATA", data);
        }
        JSONUtil.updateIfExists(jsonObject, "CODE", code);
        JSONUtil.updateIfExists(jsonObject, "MESSAGE", message);
    }
    /**
     * 为报文对象中的一些元素赋值
     *
     * @param jsonObject
     * @param JSONdata       返回数据
     * @param code       返回结果编码
     * @param message    返回结果描述
     */
    public static void assignValues(JSONObject jsonObject, JSON JSONdata, String code, String message) {
        JSONObject jsonData = (JSONObject) JSONdata;
        JSONArray DATA = (JSONArray) jsonData.get("DATA");
        JSONObject params = (JSONObject) jsonData.get("params");
        // 广东返回的结果
        jsonObject.put("dtgCode", params.get("dtgCode"));
        jsonObject.put("mofDivCode", params.get("mofDivCode"));
        jsonObject.put("XM_NAME", params.get("XM_NAME"));
        jsonObject.put("USCCODE", params.get("USCCODE"));
        if (DATA != null) {
            JSONUtil.updateIfExists(jsonObject, "DATA", DATA);
        }
        JSONUtil.updateIfExists(jsonObject, "resultCode", code);
        JSONUtil.updateIfExists(jsonObject, "resultMessage", message);
        // 广东新增
    }
}
