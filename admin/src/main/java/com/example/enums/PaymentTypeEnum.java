package com.example.enums;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.nstc.ptms.validate.EnumValueLister;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

import java.util.ArrayList;
import java.util.List;

/**
 * <p>Title: 付款类型枚举</p>
 *
 * <p>Description: 付款类型枚举</p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author tjg
 * @version 1.0
 * @since：2021/9/7 17:41
 */
@ApiModel("付款类型")
@JsonFormat(shape = JsonFormat.Shape.OBJECT)
public enum PaymentTypeEnum implements EnumValueLister {
    /**
     * 集团外供应商付款
     */
    SUPPLIERS_OUTSIDE("SUPPLIERS_OUTSIDE", "集团外供应商付款", null),
    /**
     * 集团内供应商付款
     */
    SUPPLIERS_INSIDE("SUPPLIERS_INSIDE", "集团内供应商付款", null),
    /**
     * 同名账户划转
     */
    DIRECT("DIRECT", "同名账户划转", null),
    /**
     * 费用报销
     */
    REIMBURSEMENT("REIMBURSEMENT", "费用报销", PaymentTemplateEnum.CH_DOMESTIC_PRIVATE_BATCH),
    /**
     * 工资发放
     */
    SALARY_PAY("SALARY_PAY", "工资发放", PaymentTemplateEnum.CH_DOMESTIC_PRIVATE_BATCH),
    /**
     * 内部账户付款
     */
    INNER_ACCOUNT("INNER_ACCOUNT", "内部账户付款", PaymentTemplateEnum.INNER_ACCOUNT),
    /**
     * 请款申请
     */
    SPENT("SPENT", "请款申请", PaymentTemplateEnum.REQUEST_PAYOUT),
    /**
     * 委托收款
     */
    ENTRUST("ENTRUST", "委托收款", PaymentTemplateEnum.COMMISSION_RECEIVABLES),
    /**
     * 银行主扣
     */
    BANK_DEDUCT("BANK_DEDUCT", "银行主扣", null),
    /**
     * 票据付款
     */
    PAYMENT_BILL("PAYMENT_BILL", "承兑汇票付款", PaymentTemplateEnum.BILL),
    /**
     * 混合支付
     */
    MIXED("MIXED", "混合支付", PaymentTemplateEnum.MIXED),
    /**
     * 支票付款
     */
    CHEQUE("CHEQUE", "支票付款", PaymentTemplateEnum.CHEQUE),
    ERP_SHARE001("ERP_SHARE001", "共享支付单笔", null),
    ERP_SHARE002("ERP_SHARE002", "共享支付对私批量", null);

    private static List<PaymentTypeEnum> types;

    static {
        types = new ArrayList<>(6);
        types.add(BANK_DEDUCT);
        types.add(SUPPLIERS_OUTSIDE);
        types.add(SUPPLIERS_INSIDE);
        types.add(DIRECT);
        types.add(REIMBURSEMENT);
        types.add(SALARY_PAY);
        types.add(SPENT);
        types.add(ENTRUST);
    }

    /**
     * 获取付款明细补填 付款类型下拉值
     *
     * @return
     */
    public static List<PaymentTypeEnum> getDetailRefillPaymentTypes() {
        return types;
    }

    @ApiModelProperty(value = "付款类型", example = "BANK_DEDUCT")
    private final String type;

    @ApiModelProperty(value = "付款类型名称", example = "银行主扣")
    private final String name;

    private final PaymentTemplateEnum paymentTemplate;

    PaymentTypeEnum(String type, String name, PaymentTemplateEnum paymentTemplate) {
        this.type = type;
        this.name = name;
        this.paymentTemplate = paymentTemplate;
    }

    public String getType() {
        return type;
    }

    public String getName() {
        return name;
    }

    public PaymentTemplateEnum getPaymentTemplate() {
        return paymentTemplate;
    }

    public static String getName(String type) {
        return valueOf(type).type;
    }

    public static String getNameByType(String type) {
        for (PaymentTypeEnum typeEnum : values()) {
            if (typeEnum.type.equals(type)) {
                return typeEnum.name;
            }
        }
        return "";
    }

    public static PaymentTypeEnum getPaymentTypeEnum(String type) {
        for (PaymentTypeEnum typeEnum : values()) {
            if (typeEnum.type.equals(type)) {
                return typeEnum;
            }
        }
        return null;
    }

    public static String[] exhaustiveList() {
        List<PaymentTypeEnum> types = getDetailRefillPaymentTypes();
        String[] typeNos = new String[types.size() + 1];
        for (int i = 0; i < types.size(); i++) {
            typeNos[i] = types.get(i).type;
        }
        typeNos[types.size()] = null;
        return typeNos;
    }

    public static boolean isPrivateBatch(String type) {
        return SALARY_PAY.type.equalsIgnoreCase(type) || REIMBURSEMENT.type.equalsIgnoreCase(type);
    }
}
