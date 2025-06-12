package com.cnpc.sais.ibp.auth2.srv;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.xml.soap.SOAPException;

import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.JdbcTemplate;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.TreeNodeData;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;
import com.cnpc.jcdp.soa.srvMng.SrvCfgInitializor;
import com.cnpc.jcdp.util.CommonUtil;
import com.cnpc.sais.ibp.auth.pojo.PAuthMenu;
import com.cnpc.sais.ibp.auth2.util.AuthInitializor;
import com.cnpc.sais.ibp.auth2.util.GMSUserUtil;
import com.cnpc.sais.ibp.auth2.util.MenuUtil;
import com.cnpc.sais.ibp.auth2.util.PasswordUtil;
import com.cnpc.sais.ibp.auth2.util.RoleUtil;
import com.cnpc.sais.ibp.auth2.util.UserUtil;


public class LoginAndMenuTreeSrv extends BaseService{
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");

	public static boolean reloadAuthCacheRunning = false;
	
	public ISrvMsg updateUserLogin(ISrvMsg reqDTO) throws Exception{

		String loginId = reqDTO.getValue("loginId");
		String userPwd = reqDTO.getValue("userPwd");
		String loginIp = reqDTO.getValue("loginIp");
		UserUtil userUtil = new UserUtil(); 
		UserToken user = userUtil.authUser(loginId, userPwd,loginIp);
		user.setCharset(reqDTO.getValue("charset"));
		GMSUserUtil gmsUserUtil = new GMSUserUtil();
		gmsUserUtil.setUserProperty(user);
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("userToken", user);
		msg.setValue("funCodes", RoleUtil.getFunctionCodesByRoleIds(user.getRoleIds()));
		  
		Map userProfile = userUtil.queryUserProfile(user.getUserId());		
		if(userProfile!=null){
			msg.setValue("userProfile", userProfile);		
		}
		return msg;
	}
	

	/**
	 * 
	* @Title: updateUserLoginBGPSFRZ
	* @Description:  东方物探统一认证平台接口
	* @param @param reqDTO
	* @param @return
	* @param @throws Exception    设定文件
	* @return ISrvMsg    返回类型
	* @throws
	 */
	public Map<String , Object> updateUserLoginBGPSFRZ(String loginId, String loginIp,String charset) {
 
		UserUtil userUtil = new UserUtil();
		UserToken user = userUtil.authUserBGPSFRZ(loginId, loginIp);
		user.setCharset(charset);
//		user.setCharset(reqDTO.getValue("charset"));
		GMSUserUtil gmsUserUtil = new GMSUserUtil();
		gmsUserUtil.setUserProperty(user);  
//		msg.setValue("userToken", user);
//		msg.setValue("funCodes", RoleUtil.getFunctionCodesByRoleIds(user.getRoleIds()));
//		
		Map userProfile = userUtil.queryUserProfile(user.getUserId());		
	
		//添加用户登录日志
		Map<Object,Object> map = new HashMap<Object,Object>();
		
		if(!("superadmin").equals(user.getLoginId())){
			map.put("USER_ID", user.getUserId());
			map.put("USER_NAME", user.getUserName());
			map.put("USER_ORG_ID", user.getOrgId());
			map.put("USER_ORG_SUBJECT_ID", user.getOrgSubjectionId());
			map.put("LOGIN_TIME", new Date());
			map.put("tableName", "USER_LOGIN_LOG");
			BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map, "USER_LOGIN_LOG");
		}
		Map<String,Object> mapTotal = new HashMap<String,Object>();
		mapTotal.put("userToken", user);
		mapTotal.put("funCodes", RoleUtil.getFunctionCodesByRoleIds(user.getRoleIds()));
		if(userProfile!=null){
			mapTotal.put("userProfile", userProfile);	
		} 
		
