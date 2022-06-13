package com.example.apifox.enums;
/**
 * 
 * <p>Description:保费费率下级是否适用 </p>
 *
 * @author hsw
 * 
 * @since：2018年1月30日 上午11:33:51 
 * 
 */
public enum GuaranteeRateMange implements TypeEnum{
	APPLY(new Integer(1), "适用"),
	NOAPPLY(new Integer(0), "不适用");
	
	private Integer value;
	private String name;
	GuaranteeRateMange(Integer value,String name){
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
