package com.primavera.ws.p6.resourceassignment;

import java.util.Date;

/**
 * 
 * 标题：中石油集团公司生产管理系统
 * 
 * 专业：物探专业
 * 
 * 公司: 中油瑞飞
 * 
 * 作者：李俊强，Jan 13, 2012
 * 
 * 描述：
 * 
 * 说明:
 */
public class ResourceAssignmentExtends {
	
	private ResourceAssignment resourceAssignment;
	private String orgId;
	private String orgSubjectionId;
	private String submitFlag;
	private Date modifiDate;
	private String bsflag;
	private Double budgetedUnits;
	
	public ResourceAssignmentExtends() {
		super();
		this.resourceAssignment = new ResourceAssignment();
		this.orgId = "";
		this.orgSubjectionId = "";
		this.submitFlag = "0";
		this.bsflag = "0";
		this.modifiDate = new Date();
		this.budgetedUnits = 0.0;
	}
	
	public ResourceAssignmentExtends(ResourceAssignment resourceAssignment,
			String orgId, String orgSubjectionId, String submitFlag, Date modifiDate, String bsflag, Double budgetedUnits) {
		super();
		this.resourceAssignment = resourceAssignment;
		this.orgId = orgId;
		this.orgSubjectionId = orgSubjectionId;
		this.submitFlag = submitFlag;
		this.modifiDate = modifiDate;
		this.bsflag = bsflag;
		this.budgetedUnits = budgetedUnits;
	}
	
	public ResourceAssignmentExtends(ResourceAssignment resourceAssignment) {
		super();
		this.resourceAssignment = resourceAssignment;
		this.orgId = "";
		this.orgSubjectionId = "";
		this.submitFlag = "0";
		this.bsflag = "0";
		this.modifiDate = new Date();
		this.budgetedUnits = 0.0;
	}

	public String getOrgId() {
		return orgId;
	}
	public void setOrgId(String orgId) {
		this.orgId = orgId;
	}
	public String getOrgSubjectionId() {
		return orgSubjectionId;
	}
	public void setOrgSubjectionId(String orgSubjectionId) {
		this.orgSubjectionId = orgSubjectionId;
	}
	public String getSubmitFlag() {
		return submitFlag;
	}
	public void setSubmitFlag(String submitFlag) {
		this.submitFlag = submitFlag;
	}
	public ResourceAssignment getResourceAssignment() {
		return resourceAssignment;
	}
	public void setResourceAssignment(ResourceAssignment resourceAssignment) {
		this.resourceAssignment = resourceAssignment;
	}

	public Date getModifiDate() {
		return modifiDate;
	}

	public void setModifiDate(Date modifiDate) {
		this.modifiDate = modifiDate;
	}

	public String getBsflag() {
		return bsflag;
	}

	public void setBsflag(String bsflag) {
		this.bsflag = bsflag;
	}

	public Double getBudgetedUnits() {
		return budgetedUnits;
	}

	public void setBudgetedUnits(Double budgetedUnits) {
		this.budgetedUnits = budgetedUnits;
	}

}
