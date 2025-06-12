/**
 * ��Ȩ�����ʵ��Ĺ��������
 */
package com.cnpc.sais.ibp.auth2.srv;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.InputStreamReader;
import java.io.Serializable;
import java.net.URLDecoder;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;

import com.bgp.gms.service.rm.dm.constants.DevConstants;
import com.bgp.gms.service.rm.dm.util.DevUtil;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.DataPermission;
import com.cnpc.jcdp.common.IDataPermProcessor;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.dao.IBaseDao;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.dao.Record2ColMap;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.rad.util.RADConst;
import com.cnpc.jcdp.rad.util.RadUtil;
import com.cnpc.jcdp.soa.exception.RetCodeException;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;
import com.cnpc.sais.ibp.auth.pojo.PAuthCsst;
import com.cnpc.sais.ibp.auth.pojo.PAuthOrg;
import com.cnpc.sais.ibp.auth.pojo.PAuthRole;
import com.cnpc.sais.ibp.auth2.util.AuthConstant;
import com.cnpc.sais.ibp.auth2.util.AuthInitializor;
import com.cnpc.sais.ibp.auth2.util.BusiCsstUtil;
import com.cnpc.sais.ibp.auth2.util.PasswordUtil;

@SuppressWarnings("unchecked")
public class AuthEntitySrv extends BaseService {
	private IBaseDao baseDao = BeanFactory.getBaseDao();
	private IPureJdbcDao pureDao = BeanFactory.getPureJdbcDAO();
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private static final String sql_queryUser = "select * from  p_auth_user pau where pau.user_id ='";

	/*
	 * ɾ���˵���Ҷ�ӽڵ�Ĳ˵��ſ���ɾ�������Բ�����ɾ���˵����Ӳ˵�
	 * ���ڲ˵�����֯��������ɫ�Ƕ�Զ�Ĺ�ϵ��ɾ���˵�ʱͬʱҪɾ�������˵���������ɫ�˵�����
	 * ���ڲ˵������ܾ���ͬһ������ά����ɾ���˵�ʱͬʱҪɾ���˵��µĹ���
	 * 
	 * ɾ���˵���Ҫ���Ĺ�����ɾ�������˵�������ɾ����ɫ�˵�������ɾ���˵��¹��ܼ��˵����ܹ�����ɾ���˵���¼
	 * 
	 */
	public ISrvMsg deleteMenu(ISrvMsg reqMsg) throws Exception {		
		String menuId = reqMsg.getValue("menuId");
		if(!"".equals(StringUtils.trimToEmpty(menuId))){
			List<String> deleteSqls = new ArrayList<String>();
			// ɾ���˵���֯��������
			String delMenuOrgSql = "delete from p_auth_org_resource_dms where res_id = '"+menuId+"' and res_type ='1'";
			deleteSqls.add(delMenuOrgSql);
			// ɾ���˵���ɫ����
			String delMenuRoleSql = "delete from p_auth_role_menu_dms where menu_id ='"+menuId+"'";
			deleteSqls.add(delMenuRoleSql);
			// ��ȡ�˵��¹���
			String getMenuFuncIdSql = "select distinct func_id from p_auth_menu_func_dms where menu_id ='"+menuId+"'"; 
			// ɾ���˵�����,ͬʱɾ���˵����ܹ���
			List<Map> funcIdMapList = jdbcDao.queryRecords(getMenuFuncIdSql);
			for (Map funcIdMap : funcIdMapList) {
				String funcId = (String) funcIdMap.get("func_id");
				deleteFunc(funcId);
			}
			// ɾ���˵���¼
			String delMeunSql = "delete from P_AUTH_MENU_DMS where menu_id ='"+menuId+"'";
			deleteSqls.add(delMeunSql);
			//���Ӳ˵������Ļ������ܼ�
			String delOrgMenuSql = "delete from p_auth_org_resource_dms where res_id = '"+menuId+"'";
			deleteSqls.add(delOrgMenuSql);
			//����ɾ���û��Զ���˵�
//			String delCustMenuSql = "delete from p_auth_user_defined_menu where menu_id = '"+menuId+"'";
//			deleteSqls.add(delCustMenuSql);
			jdbcDao.getJdbcTemplate().batchUpdate(deleteSqls.toArray(new String[deleteSqls.size()]));
		}
		ISrvMsg retMsg = SrvMsgUtil.createResponseMsg(reqMsg);
		return retMsg;
	}
	/*
	 * ���ӹ���,����CommCRUDSrv��ͨ�õ�JCDP_TABLE_NAME��Func��������
	 * ��ΪFunc��������Ҫ�Զ���˵������Ľ�ɫ��������
	 */
	public ISrvMsg addFunc(ISrvMsg reqMsg) throws Exception{
		ISrvMsg respMsg = SrvMsgUtil.createResponseMsg(reqMsg);
		Map params = reqMsg.toMap();
		RadUtil.decodeParams(params);
		String tableName = params.get(RADConst.TABLE_NAME_KEY).toString().toUpperCase(),
		   menuId = String.valueOf(params.get("menu_id"));
		Serializable funcId = jdbcDao.saveOrUpdateEntity(params, tableName);
		String sql = "SELECT ROLE_ID FROM p_auth_role_menu_dms WHERE MENU_ID = '"+menuId+"' GROUP BY ROLE_ID";
		List<Map> roleIds = jdbcDao.queryRecords(sql);
		List<String> sqls = new ArrayList<String>();
		sqls.add("INSERT INTO p_auth_menu_func_dms(MENU_FUNC_ID,MENU_ID,FUNC_ID) VALUES ('"+jdbcDao.generateUUID()+"','"+menuId+"','"+funcId+"')");
		for(Map roleIdMap : roleIds){
			sqls.add("INSERT INTO P_AUTH_ROLE_FUNC_DMS(ROLE_FUNC_ID,ROLE_ID,FUNC_ID) VALUES ('"+jdbcDao.generateUUID()+"','"+roleIdMap.get("role_id")+"','"+funcId+"')");
		}
		jdbcDao.getJdbcTemplate().batchUpdate(sqls.toArray(new String[0]));
		return respMsg;
	}
	/*
	 * ɾ������
	 */
	public ISrvMsg deleteFunc(ISrvMsg reqMsg)throws Exception{
		ISrvMsg retMsg = SrvMsgUtil.createResponseMsg(reqMsg);
		String funcId = reqMsg.getValue("funcId");
		deleteFunc(funcId);
		return retMsg;
	}
	/*
	 * ɾ������
	 * ���ڹ��ܺ���֯��������ɫ���˵��Ƕ�Զ�Ĺ�ϵ��ɾ������ʱͬʱҪɾ���������ܹ�������ɫ���ܹ������˵����ܹ���
	 * 
	 * ɾ��������Ҫ���Ĺ�����ɾ���������ܹ�����ɾ����ɫ���ܹ�����ɾ���˵����ܹ�����ɾ������ҵ����֤������ɾ�����ܼ�¼��ɾ�����ܹ�����filter����
	 */
	private void deleteFunc(String funcId) {
		if(!"".equals(StringUtils.trimToEmpty(funcId))){
			List<String> deleteSqls = new ArrayList<String>();
			// ɾ�����ܻ�������
			String delFuncOrgSql = "delete from p_auth_org_resource_dms where res_id ='"+funcId+"' and res_type = '2'";
			deleteSqls.add(delFuncOrgSql);
			// ɾ�����ܽ�ɫ����
			String delFuncRoleSql = "delete from p_auth_role_func_dms where func_id ='"+funcId+"'";
			deleteSqls.add(delFuncRoleSql);
			// ɾ�����ܲ˵�����
			String delFuncMenuSql = "delete from p_auth_menu_func_dms where func_id ='"+funcId+"'";
			deleteSqls.add(delFuncMenuSql);
			// ɾ������ҵ����֤����
			String delFuncCsstSql = "delete from p_auth_csst_dms where func_id ='"+funcId+"'";
			deleteSqls.add(delFuncCsstSql);
			// ɾ�����ܼ�¼
			String delFuncSql = "delete from p_auth_function_dms where func_id ='"+funcId+"'";
			deleteSqls.add(delFuncSql);
			// ɾ�����ܹ����Ļ������ܼ�
			String delOrgFuncSql = "delete from p_auth_org_resource_dms where res_id = '"+funcId+"'";
			deleteSqls.add(delOrgFuncSql);
			// ɾ�����ܹ�����filter
			String delFuncFilterScopeSql = "delete from p_auth_filter_scope_dms where filter_id in (select f.entity_id from p_auth_func_filter_dms f where f.func_id = '"+funcId+"')";
			String delFuncFilterSql = "delete from p_auth_func_filter_dms where func_id = '"+funcId+"'";
			deleteSqls.add(delFuncFilterScopeSql);
			deleteSqls.add(delFuncFilterSql);
			jdbcDao.getJdbcTemplate().batchUpdate(deleteSqls.toArray(new String[deleteSqls.size()]));
		}
	}
	
