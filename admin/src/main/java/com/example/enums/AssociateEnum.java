package com.example.enums;

/**
 * <p>Title: 账户联网方式枚举</p>
 *
 * <p>Description: 账户联网方式枚举</p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author ym
 * @version 1.0
 * @Date: 2022/3/7 09:03
 **/
public enum AssociateEnum {
    /*** 非直联 **/
    AssociateFlag_0("0", "非直联"),
    /*** 银企直联 **/
    AssociateFlag_1("1", "银企直联"),
    /*** SWIFT方式 **/
    AssociateFlag_2("2", "SWIFT方式");

    private String code;
    private String name;

    AssociateEnum(String code, String name) {
        this.code = code;
        this.name = name;
    }

    public String getCode() {
        return code;
    }

    public String getName() {
        return name;
    }
}
