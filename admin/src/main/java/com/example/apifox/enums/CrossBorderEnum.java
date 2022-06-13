package com.example.apifox.enums;
/**
 * <p>Title: CrossBorderEnum.java</p>
 *
 * <p>Description: </p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author luoyun
 * 
 * @since：2018-10-25 下午07:33:49
 * 
 */
public enum CrossBorderEnum implements TypeEnum{
	NO_RECORD(0,"未备案"),
	RECORD(1,"已备案"),
	CANCEL(2,"已注销");
	
	private Integer value;
	private String name;
	CrossBorderEnum(Integer value,String name){
		this.value = value;
		this.name = name;
	}
	public void setValue(Integer value) {
		this.value = value;
	}
	public Integer getValue() {
		return value;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getName() {
		return name;
	}
	public static String getEnumName(Integer value){
		CrossBorderEnum[] states = CrossBorderEnum.values();
		String reName = "";
		for (CrossBorderEnum crossBorderEnum : states) {
			if (crossBorderEnum.getValue().equals(value)) {
				reName = crossBorderEnum.getName();
			}
		}
		return reName;
	}
}
