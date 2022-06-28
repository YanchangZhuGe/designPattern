package com.example.enums;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * <p>Title: 账户付款方式枚举</p>
 *
 * <p>Description: 账户付款方式枚举</p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author tjg
 * @version 1.0
 * @since：2021/9/18 11:24
 */
public enum AccountPayTypeEnum {

    /**
     * 非直联付款
     */
    ACCOUNT_OFFLINE("10105", "非直联付款"),
    /**
     * 直接转发银行
     */
    ACCOUNT_DIRECT("10106", "直接转发银行"),
    /**
     * 先下拨后支出
     */
    ACCOUNT_WHEEL("10107", "先下拨后支出"),
    /**
     * 差额下拨
     */
    ACCOUNT_MARGIN_FINANCING("10110", "差额下拨");

    private final String code;
    private final String name;

    AccountPayTypeEnum(String code, String name) {
        this.code = code;
        this.name = name;
    }

    public String getCode() {
        return code;
    }

    public String getName() {
        return name;
    }

    public static String getName(String code) {
        if (code == null) {
            return null;
        }
        for (AccountPayTypeEnum accountPayTypeEnum : values()) {
            if (accountPayTypeEnum.getCode().equals(code)) {
                return accountPayTypeEnum.getName();
            }
        }
        return null;
    }

    public static List<Map<String, String>> getDropDownValues() {
        ArrayList<Map<String, String>> dropDownValue = new ArrayList<>(4);
        for (AccountPayTypeEnum typeEnum : values()) {
            HashMap<String, String> issueTypeMap = new HashMap<>(1);
            issueTypeMap.put("issueType", typeEnum.code);
            issueTypeMap.put("issueTypeName", typeEnum.name);
            dropDownValue.add(issueTypeMap);
        }
        return dropDownValue;
    }
}
