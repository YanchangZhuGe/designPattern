package designPattern.behavior.iterator.enums;

/**
 * 担保设置编码
 */
public enum GwmsParamEnum implements TypeEnum {

    P001("P001", "合同到期提醒天数"),
    P100("P100", "是否开启担保申请"),
    P101("P101", "占用担保的日期校验规则"),
    P102("P102", "跨币种占用担保的额度计算方式"),
    P103("P103", "是否可占用授信项下的担保合同额度"),
    P104("P104", "同一抵押物可否被多次抵押"),
    P105("P105", "同一质押物可否被多次抵押"),
    P106("P106", "合同到期是否自动结项"),
    ;

    GwmsParamEnum(String value, String name) {
        this.value = value;
        this.name = name;
    }

    private String value;

    private String name;

    public String getValue() {
        return this.value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public String getName() {
        return this.name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
