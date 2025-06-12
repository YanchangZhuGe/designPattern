package com.bgp.gms.service.rm.dm.util;

import java.io.Serializable;

public class EnumEntity implements Serializable {

	private static final long serialVersionUID = -2983726795409745623L;
	private String enumType;
	private String enumTypeName;
	private String key;
	private String value;
	//private String orderNum;
	
	public String getEnumTypeName() {
		return enumTypeName;
	}
	public void setEnumTypeName(String enumTypeName) {
		this.enumTypeName = enumTypeName;
	}
	public String getEnumType() {
		return enumType;
	}
	public void setEnumType(String enumType) {
		this.enumType = enumType;
	}
	public String getKey() {
		return key;
	}
	public void setKey(String key) {
		this.key = key;
	}
	public String getValue() {
		return value;
	}
	public void setValue(String value) {
		this.value = value;
	}
	/*public String getOrderNum() {
		return orderNum;
	}
	public void setOrderNum(String orderNum) {
		this.orderNum = orderNum;
	}*/
}
