package com.primavera.ws.p6.activity;
/**
 * 
 * 标题：中石油集团公司生产管理系统
 * 
 * 专业：物探专业
 * 
 * 公司: 中油瑞飞
 * 
 * 作者：李俊强，Mar 23, 2012
 * 
 * 描述：
 * 
 * 说明:
 */
public class ActivityExtends {

	private Activity activity;
	private String submitFlag;
	
	public ActivityExtends() {
		super();
		activity = new Activity();
	}
	public ActivityExtends(Activity activity) {
		super();
		this.activity = activity;
		this.submitFlag = "0";
	}
	public ActivityExtends(Activity activity, String submitFlag) {
		super();
		this.activity = activity;
		this.submitFlag = submitFlag;
	}
	
	public Activity getActivity() {
		return activity;
	}
	public void setActivity(Activity activity) {
		this.activity = activity;
	}
	public String getSubmitFlag() {
		return submitFlag;
	}
	public void setSubmitFlag(String submitFlag) {
		this.submitFlag = submitFlag;
	}
	
}
