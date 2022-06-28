package com.example.enums;

import com.nstc.ptms.validate.EnumValueLister;

/**
 * <p>Title:判断枚举：0-否 1-是</p>
 *
 * <p>Description:判断枚举：0-否 1-是</p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author
 * @version 1.0
 * @since：2021/1/21 14:28
 */
public enum YesOrNoEnum implements EnumValueLister {

    NO(0, "否"),
    YES(1, "是");

    private final Integer key;
    private final String name;

    YesOrNoEnum(Integer key, String name) {
        this.key = key;
        this.name = name;
    }

    /**
     * 判断状态值是否正确
     *
     * @param state 状态
     * @return true 正确 false-错误
     */
    public static boolean legalState(Integer state) {
        return state != null && (NO.getKey().equals(state) || YES.getKey().equals(state));
    }

    public static String getName(Integer key) {
        for (YesOrNoEnum e : values()) {
            if (e.key.equals(key)) {
                return e.name;
            }
        }
        return "";
    }

    public Integer getKey() {
        return key;
    }

    public boolean getBoolean() {
        return this.equals(YES) ? true : false;
    }

    public static YesOrNoEnum YesOrNo(String key) {
        return YES.getKey().toString().equals(key) ? YES : NO;
    }

    public String getName() {
        return name;
    }

    public static Integer[] exhaustiveList() {
        return new Integer[]{YES.getKey(), NO.getKey(), null};
    }

    public boolean compareVal(Integer value) {
        if (value == null) {
            return false;
        }
        return this.key.equals(value);
    }

}
