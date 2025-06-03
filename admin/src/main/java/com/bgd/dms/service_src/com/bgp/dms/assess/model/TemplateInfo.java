package com.bgp.dms.assess.model;

import java.util.Date;
import java.util.List;
/**
 * 考核模板,界面和excel中sheet中元素一致
 * @author 高云鹏
 *
 */
public class TemplateInfo {

	private String templateid;//模板编号
	private String TemplateName;//模板名称
	private AssessInfo assessSheetInfo;//考核对象 关联考核对象表级别为excel的sheet级目录的数据
	private String types;//模板类型 0 为后台创建 1为终端用户创建
	private Object assessRootInfo;//考核数根目录，冗余列
	private List<AssessInfo> colHeaderList;//excel表头
	private List<RowAssessInfo> rowAssessList;//excel行数据
	private java.lang.String BSFLAG;//是否有效
	private Date CREATE_DATE;//创建时间
	private Date MODIFY_DATE;//修改时间
	
	
	private String CREATER;//创建人
	private String UPDATOR;//修改人
	
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
