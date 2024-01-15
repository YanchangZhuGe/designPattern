package com.example.utils.file.enums;
/**
 * 
 * <p>
 * Title:
 * </p>
 * 
 * <p>
 * Description:工作流枚举
 * </p>
 * 
 * <p>
 * Company: 北京九恒星科技股份有限公司
 * </p>
 * 
 * @author zhanghonghui
 * 
 * @since：2015-9-22 上午11:43:15
 * 
 * @version 1.0
 */
public enum BizFlowEnum {
	/***担保申请**/
	GWMS_FM001("GWMS.FLOW.001","担保申请"),
	/***担保合同登记**/
	GWMS_FM002("GWMS.FLOW.002","担保合同登记"),
	/***担保合同变更**/
	GWMS_FM003("GWMS.FLOW.003","担保合同变更"),
	/***担保合同废弃**/
	GWMS_FM004("GWMS.FLOW.004","担保合同废弃"),
	/***担保合同结项**/
	//GWMS_FM005("GWMS.FLOW.005","担保合同结项"),
	/***担保额度占用**/
	GWMS_FM006("GWMS.FLOW.006","担保额度占用"),
	/***额度占用变更**/
	GWMS_FM007("GWMS.FLOW.007","担保占用变更"),
	/***合同发生额登记**/
	GWMS_FM008("GWMS.FLOW.008","合同发生额登记"),
	/***保证金转存**/
	GWMS_FM009("GWMS.FLOW.009","保证金转存"),
	/***信用证担保额度占用变更**/
	GWMS_FM010("GWMS.FLOW.010","信用证担保额度占用变更"),
	/***业务合同台账登记**/
	GWMS_FM011("GWMS.FLOW.011","业务合同台账登记"),

    /**
     * 担保合同替换
     */
	GWMS_FM012("GWMS.FLOW.012","担保合同替换"),
	GWMS_FM014("GWMS.FLOW.014","担保替换"),
		GWMS_FM015("GWMS.FLOW.015","担保占用释放"),
	/***担保合同变更**/
	GWMS_FM016("GWMS.FLOW.016","担保合同修正"),
	GWMS_FM017("GWMS.FLOW.017","担保合同删除"),
	;

	BizFlowEnum(String key, String name){
		this.key = key;
		this.name = name;
	}

	private String key;
	private String name;
	public String getKey() {
		return key;
	}
	public void setKey(String key) {
		this.key = key;
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
