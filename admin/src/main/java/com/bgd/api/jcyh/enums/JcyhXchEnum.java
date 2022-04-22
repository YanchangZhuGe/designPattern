package com.bgd.api.jcyh.enums;

import com.bgd.api.ApiXchEnum;

/**
 * @author guodg
 * @date 2021/5/12 13:45
 * @description 监测银行业务接口下的报文枚举
 */
public enum JcyhXchEnum implements ApiXchEnum {
    YHZH("COMMON","1001", "银行账户信息", "yhzhApiService", "DEBT_V_API_JCYH_YHZH", "DEBT_T_API_JCYH_YHZH"),
    ZJSZ("COMMON","1002", "资金收支信息", "zjszApiService", "", "DEBT_T_API_JCYH_ZJSZ"),
    WGYD("COMMON","1003", "违规疑点信息", "wgydApiService", "", "DEBT_T_API_JCYH_WGYD"),
    ZHQR("COMMON","1004", "银行账户信息确认", "zhqrApiService", "", "DEBT_T_API_JCYH_ZHQR"),
    GD_ZQXM("GD","DI_0001_0001", "债券项目查询接口_广东", "zqxmApiServiceImpl", "DEBT_V_ZQXMXX_YFZ", "");
    private String area;
    private String xchCode;
    private String message;
    // 接口业务实现
    private String xchService;
    // 接口数据来源表
    private String queryTable;
    // 接口数据存储表
    private String storageTable;

    JcyhXchEnum(String area,String xchCode, String message, String xchService, String queryTable, String storageTable) {
        this.area = area;
        this.xchCode = xchCode;
        this.message = message;
        this.xchService = xchService;
        this.queryTable = queryTable;
        this.storageTable = storageTable;
    }

    @Override
    public String getArea() {
        return area;
    }

    @Override
    public String getXchCode() {
        return xchCode;
    }

    public String getMessage() {
        return message;
    }

    @Override
    public String getXchService() {
        return xchService;
    }

    @Override
    public String getQueryTable() {
        return queryTable;
    }

    @Override
    public String getStorageTable() {
        return storageTable;
    }
}
