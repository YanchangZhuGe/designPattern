package com.cnpc.jcdp.common;

import java.io.Serializable;

/**
 * @author rechete
 *
 */
public class UserToken implements Serializable{
	//p_auth_user表的主键，用户ID， 32位长
	private String userId;
	private String loginId;
	private String userName;
	private String userPwd; // qukejiang 2011-11-08添加，用于登录P6系统
	private String orgId;
	private String orgName;
	private String charset;
	private String orgCode;
	
	

	private String codeAffordOrgID;
	//组织机构隶属关系编号
	private String orgSubjectionId;
	//管理单位的隶属关系编号
	private String subOrgIDofAffordOrg;
	
	//comm_human_employee表的主键,员工编号，10位
	private String empId;
	
	//是否开启本地缓存
	private String isCache;
	//是否加载仪表盘
	private String isDashbord;
	//用户个人配置标识
	private String userProfileId;
	
	
	
	private String projectInfoNo;//项目主键
	private String projectName;//项目名
	private String explorationMethod;//项目施工方法
	//项目类型 2013.9.24 wuhj需改
	private String projectType;
	
	//施工队伍
	private String teamOrgId;
	//区分井中的常规和非常规项目
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

	private Integer projectObjectId;//P6中项目主键
	private String projectId;//项目编号
	
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
	 * 专业 W 测井 T测试 M录井 G解释 O其他
	 */
	private String speciality;
	
	/**
	 * 以,分割多个roleId
	 */
	private String roleIds;
	
	//http request session id
	private String reqSessionId;
	//用户的每次request对应唯一的actionid
	private String actionId;
	
	
	//隶属关系
	
	
	
	//小队属于公司
	
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
	 * 专业 W 测井 T测试 M录井 G解释 O其他
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
