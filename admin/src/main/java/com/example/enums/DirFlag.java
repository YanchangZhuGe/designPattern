/*================================================================================
 * DirFlagEnum.java
 * 生成日期：2014-5-1 下午08:41:12
 * 作          者：杨庆祥
 * 项          目：FBCM03
 * (C)COPYRIGHT BY NSTC.
 * ================================================================================
 */
package com.example.enums;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * <p>
 * Title:记录方向枚举类
 * </p>
 *
 * <p>
 * Description:
 * </p>
 *
 * <p>
 * Company: 北京九恒星科技股份有限公司
 * </p>
 *
 * @author 杨庆祥
 * @version 1.0
 * @since： 2014-5-1 下午08:41:12
 */
public enum DirFlag {

    PLUS("+", 1, "正向"),
    MINUS("-", -1, "负向");

    private String value;
    private Integer code;
    private String name;

    DirFlag(String value, Integer code, String name) {
        this.value = value;
        this.code = code;
        this.name = name;
    }

    public String getValue() {
        return value;
    }

    public String getName() {
        return name;
    }

    public Integer getCode() {
        return code;
    }

    /**
     * @param code String
     * @return ApplyStatus
     * @Description: 根据值取得状态
     * @author 杨庆祥
     * @since 2018年3月28日 下午5:51:49
     */
    public static DirFlag getEnum(String value) {
        for (DirFlag c : values()) {
            if (c.getValue().equals(value)) {
                return c;
            }
        }
        return null;
    }

    /**
     * @param code String
     * @return String
     * @Description: 根据值取得枚举的描述
     * @author 杨庆祥
     * @since 2018年3月28日 下午5:51:49
     */
    public static String getEnumName(String value) {
        for (DirFlag c : values()) {
            if (c.getValue().equals(value)) {
                return c.getName();
            }
        }
        return null;
    }

    /**
     * 返回枚举列表列表
     *
     * @return
     */
    public static List<Map<String, Object>> getList() {
        List<Map<String, Object>> list = new ArrayList<>();
        for (DirFlag e : values()) {
            Map<String, Object> v = new HashMap<>();
            v.put("value", e.getValue());
            v.put("name", e.getName());
            list.add(v);
        }
        return list;
    }
}
