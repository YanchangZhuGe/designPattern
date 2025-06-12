package com.bgp.mcs.service.pm.bpm.workFlow.srv;

import java.util.HashMap;
import java.util.Map;

import com.cnpc.jcdp.common.UserToken;

public class WFVarBean {

	//ҵ������
	private String businessId;
	//ҵ�����
	private String businessTableName;
	//ҵ������ �ؼ�
	private String businessType;
	// �ύ����
	private String applicantDate;
	private String businessInfo;
	
	
	// ����Ŀ�����־
	private String projectName;
	// ��������Ϣ
	private UserToken user;
	

	
	//����ʵ������
	private Map wfVarMap =new HashMap();
		
	
	
	//����������ȡ��Ϣ
		private String queryBuilder;
		private String queryBuilderMean;
		private String listBuilder;
		private String listBuilderMean;
		private String businessLinks;
		
		
		
	public WFVarBean() {

	}

	public String getBusinessId() {
		return businessId;
	}


	public WFVarBean(String businessId, String businessTableName, String businessType,String businessInfo, String queryBuilder, String queryBuilderMean,
			String listBuilder, String listBuilderMean, String businessLinks, Map wfVarMap, String projectName, UserToken user,
			String applicantDate) {
		super();
		this.businessId = businessId;
		this.businessTableName = businessTableName;
		this.businessType = businessType;
		this.businessInfo=businessInfo;
		this.queryBuilder = queryBuilder;
		this.queryBuilderMean = queryBuilderMean;
		this.listBuilder = listBuilder;
		this.listBuilderMean = listBuilderMean;
		this.businessLinks = businessLinks;
		this.wfVarMap.putAll(wfVarMap);
		this.wfVarMap.put("wfNar_orgName", user.getOrgName());
		this.wfVarMap.put("wfNar_userName", user.getUserName());
		this.projectName = projectName;
		this.user = user;
		this.applicantDate = applicantDate;
	}

	//�ύ���̳�ʼ��bean
	public WFVarBean(String businessId, String businessTableName, String businessType,String businessInfo,  Map wfVarMap, String projectName, UserToken user,
			String applicantDate){
		super();
		this.businessId = businessId;
		this.businessTableName = businessTableName;
		this.businessType = businessType;
		this.businessInfo=businessInfo;
		this.wfVarMap.putAll(wfVarMap);
		this.projectName = projectName;
		this.user = user;
		this.applicantDate = applicantDate;
	}

	public void setBusinessId(String businessId) {
		this.businessId = businessId;
	}

	public String getBusinessTableName() {
		return businessTableName;
	}

	public void setBusinessTableName(String businessTableName) {
		this.businessTableName = businessTableName;
	}

	public String getBusinessType() {
		return businessType;
	}

	public void setBusinessType(String businessType) {
		this.businessType = businessType;
	}

	public String getQueryBuilder() {
		return queryBuilder;
	}

	public void setQueryBuilder(String queryBuilder) {
		this.queryBuilder = queryBuilder;
	}

	public String getQueryBuilderMean() {
		return queryBuilderMean;
	}

	public void setQueryBuilderMean(String queryBuilderMean) {
		this.queryBuilderMean = queryBuilderMean;
	}

	public String getListBuilder() {
		return listBuilder;
	}

	public void setListBuilder(String listBuilder) {
		this.listBuilder = listBuilder;
	}

	public String getListBuilderMean() {
		return listBuilderMean;
	}

	public void setListBuilderMean(String listBuilderMean) {
		this.listBuilderMean = listBuilderMean;
	}

	public String getBusinessLinks() {
		return businessLinks;
	}

	public void setBusinessLinks(String businessLinks) {
		this.businessLinks = businessLinks;
	}

	public Map getWfVarMap() {
		return wfVarMap;
	}

	public void setWfVarMap(Map wfVarMap) {
		this.wfVarMap = wfVarMap;
	}

	public String getProjectName() {
		return projectName;
	}

	public void setProjectName(String projectName) {
		this.projectName = projectName;
	}

	public UserToken getUser() {
		return user;
	}

	public void setUser(UserToken user) {
		this.user = user;
	}

	public String getApplicantDate() {
		return applicantDate;
	}

	public void setApplicantDate(String applicantDate) {
		this.applicantDate = applicantDate;
	}

	public String getBusinessInfo() {
		return businessInfo;
	}

	public void setBusinessInfo(String businessInfo) {
		this.businessInfo = businessInfo;
	}

	protected Object clone() throws CloneNotSupportedException {
		WFVarBean wfVar = new WFVarBean(businessId,  businessTableName,businessType,businessInfo, queryBuilder, queryBuilderMean, listBuilder, listBuilderMean, businessLinks,
				wfVarMap, projectName, user, applicantDate);
		return wfVar;
	}

}
