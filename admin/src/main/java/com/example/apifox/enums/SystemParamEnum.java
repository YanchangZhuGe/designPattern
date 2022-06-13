package com.example.apifox.enums;
/**
 * <p>Title：</p>
 *
 * <p>Description：系统参数设置枚举</p>
 *
 * <p>Company：北京九恒星科技股份有限公司</p>
 *
 * @author xiongyong
 * 
 * @since：2018年3月6日 下午3:25:22
 * 
 */
public enum SystemParamEnum {
    /** 提醒天数设置 */
	P001("P001","提醒天数设置"),
	/** 是否管理保费的抵扣额度 */
	P002("P002","是否管理保费的抵扣额度"),
	/** 担保方是否收取保费 */
	P003("P003","担保方是否收取保费");
	
	private String value;
	private String name;
	
	private SystemParamEnum(String value, String name) {
		this.value = value;
		this.name = name;
	}
	public String getValue() {
		return value;
	}
	public void setValue(String value) {
		this.value = value;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	
}
