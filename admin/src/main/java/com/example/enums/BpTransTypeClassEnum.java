package com.example.enums;

/**
 * @Describtion：BP交易类型报文组装映射枚举
 * @Autor：prince
 * @CreatTime：2021/9/14 16:50
 */
public enum BpTransTypeClassEnum {
    BANK_SUPPLIERS_OUTSIDE("Transfor_TX0001", "SUPPLIERS_OUTSIDE", "BANK"),
    BANK_SUPPLIERS_INSIDE("Transfor_TX0001", "SUPPLIERS_INSIDE", "BANK"),
    BANK_DIRECT("Transfor_TX0001", "DIRECT", "BANK"),
    BANK_REIMBURSEMENT("Transfor_TX0007", "REIMBURSEMENT", "BANK"),
    BANK_SALARY_PAY("Transfor_TX0007", "SALARY_PAY", "BANK"),
    BANK_SPENT("Transfor_TX0003", "SPENT", "BANK"),
    ;

    private String transCode;
    private String paymentType;
    private String settlementTool;

    public String getTransCode() {
        return transCode;
    }

    public String getPaymentType() {
        return paymentType;
    }

    public String getSettlementTool() {
        return settlementTool;
    }

    BpTransTypeClassEnum(String transCode, String paymentType, String settlementTool) {
        this.transCode = transCode;
        this.paymentType = paymentType;
        this.settlementTool = settlementTool;
    }

    public static String getTransCodeByOthers(String paymentType, String settlementTool) {
        for (BpTransTypeClassEnum bpTransTypeClassEnum : BpTransTypeClassEnum.values()) {
            if (bpTransTypeClassEnum.getPaymentType().equals(paymentType)
                    && bpTransTypeClassEnum.getSettlementTool().equals(settlementTool)) {
                return bpTransTypeClassEnum.getTransCode();
            }
        }
        return "";
    }
}
