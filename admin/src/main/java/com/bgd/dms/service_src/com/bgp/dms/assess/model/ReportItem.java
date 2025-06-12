package com.bgp.dms.assess.model;

import java.util.Date;

/**
 * 考核结果明细
 * 考核结果中,级别为叶级节点的考核点考核结果
 * @author 高云鹏
 *
 */
public class ReportItem {
	private String itemReportID;//考核明细编号
	private ReportInfo reportInfo;//考核明细编号
	private Object itemAssessInfo;//级别为叶级节点的考核点
	private double itemScore;//级别为叶级节点的考核分数
	private java.lang.String BSFLAG;//是否有效
	private java.lang.String types;//考核子项类型 0 正常 1异常
	private boolean isSpecial;
	private Date CREATE_DATE;//创建时间
	private Date MODIFY_DATE;//修改时间
	
	private String CREATER;//创建人
	private String UPDATOR;//修改人
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
