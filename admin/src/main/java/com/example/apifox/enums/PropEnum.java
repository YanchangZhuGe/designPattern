/*================================================================================
* PropEnum.java
* 生成日期：2015-9-22 下午01:48:50 
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
 * Description:保证金存款性质
 * </p>
 * 
 * <p>
 * Company: 北京九恒星科技股份有限公司
 * </p>
 * 
 * @author zhanghonghui
 * 
 * @since：2015-9-22 下午01:48:50
 * 
 * @version 1.0
 */
public enum PropEnum implements TypeEnum{
	/**
	 * 活期保证金存款
	 */
	PROP_1("01","活期保证金存款"),
	/**
	 * 定期保证金存款
	 */
	PROP_2("02","定期保证金存款");
	
	private String value;
	private String name;
	PropEnum(String value,String name){
		this.value = value;
		this.name = name;
	}
	public static String getPropName(String value){
		for(PropEnum p :values()){
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
