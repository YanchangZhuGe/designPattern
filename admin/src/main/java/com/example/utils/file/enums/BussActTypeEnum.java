package com.example.utils.file.enums;

/**
 * <p>Title: 接口调用业务模块操作类型枚举</p>
 * <p>Description: 接口调用业务模块操作类型枚举</p>
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author zengshaoqi
 * @since 2020/2/25 17:13
 */
public enum BussActTypeEnum {
    /**
     * 合同信息修改
     */
    CONTRACT_INFO_REGIST("合同信息登记", "contractInfoRegist", "0"),
    /**
     * 合同信息修改
     */
    CONTRACT_INFO_CHANGE("合同信息修改", "contractInfoChange", "1"),
    /**
     * 合同担保占用修改
     */
    OCCUPY_CHANGE("合同担保占用修改", "occupyChange", "2"),
    /**
     * 业务合同废弃
     */
    CONTRACT_ABANDONED("业务合同废弃", "contractAbandoned", "3"),
    /**
     * 业务合同结项
     */
    CONTRACT_END("业务合同结项", "contractEnd", "4");
    private String bussActName;
    private String bussActCode;
    private String bussActShortCode;

    public static Boolean needEndGwmsContract(String bussActShortCode) {
        return OCCUPY_CHANGE.bussActShortCode.equals(bussActShortCode) || CONTRACT_END.bussActShortCode.equals(bussActShortCode);
    }

    public static BussActTypeEnum getBussActTypeByShortCode(String bussActShortCode) {
        for (BussActTypeEnum type : values()) {
            if (type.getBussActShortCode().equals(bussActShortCode)) {
                return type;
            }
        }
        return null;
    }

    BussActTypeEnum(String bussActName, String bussActCode, String bussActShortCode) {
        this.bussActName = bussActName;
        this.bussActCode = bussActCode;
        this.bussActShortCode = bussActShortCode;
    }

    public String getBussActName() {
        return bussActName;
    }

    public void setBussActName(String bussActName) {
        this.bussActName = bussActName;
    }

    public String getBussActCode() {
        return bussActCode;
    }

    public void setBussActCode(String bussActCode) {
        this.bussActCode = bussActCode;
    }

    public String getBussActShortCode() {
        return bussActShortCode;
    }

    public void setBussActShortCode(String bussActShortCode) {
        this.bussActShortCode = bussActShortCode;
    }
}
