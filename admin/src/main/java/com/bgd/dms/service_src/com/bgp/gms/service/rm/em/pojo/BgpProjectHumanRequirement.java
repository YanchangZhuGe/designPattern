package com.bgp.gms.service.rm.em.pojo;

public class BgpProjectHumanRequirement {

	private String requirementNo;
	private String projectInfoNo;
	
	private String creator;
	private String createDate;
	private String updator;
	private String modifyDate;
	private String baflag;
	private String proflag;
	public String getProflag() {
		return proflag;
	}
	public void setProflag(String proflag) {
		this.proflag = proflag;
	}
	private String lockedIf;

	private String notes;
	private String spare1;
	private String spare2;
	private String spare3;
	private String spare4;
	private String spare5;
	
	private String orgSubjectionId;
	public String getOrgSubjectionId() {
		return orgSubjectionId;
	}
	public void setOrgSubjectionId(String orgSubjectionId) {
		this.orgSubjectionId = orgSubjectionId;
	}
	private String applyCompany;
	private String applyCompanySub;
	public String getApplyCompanySub() {
		return applyCompanySub;
	}
	public void setApplyCompanySub(String applyCompanySub) {
		this.applyCompanySub = applyCompanySub;
	}
	private String applyDate;
	private String applyState;
	private String applyNo;


	private String applicantId;

	private String procInstId;
	private String procId;
	private String procStatus;
	private String documentId;
	
	private String applicantOrgName;
	private String applicantOrgSubName;
	public String getApplicantOrgSubName() {
		return applicantOrgSubName;
	}
	public void setApplicantOrgSubName(String applicantOrgSubName) {
		this.applicantOrgSubName = applicantOrgSubName;
	}
	private String applicantName;
	private String projectName;
	
	private String noticeUserId;
	private String noticeUser;
	private String noticeWay;
	
	
	public String getNoticeUserId() {
		return noticeUserId;
	}
	public void setNoticeUserId(String noticeUserId) {
		this.noticeUserId = noticeUserId;
	}
	public String getNoticeUser() {
		return noticeUser;
	}
	public void setNoticeUser(String noticeUser) {
		this.noticeUser = noticeUser;
	}
	public String getNoticeWay() {
		return noticeWay;
	}
	public void setNoticeWay(String noticeWay) {
		this.noticeWay = noticeWay;
	}
	public String getRequirementNo() {
		return requirementNo;
	}
	public void setRequirementNo(String requirementNo) {
		this.requirementNo = requirementNo;
	}
	public String getProjectInfoNo() {
		return projectInfoNo;
	}
	public void setProjectInfoNo(String projectInfoNo) {
		this.projectInfoNo = projectInfoNo;
	}
	public String getCreator() {
		return creator;
	}
	public void setCreator(String creator) {
		this.creator = creator;
	}
	public String getCreateDate() {
		return createDate;
	}
	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}
	public String getUpdator() {
		return updator;
	}
	public void setUpdator(String updator) {
		this.updator = updator;
	}
	public String getModifyDate() {
		return modifyDate;
	}
	public void setModifyDate(String modifyDate) {
		this.modifyDate = modifyDate;
	}
	public String getBaflag() {
		return baflag;
	}
	public void setBaflag(String baflag) {
		this.baflag = baflag;
	}
	public String getLockedIf() {
		return lockedIf;
	}
	public void setLockedIf(String lockedIf) {
		this.lockedIf = lockedIf;
	}
	public String getNotes() {
		return notes;
	}
	public void setNotes(String notes) {
		this.notes = notes;
	}
	public String getSpare1() {
		return spare1;
	}
	public void setSpare1(String spare1) {
		this.spare1 = spare1;
	}
	public String getSpare2() {
		return spare2;
	}
	public void setSpare2(String spare2) {
		this.spare2 = spare2;
	}
	public String getSpare3() {
		return spare3;
	}
	public void setSpare3(String spare3) {
		this.spare3 = spare3;
	}
	public String getSpare4() {
		return spare4;
	}
	public void setSpare4(String spare4) {
		this.spare4 = spare4;
	}
	public String getSpare5() {
		return spare5;
	}
	public void setSpare5(String spare5) {
		this.spare5 = spare5;
	}
	public String getApplyCompany() {
		return applyCompany;
	}
	public void setApplyCompany(String applyCompany) {
		this.applyCompany = applyCompany;
	}
	public String getApplyDate() {
		return applyDate;
	}
	public void setApplyDate(String applyDate) {
		this.applyDate = applyDate;
	}
	public String getApplyState() {
		return applyState;
	}
	public void setApplyState(String applyState) {
		this.applyState = applyState;
	}
	public String getApplyNo() {
		return applyNo;
	}
	public void setApplyNo(String applyNo) {
		this.applyNo = applyNo;
	}

	public String getApplicantId() {
		return applicantId;
	}
	public void setApplicantId(String applicantId) {
		this.applicantId = applicantId;
	}
	public String getProcInstId() {
		return procInstId;
	}
	public void setProcInstId(String procInstId) {
		this.procInstId = procInstId;
	}
	public String getProcId() {
		return procId;
	}
	public void setProcId(String procId) {
		this.procId = procId;
	}
	public String getProcStatus() {
		return procStatus;
	}
	public void setProcStatus(String procStatus) {
		this.procStatus = procStatus;
	}
	public String getDocumentId() {
		return documentId;
	}
	public void setDocumentId(String documentId) {
		this.documentId = documentId;
	}
	public String getApplicantOrgName() {
		return applicantOrgName;
	}
	public void setApplicantOrgName(String applicantOrgName) {
		this.applicantOrgName = applicantOrgName;
	}
	public String getApplicantName() {
		return applicantName;
	}
	public void setApplicantName(String applicantName) {
		this.applicantName = applicantName;
	}
	public String getProjectName() {
		return projectName;
	}
	public void setProjectName(String projectName) {
		this.projectName = projectName;
	}
	@Override
	public String toString() {
		return "BgpProjectHumanRequirement [requirementNo=" + requirementNo
				+ ", projectInfoNo=" + projectInfoNo + ", creator=" + creator
				+ ", createDate=" + createDate + ", updator=" + updator
				+ ", modifyDate=" + modifyDate + ", baflag=" + baflag
				+ ", proflag=" + proflag + ", lockedIf=" + lockedIf
				+ ", notes=" + notes + ", spare1=" + spare1 + ", spare2="
				+ spare2 + ", spare3=" + spare3 + ", spare4=" + spare4
				+ ", spare5=" + spare5 + ", applyCompany=" + applyCompany
				+ ", applyDate=" + applyDate + ", applyState=" + applyState
				+ ", applyNo=" + applyNo + ", applicantId=" + applicantId
				+ ", procInstId=" + procInstId + ", procId=" + procId
				+ ", procStatus=" + procStatus + ", documentId=" + documentId
				+ ", applicantOrgName=" + applicantOrgName + ", applicantName="
				+ applicantName + ", projectName=" + projectName
				+ ", noticeUserId=" + noticeUserId + ", noticeUser="
				+ noticeUser + ", noticeWay=" + noticeWay + "]";
	}



}
