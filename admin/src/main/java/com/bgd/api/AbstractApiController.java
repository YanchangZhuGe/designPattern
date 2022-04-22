package com.bgd.api;

import com.bgd.api.common.enums.ApiEnum;
import com.bgd.api.common.exceptions.ApiException;
import com.bgd.api.common.security.check.ApiCheckService;
import com.bgd.api.common.utils.ExceptionUtil;
import com.bgd.api.common.utils.JSONUtil;
import com.bgd.api.common.utils.MessageUtil;
import net.sf.json.JSON;
import net.sf.json.JSONObject;

import javax.servlet.http.HttpServletRequest;

/**
 * @author guodg
 * @date 2021/5/12 14:00
 * @description
 */
public abstract class AbstractApiController {
    // 日志记录服务
    protected ApiLogService apiLogService;
    // 接口校验服务
    protected ApiCheckService apiCheckService;

    /**
     * 资源注入，每个业务接口的日志记录服务、请求校验服务可能不通，
     * 故我们在实现该抽象类时，可实现该<>init</>方法，为特定业务接口配置不同的日志服务和校验服务
     */
    protected abstract void init();

    /**
     * 接口具体服务方法
     *
     * @param message 请求内容
     * @param request 请求对象
     * @param apiEnum 提供服务的业务接口
     * @return
     */
    protected JSONObject service(JSONObject message, HttpServletRequest request, ApiEnum apiEnum) {
        // 调用初始化方法，注入资源
        init();
        String xchCode = "";
        JSONObject resMessage = null;
        String expMessage = null;
        try {
            //1.安全性校验 去除xss攻击
            message = stripXss(message);
            // 报文编码
            xchCode = JSONUtil.getString(message, "XCH_CODE");
            // 用户编码
            String userCode = JSONUtil.getString(message, "USER_CODE");
            // 请求IP
            String ipAddr = "";//HttpTool.getIpAddr(request);
            // 校验
            apiCheckService.messageSecurityVerification(message, ipAddr, apiEnum);
            // 校验通过，根据报文编码，获取其具体业务实现类
            ApiService apiService = EnumUtil.getApiServiceByXchCode(xchCode, apiEnum);
            // 处理业务请求，返回处理结果
            JSON data = apiService.handle(message, apiEnum, xchCode);
            // 封装加密的成功结果报文
            resMessage = MessageUtil.encryptQuerySuccessResultMessage(apiEnum, xchCode, userCode, data);
        } catch (ApiException e) {
            // 校验失败，返回校验失败报文
            resMessage = MessageUtil.failureResultMessage(apiEnum, xchCode, e.getCode(), e.getShowMessage());
            expMessage = e.toString();
        } catch (Exception e) {
            // 其它原因导致的失败，截取部分异常信息返回
            resMessage = MessageUtil.generalFailureResultMessage(apiEnum, xchCode, ExceptionUtil.substrMessage(e));
            expMessage = e.toString();
        } finally {
            // 最终记录日志
            apiLogService.saveLog(message, resMessage, expMessage, apiEnum);
        }
        return resMessage;
    }

    /**
     * 个性定制接口服务
     *
     * @param message 请求内容
     * @param request 请求对象
     * @param apiEnum 提供服务的业务接口
     * @return
     */
    protected JSONObject GXDZService(JSONObject message, HttpServletRequest request, ApiEnum apiEnum)
    {
        // 基础流程-初始化bean工厂
        init();

        String APICode = "";
        String APIArea = "";
        JSONObject resMessage = null;
        String expMessage = null;

        try
        {
            // 基础流程-安全性校验 去除xss攻击
            message = stripXss(message);
            // 获取接口编码,所属区划
            APICode = getAPICode(message, APICode);
            // 校验通过，根据报文编码，获取其具体业务实现类
            ApiService apiService = EnumUtil.getApiServiceByXchCode(APICode, apiEnum);
            // 处理业务请求，返回处理结果
            JSON data = apiService.handle(message, apiEnum, APICode);
            // 封装加密的成功结果报文
            resMessage = MessageUtil.GXDZQuerySuccessResultMessage(apiEnum, APICode, data);
        } catch (ApiException e)
        {
            // 校验失败，返回校验失败报文
            resMessage = MessageUtil.failureResultMessage(apiEnum, APICode, e.getCode(), e.getShowMessage());
            expMessage = e.toString();
        } catch (Exception e)
        {
            // 其它原因导致的失败，截取部分异常信息返回
            resMessage = MessageUtil.generalFailureResultMessage(apiEnum, APICode, ExceptionUtil.substrMessage(e));
            expMessage = e.toString();
        } finally
        {
            // 最终记录日志
            apiLogService.saveLog(message, resMessage, expMessage, apiEnum);
        }
        return resMessage;
    }

    public String getAPICode(JSONObject message, String APICode)
    {

        // 报文编码
        APICode = JSONUtil.getString(message, "XCH_CODE");
        if (APICode.length() == 0)
        {
            // 兼容不同接口编码
            APICode = JSONUtil.getString(message, "dtgCode");
        }

        return APICode;
    }

    public String getAPIArea(JSONObject message, String APIArea)
    {

        // 报文编码
        APIArea = JSONUtil.getString(message, "ADCode");
        if (APIArea.length() == 0)
        {
            // 兼容不同区划
            APIArea = JSONUtil.getString(message, "mofDivCode");
        }

        // 取省级区划
        if (APIArea.length() > 1)
        {
            APIArea = APIArea.substring(0, 2);
        }

        return APIArea;
    }

    /**
     * 剥夺XSS攻击
     *
     * @param message
     * @return
     */
    protected JSONObject stripXss(JSONObject message) {
        String stripXss = "";//AccessControl.stripXss(message.toString());
        stripXss = "";//AccessControl.stripXssSql(stripXss);
        return JSONObject.fromObject(stripXss);
    }
}
