package com.bgp.dms.assess.model;

/***********************************************************************
 * Module:  AssessInfo.java
 * Author:  高云鹏
 * desc 考核对象，以树形结构存储
 * Purpose: Defines the Class AssessInfo
 ***********************************************************************/

import java.util.*;

public class AssessInfo {

	private java.lang.String assessInfoID;//主键
	private java.lang.String assessInfoCode;//层级编码 例如0101 010102
	private AssessInfo rootNode;
	private List<AssessInfo> superiorAssessInfos;//上级节点集合
	private String isdisplay;//是否显示 0 显示 1隐藏
	private List<AssessInfo> childAssessInfos;//下级节点集合

	private java.lang.String assessInfoName;//审核节点名称

	private java.lang.Boolean isLeaf;//是否叶节点

	private java.lang.Boolean isRoot;//是否跟节点
	
	private java.lang.Boolean isSheet;//是否excel的sheet节点
	
	private java.lang.Boolean isColHeader;//是否excel的列的头节点
	
	private java.lang.Boolean isRowHeader;//是否excel的行的头节点

	private String nodetypes;//节点类型 N是否为根目录 L是否为叶目录
	
	private String excelType;//excel维度H:行数据即考核点 L:列数据，即考核要素 N:普通节点 S:sheet 节点
	
	public String getNodetypes() {
		return nodetypes;
	}

	public void setNodetypes(String nodetypes) {
		this.nodetypes = nodetypes;
	}

	public String getExcelType() {
		return excelType;
	}

	public void setExcelType(String excelType) {
		this.excelType = excelType;
	}

	private double fullScore;//所占分数

	
	
	private String remarks;//描述
	
	private int displayOrder;//显示位置，数值越大越靠前
	
	private int level;//所属层级

	private double QualifiedScore;//及格分数
	private java.lang.String BSFLAG;//是否有效
	private Date CREATE_DATE;//创建时间
	private Date MODIFY_DATE;//修改时间
	
	private String CREATER;//创建人
	private String UPDATOR;//修改人
	
	public java.lang.String getBSFLAG() {
		return BSFLAG;
	}

	public void setBSFLAG(java.lang.String bSFLAG) {
		BSFLAG = bSFLAG;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public int getDisplayOrder() {
		return displayOrder;
	}

	public void setDisplayOrder(int displayOrder) {
		this.displayOrder = displayOrder;
	}

	public int getLevel() {
		return level;
	}

	public void setLevel(int level) {
		this.level = level;
	}

	

	public double getQualifiedScore() {
		return QualifiedScore;
	}

	public void setQualifiedScore(Double qualifiedScore) {
		QualifiedScore = qualifiedScore;
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

	public java.lang.String getAssessInfoID() {
		return assessInfoID;
	}

	public void setAssessInfoID(java.lang.String assessInfoID) {
		this.assessInfoID = assessInfoID;
	}

	public java.lang.String getAssessInfoCode() {
		return assessInfoCode;
	}

	public void setAssessInfoCode(java.lang.String assessInfoCode) {
		this.assessInfoCode = assessInfoCode;
	}

	public List<AssessInfo> getSuperiorAssessInfos() {
		return superiorAssessInfos;
	}

	public void setSuperiorAssessInfos(List<AssessInfo> superiorAssessInfos) {
		this.superiorAssessInfos = superiorAssessInfos;
	}

	public java.lang.Boolean getIsLeaf() {
		return isLeaf;
	}

	public void setIsLeaf(java.lang.Boolean isLeaf) {
		this.isLeaf = isLeaf;
	}

	public java.lang.Boolean getIsRoot() {
		return isRoot;
	}

	public void setIsRoot(java.lang.Boolean isRoot) {
		this.isRoot = isRoot;
	}

	public double getFullScore() {
		return fullScore;
	}

	public void setFullScore(double fullScore) {
		this.fullScore = fullScore;
	}

	

	public List<AssessInfo> getChildAssessInfos() {
		return childAssessInfos;
	}

	public void setChildAssessInfos(List<AssessInfo> childAssessInfos) {
		this.childAssessInfos = childAssessInfos;
	}

	public java.lang.String getAssessInfoName() {
		return assessInfoName;
	}

	public void setAssessInfoName(java.lang.String assessInfoName) {
		this.assessInfoName = assessInfoName;
	}

	public java.lang.Boolean getIsSheet() {
		return isSheet;
	}

	public void setIsSheet(java.lang.Boolean isSheet) {
		this.isSheet = isSheet;
	}

	public java.lang.Boolean getIsColHeader() {
		return isColHeader;
	}

	public void setIsColHeader(java.lang.Boolean isColHeader) {
		this.isColHeader = isColHeader;
	}

	public java.lang.Boolean getIsRowHeader() {
		return isRowHeader;
	}

	public void setIsRowHeader(java.lang.Boolean isRowHeader) {
		this.isRowHeader = isRowHeader;
	}

	public AssessInfo getRootNode() {
		return rootNode;
	}

	public void setRootNode(AssessInfo rootNode) {
		this.rootNode = rootNode;
	}

	public String getIsdisplay() {
		return isdisplay;
	}

	public void setIsdisplay(String isdisplay) {
		this.isdisplay = isdisplay;
	}

}
