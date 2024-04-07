/*================================================================================
* GuaranteeLogType.java
* 生成日期：2015-11-3 上午11:27:35 
* 作          者：zhanghonghui
* 项          目：GWMS-Service
* (C)COPYRIGHT BY NSTC.
* ================================================================================
*/
package com.example.utils.file.enums;

/**
 * <p>
 * Title:
 * </p>
 * 
 * <p>
 * Description:担保合同日志类型
 * </p>
 * 
 * <p>
 * Company: 北京九恒星科技股份有限公司
 * </p>
 * 
 * @author zhanghonghui
 * 
 * @since：2015-11-3 上午11:27:35
 * 
 * @version 1.0
 */
public enum GuaranteeLogType {
	/***合同登记**/
	T_01("01","担保合同登记"),
	/***合同变更**/
	T_02("02","合同变更"),
	/***合同废弃**/
	T_03("03","合同废弃"),
	/***合同结项**/
	T_04("04","合同结项"),
	/***转存登记**/
	T_05("05","转存登记"),
	/***转存结项**/
	T_06("06","转存结项"),
	/** 合同占用 */
	T_07("07","合同额度占用"),
	/** 合同发生额登记*/
	T_08("08","合同发生额登记"),
	/** 额度占用变更 */
	T_09("09","担保占用变更"),

	CORRECT("10", "合同修正"),

	END_UNTI("11", "取消结项"),

	RECORD("12", "备案"),

	RECORD_UNTI("13", "取消备案"),

	CANCLE("14", "注销"),

	CANCEL_UNTI("15", "取消注销"),

	OCCUPY_RELEASE("16", "额度释放")
	;

	private String value;
	private String name;
	
	GuaranteeLogType(String value,String name){
		this.value = value;
		this.name = name;
	}
	/**
	 * 
	 * @Description:日志名称
	 * @param value
	 * @return
	 * @author zhanghonghui
	 * @since 2015-9-22 上午11:05:10
	 */
	public static String getTypeName(String value){
		for(GuaranteeLogType t : values()){
			if(t.getValue().equals(value)){
				return t.getName();
			}
		}
		return "";
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
