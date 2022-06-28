package com.example.enums;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.nstc.ptms.validate.EnumValueLister;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import org.apache.commons.lang.StringUtils;

import java.util.Arrays;
import java.util.List;

@ApiModel("明细补填类型")
@JsonFormat(shape = JsonFormat.Shape.OBJECT)
public enum RefillTypeEnum implements EnumValueLister {
    /**
     * 00(结算方式)00(业务编号)00(费用类型)
     *
     * 01 账户付款
     * 02 票证
     * 03 现金
     *
     * --
     *
     * 01 业务款项
     * 02 手续费/保证金等等....
     */
    /**
     * 提交无特殊业务台账
     */
    P010101("P010101", "经营付款"),
    P010201("P010201", "结售汇付款"),
    /**
     * 提交前无特殊业务台账
     * 审批后做融资合同台账
     */
    P010301("P010301", "融资业务付款"),

    /**
     * 提交前需要锁定票据（手续费除外）
     * 审批后出库完结、登记台账等
     */
    P020101("P020101", "进口托收付款"),
    P020201("P020201", "信用证付款业务"),
    P020301("P020301", "进口保函付款"),
    P020401("P020401", "支票兑付"),
    P020501("P020501", "承兑汇票付款"),
    P020502("P020502", "承兑汇票手续费"),
    /**
     * 提交前需要预占库存现金
     * 审批后实际生成库存现金台账
     */
    P030101("P030101", "现金支取"),

    /**
     * 提交无特殊业务台账
     */
    P010402("P010402", "保证金缴存"),
    /**
     * 提交前无特殊业务台账
     * 审批后做理财合同台账
     */
    P010401("P010401", "理财业务付款"),


    /*P01("P01", "支票兑付"),
    P02("P02", "票据承兑"),
    P03("P03", "进口信用证付款"),
    P04("P04", "进口托收付款"),
    P05("P05", "融资业务"),
    P06("P06", "投资理财业务"),
    P07("P07", "保证金业务"),
    P08("P08", "结售汇付款"),
    P09("P09", "国内信用证付款"),
    P10("P10", "手续费"),
    P11("P11", "现金支取"),
    P12("P12", "进口保函付款"),
    P13("P13", "承兑手续费"),
    P14("P14", "信用证手续费"),
    P15("P15", "信用证保证金业务"),
    P16("P16", "承兑汇票保证金业务"),
    P17("P17", "信用证短贷业务"),
    P18("P18", "手动做账付款"),
    P19("P19", "经营付款"),
    P20("P20", "保函手续费"),
    P05_06("P05_06", "融资-提前还本")*/;
    private static final String ACCOUNT_PAY = "P01";
    private static final String BILL_PAY = "P02";
    private static final String CASH_PAY = "P03";

    private static final String SD = "01";
    private static final String LC = "02";
    private static final String LG = "03";
    private static final String CK = "04";
    private static final String DF = "05";

    private static final String BUSINESS_AMOUNT = "01";


    private static final int CODE_LENGTH = 7;

    /**
     * 根据补填业务类型判断是否需要锁定票据
     *
     * @param refillTypeNo
     * @param businessOperateStatus
     * @return
     */
    public static boolean needLockOrUnLockBill(String refillTypeNo, Integer businessOperateStatus) {
        if (StringUtils.isBlank(refillTypeNo) || refillTypeNo.length() != CODE_LENGTH) {
            return false;
        }
        String feeType = StringUtils.substring(refillTypeNo, -2);
        boolean needLOUBill = refillTypeNo.startsWith(BILL_PAY) && BUSINESS_AMOUNT.equals(feeType);
        // 信用证及托收需要手动标记结束
        String billType = StringUtils.substring(refillTypeNo, 3, 5);
        Integer endBill = RefillBusinessOperateStatusEnum.END_BILL.getSwitchByStatus(businessOperateStatus);
        return !(SD.equals(billType) || LC.equals(billType)) || YesOrNoEnum.YES.getKey().equals(endBill);
    }

    /**
     * 校验是否需要记录现金相关台账
     *
     * @param refillTypeNo 补填类型
     * @return
     */
    public static boolean needRecordCash(String refillTypeNo) {
        if (StringUtils.isBlank(refillTypeNo) || refillTypeNo.length() != CODE_LENGTH) {
            return false;
        }
        return refillTypeNo.startsWith(CASH_PAY);
    }

    public static List<RefillTypeEnum> getRefillTypeList() {
        return Arrays.asList(values());
    }

    /**
     * 明细补填业务类型编号
     */
    @ApiModelProperty(value = "明细补填类型编号", example = "P010101")
    private String refillTypeNo;
    /**
     * 明细补填业务类型名称
     */
    @ApiModelProperty(value = "明细补填类型名称", example = "经营付款")
    private String refillTypeName;

    public String getRefillTypeNo() {
        return refillTypeNo;
    }

    public String getRefillTypeName() {
        return refillTypeName;
    }

    RefillTypeEnum(String refillTypeNo, String refillTypeName) {
        this.refillTypeNo = refillTypeNo;
        this.refillTypeName = refillTypeName;
    }

    public static String getNameByNo(String refillTypeNo) {
        return valueOf(refillTypeNo).refillTypeName;
    }

    public static String[] exhaustiveList() {
        RefillTypeEnum[] types = values();
        String[] typeNos = new String[types.length + 1];
        for (int i = 0; i < types.length; i++) {
            typeNos[i] = types[i].refillTypeNo;
        }
        typeNos[types.length] = null;
        return typeNos;
    }
}