	/**
	 * ��ѯ��֯�����ĵݹ鷽��
	 * @return
	 */
	public List<Map> queryEntityCascade(String orgId) {
		List<Map> result = new ArrayList<Map>();
		String sql = "select * from p_auth_org where org_id = '"+orgId+"'";
		result.add(jdbcDao.queryRecordBySQL(sql));
		new Object(){
			public void queryEntityCascade(String orgId,List<Map> result){
				String sql = "select * from p_auth_org where parent_id = '"+orgId+"'";
				List<Map> orgs = jdbcDao.queryRecords(sql);
				if(orgs != null && orgs.size() > 0 ){
					result.addAll(orgs);
					for(Map m : orgs){
						queryEntityCascade(String.valueOf(m.get("org_id")), result);
					}
				}
			}
		}.queryEntityCascade(orgId,result);
		return result;
	}

	// ���ù���Ա
	public ISrvMsg saveManager(ISrvMsg reqMsg) throws Exception {
		String userId = reqMsg.getValue("userId");
		ISrvMsg retMsg = SrvMsgUtil.createResponseMsg(reqMsg);
		//����û�����Ϣ
		String queryOrg = "select * from p_auth_user where user_id ='"+userId+"'";
		Map user = jdbcDao.queryRecordBySQL(queryOrg);
		String orgId = user.get("org_id").toString();
		//���Ҹ���֯�����Ƿ�����������Ա�û�
		String queryAdminUser = "select u.* from p_auth_user u ,P_AUTH_USER_ROLE_DMS ur where u.user_id = ur.user_id and ur.role_id ='"+AuthConstant.ADMIN_ROLE_ID+"' and u.user_status<'2' and u.org_id = '"+orgId+"'";
		List<Map> adminUser = jdbcDao.queryRecords(queryAdminUser);
		if(adminUser.size()==0){
			List<Map> temps = queryEntityCascade(orgId);
			if(temps.size() > 0 ){
				//����֯�������������������û������Ľ�ɫ
				String sql = 	"SELECT R.*\n" +
								"  FROM p_auth_user PU,\n" + 
								"       P_AUTH_USER_ROLE_DMS PR,\n" + 
								"       P_AUTH_ROLE_DMS R\n"+
								" WHERE PU.USER_ID = PR.USER_ID\n" + 
								"   AND R.ROLE_ID = PR.ROLE_ID AND R.ROLE_LEVEL = 'U' AND PU.ORG_ID = '{0}'";
				StringBuffer sb = new StringBuffer(),
							 sb1 = new StringBuffer();
				int length = temps.size();
				for(int i = 0 ; i < length-1 ; i++){
					sb.append(AuthManagerUtil.format(sql, temps.get(i).get("org_id"))+ " union ");
					sb1.append("'"+temps.get(i).get("org_id")+"',");
				}
				sb.append(AuthManagerUtil.format(sql, temps.get(length-1).get("org_id")));
				sb1.append("'"+temps.get(length-1).get("org_id")+"'");
				List<Map> subRolelist = jdbcDao.queryRecords(sb.toString());
				if(subRolelist.size()>0){
					List<String> execSqls = new ArrayList<String>();
					for(int i=0;i<subRolelist.size();i++){
						Map roleMap = (Map)subRolelist.get(i);
						String roleIdOld = (String) roleMap.get("role_id");
						//�½�ͬ����ɫ
						String newRoleId = jdbcDao.generateUUID();
						sql = "insert into P_AUTH_ROLE_DMS(ROLE_ID,ROLE_E_NAME,ROLE_C_NAME,DATA_ORG_ID,USER_ORG_ID,REMARK,ROLE_LEVEL) values ('"+newRoleId+"','"+roleMap.get("role_e_name")+"','"+roleMap.get("role_c_name")+"','"+roleMap.get("data_org_id")+"','"+orgId+"','"+roleMap.get("remark")+"','"+roleMap.get("role_level")+"')";
						execSqls.add(sql);
						//����½���ɫ�빦�ܵĹ���
						String queryRoleFunc= "select * from p_auth_role_func_dms where role_id='"+roleIdOld+"'";
						List<Map> roleFunc = jdbcDao.queryRecords(queryRoleFunc);
						for(int j=0;j<roleFunc.size();j++){
							sql = "insert into p_auth_role_func_dms(role_func_id,role_id,func_id) values('"+jdbcDao.generateUUID()+"','"+newRoleId+"','"+roleFunc.get(j).get("func_id")+"')";
							execSqls.add(sql);
						}
						//����½���ɫ��˵��Ĺ���
						String queryRoleMenu= "select * from p_auth_role_menu_dms where role_id='"+roleIdOld+"'";
						List<Map> roleMenu = jdbcDao.queryRecords(queryRoleMenu);
						for(int j=0;j<roleMenu.size();j++){
							sql = "insert into p_auth_role_menu_dms(ROLE_MENU_ID,ROLE_ID,MENU_ID,CHECK_STATUS) values('"+jdbcDao.generateUUID()+"','"+newRoleId+"','"+roleMenu.get(j).get("menu_id")+"','"+roleMenu.get(j).get("check_status")+"')";
							execSqls.add(sql);
						}
						//����½���ɫ���û��Ĺ���
						//�޸� �޳������ڸ���֯������������
						String queryRoleUser= "select pr.user_id from P_AUTH_USER_ROLE_DMS pr, p_auth_user pu where pu.user_id = pr.user_id and pr.role_id='"+roleIdOld+"' and pu.org_id in ("+sb1.toString()+")";
						List<Map> roleUser = jdbcDao.queryRecords(queryRoleUser);
						for(int j=0;j<roleUser.size();j++){
							sql = "insert into P_AUTH_USER_ROLE_DMS(USER_ROLE_ID,user_id,role_id) values ('"+jdbcDao.generateUUID()+"','"+roleUser.get(j).get("user_id")+"','"+newRoleId+"')";
							execSqls.add(sql);
						}
						//ɾ��ԭ����ɫ���û�֮��Ĺ�ϵ
						//�޸� �޳������ڸ���֯������������
						sql = "delete from P_AUTH_USER_ROLE_DMS where role_id='"+roleIdOld+"' and user_id in (select pu.user_id from p_auth_user pu where pu.org_id in ("+sb1.toString()+"))";
						execSqls.add(sql);
					}
					if(execSqls.size() != 0){
						jdbcDao.getJdbcTemplate().batchUpdate(execSqls.toArray(new String[execSqls.size()]));
					}
					temps.clear();execSqls.clear();sb1.setLength(0);
					sb.setLength(0);sb.append("''");
					length = subRolelist.size();
					//��ѯ�������Ľ�ɫ�����Ĳ˵��͹���,������֯�ṹ���ܼ�
					sql = 	"SELECT PM.MENU_ID AS ID, '"+AuthConstant.MENU+"' AS TYPE\n" +
							"  FROM p_auth_role_menu_dms PM\n" + 
							" WHERE PM.ROLE_ID IN ({0})\n" + 
							" UNION \n" + 
							"SELECT PF.FUNC_ID AS ID, '"+AuthConstant.FUNC+"' AS TYPE\n" + 
							"  FROM p_auth_role_func_dms PF\n" + 
							" WHERE PF.ROLE_ID IN ({0})";
					for(int i = 0 ; i < length; i++){
						sb.append(",'"+subRolelist.get(i).get("role_id")+"'");
						if(i > 0 && i % 499 == 0 ){
							temps.addAll(jdbcDao.queryRecords(AuthManagerUtil.format(sql, sb.toString())));
							sb.setLength(0);sb.append("''");
						}
					}
					if(sb.length() > 2){
						temps.addAll(jdbcDao.queryRecords(AuthManagerUtil.format(sql, sb.toString())));
					}
					String sqlTemplate = "insert into p_auth_org_resource_dms(ORG_RES_ID,ORG_ID,RES_ID,RES_TYPE) values ('{0}','"+orgId+"','{1}','{2}')";
					for(Map map : temps){
						String type = (String) map.get("type");
						if(AuthConstant.MENU.equals(type)){
							execSqls.add(AuthManagerUtil.format(sqlTemplate,jdbcDao.generateUUID(),map.get("id"),AuthConstant.MENU)); 
						}else if(AuthConstant.FUNC.equals(type)){
							execSqls.add(AuthManagerUtil.format(sqlTemplate,jdbcDao.generateUUID(),map.get("id"),AuthConstant.FUNC)); 
						}
					}
					if(execSqls.size() != 0){
						jdbcDao.getJdbcTemplate().batchUpdate(execSqls.toArray(new String[execSqls.size()]));
					}
				}
			}
		}
		//�����û�����Ϊ����Ա
		user.put("user_type", AuthConstant.ADMIN_USER_TYPE);
		jdbcDao.saveOrUpdateEntity(user, "p_auth_user");
		Map<String,String> map = new HashMap<String,String>();
		map.put("user_id", userId);
		map.put("role_id", AuthConstant.ADMIN_ROLE_ID);
		jdbcDao.saveOrUpdateEntity(map, "P_AUTH_USER_ROLE_DMS");
		return retMsg;
	}

