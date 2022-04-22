package com.bgd.api;

import net.sf.json.JSONObject;

/**
 * @author guodg
 * @date 2021/5/18 10:25
 * @description 接口数据传输，报文模板
 * 每个业务接口，都可能有自定义报文传输模板，对此，我们只需在每个业务接口下实现该接口，并实现其中的报文构造方法，
 * 我们的通用报文操作工具类，就可以使用该模板来操作报文结构
 */
public interface ApiMessageTemplate {
    /**
     * 构造成功响应报文并返回
     *
     * @return
     */
    JSONObject getSuccessResponseMessageTemplate();

    /**
     * 构造查询请求成功响应报文并返回
     * 报文中包含查询的结果数据集
     *
     * @return
     */
    JSONObject getQuerySuccessResponseMessageTemplate();

    /**
     * 构造失败响应报文并返回
     *
     * @return
     */
    JSONObject getFailureResponseMessageTemplate();

    /**
     * 构造请求报文并返回
     *
     * @return
     */
    JSONObject getRequestMessageTemplate();


}
