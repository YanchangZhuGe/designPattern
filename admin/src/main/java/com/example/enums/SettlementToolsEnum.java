package com.example.enums;

import com.nstc.ptms.constants.PtmsConstants;

import java.util.ArrayList;
import java.util.List;

/**
 * <p>Title: 结算工具枚举</p>
 *
 * <p>Description: 结算工具枚举</p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author tjg
 * @version 1.0
 * @since：2021/8/25 9:34
 */
public enum SettlementToolsEnum {

    /**
     *
     */
    BANK("BANK", "账户", null),
    BILL("BILL", "票据", PaymentTemplateEnum.BILL),
    LC("LC", "信用证", PaymentTemplateEnum.LC),
    CHEQUE("CHEQUE", "支票", PaymentTemplateEnum.CHEQUE),
    CASH("CASH", "现金", PaymentTemplateEnum.CASH),
    REMITTING("REMITTING", "托收", PaymentTemplateEnum.REMITTING),
    MIXED("MIXED", "混合", PaymentTemplateEnum.MIXED),
    ;

    private final String settlementTools;
    private final String name;
    private final PaymentTemplateEnum paymentTemplate;

    private static final String SUFFIX = "_PAYMENT";

    SettlementToolsEnum(String settlementTools, String name, PaymentTemplateEnum paymentTemplate) {
        this.settlementTools = settlementTools;
        this.name = name;
        this.paymentTemplate = paymentTemplate;
    }

    public String getSettlementTools() {
        return settlementTools;
    }

    public String getName() {
        return name;
    }

    public PaymentTemplateEnum getPaymentTemplate() {
        return paymentTemplate;
    }

    public static List<String> getAllCode() {
        List<String> allCode = new ArrayList<>(values().length);
        for (SettlementToolsEnum anEnum : values()) {
            allCode.add(anEnum.settlementTools);
        }
        return allCode;
    }

    /**
     * 获取结算工具名称时，无需通过接口查询数据字典。原因：
     * 数据字典即便新增了结算工具，但是由于需要业务系统开发，故枚举类一定会更新。
     * 从节约性能考虑，直接取枚举中的名称
     *
     * @param settlementCode
     * @return
     */
    public static String getName(String settlementCode) {
        for (SettlementToolsEnum toolsEnum : values()) {
            if (toolsEnum.settlementTools.equals(settlementCode)) {
                return toolsEnum.name;
            }
        }
        return "";
    }

    public static SettlementToolsEnum getSettlementToolsEnum(String settlementCode) {
        for (SettlementToolsEnum toolsEnum : values()) {
            if (toolsEnum.settlementTools.equals(settlementCode)) {
                return toolsEnum;
            }
        }
        return null;
    }

    public static String getBeanName(String settlementCode) {
        for (SettlementToolsEnum toolsEnum : values()) {
            if (toolsEnum.settlementTools.equals(settlementCode)) {
                return toolsEnum.getBeanName();
            }
        }
        return null;
    }

    private String getBeanName() {
        return new StringBuilder()
                .append(PtmsConstants.CHANNEL)
                .append(".")
                .append(this.settlementTools)
                .append(SUFFIX)
                .toString();
    }
}
