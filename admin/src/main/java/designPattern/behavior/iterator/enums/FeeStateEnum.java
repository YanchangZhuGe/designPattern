package designPattern.behavior.iterator.enums;

/**
 * <p>
 * Title:
 * </p>
 *
 * <p>
 * Description:保费缴纳状态
 * </p>
 *
 * <p>
 * Company: 北京九恒星科技股份有限公司
 * </p>
 *
 * @author lj
 * @version 1.0
 * @since：2018年2月27日 下午3:21:11
 */
public enum FeeStateEnum implements TypeEnum {

    /**
     * 未缴清
     */
    UNPAID(0, "未缴清"),
    /**
     * 已缴清
     */
    PAID(1, "已缴清"),
    /**
     * 已免收
     */
    EXEMPT(2, "已免收"),
    NOT_PAID(3, "未缴纳");

    private Integer value;

    private String name;

    FeeStateEnum(Integer value, String name) {
        this.value = value;
        this.name = name;
    }

    public static String getNameByVal(Integer val) {
        if (val == null) return null;
        for (FeeStateEnum feeStateEnum : values()) {
            if (feeStateEnum.getValue().equals(val)) {
                return feeStateEnum.getName();
            }
        }
        return null;
    }

    public Integer getValue() {
        return value;
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
