package com.bgp.dms.assess.model;

import java.util.Date;
import java.util.List;

/**
 * 考核报告
 * @author 高云鹏
 * 用对应的考核模板考核对应的被考核对象
 */
public class ReportInfo {

	private String reportId;//考核报告流水号 主键
	private String orgid;//被考核单位
	private TemplateInfo templateInfo;//所用模板
	private String reviewer;//考核人
	private String opinion;//考核意见
	private java.lang.String BSFLAG;//是否有效
	private Date CREATE_DATE;//创建时间
	private Date MODIFY_DATE;//修改时间
	
	private String CREATER;//创建人
	private String UPDATOR;//修改人
	private List<ReportItem> reportItemList;//考核子项结果集合
	public String getReportId() {
		return reportId;
	}
	public void setReportId(String reportId) {
		this.reportId = reportId;
	}
	public String getOrgid() {
		return orgid;
	}
	public void setOrgid(String orgid) {
		this.orgid = orgid;
	}
	public TemplateInfo getTemplateInfo() {
		return templateInfo;
	}
	public void setTemplateInfo(TemplateInfo templateInfo) {
		this.templateInfo = templateInfo;
	}
	public String getReviewer() {
		return reviewer;
	}
	public void setReviewer(String reviewer) {
		this.reviewer = reviewer;
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
	public String getOpinion() {
		return opinion;
	}
	public void setOpinion(String opinion) {
		this.opinion = opinion;
	}
	public List<ReportItem> getReportItemList() {
		return reportItemList;
	}
	public void setReportItemList(List<ReportItem> reportItemList) {
		this.reportItemList = reportItemList;
	}
	
}
