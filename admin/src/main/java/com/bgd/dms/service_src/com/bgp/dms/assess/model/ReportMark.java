package com.bgp.dms.assess.model;

import java.util.Date;
import java.util.List;

/**
 * 考核报告异常清单
 * @author 高云鹏
 *
 */
public class ReportMark {
	private String reportMarkID;//异常清单编号
	private String reportMarkName;//异常清单名称
	private String reportMarkDesc;//异常清单描述
	private double Score;//异常清单总分数
	private List<ReportItem> itemList;//异常子项报告结果集合
	private java.lang.String BSFLAG;//是否有效
	private Date CREATE_DATE;//创建时间
	private Date MODIFY_DATE;//修改时间
	
	private String CREATER;//创建人
	private String UPDATOR;//修改人
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
