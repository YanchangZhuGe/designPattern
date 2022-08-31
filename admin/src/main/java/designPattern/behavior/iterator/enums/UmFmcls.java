/*================================================================================
 * UmFmcls.java
 * 生成日期：2015-9-22 上午11:09:53
 * 作          者：zhanghonghui
 * 项          目：GWMS-Service
 * (C)COPYRIGHT BY NSTC.
 * ================================================================================
 */
package designPattern.behavior.iterator.enums;

/**
 * <p>
 * Title:
 * </p>
 *
 * <p>
 * Description:工单类型
 * </p>
 *
 * <p>
 * Company: 北京九恒星科技股份有限公司
 * </p>
 *
 * @author zhanghonghui
 * @version 1.0
 * @since：2015-9-22 上午11:09:53
 */
public enum UmFmcls {
    /***担保申请**/
    GWMS_FM001("GWMS_FM001", "担保申请", BizFlowEnum.GWMS_FM001),
    /***担保合同登记**/
    GWMS_FM002("GWMS_FM002", "担保合同登记", BizFlowEnum.GWMS_FM002),
    /***担保合同变更**/
    GWMS_FM003("GWMS_FM003", "担保合同变更", BizFlowEnum.GWMS_FM003),
    /***担保合同废弃**/
    GWMS_FM004("GWMS_FM004", "担保合同废弃", BizFlowEnum.GWMS_FM004),
    /***担保合同结项**/
    GWMS_FM005("GWMS_FM005", "担保合同结项", null),
    /***担保额度占用**/
    GWMS_FM006("GWMS_FM006", "担保额度占用", BizFlowEnum.GWMS_FM006),
    /***额度占用变更**/
    GWMS_FM007("GWMS_FM007", "担保占用变更", BizFlowEnum.GWMS_FM007),
    /***合同发生额登记**/
    GWMS_FM008("GWMS_FM008", "合同发生额登记", BizFlowEnum.GWMS_FM008),
    /***保证金转存**/
    GWMS_FM009("GWMS_FM009", "保证金转存", BizFlowEnum.GWMS_FM009),
    /***信用证担保额度占用变更**/
    GWMS_FM010("GWMS_FM010", "信用证担保额度占用变更", BizFlowEnum.GWMS_FM010),
    /***业务合同台账登记**/
    GWMS_FM011("GWMS_FM011", "业务合同台账登记", BizFlowEnum.GWMS_FM011),
    /**
     * 担保替换
     */
    GWMS_FM012("GWMS_FM012", "担保合同替换", BizFlowEnum.GWMS_FM012), GWMS_FM014("GWMS_FM014", "担保合同替换", BizFlowEnum.GWMS_FM014), GWMS_FM015("GWMS_FM015", "担保占用释放", BizFlowEnum.GWMS_FM015),
    /***担保合同修正**/
    GWMS_FM016("GWMS_FM016", "担保合同修正", BizFlowEnum.GWMS_FM016),
    GWMS_FM017("GWMS_FM017", "担保合同删除", BizFlowEnum.GWMS_FM017);

    private String value;
    private String name;
    private BizFlowEnum flow;

    UmFmcls(String value, String name, BizFlowEnum flow) {
        this.value = value;
        this.name = name;
        this.flow = flow;
    }


    /**
     * @return BizFlowEnum
     */
    public BizFlowEnum getFlow() {
        return flow;
    }


    /**
     * @param flow BizFlowEnum
     */
    public void setFlow(BizFlowEnum flow) {
        this.flow = flow;
    }


    public static String getFmClsName(String value) {
        for (UmFmcls t : values()) {
            if (t.getValue().equals(value)) {
                return t.getName();
            }
        }
        return "";
    }

    /**
     * @param value
     * @return
     * @Description:获取工单类型
     * @author zhanghonghui
     * @since 2015-9-24 上午09:54:31
     */
    public static UmFmcls getFmCls(String value) {
        for (UmFmcls t : values()) {
            if (t.getValue().equals(value)) {
                return t;
            }
        }
        return null;
    }

    /**
     * @return String
     */
    public String getValue() {
        return value;
    }

    /**
     * @param value String
     */
    public void setValue(String value) {
        this.value = value;
    }

    /**
     * @return String
     */
    public String getName() {
        return name;
    }

    /**
     * @param name String
     */
    public void setName(String name) {
        this.name = name;
    }


}
