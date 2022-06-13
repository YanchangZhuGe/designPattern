package com.example.enums;

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
public enum LmsYesOrNoEnum {

    YES(1, "是"),
    NO(0, "否");

    private Integer value;
    private String name;

    LmsYesOrNoEnum(Integer value, String name) {
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
        for (LmsYesOrNoEnum lmsYesOrNoEnum : values()) {
            if (lmsYesOrNoEnum.getValue().equals(value)) {
                return lmsYesOrNoEnum.getName();
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
