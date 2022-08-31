package designPattern.behavior.iterator.enums;

/**
 * <p>Title:是否收取保费枚举</p>
 *
 * <p>Description:是否</p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 */
public enum ChargePremiumEnum {

    YES(1, "是"),
    NO(2, "否");

    private Integer value;
    private String name;

    ChargePremiumEnum(Integer value, String name) {
        this.value = value;
        this.name = name;
    }

    /**
     * 根据状态值获取状态名称
     *
     * @param value
     * @return
     */
    public static String getNameByValue(Integer value) {
        if (value == null) {
            return null;
        }
        for (ChargePremiumEnum yesOrNoEnum : values()) {
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