	// ȡ������Ա
	public ISrvMsg deleteManager(ISrvMsg reqMsg) throws Exception {
		String userId = reqMsg.getValue("userId");
		UserToken userToken = reqMsg.getUserToken();
		String superOrgId = userToken.getOrgId();
		ISrvMsg retMsg = SrvMsgUtil.createResponseMsg(reqMsg);
		
		String queryOrg = "select * from p_auth_user where user_id ='"+userId+"'";
		Map user = jdbcDao.queryRecordBySQL(queryOrg);
		String orgId = user.get("org_id").toString();
		
		String queryOrgName = "select * from p_auth_org where org_id = '"+orgId+"'";
		Map orgMap = jdbcDao.queryRecordBySQL(queryOrgName);
		String orgName = (String) orgMap.get("org_name");
		//�޸��û�����Ϊ��ͨ�û�
		user.put("user_type", AuthConstant.COMMON_USER_TYPE);
		jdbcDao.saveOrUpdateEntity(user, "p_auth_user");
		// ɾ������֯�����Ĺ���Ա
//		String delUserRole = "delete from p_auth_user_role where user_id = '"+userId+"' and role_id ='"+AuthConstant.ADMIN_ROLE_ID+"'";
		String delUserRole = "delete from P_AUTH_USER_ROLE_DMS where user_id = '"+userId+"'";
		jdbcDao.executeUpdate(delUserRole);
		//���Ҹ���֯�����Ƿ�����������Ա�û�
		String queryAdminUser = "select u.* from p_auth_user u ,P_AUTH_USER_ROLE_DMS ur where u.user_id = ur.user_id and ur.role_id ='"+AuthConstant.ADMIN_ROLE_ID+"' and u.user_status<'2' and u.org_id = '"+orgId+"'";
		List<Map> adminUser = jdbcDao.queryRecords(queryAdminUser);
		if(adminUser.size()==0){
			//���������Ƿ��й���Ա���������쳣
			String querySubOrg ="select * from p_auth_org where parent_id = '"+orgId+"'";
			List<Map> subOrg = jdbcDao.queryRecords(querySubOrg);
			if(subOrg.size()>0){
				for(int i=0;i<subOrg.size();i++){
					Map temp=(Map)subOrg.get(i);
					String subOrgId=(String)temp.get("org_id");
					String querySubAdmin = "select u.* from p_auth_user u ,P_AUTH_USER_ROLE_DMS ur where u.user_id = ur.user_id and ur.role_id ='"+AuthConstant.ADMIN_ROLE_ID+"' and u.user_status<'2' and u.org_id = '"+subOrgId+"'";
					List<Map> subAdmin = jdbcDao.queryRecords(querySubAdmin);
					if(subAdmin.size()>0){
						throw new RetCodeException("HAS_SUB_ADMIN");
					}
				}
			}
			//�Ѹ���֯�����Ľ�ɫ�������󱣴浽�ϼ���֯����
			String queryRole = "select * from p_auth_role_dms where user_org_id='"+orgId+"'";
			List<Map> role = jdbcDao.queryRecords(queryRole);
			if(role.size()>0){
				for(int i=0;i<role.size();i++){
					Map temp=(Map)role.get(i);
					String roleName=(String)temp.get("role_c_name");
					String roleNameNew = roleName+"_"+orgName;
					temp.put("role_c_name", roleNameNew);
					temp.put("user_org_id", superOrgId);
					jdbcDao.saveOrUpdateEntity(temp, "p_auth_role_dms");
				}
			}
			//ɾ������֯�������ܼ�
			String deleteOrgMenusAndFuncs = "delete from p_auth_org_resource_dms where org_id = '"+orgId+"'";
			jdbcDao.executeUpdate(deleteOrgMenusAndFuncs);
			//ɾ������֯�������û����Զ���˵�
//			String deleteUserCustMenus = "delete from p_auth_user_defined_menu where user_id in (select user_id from p_auth_user where org_id ='"+orgId+"')";
//			jdbcDao.executeUpdate(deleteUserCustMenus);
		}
		
		return retMsg;
	}
	/*
	 * ���org_code��Ч
	 */
	public ISrvMsg queryCommUsersByOrg(ISrvMsg reqDTO) throws Exception{
		ISrvMsg respDTO =  SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken userToken = reqDTO.getUserToken();	
		String userOrgId = StringUtils.trimToEmpty(userToken.getOrgId()),
			   sql = StringUtils.trimToEmpty(reqDTO.getValue("querySql"));
//		String ep_data_auth_funcCode = StringUtils.trimToEmpty("EP_DATA_AUTH_funcCode");
//		CommCRUDSrv commSrv = (CommCRUDSrv)BeanFactory.getBean("RADCommCRUD");
		int currentPage = Integer.parseInt(AuthManagerUtil.trim2Default(reqDTO.getValue("currentPage"), "")),
			pageSize =Integer.parseInt(AuthManagerUtil.trim2Default(reqDTO.getValue("pageSize"), ""));
		currentPage = currentPage < 1 ? 1 : currentPage;
		final String  querySql = URLDecoder.decode(sql,"UTF-8");
		PAuthOrg pauthOrg = (PAuthOrg) baseDao.get(PAuthOrg.class, userOrgId);
		List<Map> result = new ArrayList<Map>();
		if(pauthOrg != null){
			result.addAll(jdbcDao.queryRecords(AuthManagerUtil.format(querySql,"'"+pauthOrg.getOrgId()+"'")));
//		final String subOrgsSql =   "SELECT po.org_id,\n" +
//									"       CASE\n" + 
//									"         WHEN (SELECT DISTINCT 1\n" + 
//									"                 FROM p_auth_user pu, p_auth_user_role pr\n" + 
//									"                WHERE pu.user_id = pr.user_id\n" + 
//									"                  AND pu.org_id = po.org_id\n" + 
//									"                  AND pr.role_id = '"+AuthConstant.ADMIN_ROLE_ID+"') IS NULL THEN\n" + 
//									"          'false'\n" + 
//									"         ELSE\n" + 
//									"          'true'\n" + 
//									"       END AS hasadmin\n" + 
//									"  FROM p_auth_org po\n" + 
//									" WHERE po.parent_id = '{0}'";
//			List<Map> subOrgsMap = jdbcDao.queryRecords(AuthManagerUtil.format(subOrgsSql,pauthOrg.getOrgId()));
//			for(Map subOrgMap : subOrgsMap){
//				new Object(){
//					public void queryCommUsersByRoleAndOrg(Map subOrgMap ,List<Map> result){
//						boolean hasAdmin  = Boolean.valueOf(subOrgMap.get("hasadmin").toString());
//						if(!hasAdmin){
//							String orgId = subOrgMap.get("org_id").toString();
//							result.addAll(jdbcDao.queryRecords(AuthManagerUtil.format(querySql,"'"+orgId+"'")));
//							List<Map> subsMap = jdbcDao.queryRecords(AuthManagerUtil.format(subOrgsSql,orgId));
//							if(subsMap.size() > 0 ){
//								for(Map subMap : subsMap){
//									queryCommUsersByRoleAndOrg(subMap,result);
//								}
//							}
//						}
//					}
//				}.queryCommUsersByRoleAndOrg(subOrgMap,result);
//			}
		}
		int totalRows = result.size(),
			fromIndex = (currentPage-1)*pageSize < totalRows ?  (currentPage-1)*pageSize : 0,
			toIndex = currentPage*pageSize < totalRows ? currentPage*pageSize : totalRows;
 		respDTO.setValue("datas", result.subList(fromIndex, toIndex));
		respDTO.setValue("totalRows", result.size());
		return respDTO;
	}
	/*
	 * ���org_code��Ч
	 */
//	public ISrvMsg queryCommUsersByOrg(ISrvMsg reqDTO) throws Exception{
//		String querySql = StringUtils.trimToEmpty(reqDTO.getValue("querySql"));
//		ISrvMsg respDTO = SrvMsgUtil.createResponseMsg(reqDTO);
//		if(!"".equals(querySql)){
//			querySql = URLDecoder.decode(querySql,"UTF-8");
//			String userOrgCode = reqDTO.getUserToken().getOrgCode(),
//				   orderBySql = null;
//		    String sql ="SELECT po.org_id FROM p_auth_org po WHERE po.org_code LIKE '"
//						+userOrgCode
//						+"%' AND NOT EXISTS (SELECT 1 FROM (SELECT po.org_code FROM p_auth_org po, p_auth_user pu WHERE pu.user_type = '"
//						+AuthConstant.ADMIN_USER_TYPE
//						+"' AND pu.org_id = po.org_id AND po.org_code LIKE '"
//						+userOrgCode
//						+"?%') p WHERE po.org_code LIKE concat(p.org_code,'%'))";
//			List<Map> orgs = jdbcDao.queryRecords(sql);
//			if(querySql.matches(".+\\s+[o|O][r|R][d|D][e|E][r|R]\\s+[b|B][y|Y]\\s+\\S.+")){
//				int i = querySql.toLowerCase().lastIndexOf("order");
//				orderBySql = querySql.substring(i);sql = querySql.substring(0, i);
//			}else{
//				sql = querySql;
//			}
//			querySql = null;
//			StringBuffer sb = new StringBuffer("''");
//			List<String> sqls = new ArrayList<String>();
//			if(sql.matches(".+\\{0\\}.+")){
//				if(orgs.size() > 0){
//					for(int i = 0 ;i < orgs.size();){
//						sb.append(",'"+orgs.get(i).get("org_id")+"'");
//						if(++i%999 == 0){
//							sqls.add(MessageFormat.format(sql,sb));
//							sqls.add(" UNION ALL ");
//							sb.setLength(0);
//							sb.append("''");
//						}
//					}
//					if(sb.equals("''")){
//						sqls.remove(sqls.size()-1);
//					}else{
//						sqls.add(AuthManagerUtil.format(sql, sb));
//					}
//					sb.setLength(0);
//					for(String s : sqls){
//						sb.append(s);
//					}
//					if(orderBySql != null){
//						sb.insert(0, "select * from (").append(") "+orderBySql);
//					}
//					sql = sb.toString();
//				}else{
//					sql = sql.replaceAll("\\{0\\}", "''");
//				}
//			}
//			String funcCode = StringUtils.trimToEmpty(reqDTO.getValue("EP_DATA_AUTH_funcCode"));
//			if(!"".equals(funcCode)){
//				IDataPermProcessor dpProc = (IDataPermProcessor) BeanFactory.getBean("ICGDataPermProcessor");
//				DataPermission dp = dpProc.getDataPermission(reqDTO.getUserToken(),funcCode, sql);
//				sql = dp.getFilteredSql();
//			}
//			PageModel pageModel = new PageModel();
//			String currentPage = reqDTO.getValue("currentPage");
//			if (currentPage == null || currentPage.trim().equals(""))
//				currentPage = "1";
//			String pageSize = reqDTO.getValue("pageSize");
//			if (pageSize == null || pageSize.trim().equals("")) {
//				ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
//				pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
//			}
//			pageModel.setCurrPage(Integer.parseInt(currentPage));
//			pageModel.setPageSize(Integer.parseInt(pageSize));
//			//param.setRowMapper(Record2ColMap.instance);
//			pageModel = jdbcDao.queryRecordsBySQL(sql,pageModel);
//			respDTO.setValue("datas", pageModel.getData());
//			respDTO.setValue("totalRows", pageModel.getTotalRow());
//		}
//		return respDTO;
//	}
	public ISrvMsg deleteOrg(ISrvMsg reqMsg) throws Exception {
		ISrvMsg retMsg = SrvMsgUtil.createResponseMsg(reqMsg);
		List<String> deleteSqls = new ArrayList<String>();
		String orgId = reqMsg.getValue("org_id");
		PAuthOrg pauthOrg = (PAuthOrg) baseDao.get(PAuthOrg.class, orgId);
		if(pauthOrg != null)
			deleteOrg(pauthOrg,deleteSqls);
		/*
		 * List siblingOrgMenus =
		 * baseDao.queryByHql("from PAuthOrg WHERE parentId='"
		 * +pauthOrg.getParentId()+"'"); if(siblingOrgMenus.size()==1){ PAuthOrg
		 * parentOrg = (PAuthOrg)baseDao.get(PAuthOrg.class,
		 * pauthOrg.getParentId()); parentOrg.setIsLeaf("1");
		 * baseDao.update(parentOrg); } deleteOrg(pauthOrg);
		 */
		if(deleteSqls.size() != 0)
			jdbcDao.getJdbcTemplate().batchUpdate(deleteSqls.toArray(new String[deleteSqls.size()]));
		return retMsg;
	}

