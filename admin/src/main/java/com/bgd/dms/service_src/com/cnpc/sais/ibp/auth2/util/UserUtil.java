package com.cnpc.sais.ibp.auth2.util;



import java.util.Date;
import java.util.Hashtable;
import java.util.List;
import java.util.Map;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.dao.IBaseDao;
import com.cnpc.jcdp.icg.ldap.ADProxy;
import com.cnpc.jcdp.icg.ldap.ADServerInfo;
import com.cnpc.jcdp.soa.exception.RetCodeException;
import com.cnpc.jcdp.soa.exception.ServiceException;
import com.cnpc.sais.ibp.auth2.dao.AuthLogicDao;
import com.cnpc.sais.ibp.auth.pojo.PAuthOrg;
import com.cnpc.sais.ibp.auth.pojo.PAuthUser;

/**
 * Project：SAIS(Service)
 * 
 * Creator：rechete
 * 
 * Creator Time:2008-4-28 上午10:17:47
 * 
 * Description：System User Management Util
 * 
 * Revision history：
 * 
 * 
 * 
 */
public class UserUtil {
	private AuthLogicDao authDao = (AuthLogicDao) BeanFactory.getBean("AuthLogicDao");

	private IBaseDao baseDao = BeanFactory.getBaseDao();
	private UserToken userToken;
	private static Map<String,ADServerInfo> adServeres = new Hashtable<String,ADServerInfo> ();
	
	static{
		ADServerInfo server = new ADServerInfo();
		server.setDomainName("@cnpc.com.cn");
		server.setIpAddr("cnpc.com.cn");
		server.setPort("389");
		adServeres.put("cnpc.com.cn", server);
	}
	
	public Map queryUserProfile(String userId){
		String sql = "SELECT * FROM ew_pc_profile WHERE ENTITY_REF_ID='"+userId+"'";
		Map ret = authDao.getJdbcDao().queryRecordBySQL(sql);
		return ret;
	}
	
	/**
	 * 根据userToken构建User对象
	 * @param userToken
	 * @return
	 */
	public static PAuthUser constructUser(UserToken userToken){
		PAuthUser user = new PAuthUser();
		//initialize role property
		String roleIds = userToken.getRoleIds();
		if(roleIds!=null || roleIds.trim().equals("")){
			String[] roleArray = roleIds.split(",");
			for(int i=0;i<roleArray.length;i++){
				user.addRole(RoleUtil.getRole(roleArray[i]));
			}
		}
		//initialize org property
		PAuthOrg org = OrgUtil.getOrg(userToken.getOrgId());
		user.setOrg(org);
		
		return user;
	}
	
	private static ADServerInfo getADServerInfo(String domain){ 
		return adServeres.get(domain);
	}
	
	private boolean verifyUserPassword(PAuthUser currentUser,String pwd){
		boolean ret = false;
		
		ADServerInfo adServer = currentUser.getDomain()==null?null:getADServerInfo(currentUser.getDomain());		
	    if(adServer==null){ 
	    	pwd = PasswordUtil.encrypt(pwd);
			ret = pwd.equals(currentUser.getUserPwd());
	    }
		else{	
			ret = ADProxy.authenticateByAD(adServer, currentUser.getLoginId(), pwd);
		}
		return ret;
	}
	

	
	/**
	 * 用户登陆验证
	 * @param userId
	 * @param pwd 未加密的密码
	 * @return
	 */
	public UserToken authUser(String loginId,String pwd,String loginIp)throws ServiceException{
		if(loginId==null){
			throw new RetCodeException(AuthConstant.SP_AUTH_USER_NOTEXIST);
		}		
		PAuthUser currentUser = authDao.getUserByLoginId(loginId);
		if(currentUser==null || 
				AuthConstant.USER_REMOVED.equals(currentUser.getUserStatus())) 
			throw new RetCodeException(AuthConstant.SP_AUTH_USER_NOTEXIST);
		
		if(AuthConstant.USER_DISABLED.equals(currentUser.getUserStatus()))
			throw new RetCodeException(AuthConstant.SP_AUTH_USER_DISABLED);
		if(!verifyUserPassword(currentUser,pwd))
			throw new RetCodeException(AuthConstant.SP_AUTH_PWD_ERROR);
		
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
	
	
	/**
	 * 
	* @Title: authUserBGPSFRZ
	* @Description: 东方物探统一身份登陆验证
	* @param @param loginId  用户登录名
	* @param @param loginIp  用户认证
	* @param @return
	* @param @throws ServiceException    设定文件
	* @return UserToken    返回类型
	* @throws
	 */
	public UserToken authUserBGPSFRZ(String loginId,String loginIp)throws ServiceException{
		if(loginId==null){
			throw new RetCodeException(AuthConstant.SP_AUTH_USER_NOTEXIST);
		}		
		PAuthUser currentUser = authDao.getUserByLoginId(loginId);
		if(currentUser==null || 
				AuthConstant.USER_REMOVED.equals(currentUser.getUserStatus())) 
			throw new RetCodeException(AuthConstant.SP_AUTH_USER_NOTEXIST);
		
		if(AuthConstant.USER_DISABLED.equals(currentUser.getUserStatus()))
			throw new RetCodeException(AuthConstant.SP_AUTH_USER_DISABLED);
//		if(!verifyUserPassword(currentUser,pwd))
//			throw new RetCodeException(AuthConstant.SP_AUTH_PWD_ERROR);
		
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
	
	
	/**
	 * 用户身份认证登陆验证
	 * @param userId
	 * @param pwd 未加密的密码
	 * @return
	 * @throws Exception 
	 */
	public UserToken authUserSFRZ(String loginId,String loginIp,String cerficate)throws Exception{
		if(loginId==null){
			loginId = "anonymous_user";
		}		
		PAuthUser currentUser = authDao.getUserByLoginId(loginId);
		if(currentUser==null || AuthConstant.USER_REMOVED.equals(currentUser.getUserStatus())) 
			throw new RetCodeException(AuthConstant.SP_AUTH_USER_NOTEXIST);
		
		if(AuthConstant.USER_DISABLED.equals(currentUser.getUserStatus()))
			throw new RetCodeException(AuthConstant.SP_AUTH_USER_DISABLED);
		
		//证书验证
		//请求IP地址
		String ips[] = {"10.21.14.236"};
		//请求证书号
		String ca_numbers[] = {"S000000217"};
		int outErrorIP = 0;
		boolean equalsIP = false,equalsCA = false;
		int outErrorCA = 0;
		for(int i=0;i<ips.length;i++) {
			String main_url = ips[i];
			//验证IP
			if(main_url.equals(loginIp)){
				equalsIP = true;
					for(int j=0;j<ca_numbers.length;j++) {
						String ca_number = ca_numbers[j];
						if(ca_number.equals(cerficate)) {
							equalsCA = true;
							if(loginId==null) {
								throw new RetCodeException(AuthConstant.SP_AUTH_USER_NOTEXIST);
							}
						}else {
							if(equalsCA == false) {
								outErrorCA++;
								if(outErrorCA==1) {
									throw new RetCodeException("SP_AUTH_CERF_ERROR");
								}
							}
						}
					}
			}else {
				if(equalsIP == false){
					outErrorIP++;
					if(outErrorIP==1) {
						throw new RetCodeException("SP_AUTH_IP_NOT_INTER");
					}
				}
			}
			
		}

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
