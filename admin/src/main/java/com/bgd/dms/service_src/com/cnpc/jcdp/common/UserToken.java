package com.cnpc.jcdp.common;

import java.io.Serializable;

/**
 * @author rechete
 *
 */
public class UserToken implements Serializable{
	//p_auth_user����������û�ID�� 32λ��
	private String userId;
	private String loginId;
	private String userName;
	private String userPwd; // qukejiang 2011-11-08��ӣ����ڵ�¼P6ϵͳ
	private String orgId;
	private String orgName;
	private String charset;
	private String orgCode;
	
	

	private String codeAffordOrgID;
	//��֯����������ϵ���
	private String orgSubjectionId;
	//����λ��������ϵ���
	private String subOrgIDofAffordOrg;
	
	//comm_human_employee�������,Ա����ţ�10λ
	private String empId;
	
	//�Ƿ������ػ���
	private String isCache;
	//�Ƿ�����Ǳ���
	private String isDashbord;
	//�û��������ñ�ʶ
	private String userProfileId;
	
	
	
	private String projectInfoNo;//��Ŀ����
	private String projectName;//��Ŀ��
	private String explorationMethod;//��Ŀʩ������
	//��Ŀ���� 2013.9.24 wuhj���
	private String projectType;
	
	//ʩ������
	private String teamOrgId;
	//���־��еĳ���ͷǳ�����Ŀ
	private String projectCommon;
	
	public String getProjectCommon()
	{
		return projectCommon;
	}

	public void setProjectCommon(String projectCommon)
	{
		this.projectCommon = projectCommon;
	}

	public String getTeamOrgId()
	{
		return teamOrgId;
	}

	public void setTeamOrgId(String teamOrgId)
	{
		this.teamOrgId = teamOrgId;
	}

	public String getProjectType() {
		return projectType;
	}

	public void setProjectType(String projectType) {
		this.projectType = projectType;
	}

	public String getExplorationMethod() {
		return explorationMethod;
	}

	public void setExplorationMethod(String explorationMethod) {
		this.explorationMethod = explorationMethod;
	}

	private Integer projectObjectId;//P6����Ŀ����
	private String projectId;//��Ŀ���
	
    public String getProjectInfoNo() {
		return projectInfoNo;
	}

	public void setProjectInfoNo(String projectInfoNo) {
		this.projectInfoNo = projectInfoNo;
	}

	public String getProjectName() {
		return projectName;
	}

	public void setProjectName(String projectName) {
		this.projectName = projectName;
	}

	public Integer getProjectObjectId() {
		return projectObjectId;
	}

	public void setProjectObjectId(Integer projectObjectId) {
		this.projectObjectId = projectObjectId;
	}

	public String getProjectId() {
		return projectId;
	}

	public void setProjectId(String projectId) {
		this.projectId = projectId;
	}

	public String getOrgCode()
    {
        return orgCode;
    }

    public void setOrgCode(String s)
    {
        orgCode = s;
    }

	public String getCodeAffordOrgID() {
		return codeAffordOrgID;
	}

	public void setCodeAffordOrgID(String codeAffordOrgID) {
		this.codeAffordOrgID = codeAffordOrgID;
	}

	public String getSubOrgIDofAffordOrg() {
		return subOrgIDofAffordOrg;
	}

	public void setSubOrgIDofAffordOrg(String subOrgIDofAffordOrg) {
		this.subOrgIDofAffordOrg = subOrgIDofAffordOrg;
	}

	
	public String getOrgSubjectionId() {
		return orgSubjectionId;
	}

	public void setOrgSubjectionId(String orgSubjectionId) {
		this.orgSubjectionId = orgSubjectionId;
	}

	/**
	 * רҵ W �⾮ T���� M¼�� G���� O����
	 */
	private String speciality;
	
	/**
	 * ��,�ָ���roleId
	 */
	private String roleIds;
	
	//http request session id
	private String reqSessionId;
	//�û���ÿ��request��ӦΨһ��actionid
	private String actionId;
	
	
	//������ϵ
	
	
	
	//С�����ڹ�˾
	
//	private String domainId;
//
//	public String getDomainId() {
//		return domainId;
//	}
//
//	public void setDomainId(String domainId) {
//		this.domainId = domainId;
//	}

	public String getReqSessionId() {
		return reqSessionId;
	}

	public void setReqSessionId(String reqSessionId) {
		this.reqSessionId = reqSessionId;
	}

	public UserToken(){
	}
	
//	public UserToken(User user){
//		this.userId = user.getId();
//		this.userName = user.getName();
//		this.orgId = user.getOrgId();
//		this.orgName = user.getOrgName();
//		this.teamId = user.getTeamId();
//		this.teamName = user.getTeamName();
//	}
	
	public UserToken(String transStr) {
		String[] transStrs = transStr.split("_");
		this.userId = transStrs[0];
		this.userName = transStrs[1];
		this.orgId = transStrs[2];
		this.orgName = transStrs[3];
	}
	
//	public UserToken(String userId){
//		this.userId = userId;
//	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}
	
	public String getOrgId() {
		return orgId;
	}

	public void setOrgId(String orgId) {
		this.orgId = orgId;
	}

	public String getOrgName() {
		return orgName;
	}

	public void setOrgName(String orgName) {
		this.orgName = orgName;
	}




	
	/**
	 * 
	 * @return
	 */
	public String toTransStr() {
		String userId = this.getUserId();
		String userName = this.getUserName();
		String orgId = this.getOrgId();
		String orgName = this.getOrgName();

		return userId + "_" + userName + "_" + orgId + "_" + orgName 
				;
	}



	public String getActionId() {
		return actionId;
	}

	public void setActionId(String actionId) {
		this.actionId = actionId;
	}

	public String getRoleIds() {
		return roleIds;
	}

	public void setRoleIds(String roleIds) {
		this.roleIds = roleIds;
	}

	public String getLoginId() {
		return loginId;
	}

	public void setLoginId(String loginId) {
		this.loginId = loginId;
	}

	/**
	 * רҵ W �⾮ T���� M¼�� G���� O����
	 * @return
	 */
	public String getSpeciality() {
		return speciality;
	}

	public void setSpeciality(String speciality) {
		this.speciality = speciality;
	}

	public String getCharset() {
		return charset;
	}

	public void setCharset(String charset) {
		this.charset = charset;
	}

	public String getEmpId() {
		return empId;
	}

	public void setEmpId(String empId) {
		this.empId = empId;
	}

	public String getUserPwd() {
		return userPwd;
	}

	public void setUserPwd(String userPwd) {
		this.userPwd = userPwd;
	}

	public String getIsCache() {
		return isCache;
	}

	public void setIsCache(String isCache) {
		this.isCache = isCache;
	}

	public String getIsDashbord() {
		return isDashbord;
	}

	public void setIsDashbord(String isDashbord) {
		this.isDashbord = isDashbord;
	}

	public String getUserProfileId() {
		return userProfileId;
	}

	public void setUserProfileId(String userProfileId) {
		this.userProfileId = userProfileId;
	}
	
	

}