	private void deleteOrg(PAuthOrg org,List<String> deleteSqls) {
		if(deleteSqls == null) deleteSqls = new ArrayList<String>();
		List subOrgs = baseDao.queryByHql("from PAuthOrg WHERE parentId='" + org.getOrgId() + "'");
		if (subOrgs != null)
			for (int i = 0; i < subOrgs.size(); i++) {
				deleteOrg((PAuthOrg) subOrgs.get(i),deleteSqls);
		}
//		baseDao.delete(PAuthOrg.class, org.getOrgId());
		deleteSqls.addAll(deleteOrgByCascade(org));	
		
	}
	public List<String> deleteOrgByCascade(PAuthOrg org){
		List<String> deleteSqls = new ArrayList<String>();
		//1.ɾ�����������Ĳ˵��͹��ܵ�
		deleteSqls.add("delete from p_auth_org_resource_dms where org_id = '"+org.getOrgId()+"'");
		//2.ɾ�����������Ľ�ɫ
		List<PAuthRole> roles = baseDao.queryByHql("from PAuthRole WHERE userOrgId='" + org.getOrgId() + "'");
		for(PAuthRole role : roles){
			deleteSqls.addAll(deleteRoleByCascade((role)));
		}
		//3.ɾ�������������û�
		deleteSqls.add("delete from p_auth_user where org_id = '"+org.getOrgId()+"'");
		//4.ɾ�������û����Զ���˵�
//		deleteSqls.add("delete from p_auth_user_defined_menu where user_id in (select user_id from p_auth_user where org_id ='"+org.getOrgId()+"')");
		//5.ɾ������
		deleteSqls.add("delete from p_auth_org where org_id = '"+org.getOrgId()+"'");
		return deleteSqls;
	}
	public List<String> deleteRoleByCascade(PAuthRole role){
		List<String> deleteSqls = new ArrayList<String>();
		//1.ɾ����ɫ�����Ĳ˵�
		deleteSqls.add("delete from p_auth_role_menu_dms where role_id = '"+role.getRoleId()+"'");
		//2.ɾ����ɫ�����Ĺ��ܵ�
		deleteSqls.add("delete from p_auth_role_func_dms where role_id = '"+role.getRoleId()+"'");
		//3.ɾ����ɫ�������û�
		deleteSqls.add("delete from P_AUTH_USER_ROLE_DMS where role_id = '"+role.getRoleId()+"'");
		//4.ɾ����ɫ
		deleteSqls.add("delete from p_auth_role_dms where role_id = '"+role.getRoleId()+"'");
		return deleteSqls;
	}
	public ISrvMsg addModuleFunc(ISrvMsg reqMsg) throws Exception {
		ISrvMsg retMsg = SrvMsgUtil.createResponseMsg(reqMsg);

		String module_id = reqMsg.getValue("module_id");
		String sql = "SELECT parent_id AS id FROM ew_module WHERE entity_id='"
				+ module_id + "'";
		Map module = jdbcDao.queryRecordBySQL(sql);
		String subSysId = module.get("id").toString();
		Map params = reqMsg.toMap();
		RadUtil.decodeParams(params);
		params.put("subsys_id", subSysId);
		jdbcDao.saveOrUpdateEntity(params, "p_auth_function_dms");
		return retMsg;
	}

