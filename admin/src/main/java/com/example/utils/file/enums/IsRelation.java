package com.example.utils.file.enums;

/**
 * <p>
 * Title：
 * </p>
 *
 * <p>
 * Description：融资是否关联担保枚举
 * </p>
 *
 * <p>
 * Company：北京九恒星科技股份有限公司
 * </p>
 *
 * @author xiongyong
 * 
 * @since：2018年3月20日 下午4:20:30
 * 
 */
public enum IsRelation {
	IS_RELATION("Y", "融资关联担保"),
	IS_NOT_RELATION("N", "融资未关联担保");

	private String value;
	private String name;

	private IsRelation(String value, String name) {
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
