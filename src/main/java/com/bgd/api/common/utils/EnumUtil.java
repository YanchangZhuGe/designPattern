package com.bgd.api.common.utils;

import com.bgd.api.ApiService;
import com.bgd.api.ApiXchEnum;
import com.bgd.api.common.enums.ApiEnum;
import com.bgd.platform.util.service.SpringContextUtil;

/**
 * @author guodg
 * @date 2021/1/18 10:30
 * @description 枚举工具类
 */
public class EnumUtil {
    /**
     * 根据报文编码获取其具体业务实现类
     *
     * @param xchCode
     * @return
     */
    public static ApiService getApiServiceByXchCode(String xchCode, ApiEnum apiEnum) {
        ApiXchEnum[] xchEnum = apiEnum.getXchEnum();
        for (ApiXchEnum apiXchEnum : xchEnum) {
            String xchCode1 = apiXchEnum.getXchCode();
            if (xchCode1.equals(xchCode)) {
                String xchService = apiXchEnum.getXchService();
                ApiService apiService = (ApiService) SpringContextUtil.getBean(xchService);
                return apiService;
            }
        }
        // 若没有匹配的报文业务实现，则返回默认实现类
        return (ApiService) SpringContextUtil.getBean("notFoundApiService");
    }

    /**
     * 根据报文编码查询其数据来源表
     *
     * @param xchCode
     * @param apiEnum
     * @return
     */
    public static String getQueryTableByXchCode(String xchCode, ApiEnum apiEnum) {
        ApiXchEnum[] xchEnum = apiEnum.getXchEnum();
        for (ApiXchEnum apiXchEnum : xchEnum) {
            String xchCode1 = apiXchEnum.getXchCode();
            if (xchCode1.equals(xchCode)) {
                String queryTable = apiXchEnum.getQueryTable();
                return queryTable;
            }
        }
        return null;
    }

    /**
     * 根据报文编码获取其数据存储表
     *
     * @param xchCode
     * @param apiEnum
     * @return
     */
    public static String getStorageTableByXchCode(String xchCode, ApiEnum apiEnum) {
        ApiXchEnum[] xchEnum = apiEnum.getXchEnum();
        for (ApiXchEnum apiXchEnum : xchEnum) {
            String xchCode1 = apiXchEnum.getXchCode();
            if (xchCode1.equals(xchCode)) {
                String storageTable = apiXchEnum.getStorageTable();
                return storageTable;
            }
        }
        return null;
    }
}