	public ISrvMsg validateBusiCsst(ISrvMsg reqMsg) throws Exception {
		ISrvMsg retMsg = SrvMsgUtil.createResponseMsg(reqMsg);
		String ids = reqMsg.getValue("ids");

		String func_code = reqMsg.getValue("funcCode");
		PAuthCsst csst = BusiCsstUtil.getPAuthCsst(func_code);
		String sqls = csst.getCdt_sql();
		String idArray[] = ids.split(",");

		for (int i = 0; i < idArray.length; i++) {
			BufferedReader br = new BufferedReader(new InputStreamReader(
					new ByteArrayInputStream(sqls.getBytes())));
			String sql = br.readLine();
			while (sql != null) {
				sql = sql.replace("{id}", idArray[i]);
				Map ret = jdbcDao.queryRecordBySQL(sql);
				sql = br.readLine();
				if (Integer.parseInt(ret.values().toArray()[0] + "") > 0) {
					retMsg.setValue("validateRet", false);
					retMsg.setValue("validateMsg", sql);
					return retMsg;
				}
				sql = br.readLine();
			}
		}
		retMsg.setValue("validateRet", true);
		return retMsg;
	}

	public ISrvMsg addOrUpdateUser(ISrvMsg reqMsg) throws Exception {
		String userId = reqMsg.getValue("user_id");
		if (userId == null || userId.length() < 1) { // ����user��������Ϊ��ʼֵ
			reqMsg.setValue("user_pwd", PasswordUtil.encrypt(AuthInitializor.param
					.getDefaultPassword()));
		}
		
		Map params = reqMsg.toMap();
		RadUtil.decodeParams(params);
		String tableName = params.get(RADConst.TABLE_NAME_KEY).toString();
		Serializable id = jdbcDao.saveOrUpdateEntity(params, tableName);
		List sqls = reqMsg.getCheckBoxValues("RADSQL");
		
		if (sqls != null) {
			for (int i = 0; i < sqls.size(); i++) {
				jdbcDao.executeUpdate(sqls.get(i).toString());
			}
		}
		
		ISrvMsg retMsg = SrvMsgUtil.createResponseMsg(reqMsg);
		retMsg.setValue("entity_id", id);
		return retMsg;
	}

