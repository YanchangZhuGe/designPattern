package com.example.apifox.enums;

/**
 * <p>Title:基础枚举</p>
 *
 * <p>Description:是否</p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author tangjiagang
 * @version 1.0
 * @since：2020/10/28 10:57
 */
public enum ResultTypeEnum {

    Tree(1, "树级结构"),
    List(0, "平铺结构");

    private Integer value;
    private String name;

    ResultTypeEnum(Integer value, String name) {
        this.value = value;
        this.name = name;
    }

    /**
     * 根据状态值获取状态名称
     * @param value
     * @return
     */
    public static String getNameByValue(Integer value) {
        if (value == null) {
            return null;
        }
        for (ResultTypeEnum yesOrNoEnum : values()) {
            if (yesOrNoEnum.getValue().equals(value)) {
                return yesOrNoEnum.getName();
            }
        }
        return null;
    }

    public Integer getValue() {
        return value;
    }

    public String getStrValue() {
        return String.valueOf(value);
    }

    public void setValue(Integer value) {
        this.value = value;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
