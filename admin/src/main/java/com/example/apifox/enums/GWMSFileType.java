/*================================================================================
* GWMSFileType.java
* 生成日期：2015-10-10 下午04:49:34 
* 作          者：zhanghonghui
* 项          目：GWMS-Service
* (C)COPYRIGHT BY NSTC.
* ================================================================================
*/
package com.example.apifox.enums;

/**
 * <p>
 * Title:
 * </p>
 * 
 * <p>
 * Description:附件类型
 * </p>
 * 
 * <p>
 * Company: 北京九恒星科技股份有限公司
 * </p>
 * 
 * @author zhanghonghui
 * 
 * @since：2015-10-10 下午04:49:34
 * 
 * @version 1.0
 */
public enum GWMSFileType implements TypeEnum{
	/**
	 * 担保合同附件
	 */
	T_01("01","担保合同附件"),
	/**
	 * 担保合同台帐附件
	 */
	T_02("02","担保合同台账附件"),
	/**
	 * 抵质押物信息附件
	 */
	T_03("03","抵质押物信息附件")
	;
	private String value;
	private String name;
	GWMSFileType(String value,String name){
		this.value = value;
		this.name = name;
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
