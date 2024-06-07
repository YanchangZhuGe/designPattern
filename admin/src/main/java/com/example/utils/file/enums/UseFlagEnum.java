package com.example.utils.file.enums;
/**
 * <p>Title：</p>
 *
 * <p>Description ：是否启用</p>
 *
 * <p>Company：北京九恒星科技股份有限公司</p>
 *
 * @author xiongyong
 * 
 * @since：2018年3月16日 下午2:05:41
 * 
 */
public enum UseFlagEnum {

	ENABLE(1,"启用"),
	DISABLE(0,"停用");
	
	private Integer value;
	private String name;
	
	private UseFlagEnum(Integer value, String name) {
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
