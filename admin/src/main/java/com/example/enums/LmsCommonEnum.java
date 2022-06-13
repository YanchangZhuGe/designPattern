package com.example.enums;

/**
 * <p>Title:基础数据枚举</p>
 *
 * 尽量不要循环获取所有值
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @version 1.0
 * @since：2020/10/28 10:57
 */
public enum LmsCommonEnum {

    IS_DELETE_Y(1,"1","已删除" ,"已删除"),
    IS_DELETE_N(0,"0","", "未删除"),
    PLAN_FK(0,"FK","放款", "还本付息计划-放款"),
    PLAN_HB(0,"HB","还本", "还本付息计划-还本"),
    PLAN_FX(0,"FX","付息", "还本付息计划-付息"),
    PLAN_QT(0,"QT","其他", "还本付息计划-其他"),
    RATE_TYPE_1(1,"1","正常利息", "利息匡算"),
    RATE_TYPE_2(2,"2","罚息利息", "利息匡算"),
    RATE_TYPE_3(3,"3","展期利息", "利息匡算"),
    ;

    private Integer value;
    private String code;
    private String name;
    private String description;

    LmsCommonEnum(Integer value, String code, String name, String description) {
        this.value = value;
        this.code = code;
        this.name = name;
        this.description = description;
    }

    public Integer getValue() {
        return value;
    }

    public void setValue(Integer value) {
        this.value = value;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
