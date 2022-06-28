package com.example.enums;

import java.util.ArrayList;
import java.util.List;

/**
 * <p>Title: 落地规则付款类型枚举</p>
 *
 * <p>Description: 落地规则付款类型枚举</p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author ym
 * @version 1.0
 * @since：2021/8/26
 */
public enum PayClsEnum {
    /**
     * 单笔对外付款
     */
    SINGLE_OUTSIDE("8200_01", "单笔对外付款"),
    /**
     * 混合支付
     */
    MIXED("8288_01", "混合支付"),
    /**
     * 单笔对内付款
     */
    SINGLE_INSIDE("8201_01", "单笔对内付款"),
    /**
     * 支票付款
     */
    CHEQUE("8205_01", "支票付款"),
    /**
     * 票据付款
     */
    BILL("8206_01", "票据付款"),
    /**
     * 工资发放
     */
    SALARY_PAYMENT("8204_01", "工资发放"),
    /**
     * 费用报销
     */
    REIMBURSEMENT("8204_02", "费用报销"),
    /**
     * 国内信用证付款
     */
    INCREDIT("8207_01", "国内信用证付款"),
    /**
     * 国际付款
     */
    INTERNATION("8209_01", "国际付款"),
    /**
     * 现金付款
     */
    CASH("8208_01", "现金付款"),
    /**
     * 请款申请
     */
    FUND("8202_01", "请款申请");

    private final String typeNo;
    private final String name;

    PayClsEnum(String typeNo, String name) {
        this.typeNo = typeNo;
        this.name = name;
    }

    public String getTypeNo() {
        return typeNo;
    }

    public String getName() {
        return name;
    }

    /**
     * 根据name返回枚举typeNo
     *
     * @param Name
     * @return typeNO
     */
    public static String getEumByName(String Name) {
        for (PayClsEnum testEnums : PayClsEnum.values()) {
            if (testEnums.getName().equals(Name)) {
                return testEnums.getTypeNo();
            }
        }
        return null;
    }

    public static List<String> getAllTypeNo() {
        List<String> allTypeNo = new ArrayList<>(values().length);
        for (PayClsEnum anEnum : values()) {
            allTypeNo.add(anEnum.typeNo);
        }
        return allTypeNo;
    }
}
