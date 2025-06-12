package com.cnpc.sais.ibp.auth2.util;

import java.util.Date;
import java.util.List;
import java.util.Map;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.dao.IBaseDao;
import com.cnpc.jcdp.dao.IJdbcDao;
import com.cnpc.jcdp.soa.exception.RetCodeException;
import com.cnpc.jcdp.soa.exception.ServiceException;
import com.cnpc.jcdp.util.StringUtil;
import com.cnpc.sais.ibp.auth.pojo.PAuthOrg;
import com.cnpc.sais.ibp.auth.pojo.PAuthUser;
import com.cnpc.sais.ibp.auth2.dao.AuthLogicDao;

/**
 * 
 * 
 * 
 * 
 */
public class GMSUserUtil {

	private IJdbcDao jdbcDao = BeanFactory.getQueryJdbcDAO();
	private AuthLogicDao authDao = (AuthLogicDao) BeanFactory.getBean("AuthLogicDao");
	private IBaseDao baseDao = BeanFactory.getBaseDao();
	
	/**
	 * 设置GMS系统添加的UserToken属性
	 * @return
	 */
	public void setUserProperty(UserToken userToken)throws ServiceException{
		
		//查询用户的组织机构信息
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT u.emp_id,o.org_id,o.org_name,o.org_level,so.org_subjection_id,so.code_afford_org_id,so.code_afford_if,u.user_pwd");
		sb.append(" FROM p_auth_user u,comm_org_information o,comm_org_subjection so");
		sb.append(" WHERE u.org_id=o.org_id AND o.org_id=so.org_id  and o.bsflag='0' and so.bsflag='0'");
		sb.append(" and u.user_id='").append(userToken.getUserId()).append("'");
		
		Map map = jdbcDao.queryRecordBySQL(sb.toString());		

		if(map!=null){
			userToken.setEmpId(StringUtil.getStrFromMap(map, "empId"));
			userToken.setOrgName(StringUtil.getStrFromMap(map, "orgName"));
			userToken.setOrgSubjectionId(StringUtil.getStrFromMap(map, "orgSubjectionId"));
			userToken.setCodeAffordOrgID(StringUtil.getStrFromMap(map, "codeAffordOrgId"));
			userToken.setUserPwd(StringUtil.getStrFromMap(map, "userPwd"));
		}else{
			throw new RetCodeException("IBP_AUTH_ORG_ERROR");
		}

		sb = new StringBuffer("SELECT so.org_subjection_id FROM comm_org_subjection so ");
		sb.append("WHERE so.org_id='"+userToken.getCodeAffordOrgID()+"' and so.bsflag='0'");
		map = jdbcDao.queryRecordBySQL(sb.toString());
		
		if(map!=null){
			userToken.setSubOrgIDofAffordOrg(StringUtil.getStrFromMap(map, "orgSubjectionId"));
			userToken.setOrgCode(userToken.getSubOrgIDofAffordOrg());
		}else{
			throw new RetCodeException("IBP_AUTH_ORG_ERROR");
		}
		
		// 查询默认项目
		sb = new StringBuffer("select t1.project_info_no,t2.project_common,t2.PROJECT_TYPE,t2.project_name,t2.project_id,t2.exploration_method,p6.object_id as project_object_id");
		sb.append(" from bgp_pm_choosen_project t1 join gp_task_project t2 on t1.project_info_no=t2.project_info_no and t1.user_id='");
		sb.append(userToken.getUserId()).append("' left join bgp_p6_project p6 on p6.project_info_no = t1.project_info_no and p6.bsflag = '0'");
		
		map = jdbcDao.queryRecordBySQL(sb.toString());
		
		if(map!=null){
			userToken.setProjectId(StringUtil.getStrFromMap(map, "projectId"));
			userToken.setProjectInfoNo(StringUtil.getStrFromMap(map, "projectInfoNo"));
			userToken.setProjectName(StringUtil.getStrFromMap(map, "projectName"));
			userToken.setExplorationMethod(StringUtil.getStrFromMap(map, "explorationMethod"));
			//项目类型
			userToken.setProjectType(StringUtil.getStrFromMap(map, "projectType"));
			
			userToken.setProjectCommon(StringUtil.getStrFromMap(map, "projectCommon"));
			
			String projectObjectId = StringUtil.getStrFromMap(map, "projectObjectId");
			if (projectObjectId != null && !"".equals(projectObjectId)) {
				userToken.setProjectObjectId(Integer.parseInt(projectObjectId));
			}

		}
		
		if(map!=null){
			//获取项目的施工队伍信息
			String teamSql = "select org_id from gp_task_project_dynamic  where project_info_no='"+StringUtil.getStrFromMap(map, "projectInfoNo")+"'";
			map = jdbcDao.queryRecordBySQL(teamSql);
		}

		
		if(map!=null && !map.isEmpty()){
			userToken.setTeamOrgId(StringUtil.getStrFromMap(map, "orgId"));
		}
		
		//查询用户个人设置信息
		sb=new StringBuffer("select is_cache,is_dashbord,user_profile_id from p_auth_user_profile_dms where user_id = '"+userToken.getUserId()+"' and bsflag='0'");
		map = jdbcDao.queryRecordBySQL(sb.toString());
		if(map==null){
			userToken.setIsCache("0");
			userToken.setIsDashbord("1");
		}else{
			userToken.setIsCache((String) map.get("isCache"));
			userToken.setIsDashbord((String) map.get("isDashbord"));
			userToken.setUserProfileId((String) map.get("userProfileId"));
		}
	}
	
	public UserToken authUserNoPassword(String loginId,String loginIp) {
		UserToken userToken = null;
		if(loginId==null){
			return null;
		}		
		PAuthUser currentUser = authDao.getUserByLoginId(loginId);
		if(currentUser==null || AuthConstant.USER_REMOVED.equals(currentUser.getUserStatus())) 
			return null;
		
		if(AuthConstant.USER_DISABLED.equals(currentUser.getUserStatus()))
			return null;
		/*if(!verifyUserPassword(currentUser,pwd))
			throw new RetCodeException(AuthConstant.SP_AUTH_PWD_ERROR);*/
		
		currentUser.setLastLoginTime(currentUser.getThisLoginTime());
		currentUser.setThisLoginTime(new Date(System.currentTimeMillis()));
		currentUser.setLoginIp(loginIp);
		baseDao.update(currentUser);
		
		List<String> roleIdList = authDao.getUserRoleIds(loginId);	
		userToken = new UserToken();
		String roleIds = AuthConstant.COMMON_ROLE_ID;
		if(roleIdList!=null){
			for(int i=0;i<roleIdList.size();i++){
				String role  = roleIdList.get(i);
				if(!role.equals(AuthConstant.COMMON_ROLE_ID))
					roleIds += (","+roleIdList.get(i));
			}
		}
		userToken.setRoleIds(roleIds);
		userToken.setUserId(currentUser.getUserId());
		userToken.setLoginId(currentUser.getLoginId());
		userToken.setUserName(currentUser.getUserName());
		userToken.setOrgId(currentUser.getOrgId());
		userToken.setEmpId(currentUser.getEmpId());
		if(currentUser.getOrgId()!=null && !"".equals(currentUser.getOrgId())){
			PAuthOrg authOrg = (PAuthOrg)baseDao.get(PAuthOrg.class, currentUser.getOrgId());
			if(authOrg!=null) userToken.setOrgCode(authOrg.getOrgCode());
		}		
		
		return userToken;
	}
}