		return mapTotal;
	}
	
	public ISrvMsg query4ChildrenMenus(ISrvMsg reqDTO) throws Exception{

		String menuId = reqDTO.getValue("parentNodeId");
		
		log.info("query4ChildrenMenus...菜单IDparentNodeId......"+menuId);
		UserToken user = reqDTO.getUserToken();
		List<PAuthMenu> menus = new ArrayList<PAuthMenu>();
		//组织机构隶属单位
		String orgCode = user.getOrgCode();
		if(menuId==null ){
			menus.addAll(MenuUtil.getChildrenMenusOfRootMenu(user));
		}else{
			//判断是否是新兴物化探井中业务
//			if(("C605005001").equals(orgCode)){
//				Map<String,String> map = jdbcDao.queryRecordBySQL("select th.project_common from gp_task_project th where th.project_info_no='"+user.getProjectInfoNo()+"' ");
//				//获取井中常规项目的菜单权限
//				ProjectAuthMenu proAuthMenu = ProjectAuthMenu.getProjectAuthMenu();
//				//手动维护的权限菜单
//				Properties pro = proAuthMenu.getConfigInfo();
//				 
//				//常规项目
//				if(("1").equals(map.get("project_common")) && pro.keySet().contains(menuId) ){
//					 
//						//获取菜单权限
//						String menuIds  =  (String)pro.get(menuId); 
//						
//						for(String s : menuId.split(",")){
//							//分配的权限菜单
//							List<PAuthMenu> menulist = MenuUtil.getChildrenMenus(s, user);
//							//根据项目过滤权限
//							for (PAuthMenu pAuthMenu : menulist)
//							{
//								if (menuIds.indexOf(pAuthMenu.getMenuId()) != -1)
//									menus.add(pAuthMenu);
//							}
//						
//						}
//				 
//				} else {
//					for(String s : menuId.split(",")){
//						menus.addAll(MenuUtil.getChildrenMenus(s, user));
//					}
//				}
//			} else {
				for(String s : menuId.split(",")){
					menus.addAll(MenuUtil.getChildrenMenus(s, user));
//				}
			}

		}
		
		
		List<TreeNodeData> nodes = new ArrayList<TreeNodeData>();
		if(menus!=null)
			for(int i=0;i<menus.size();i++){	
				nodes.add(AuthManagerUtil.getNodeFromPAuthMenu(menus.get(i),CommonUtil.getCharset(user)));
			}
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		msg.isSuccessRet();
		
		msg.setValue("nodes", nodes);
		return msg;
	}
	
	
	public ISrvMsg reloadCache(ISrvMsg reqMsg) throws Exception{
		String cacheType = reqMsg.getValue("cacheType");
		if("auth".equals(cacheType)){
			AuthInitializor init = new AuthInitializor();
			init.run();			
		}
		else if("srvCfg".equals(cacheType)){
			SrvCfgInitializor init = new SrvCfgInitializor();
			init.run();			
		}
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqMsg);
		return msg;
	}
	
	public ISrvMsg savePassword(ISrvMsg reqMsg) throws SOAPException{
		ISrvMsg respMsg = SrvMsgUtil.createResponseMsg(reqMsg);
		String ids = reqMsg.getValue("ids");
		if(ids != null){
			String[] idArr = ids.split(",");
			if(idArr != null && idArr.length >0 ){
				String pwd = PasswordUtil.encrypt(AuthInitializor.param.getDefaultPassword());
				StringBuffer sqlBF = new StringBuffer( "update p_auth_user set user_pwd='"+pwd+"' where user_id in (");
				for(int i=0;i<idArr.length;i++){
					sqlBF.append("'"+idArr[i]+"',");
				}
				sqlBF = sqlBF.deleteCharAt(sqlBF.length()-1);
				sqlBF.append(")");
				jdbcDao.executeUpdate(sqlBF.toString());
			}
		}
		
		return respMsg;
	}
	
	/**
	 * 调整菜单位置
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg moveTreeNodePosition(ISrvMsg isrvmsg) throws Exception {
		 
		ISrvMsg respMsg = SrvMsgUtil.createResponseMsg(isrvmsg);
 
		String pkValue = isrvmsg.getValue("pkValue");               
		int index = Integer.parseInt(isrvmsg.getValue("index"));    //拖动的顺序 
		String newParentId = isrvmsg.getValue("newParentId");
		
		//根据  org_hr_id查询   orderNum  
		StringBuffer subsqla = new StringBuffer("select menu_id from P_AUTH_MENU_DMS t1 where t1.parent_menu_id='");
		subsqla.append(newParentId).append("' order by t1.order_num desc");
	 
		List datas =BeanFactory.getQueryJdbcDAO().queryRecords(subsqla.toString());
		
		if(datas.size()==0){
			// set parent node to non-leaf
			String sql = "update P_AUTH_MENU_DMS set is_leaf='0' where menu_id='"+newParentId+"'";
			RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
			radDao.executeUpdate(sql);
		}
		
		for(int i=0;i<datas.size();i++){
			// 移动位置
			Map data = (Map)datas.get(i);
			String dataId = (String)data.get("menuId");
			if(pkValue.equals(dataId)){
				datas.remove(i);
				break;
			}
		}
		Map map = new HashMap();
		map.put("menuId", pkValue);
		
		datas.add(index, map);
		
		// 写入新位置到数据库
		saveNewPosition(datas, newParentId);
		
		return respMsg;
	}
	/**
	 * 写入新位置到数据库
	 * @param orgs
	 */
	private void saveNewPosition(final List orgs, final String parentMenuId){

		final RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");

    	JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();
    	
		String sql = "update P_AUTH_MENU_DMS set order_num=?, parent_menu_id=? where menu_id=?";
		
		BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
			public void setValues(PreparedStatement ps, int i) throws SQLException {
				Map data = null;
				try {
					data = (Map)orgs.get(i);
				} catch (Exception e) {
					
				}
				ps.setString(1, String.valueOf(6666-i));

				ps.setString(2, parentMenuId);
				
				ps.setString(3, (String)data.get("menuId"));
			}

			public int getBatchSize() {
				return orgs.size();
			}
		};

		jdbcTemplate.batchUpdate(sql, setter);

	}
	
	/**
	 * 
	* @Title: updateWfRProcinst
	* @Description: TODO(这里用一句话描述这个方法的作用)
	* @param @param reqDTO
	* @param @return
	* @param @throws Exception    设定文件
	* @return ISrvMsg    返回类型
	* @throws
	 */
	public ISrvMsg updateWfRProcinst(ISrvMsg reqDTO) throws Exception{
		
		String sql = reqDTO.getValue("deleteSql");
		
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		
		JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
		
		jdbcTemplate.update(sql);
		
		ISrvMsg respDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		
		return respDTO;
	}
}
