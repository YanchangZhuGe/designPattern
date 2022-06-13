/*================================================================================
* DumpType.java
* 生成日期：2015-9-25 上午11:05:14 
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
 * Description:转存方式
 * </p>
 * 
 * <p>
 * Company: 北京九恒星科技股份有限公司
 * </p>
 * 
 * @author zhanghonghui
 * 
 * @since：2015-9-25 上午11:05:14
 * 
 * @version 1.0
 */
public enum DumpType implements TypeEnum{
	/**
	 * 本金转存
	 */
	PRINCIAL("01","本金转存"),
	/**
	 * 本息转存
	 */
	PRINCIAL_INTEREST("02","本息转存");
	private String value;
	private String name;
	DumpType(String value,String name){
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
