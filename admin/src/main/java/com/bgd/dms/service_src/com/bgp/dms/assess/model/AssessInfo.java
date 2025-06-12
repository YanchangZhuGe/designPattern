package com.bgp.dms.assess.model;

/***********************************************************************
 * Module:  AssessInfo.java
 * Author:  ������
 * desc ���˶��������νṹ�洢
 * Purpose: Defines the Class AssessInfo
 ***********************************************************************/

import java.util.*;

public class AssessInfo {

	private java.lang.String assessInfoID;//����
	private java.lang.String assessInfoCode;//�㼶���� ����0101 010102
	private AssessInfo rootNode;
	private List<AssessInfo> superiorAssessInfos;//�ϼ��ڵ㼯��
	private String isdisplay;//�Ƿ���ʾ 0 ��ʾ 1����
	private List<AssessInfo> childAssessInfos;//�¼��ڵ㼯��

	private java.lang.String assessInfoName;//��˽ڵ�����

	private java.lang.Boolean isLeaf;//�Ƿ�Ҷ�ڵ�

	private java.lang.Boolean isRoot;//�Ƿ���ڵ�
	
	private java.lang.Boolean isSheet;//�Ƿ�excel��sheet�ڵ�
	
	private java.lang.Boolean isColHeader;//�Ƿ�excel���е�ͷ�ڵ�
	
	private java.lang.Boolean isRowHeader;//�Ƿ�excel���е�ͷ�ڵ�

	private String nodetypes;//�ڵ����� N�Ƿ�Ϊ��Ŀ¼ L�Ƿ�ΪҶĿ¼
	
	private String excelType;//excelά��H:�����ݼ����˵� L:�����ݣ�������Ҫ�� N:��ͨ�ڵ� S:sheet �ڵ�
	
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

	private double fullScore;//��ռ����

	
	
	private String remarks;//����
	
	private int displayOrder;//��ʾλ�ã���ֵԽ��Խ��ǰ
	
	private int level;//�����㼶

	private double QualifiedScore;//�������
	private java.lang.String BSFLAG;//�Ƿ���Ч
	private Date CREATE_DATE;//����ʱ��
	private Date MODIFY_DATE;//�޸�ʱ��
	
	private String CREATER;//������
	private String UPDATOR;//�޸���
	
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
