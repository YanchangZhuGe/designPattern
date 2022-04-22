package com.bgd.api;

import com.bgd.api.common.enums.ApiEnum;
import com.bgd.api.common.exceptions.ApiException;
import net.sf.json.JSONObject;

import java.util.List;
import java.util.Map;

/**
 * @author guodg
 * @date 2021/5/19 17:51
 * @description 接口日志记录服务接口
 */
public interface ApiLogService {
    /**
     * 保存接口日志
     *
     * @param reqMessage 请求报文
     * @param resMessage 响应报文
     * @param expMessage 异常信息
     * @param apiEnum    业务接口枚举
     */
    void saveLog(JSONObject reqMessage, JSONObject resMessage, String expMessage, ApiEnum apiEnum);

    /**
     * 保存接口要发送的数据到接口表
     *
     * @param inputList 数据集
     * @param table     表名
     * @return
     * @throws ApiException
     */
    void saveApiXchData(List<Map> inputList, String table) throws ApiException;
}
