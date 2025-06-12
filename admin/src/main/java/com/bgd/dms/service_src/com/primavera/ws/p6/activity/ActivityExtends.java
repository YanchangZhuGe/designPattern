package com.primavera.ws.p6.activity;
/**
 * 
 * ���⣺��ʯ�ͼ��Ź�˾��������ϵͳ
 * 
 * רҵ����̽רҵ
 * 
 * ��˾: �������
 * 
 * ���ߣ��ǿ��Mar 23, 2012
 * 
 * ������
 * 
 * ˵��:
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
