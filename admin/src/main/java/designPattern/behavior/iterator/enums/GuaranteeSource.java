package designPattern.behavior.iterator.enums;

/**
 * 担保来源枚举
 *
 * @author Administrator
 */
public enum GuaranteeSource {
    //自有
    OWN(0),
    //第三方
    THIRD(1);

    private Integer value;

    private GuaranteeSource(Integer value) {
        this.value = value;
    }

    public Integer getValue() {
        return value;
    }

    public void setValue(Integer value) {
        this.value = value;
    }


}