	public ISrvMsg queryUsers(ISrvMsg reqMsg) throws Exception {
		ISrvMsg retMsg = SrvMsgUtil.createResponseMsg(reqMsg);
		String sql = reqMsg.getValue("querySql");
		if (sql.indexOf("%") >= 0)
			sql = URLDecoder.decode(sql, "UTF-8");
		String currentPage = reqMsg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqMsg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel param = new PageModel();
		param.setCurrPage(Integer.parseInt(currentPage));
		param.setPageSize(Integer.parseInt(pageSize));
		param.setRowMapper(Record2ColMap.instance);

		// ��������Ȩ��
		String funcCode = reqMsg.getValue("EP_DATA_AUTH_funcCode");
		if (funcCode != null) {
			IDataPermProcessor dpProc = (IDataPermProcessor) BeanFactory
					.getBean("ICGDataPermProcessor");
			DataPermission dp = dpProc.getDataPermission(reqMsg.getUserToken(),
					funcCode, sql);
			sql = dp.getFilteredSql();
		}

		PageModel model = jdbcDao.queryRecordsBySQL(sql, param);
		List list = model.getData();
		for (int i = list.size() - 1; i >= 0; i--) {
			Map map = (Map) list.get(i);
			String pwd = map.get("user_pwd").toString();
			map.put("user_pwd", PasswordUtil.decrypt(pwd));
			list.remove(i);
			list.add(map);
		}
		retMsg.setValue("datas", list);
		retMsg.setValue("totalRows", list.size());
		return retMsg;
	}

	public ISrvMsg updatePassWord(ISrvMsg reqMsg) throws Exception {
		ISrvMsg retMsg = SrvMsgUtil.createResponseMsg(reqMsg);
		Map paramMap = reqMsg.toMap();
		UserToken user = reqMsg.getUserToken();
		String user_id = user != null ? user.getUserId():"";
		String sql = sql_queryUser + user_id + "'";
		Map userMap = jdbcDao.queryRecordBySQL(sql);
		Object oldPwd = userMap.get("user_pwd");
		String checkPwd = paramMap.get("old_pwd").toString();
		checkPwd = PasswordUtil.encrypt(checkPwd);
		if (!checkPwd.equals(oldPwd)) {
			retMsg.setValue("return_msg", "�����벻��");
			retMsg.setValue("returnCode", "1");
			return retMsg;
		}
	
		userMap.put("user_pwd", PasswordUtil.encrypt(paramMap.get("user_pwd").toString()));
		jdbcDao.saveOrUpdateEntity(userMap, "p_auth_user");
		return retMsg;
	}
	
