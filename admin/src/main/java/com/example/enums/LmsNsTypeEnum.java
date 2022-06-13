package com.example.enums;

/**
 * <p>
 * Title:
 * </p>
 *
 * <p>
 * Description:操作状态枚举
 * </p>
 *
 * <p>
 * Company: 北京九恒星科技股份有限公司
 * </p>
 *
 * @author chenlu
 * @since：2016-8-8 下午01:18:33
 */

public enum LmsNsTypeEnum {
    N_00(0, "财务公司"),
    N_01(1, "成员单位"),
    N_02(2, "金融机构"),
    N_03(3, "其他合作伙伴"),
    N_04(4, "集团公司"),
    N_05(5, "结算中心");

    LmsNsTypeEnum(Integer key, String name) {
        this.key = key;
        this.name = name;
    }

    private Integer key;
    private String name;

    public Integer getKey() {
        return key;
    }

    public void setKey(Integer key) {
        this.key = key;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
