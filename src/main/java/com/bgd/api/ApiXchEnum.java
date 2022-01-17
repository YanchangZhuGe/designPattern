package com.bgd.api;

/**
 * @author guodg
 * @date 2021/5/13 14:09
 * @description 报文枚举类接口
 * 每个业务接口下，有多个报文枚举，我们要统一所有的报文枚举，提供查询报文编码以及其业务实现的方法
 */
public interface ApiXchEnum {
    /**
    * 接口所属地区
    */
    String getArea();

    /**
     * 查询报文编码
     *
     * @return
     */
    String getXchCode();

    /**
     * 获取报文业务实现类
     *
     * @return
     */
    String getXchService();

    /**
     * 获取数据来源表
     *
     * @return
     */
    String getQueryTable();

    /**
     * 获取数据存储表
     *
     * @return
     */
    String getStorageTable();
}
