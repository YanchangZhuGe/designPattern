package com.example.enums;

/**
 * <p>Title:工单类型</p>
 *
 * <p>Description:工单类型</p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @since：2021/4/14 11:37
 */
public enum LmsUmFmClsEnum {

    LMS_FM001("1", "LMS_FM001", "内部借款合同登记"),
    LMS_FM002("2", "LMS_FM002", "借款申请"),
    LMS_FM003("3", "LMS_FM003", "提款申请"),
    LMS_FM004("4", "LMS_FM004", "展期申请"),
    LMS_FM005("5", "LMS_FM005", "合同变更"),
    LMS_FM006("6", "LMS_FM006", "借款合同修正"),
    LMS_FM007("7", "LMS_FM007", "放款台账登记"),
    LMS_FM008("8", "LMS_FM008", "还款台账登记"),
    LMS_FM009("9", "LMS_FM009", "合同结束"),
    LMS_FM010("10", "LMS_FM010", "借款合同作废"),
    LMS_FM011("11", "LMS_FM011", "借款合同展期"),
    LMS_FM012("12", "LMS_FM012", "利率变更");




    private String code;
    private String value;
    private String name;

    LmsUmFmClsEnum(String code, String value, String name) {
        this.code = code;
        this.value = value;
        this.name = name;
    }

    @Override
    public String toString() {
        return value + ":" + name;
    }

    /**
     * @param value
     * @return String
     * @Description：根据VALUE获取NAME
     * @author tangjiagang
     * @since：2020/10/28 16:37
     */
    public static String getFmClsName(String value) {
        for (LmsUmFmClsEnum anEnum : values()) {
            if (anEnum.getValue().equals(value)) {
                return anEnum.getName();
            }
        }
        return "";
    }

    /**
     * @param value
     * @return
     * @Description：获取工单类型
     * @author tangjiagang
     * @since：2020/10/28 11:36
     */
    public static LmsUmFmClsEnum getFmCls(String value) {
        for (LmsUmFmClsEnum anEnum : values()) {
            if (anEnum.getValue().equals(value)) {
                return anEnum;
            }
        }
        return null;
    }


    /**
     * @param code
     * @return
     * @Description：获取工单类型
     * @author tangjiagang
     * @since：2020/10/28 11:36
     */
    public static LmsUmFmClsEnum getFmClsByCode(String code) {
        for (LmsUmFmClsEnum anEnum : values()) {
            if (anEnum.getCode().equals(code)) {
                return anEnum;
            }
        }
        return null;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

}
