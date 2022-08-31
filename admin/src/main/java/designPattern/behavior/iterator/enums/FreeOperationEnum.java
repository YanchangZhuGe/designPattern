package designPattern.behavior.iterator.enums;

/**
 * <p>
 * Title:
 * </p>
 *
 * <p>
 * Description:免收操作
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
public enum FreeOperationEnum implements TypeEnum {

    /**
     * 无
     */
    FREE_NONE(0, "无"),
    /**
     * 免收滞纳金
     */
    FREE_LATEFEE(1, "免收滞纳金"),
    /**
     * 免收全部
     */
    FREE_ALL(2, "免收全部");

    private Integer value;

    private String name;

    FreeOperationEnum(Integer value, String name) {
        this.value = value;
        this.name = name;
    }


    public static FreeOperationEnum getFreeOperationEnum(Integer value) {
        for (FreeOperationEnum p : values()) {
            if (p.getValue().equals(value)) {
                return p;
            }
        }
        return null;
    }

    public static String getNameByVal(Integer value) {
        for (FreeOperationEnum p : values()) {
            if (p.getValue().equals(value)) {
                return p.getName();
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
