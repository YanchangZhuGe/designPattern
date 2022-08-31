/**
 *
 */
package designPattern.behavior.iterator.enums;
/**
 * <p>Title: </p>
 *
 * <p>Description: </p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author yangliye
 *
 * @since：2016年9月12日 下午3:29:16
 *
 */

/**
 * @author Administrator
 *
 */
public enum RemoteBizCode {
    /**保存担保占用信息*/
    T01("T01", "保存担保占用信息"),
    /**删除担保占用信息*/
    T02("T02", "删除担保占用信息"),
    /**查询担保占用信息"*/
    T03("T03", "查询担保占用信息"),
    /**变更担保占用信息流程状态*/
    T04("T04", "变更担保占用信息流程状态"),
    /**担保额度预占/释放预占*/
    T05("T05", "担保额度预占/释放预占"),
    /** 担保额度占用 */
    T06("T06", "担保额度占用"),
    /** 担保额度释放*/
    T07("T07", "担保额度释放"),
    /** */
    T08("T08", "");
    private String code;
    private String describtion;

    /**
     * @return the code
     */
    public String getCode() {
        return code;
    }

    /**
     * @param code the code to set
     */
    public void setCode(String code) {
        this.code = code;
    }

    /**
     * @return the describtion
     */
    public String getDescribtion() {
        return describtion;
    }

    /**
     * @param describtion the describtion to set
     */
    public void setDescribtion(String describtion) {
        this.describtion = describtion;
    }

    private RemoteBizCode(String code, String describtion) {
        this.code = code;
        this.describtion = describtion;
    }

    public static RemoteBizCode getRemoteBizCodeByBizCode(String bizCode) {
        for (RemoteBizCode remoteBizCode : values()) {
            if (remoteBizCode.getCode().equals(bizCode)) {
                return remoteBizCode;
            }
        }
        return null;
    }
}
