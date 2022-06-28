package com.example.enums;

public enum CashFlowTypeEnum {
    MANAGEMENT("attributeType_management", "经营付款"),
    LOAN("attributeType_loan", "融资付款"),
    INVESTMENT("attributeType_investment", "投资付款");

    /**
     * 类型编号
     */
    private final String typeNo;
    /**
     * 类型名称
     */
    private final String typeName;

    public String getTypeNo() {
        return typeNo;
    }

    public String getTypeName() {
        return typeName;
    }

    CashFlowTypeEnum(String typeNo, String typeName) {
        this.typeNo = typeNo;
        this.typeName = typeName;
    }
}
