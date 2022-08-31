package designPattern.behavior.iterator.enums;

/**
 * <p>Title: 担保合同性质枚举</p>
 * <p>Description: 担保合同性质枚举</p>
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author zengshaoqi
 * @since 2020/2/25 10:23
 */
public enum GuaranteeNatureEnum implements TypeEnum {
    /**
     * 一般担保
     */
    GENERAL("一般担保", 1),
    /**
     * 最高额担保
     */
    MAXIMUM("最高额担保", 2);

    /**
     * 合同性质名称
     */
    private String name;
    /**
     * 合同性质编码
     */
    private Integer value;

    GuaranteeNatureEnum(String name, Integer value) {
        this.name = name;
        this.value = value;
    }

    public static String getNameByValue(Integer val) {
        if (val == null) {
            return null;
        }

        for (GuaranteeNatureEnum temp : values()) {
            if (temp == null) {
                continue;
            }

            Integer value = temp.getValue();
            if (value == null) {
                continue;
            }

            if (value.equals(val)) {
                return temp.getName();
            }
        }
        return null;
    }

    @Override
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Override
    public Integer getValue() {
        return value;
    }

    public void setValue(Integer value) {
        this.value = value;
    }
}
