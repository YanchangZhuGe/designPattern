package com.bgd.api.common.enums;

import com.bgd.api.ApiMessageTemplate;
import com.bgd.api.ApiXchEnum;
import com.bgd.api.jcyh.enums.JcyhXchEnum;
import com.bgd.api.jcyh.template.GXDZApiMessageTemplateImpl;
import com.bgd.api.jcyh.template.JcyhApiMessageTemplateImpl;

/**
 * @author guodg
 * @date 2021/5/12 11:42
 * @description 业务接口枚举
 * 我们把提供服务的同一组业务抽象为一个业务接口，例如专项债券项目穿透式监测银行接口，其下提供对四种数据资源的访问，故可将其抽象为一个业务接口；
 * xchEnum字段，定义了该业务接口下供访问的资源数组（即报文）
 * apiMessageTemplate字段，定义了为该接口下的报文模板
 */
public enum ApiEnum {
    API_JCYH("JCYH", "监测银行接口服务", JcyhXchEnum.values(), new JcyhApiMessageTemplateImpl()),
    API_GXDZ_GD("API_GXDZ", "个性接口", JcyhXchEnum.values(), new GXDZApiMessageTemplateImpl());

    private String code;
    private String message;
    // 业务接口下的报文枚举集
    private ApiXchEnum[] xchEnum;
    // 提供接口模板
    private ApiMessageTemplate apiMessageTemplate;

    ApiEnum(String code, String message, ApiXchEnum[] xchEnum, ApiMessageTemplate apiMessageTemplate) {
        this.code = code;
        this.message = message;
        this.xchEnum = xchEnum;
        this.apiMessageTemplate = apiMessageTemplate;
    }

    public String getCode() {
        return code;
    }

    public String getMessage() {
        return message;
    }

    public ApiXchEnum[] getXchEnum() {
        return xchEnum;
    }

    public ApiMessageTemplate getApiMessageTemplate() {
        return apiMessageTemplate;
    }
}
