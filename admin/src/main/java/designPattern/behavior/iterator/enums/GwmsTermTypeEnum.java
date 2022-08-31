package designPattern.behavior.iterator.enums;

/**
 * 期限，1日，2月，3年
 */
public enum GwmsTermTypeEnum implements TypeEnum {

    /**
     * 年
     */
    YEAR("3", "年"),
    /**
     * 天
     */
    MONTH("2", "月"),
    /**
     * 天
     */
    DAY("1", "日");

    private String value;

    private String name;

    GwmsTermTypeEnum(String value, String name) {
        this.value = value;
        this.name = name;
    }

    public static String getNameByValue(String value) {
        if (value == null) {
            return null;
        }

        for (GwmsTermTypeEnum temp : values()) {
            if (temp == null) {
                continue;
            }

            if (value.equals(temp.getValue())) {
                return temp.getName();
            }
        }

        return null;
    }

    @Override
    public String getValue() {
        return value;
    }

    @Override
    public String getName() {
        return name;
    }
}
