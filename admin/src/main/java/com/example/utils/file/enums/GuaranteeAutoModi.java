package com.example.utils.file.enums;
/**
 * 担保合同变更自动任务标识
 * @author Administrator
 *
 */
public enum GuaranteeAutoModi {
	// 等待执行
	WAIT_DO(0),
	// 已执行
	HAVE_DO(1);
	
	private  Integer value;

	private GuaranteeAutoModi(Integer value) {
		this.value = value;
	}

	public Integer getValue() {
		return value;
	}

	public void setValue(Integer value) {
		this.value = value;
	}
	
}