	public ISrvMsg deleteRole(ISrvMsg reqMsg) throws Exception{
		ISrvMsg retMsg = SrvMsgUtil.createResponseMsg(reqMsg);
		String selectedIds = reqMsg.getValue("selectedIds");
		String[] newSelIds = selectedIds.split(",");
		String originIds = reqMsg.getValue("originIds");
		if (originIds == null)
			originIds = "";
		String[] oldSelIds = originIds.split(",");

		Map params = new HashMap();
		params.put(RADConst.TABLE_NAME_KEY, reqMsg.getValue("rlTableName"));
		params.put(reqMsg.getValue("rlColumnName"), reqMsg
				.getValue("rlColumnValue"));
		String toSelColumnName = reqMsg.getValue("toSelColumnName");
		for (int i = 0; i < newSelIds.length; i++) {
			if (originIds.indexOf(newSelIds[i]) >= 0)
				continue;
			params.put(toSelColumnName, newSelIds[i]);
			jdbcDao.insertEntity(params, RADConst.TABLE_NAME_KEY);
		}

		String sql = "DELETE FROM " + params.get(RADConst.TABLE_NAME_KEY);
		String rlColumnName = reqMsg.getValue("rlColumnName");
		if (jdbcDao.isOracleDialect()) {
			rlColumnName = rlColumnName.toUpperCase();
			toSelColumnName = toSelColumnName.toUpperCase();
		}
		sql += " WHERE " + rlColumnName + "='"
				+ reqMsg.getValue("rlColumnValue") + "'";
		sql += " AND " + toSelColumnName + "='";
		for (int i = 0; i < oldSelIds.length; i++) {
			if (selectedIds.indexOf(oldSelIds[i]) < 0) {
				String delSql = sql + oldSelIds[i] + "'";
				jdbcDao.executeUpdate(delSql);
//				if("user_id".equals(rlColumnName.toLowerCase())){
//					jdbcDao.executeUpdate("DELETE FROM p_auth_user_defined_menu where user_id = '"+reqMsg.getValue("rlColumnValue")+"' and menu_id in (select menu_id from p_auth_role_menu m where m.role_id = '"+oldSelIds[i]+"')");
//				}else if("role_id".equals(rlColumnName.toLowerCase())){
//					jdbcDao.executeUpdate("DELETE FROM p_auth_user_defined_menu where user_id = '"+oldSelIds[i]+"' and menu_id in (select menu_id from p_auth_role_menu m where m.role_id = '"+reqMsg.getValue("rlColumnValue")+"')");
//				}
			}
		}
		rlColumnName = reqMsg.getValue("rlColumnName");
		String rlColumnValue = reqMsg.getValue("rlColumnValue");
		String rlTableName = reqMsg.getValue("rlTableName");
		toSelColumnName = reqMsg.getValue("toSelColumnName");
		sql = "SELECT " + toSelColumnName + " FROM " + rlTableName
				+ " WHERE " + rlColumnName + "='" + rlColumnValue + "'";
		List<Map> maps = jdbcDao.queryRecords(sql);
		String ids = ",";
		for (int i = 0; i < maps.size(); i++) {
			Map map = maps.get(i);
			ids += map.values().toArray()[0] + ",";
		}
		retMsg.setValue("relationedIds", ids);
		return retMsg;
	}
	/**
	 * ��ʾȫ���û���Ϣ 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	
	public ISrvMsg queryUserDetInfo(ISrvMsg isrvmsg) throws Exception {
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String currentPage = isrvmsg.getValue("page");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = isrvmsg.getValue("rows");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String orgSubId = isrvmsg.getValue("orgsubid");
		String useSubId = isrvmsg.getValue("usesubid");
		String loginId = isrvmsg.getValue("loginid");
		String userName = isrvmsg.getValue("username");
		String userEmail = isrvmsg.getValue("useremail");
		String userType = isrvmsg.getValue("usertype");
		String sortField = isrvmsg.getValue("sort");
		String sortOrder = isrvmsg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select p.user_id,p.org_id,p.login_id,p.user_name,info.org_name,p.email,p.login_ip,"
				+ " to_char(p.last_login_time,'yyyy-mm-dd hh24:mi:ss') as last_login_time,case p.user_status"
				+ " when '0' then '��Ч' when '1' then '����' when '2' then '����' else 'δ֪״̬' end as userstatus,"
				+ " case p.user_type when '0' then '�����û�' when '2' then '��̽������Ա' when '3' then '��ͨ�û�'"
				+ " else 'δ֪����' end as usertype"
				+ " from p_auth_user p"
				+ " left join comm_org_information info on p.org_id = info.org_id and info.bsflag = '0'"
				+ " left join comm_org_subjection n on n.org_id = p.org_id and n.bsflag = '0'"
				+ " where p.bsflag = '0'");
		if(StringUtils.isNotBlank(useSubId)){
			querySql.append(" and n.org_subjection_id like '"+useSubId+"%' ");
		}else{
			querySql.append(" and n.org_subjection_id like '"+orgSubId+"%' ");
		}
		//��¼ID
		if (StringUtils.isNotBlank(loginId)) {
			querySql.append(" and p.login_id like '%"+loginId+"%'");
		}
		//�û���
		if (StringUtils.isNotBlank(userName)) {
			querySql.append(" and p.user_name like '%"+userName+"%'");
		}
		//�û�����
		if (StringUtils.isNotBlank(userEmail)) {
			querySql.append(" and p.email like '%"+userEmail+"%'");
		}
		//�û�����
		if (StringUtils.isNotBlank(userType)) {
			querySql.append(" and p.user_type = '"+userType+"'");
		}
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+",p.user_id");
		}else{
			querySql.append(" order by case p.user_type when '3' then 1 when '2' then 2 when '0' then 3 end,"
							+ " p.last_login_time desc nulls last,p.user_name,n.org_subjection_id,p.user_id");
		}
		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * NEWMETHOD ����û��Ļ�����Ϣ
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getUserMainInfo(ISrvMsg reqDTO) throws Exception {
		String userId = reqDTO.getValue("userid");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sb = new StringBuffer()
				.append("select p.user_id,p.login_id,p.user_name,info.org_name,info.org_abbreviation as shortorgname,"
						+ " p.org_id,p.user_type,p.email,p.login_ip,p.last_login_time,p.emp_id,case p.user_status"
						+ " when '0' then '��Ч' when '1' then '����' when '2' then '����' else 'δ֪״̬' end as userstatus,"
						+ " case p.user_type when '0' then '�����û�' when '2' then '��̽������Ա' when '3' then '��ͨ�û�'"
						+ " else 'δ֪����' end as usertypename"
						+ " from p_auth_user p"
						+ " left join comm_org_information info on p.org_id = info.org_id and info.bsflag = '0'"
						+ " left join comm_org_subjection n on n.org_id = p.org_id and n.bsflag = '0'"
						+ " where p.user_id = '"+ userId + "'");
		Map devBackappMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(devBackappMap)) {
			responseMsg.setValue("data", devBackappMap);
		}
		return responseMsg;
	}
	/**
	 * NEWMETHOD ��ѯ�û��Ľ�ɫ��Ϣ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryUserRoles(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String currentPage = msg.getValue("page");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = msg.getValue("rows");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String userId = msg.getValue("userid");
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select user_role_id,role_c_name,role_e_name,role_category,d.coding_name"
					+ " from p_auth_user_role_dms ur"
					+ " left join p_auth_role_dms r on ur.role_id = r.role_id"
					+ " left join comm_coding_sort_detail d on d.coding_code_id = r.role_category"
					+ " where ur.user_id = '"+userId+"'");
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by role_c_name");
		}
		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * NEWMETHOD �����û�EMPID����û������Ϣ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryUserInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String empId = msg.getValue("empid");
		String sql = "select emp.org_id,sub.org_subjection_id,info.org_abbreviation,emp.employee_name"
				   + " from comm_human_employee emp"
				   + " left join comm_org_information info on emp.org_id = info.org_id and info.bsflag = '0'"
				   + " left join comm_org_subjection sub on info.org_id = sub.org_id and sub.bsflag = '0'"
				   + " where emp.employee_id = '"+empId+"'";
		Map mainMap = jdbcDao.queryRecordBySQL(sql.toString());
		if (MapUtils.isNotEmpty(mainMap)) {
			responseDTO.setValue("mainMap", mainMap);
		}
		return responseDTO;
	}
	/**
	 * NEWMETHOD ������¼�û�ʱ�ж��û��Ƿ��Ѿ����ڡ�ɾ���û�
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg opUserInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String empId= msg.getValue("empid");
		String loginId= msg.getValue("loginid");
		String retFlag = "0";
		try {
			if(DevUtil.isValueNotNull(empId, DevConstants.SUPERADMIN_EMP_ID)){
				retFlag = "4";// ���ܶԳ�������Ա�������κβ���
			}else if(DevUtil.isValueNotNull(loginId, DevConstants.SUPERADMIN_LOGIN_ID)){
				retFlag = "5";// ���ܶԳ�������Ա�������κβ���
			}else{
				String opFlag = msg.getValue("opflag");
				String userId= msg.getValue("userid");
				
				if(DevUtil.isValueNotNull(opFlag, "ex")){//�ж��û��Ƿ����
					String addupFlag= msg.getValue("addupflag");
					String email = msg.getValue("email");
					String userSql = "select user_id from p_auth_user where bsflag = '0' and emp_id = '"+empId+"' ";
					if(DevUtil.isValueNotNull(addupFlag, "up")){//�������Ϊ�����û��ж��û��Ƿ����
						userSql += "and user_id != '"+userId+"'";
					}
					Map userMap = jdbcDao.queryRecordBySQL(userSql);
					if (MapUtils.isNotEmpty(userMap)) {//ѭ���ж�д�ĺܶ��ģ����Ż�
						retFlag = "1";// �û��Ѿ�����
					}else{
						String loginIdSql = "select user_id from p_auth_user where bsflag = '0' and login_id = '"+loginId+"' ";
						if(DevUtil.isValueNotNull(addupFlag, "up")){//�������Ϊ�����û��ж��û��Ƿ����
							loginIdSql += "and user_id != '"+userId+"'";
						}
						Map loginIdMap = jdbcDao.queryRecordBySQL(loginIdSql);
						if (MapUtils.isNotEmpty(loginIdMap)) {
							retFlag = "2";// ��¼���Ѿ�����
						}else{
							String emailSql = "select user_id from p_auth_user where bsflag = '0' and email = '"+email+"' ";
							if(DevUtil.isValueNotNull(addupFlag, "up")){//�������Ϊ�����û��ж��û��Ƿ����
								emailSql += "and user_id != '"+userId+"'";
							}
							Map emailMap = jdbcDao.queryRecordBySQL(emailSql);
							if (MapUtils.isNotEmpty(emailMap)) {
								retFlag = "6";// �����Ѿ�����
							}
						}
					}
				}else if(DevUtil.isValueNotNull(opFlag, "del")){//ɾ���û�
					String delSql = "update p_auth_user "
							  + " set bsflag = '1',"
							  + " modifi_date = sysdate"
							  + " where user_id ='"+userId+"'";
					jdbcDao.executeUpdate(delSql);
				}else if(DevUtil.isValueNotNull(opFlag, "pwd")){//�����û�����
					String delSql = "update p_auth_user "
							  + " set user_pwd = '"+PasswordUtil.encrypt(AuthInitializor.param.getDefaultPassword())+"',"
							  + " modifi_date = sysdate"
							  + " where user_id ='"+userId+"'";
					jdbcDao.executeUpdate(delSql);
				}else if(DevUtil.isValueNotNull(opFlag, "dr")){//ɾ���û���ɫ
					String delStr = "";
					String[] userRoleIds = msg.getValue("userroleids").split(",", -1);
					final List<Map<String, Object>> datasList = new ArrayList<Map<String, Object>>();
					for (int index = 0; index < userRoleIds.length; index++) {
						if(index == 0){
							delStr = userRoleIds[index];
						}else{
							delStr += "','"+userRoleIds[index]+"";
						}
					}
					String delRoleSql = "delete from p_auth_user_role_dms "
							  + " where user_role_id in ( '"+delStr+"' )";
					jdbcDao.executeUpdate(delRoleSql);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			retFlag = "3";// ��ѯʧ��
		}
		responseDTO.setValue("datas", retFlag);
		return responseDTO;
	}
	/**
	 * NEWMETHOD ����/�޸ĵ�¼�û�
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveOrUpdateUserInfo(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
		String orgId = msg.getValue("orgid");
		String loginId = msg.getValue("loginid");
		String userName = msg.getValue("username");
		String email = msg.getValue("email");
		String empId = msg.getValue("empid");
		String userType = msg.getValue("usertype");
		String addUpFlag = msg.getValue("addupflag");//���/�޸ı�ʶ
		String userId = msg.getValue("userid");

		Map mainMap = new HashMap();
		if(DevUtil.isValueNotNull(addUpFlag, "add")){//����
			mainMap.put("org_id", orgId);
			mainMap.put("user_pwd", PasswordUtil.encrypt(AuthInitializor.param.getDefaultPassword()));
			mainMap.put("login_id", loginId);
			mainMap.put("user_name", userName);
			mainMap.put("user_status", DevConstants.BSFLAG_NORMAL);
			mainMap.put("email", email);
			mainMap.put("emp_id", empId);
			mainMap.put("bsflag", DevConstants.BSFLAG_NORMAL);
			mainMap.put("user_type", userType);
			mainMap.put("modifi_date", DevUtil.getCurrentTime());
			mainMap.put("modifier", user.getEmpId());
		}else{
			mainMap.put("user_id", userId);
			mainMap.put("org_id", orgId);
			mainMap.put("login_id", loginId);
			mainMap.put("email", email);
			mainMap.put("user_type", userType);
			mainMap.put("modifi_date", DevUtil.getCurrentTime());
			mainMap.put("modifier", user.getEmpId());
		}
		jdbcDao.saveOrUpdateEntity(mainMap, "p_auth_user");

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		return responseDTO;
	}
	/**
	 * ��ʾȫ����ɫ��Ϣ 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */	
	public ISrvMsg queryRoleDetInfo(ISrvMsg isrvmsg) throws Exception {
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String currentPage = isrvmsg.getValue("page");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = isrvmsg.getValue("rows");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String userId = isrvmsg.getValue("userid");
		String roleName = isrvmsg.getValue("rolename");
		String chroleName = isrvmsg.getValue("chrolename");
		String enroleName = isrvmsg.getValue("enrolename");
		String sortField = isrvmsg.getValue("sort");
		String sortOrder = isrvmsg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select p.role_id,p.role_e_name,p.role_c_name,d.coding_name as role_category_name"
				  	  + " from p_auth_role_dms p"
				  	  + " left join comm_coding_sort_detail d on p.role_category = d.coding_code_id"
				  	  + " where p.role_level != '00000' and p.role_level != '20000' and p.role_id not in"
				  	  + " (select ur.role_id from p_auth_user_role_dms ur where ur.user_id = '"+userId+"')");
		//��ɫ����
		if(StringUtils.isNotBlank(roleName)){
			querySql.append(" and d.coding_name like '"+roleName+"%' ");
		}
		//��������
		if (StringUtils.isNotBlank(chroleName)) {
			querySql.append(" and p.role_c_name like '%"+chroleName+"%'");
		}
		//Ӣ������
		if (StringUtils.isNotBlank(enroleName)) {
			querySql.append(" and p.role_e_name like '%"+enroleName+"%'");
		}
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by d.coding_name,p.role_level");
		}
		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * NEWMETHOD ���û���ӽ�ɫ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveUserRoleInfo(ISrvMsg msg) throws Exception {
		String userId = msg.getValue("userid");

		String[] idInfos = msg.getValue("idinfos").split(",", -1);
		final List<Map<String, Object>> datasList = new ArrayList<Map<String, Object>>();
		for (int index = 0; index < idInfos.length; index++) {
			Map<String, Object> dataMap = new HashMap<String, Object>();
			dataMap.put("roleid", idInfos[index]);
			dataMap.put("userid", userId);
			datasList.add(dataMap);
		}
		String insRoleDetSql = "insert into p_auth_user_role_dms(user_role_id,user_id,role_id)values(?,?,?)";
		jdbcDao.getJdbcTemplate().batchUpdate(insRoleDetSql,
				new BatchPreparedStatementSetter() {
					@Override
					public void setValues(PreparedStatement ps, int i)
							throws SQLException {
						Map<String, Object> roleSaveMap = datasList.get(i);
						ps.setString(1, jdbcDao.generateUUID());
						ps.setString(2, (String) roleSaveMap.get("userid"));
						ps.setString(3, (String) roleSaveMap.get("roleid"));
					}

					@Override
					public int getBatchSize() {
						return datasList.size();
					}
				});

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		return responseDTO;
	}
}
