package com.example.enums;

/**
 * <p>Title: </p>
 *
 * <p>Description: </p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author zhanghonghui
 * @since：2017-2-10 上午10:01:57
 */
public enum ExecSendFlagEnum {
	/**
	 * 未处理
	 */
	NOT_SEND(0, "未处理"),
	/**
	 * 处理中
	 */
	SENDING(1, "处理中"),
	/**
	 * 已处理
	 */
	SENT(2, "已处理");
	private String name;
	private Integer value;

	ExecSendFlagEnum(Integer value, String name) {
		this.value = value;
		this.name = name;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public static String getFlagName(Integer value) {
		for (ExecSendFlagEnum d : values()) {
			if (d.getValue().equals(value)) {
				return d.getName();
			}
		}
		return null;
	}

	public Integer getValue() {
		return value;
	}

	public void setValue(Integer value) {
		this.value = value;
	}

}
