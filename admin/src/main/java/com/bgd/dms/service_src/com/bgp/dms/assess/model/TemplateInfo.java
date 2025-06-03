package com.bgp.dms.assess.model;

import java.util.Date;
import java.util.List;
/**
 * ����ģ��,�����excel��sheet��Ԫ��һ��
 * @author ������
 *
 */
public class TemplateInfo {

	private String templateid;//ģ����
	private String TemplateName;//ģ������
	private AssessInfo assessSheetInfo;//���˶��� �������˶������Ϊexcel��sheet��Ŀ¼������
	private String types;//ģ������ 0 Ϊ��̨���� 1Ϊ�ն��û�����
	private Object assessRootInfo;//��������Ŀ¼��������
	private List<AssessInfo> colHeaderList;//excel��ͷ
	private List<RowAssessInfo> rowAssessList;//excel������
	private java.lang.String BSFLAG;//�Ƿ���Ч
	private Date CREATE_DATE;//����ʱ��
	private Date MODIFY_DATE;//�޸�ʱ��
	
	
	private String CREATER;//������
	private String UPDATOR;//�޸���
	
	public String getTemplateid() {
		return templateid;
	}
	public void setTemplateid(String templateid) {
		this.templateid = templateid;
	}
	public String getTemplateName() {
		return TemplateName;
	}
	public void setTemplateName(String templateName) {
		TemplateName = templateName;
	}
	public AssessInfo getAssessSheetInfo() {
		return assessSheetInfo;
	}
	public void setAssessSheetInfo(AssessInfo assessSheetInfo) {
		this.assessSheetInfo = assessSheetInfo;
	}
	public String getTypes() {
		return types;
	}
	public void setTypes(String types) {
		this.types = types;
	}
	public Object getAssessRootInfo() {
		return assessRootInfo;
	}
	public void setAssessRootInfo(Object assessRootInfo) {
		this.assessRootInfo = assessRootInfo;
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
	public List<AssessInfo> getColHeaderList() {
		return colHeaderList;
	}
	public void setColHeaderList(List<AssessInfo> colHeaderList) {
		this.colHeaderList = colHeaderList;
	}
	public List<RowAssessInfo> getRowAssessList() {
		return rowAssessList;
	}
	public void setRowAssessList(List<RowAssessInfo> rowAssessList) {
		this.rowAssessList = rowAssessList;
	}
	
}
