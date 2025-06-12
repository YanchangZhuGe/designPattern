package com.bgp.dms.assess.model;

import java.util.Date;

/**
 * ���˽����ϸ
 * ���˽����,����ΪҶ���ڵ�Ŀ��˵㿼�˽��
 * @author ������
 *
 */
public class ReportItem {
	private String itemReportID;//������ϸ���
	private ReportInfo reportInfo;//������ϸ���
	private Object itemAssessInfo;//����ΪҶ���ڵ�Ŀ��˵�
	private double itemScore;//����ΪҶ���ڵ�Ŀ��˷���
	private java.lang.String BSFLAG;//�Ƿ���Ч
	private java.lang.String types;//������������ 0 ���� 1�쳣
	private boolean isSpecial;
	private Date CREATE_DATE;//����ʱ��
	private Date MODIFY_DATE;//�޸�ʱ��
	
	private String CREATER;//������
	private String UPDATOR;//�޸���
	public String getItemReportID() {
		return itemReportID;
	}
	public void setItemReportID(String itemReportID) {
		this.itemReportID = itemReportID;
	}
	public ReportInfo getReportInfo() {
		return reportInfo;
	}
	public void setReportInfo(ReportInfo reportInfo) {
		this.reportInfo = reportInfo;
	}
	public Object getItemAssessInfo() {
		return itemAssessInfo;
	}
	public void setItemAssessInfo(Object itemAssessInfo) {
		this.itemAssessInfo = itemAssessInfo;
	}
	public double getItemScore() {
		return itemScore;
	}
	public void setItemScore(double itemScore) {
		this.itemScore = itemScore;
	}
	public java.lang.String getBSFLAG() {
		return BSFLAG;
	}
	public void setBSFLAG(java.lang.String bSFLAG) {
		BSFLAG = bSFLAG;
	}
	public Date getCREATE_DATE() {
		return CREATE_DATE;
	}
	public void setCREATE_DATE(Date cREATE_DATE) {
		CREATE_DATE = cREATE_DATE;
	}
	public Date getMODIFY_DATE() {
		return MODIFY_DATE;
	}
	public void setMODIFY_DATE(Date mODIFY_DATE) {
		MODIFY_DATE = mODIFY_DATE;
	}
	public String getCREATER() {
		return CREATER;
	}
	public void setCREATER(String cREATER) {
		CREATER = cREATER;
	}
	public String getUPDATOR() {
		return UPDATOR;
	}
	public void setUPDATOR(String uPDATOR) {
		UPDATOR = uPDATOR;
	}
	public java.lang.String getTypes() {
		return types;
	}
	public void setTypes(java.lang.String types) {
		this.types = types;
	}
	public boolean isSpecial() {
		return isSpecial;
	}
	public void setSpecial(boolean isSpecial) {
		if("1".equals(types)){
			isSpecial = true;
		}else{
			isSpecial = false;
		}
		this.isSpecial = isSpecial;
	}
	
}
