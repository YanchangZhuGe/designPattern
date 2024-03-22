package com.example.utils.file.enums;

/**
 * 
 * <p>Description: </p>
 *
 * @author hsw
 * 
 * @since：2018年1月30日 上午11:33:51 
 * 
 */
public enum GuaranteeBaseRateStateType implements TypeEnum {
	EFFECT(new Integer(1), "生效"),
	LOSE(new Integer(0), "不生效");
	
	private Integer value;
	private String name;
	GuaranteeBaseRateStateType(Integer value,String name){
		this.setName(name);
		this.setValue(value);
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
