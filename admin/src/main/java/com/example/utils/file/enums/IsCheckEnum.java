/*================================================================================
* AccrualType.java
* 生成日期：2015-9-22 下午02:07:34 
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
 * Description:集团内/集团外
 * </p>
 * 
 * <p>
 * Company: 北京九恒星科技股份有限公司
 * </p>
 *
 * 
 * @version 1.0
 */
public enum IsCheckEnum implements TypeEnum {

	/**
	 * 集团外
	 */
	OUT("out","集团外"),
	/**
	 * 集团内
	 */
	IN("in","集团内");
	private String value;
	private String name;
	IsCheckEnum(String value, String name){
		this.value = value;
		this.name = name;
	}
	public static String getTypeName(String value){
		for(IsCheckEnum p :values()){
			if(p.getValue().equals(value)){
				return p.getName();
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
