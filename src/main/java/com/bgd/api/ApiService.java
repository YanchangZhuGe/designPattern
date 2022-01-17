package com.bgd.api;

import com.bgd.api.common.enums.ApiEnum;
import net.sf.json.JSON;
import net.sf.json.JSONObject;

/**
 * @author guodg
 * @date 2021/5/12 13:58
 * @description 接口业务处理抽象接口
 * 该抽象类封装了异常处理及日志记录的操作，针对具体业务，我们只用关注业务实现即可
 */
public interface ApiService {
    /**
     * 真正做业务处理的方法，改方法有handler方法调用
     * 1.如果是查询业务，则返回查询结果集
     * 2.如果是保存数据业务，则返回保存成功信息
     *
     * @param message 请求报文
     * @param apiEnum 业务接口
     * @param xchCode 报文编码
     * @return 返回JSON格式对象，若是查询接口，则应返回JSONArray数组，
     * 若是数据保存接口，则可根据情况返回JSONObject类型响应信息，或者返回null
     */
    JSON handle(JSONObject message, ApiEnum apiEnum, String xchCode) throws Exception;

}
