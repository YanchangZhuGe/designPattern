package com.bgp.dms.assess.model;

import java.util.Date;
import java.util.List;

/**
 * ���˱����쳣�嵥
 * @author ������
 *
 */
public class ReportMark {
	private String reportMarkID;//�쳣�嵥���
	private String reportMarkName;//�쳣�嵥����
	private String reportMarkDesc;//�쳣�嵥����
	private double Score;//�쳣�嵥�ܷ���
	private List<ReportItem> itemList;//�쳣�����������
	private java.lang.String BSFLAG;//�Ƿ���Ч
	private Date CREATE_DATE;//����ʱ��
	private Date MODIFY_DATE;//�޸�ʱ��
	
	private String CREATER;//������
	private String UPDATOR;//�޸���
	public String getReportMarkID() {
		return reportMarkID;
	}
	public void setReportMarkID(String reportMarkID) {
		this.reportMarkID = reportMarkID;
	}
	public String getReportMarkName() {
		return reportMarkName;
	}
	public void setReportMarkName(String reportMarkName) {
		this.reportMarkName = reportMarkName;
	}
	public String getReportMarkDesc() {
		return reportMarkDesc;
	}
	public void setReportMarkDesc(String reportMarkDesc) {
		this.reportMarkDesc = reportMarkDesc;
	}
	public double getScore() {
		return Score;
	}
	public void setScore(double score) {
		Score = score;
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
	public List<ReportItem> getItemList() {
		return itemList;
	}
	public void setItemList(List<ReportItem> itemList) {
		this.itemList = itemList;
	}
	
}
