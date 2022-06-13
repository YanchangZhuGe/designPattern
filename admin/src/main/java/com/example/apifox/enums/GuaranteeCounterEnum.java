package com.example.apifox.enums;
/**
 * <p>Title：</p>
 *
 * <p>Description：</p>
 *
 * <p>Company：北京九恒星科技股份有限公司</p>
 *
 * @author xiongyong
 * 
 * @since：2018年4月9日 上午9:28:01
 * 
 */
public enum GuaranteeCounterEnum implements TypeEnum{
	PROPLE(0,"质押"),
	PROMORT(1,"抵押"),
	ENSURE(2,"保证");
	
	private Integer value;
	private String name;
	
	private GuaranteeCounterEnum(Integer value, String name) {
		this.value = value;
		this.name = name;
	}
	public Integer getValue() {
		return value;
	}
	public void setValue(Integer value) {
		this.value = value;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	
	
	
}
