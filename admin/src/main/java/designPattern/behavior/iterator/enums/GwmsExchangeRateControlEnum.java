package designPattern.behavior.iterator.enums;

/**
 * 汇率浮动，固定枚举类
 */
public enum GwmsExchangeRateControlEnum implements TypeEnum {

    FIXED("0", "固定汇率"),

    FLOAT("1", "浮动汇率");

    private String value;

    private String name;

    GwmsExchangeRateControlEnum(String value, String name) {
        this.value = value;
        this.name = name;
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
