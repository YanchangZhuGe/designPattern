package com.bgp.dms.assess.model;

import java.util.Date;
import java.util.List;

/**
 * ���˱���
 * @author ������
 * �ö�Ӧ�Ŀ���ģ�忼�˶�Ӧ�ı����˶���
 */
public class ReportInfo {

	private String reportId;//���˱�����ˮ�� ����
	private String orgid;//�����˵�λ
	private TemplateInfo templateInfo;//����ģ��
	private String reviewer;//������
	private String opinion;//�������
	private java.lang.String BSFLAG;//�Ƿ���Ч
	private Date CREATE_DATE;//����ʱ��
	private Date MODIFY_DATE;//�޸�ʱ��
	
	private String CREATER;//������
	private String UPDATOR;//�޸���
	private List<ReportItem> reportItemList;//��������������
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
