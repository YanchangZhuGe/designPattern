package com.example.utils.file.enums;
/**
 * <p>Title：</p>
 *
 * <p>Description：是否开通最高额度限制 </p>
 *
 * <p>Company：北京九恒星科技股份有限公司</p>
 *
 * @author xiongyong
 * 
 * @since：2018年2月6日 下午8:16:54
 * 
 */
public enum IsProGuarantee {
   PRO(1,"是"),
   NOT_PRO(0,"否");
	
	private Integer value;
	private String name;

	private IsProGuarantee(Integer value, String name) {
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
