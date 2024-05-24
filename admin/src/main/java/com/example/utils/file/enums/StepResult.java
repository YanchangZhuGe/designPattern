package com.example.utils.file.enums;
/**
 * <p>Title: </p>
 *
 * <p>Description: 流程审批步骤</p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author lanheng
 * 
 * @since：2016年9月30日 下午2:11:02
 * 
 */
public enum StepResult {
	REJECT(0, "拒绝"),
	PASS(1, "通过"),
	CACEL(2, "撤销");
	
	private int code;
	private String text;
	
	private StepResult(int code, String text){
		this.code = code;
		this.text = text;
	}

	public int getCode() {
		return code;
	}

	public String getText() {
		return text;
	}
}
