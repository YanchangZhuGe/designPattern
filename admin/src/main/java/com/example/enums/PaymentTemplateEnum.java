package com.example.enums;

public enum PaymentTemplateEnum {

    /**
     * 集团外供应商付款、集团内供应商付款、同名账户划转
     */
    CH_DOMESTIC_LOCAL_CURRENCY("CH_DOMESTIC_LOCAL_CURRENCY", "中国境内本币付款"),
    /**
     * 集团外供应商付款、集团内供应商付款、同名账户划转
     */
    CH_DOMESTIC_FOREIGN_CURRENCY("CH_DOMESTIC_FOREIGN_CURRENCY", "中国境内外币付款"),
    /**
     * 费用报销、工资发放
     */
    CH_DOMESTIC_PRIVATE_BATCH("CH_DOMESTIC_PRIVATE_BATCH", "中国境内对私批量付款"),
    /**
     * 集团外供应商付款、集团内供应商付款、同名账户划转
     */
    CH_INTERNATIONAL("CH_INTERNATIONAL", "中国国际付款"),
    /**
     * 集团外供应商付款、集团内供应商付款、同名账户划转
     */
    APAC("APAC", "亚太区付款"),
    /**
     * 集团外供应商付款、集团内供应商付款、同名账户划转
     */
    SGP("SGP", "新加坡付款"),
    /**
     * 集团外供应商付款、集团内供应商付款、同名账户划转
     */
    GB("GB", "英国付款"),
    /**
     * 集团外供应商付款、集团内供应商付款、同名账户划转
     */
    SEPA("SEPA", "SEPA付款"),
    /**
     * 集团外供应商付款、集团内供应商付款、同名账户划转
     */
    EU_INTERNATIONAL("EU_INTERNATIONAL", "欧洲国际付款"),
    /**
     * 集团外供应商付款、集团内供应商付款、同名账户划转
     */
    AUS("AUS", "澳大利亚付款"),
    /**
     * 集团外供应商付款、集团内供应商付款、同名账户划转
     */
    CL("CL", "智利付款"),
    /**
     * 集团外供应商付款、集团内供应商付款、同名账户划转
     */
    VN("VN", "越南付款"),
    /**
     * 集团外供应商付款、集团内供应商付款、同名账户划转
     */
    MX("MX", "墨西哥付款"),
    /**
     * 集团外供应商付款、集团内供应商付款、同名账户划转
     */
    US("US", "美国付款"),
    /**
     * 集团外供应商付款、集团内供应商付款、同名账户划转
     */
    JP("JP", "日本付款"),
    /**
     * 集团外供应商付款、集团内供应商付款、同名账户划转
     */
    COMMON("COMMON", "通用付款"),
    /**
     * 内部账户付款
     */
    INNER_ACCOUNT("INNER_ACCOUNT", "内部账户付款"),
    /**
     * 请款申请
     */
    REQUEST_PAYOUT("REQUEST_PAYOUT", "请款申请"),
    /**
     * 委托收款
     */
    COMMISSION_RECEIVABLES("COMMISSION_RECEIVABLES", "委托收款"),
    /**
     * 集团外供应商付款、集团内供应商付款、费用报销、工资发放
     */
    CASH("CASH", "现金付款"),
    /**
     * 集团外供应商付款、集团内供应商付款、费用报销、工资发放
     */
    CHEQUE("CHEQUE", "支票付款"),
    /**
     * 票据付款
     */
    BILL("BILL", "承兑汇票付款"),
    /**
     * 信用证付款
     */
    LC("LC", "信用证"),
    /**
     * 托收
     */
    REMITTING("REMITTING", "托收"),
    /**
     * 混合支付
     */
    MIXED("MIXED", "混合支付"),
    ;


    private final String template;
    private final String name;

    PaymentTemplateEnum(String template, String name) {
        this.template = template;
        this.name = name;
    }

    public String getTemplate() {
        return template;
    }

    public String getName() {
        return name;
    }

    public static String getNameByTemplate(String template) {
        for (PaymentTemplateEnum testEnums : PaymentTemplateEnum.values()) {
            if (testEnums.getTemplate().equals(template)) {
                return testEnums.getName();
            }
        }
        return "";
    }

    public static PaymentTemplateEnum getPaymentTemplate(String template) {
        for (PaymentTemplateEnum templateEnum : values()) {
            if (templateEnum.template.equals(template)) {
                return templateEnum;
            }
        }
        return null;
    }

    public static boolean isInnerAccountPay(String template) {
        return INNER_ACCOUNT.template.equals(template) || REQUEST_PAYOUT.template.equals(template);
    }
}
