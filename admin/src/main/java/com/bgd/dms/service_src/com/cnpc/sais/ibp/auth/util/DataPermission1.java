package com.cnpc.sais.ibp.auth.util;

import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;



import com.cnpc.jcdp.dao.IJdbcDao;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.soa.exception.ServiceException;
import com.cnpc.sais.ibp.auth.pojo.PAuthFunction;
import com.cnpc.sais.ibp.auth.pojo.PAuthRole;


/**
 * Project：CNLC OMS(Service)
 * 
 * Creator：rechete
 * 
 * Creator Time:2008-4-28 上午10:17:47
 * 
 * Description：数据权限管理类
 * 
 * Revision history：
 * 
 * 
 * 
 */
public class DataPermission1 {
	private ILog log = LogFactory.getLogger(AuthInitializor.class);	
	private IJdbcDao jdbcDao = BeanFactory.getQueryJdbcDAO();
	
	private static final String CDT_ALL = "000";
	private static final String orgTable = "dataAuthOrg";
	
/*	public String getAuthedSql0(String sql,UserToken user,DataAuthParam param)throws ServiceException{
		StringBuffer sb = new StringBuffer("select dataAuthView.* from(");
		sb.append(sql);
		sb.append(") dataAuthView,p_auth_org "+orgTable);
		sb.append(" WHERE dataAuthView."+param.getOrgClmName()+"="+orgTable+".Org_Id");
		
		String dataOrgId = getDataOrgId(param.getFuncCode(),user);
		String cdtSql = processDataPermission(dataOrgId,param.getDataLevels());		
		if(cdtSql!=null && !"".equals(cdtSql))
			sb.append(" AND ("+cdtSql+")");
		log.debug("-------------data auth process 0----------");
		log.debug(sql);
		log.debug("-------------data auth process 1----------");
		log.debug(sb.toString());
		log.debug("-------------data auth process 2----------");
		return sb.toString();
	}*/
	
/*	public String getAuthedSql(String sql,UserToken user,String funcCode)throws ServiceException{
		DataAuthParam daParam = null;
		if(daParam==null){
			daParam = new DataAuthParam();
			daParam.setOrgClmName("dept");
		}
		StringBuffer sb = new StringBuffer("select dataAuthView.* from(");
		sb.append(sql);
		sb.append(") dataAuthView");
		sb.append(daParam.getFilterString(user));
		return sb.toString();
	}*/
	
	/**
	 * 
	 * @param orgClmName
	 * @param dataOrgId
	 * @param orgLevels
	 * @return
	 * @throws RetCodeException
	 */
	private String processDataPermission(String dataOrgId,String orgLevels)throws ServiceException{
		StringBuffer sb = new StringBuffer("");
		
		String[] strLevels = orgLevels.split(",");
		int[] selLevels = new int[strLevels.length];
		for(int i=0;i<strLevels.length;i++)
			selLevels[i] = Integer.parseInt(strLevels[i]);
		
		Map dataOrg = queryAuthOrg(dataOrgId);
		if(dataOrg==null) return null;
			//throw new RetCodeException(AuthConstant.SP_AUTH_DATAORG_ERROR);
		
		int dataOrgLevel = Integer.parseInt(dataOrg.get("orgLevel").toString());
		for(int i=0;i<selLevels.length;i++){
			//层次数值大的没有查看层次数值小的org权限
			if(dataOrgLevel>selLevels[i]) continue;
			String sql = getLevelSqlCdt(dataOrg,selLevels[i]);
			if("".equals(sql)) continue;
			if(sb.length()==0) sb.append("("+sql+")");
			else sb.append(" OR ("+sql+")");
		}
		
		return sb.toString();
	}
	
	private String getLevelSqlCdt(Map dataOrg,int selLevel){
		String ret = "";
		String dataOrgId = dataOrg.get("orgId").toString();
		int dataOrgLevel = Integer.parseInt(dataOrg.get("orgLevel").toString());
		if(dataOrgLevel==selLevel)
			ret = orgTable+".Org_Id='"+dataOrgId+"'";
/*		else if(dataOrgLevel<selLevel)
			ret = orgTable+".Org_Id='not exist'";*/
		else{
			String cdt = getCdt(dataOrg,selLevel);
			//包括该层次的所有组织机构
			if(CDT_ALL.equals(cdt)){
				ret = orgTable+".Org_Level='"+selLevel+"'";
			}
			//部分包含
		}	
		
		return ret;
	}
	
	/**
	 * 获取authOrg在selLevel层次的数据权限属性
	 * @param authOrg
	 * @param selLevel
	 * @return
	 */
	private String getCdt(Map authOrg,int selLevel){
		String key = "l"+selLevel+"Cdt";
		return (String)authOrg.get(key);
	}
	
	/**
	 * 功能->角色
	 * 			+UserToken->DataOrgId
	 * @param functionId
	 * @param user
	 * @return
	 */
	private String getDataOrgId(String functionId,UserToken user){
		String roleIds = user.getRoleIds();
		String[] roleArray = roleIds.split(",");
		String roleId = null;
		for(int i=0;i<roleArray.length;i++){
			PAuthRole role = RoleUtil.getRole(roleArray[i]);
			if(role==null) continue;
			List<PAuthFunction> funcs = RoleUtil.getFunctions(role);
			for(int j=0;j<funcs.size();j++){
				log.debug(funcs.get(j).getFuncId());
				if(functionId.equals(funcs.get(j).getFuncCode())){ 
					roleId = roleArray[i];
					break;
				}
			}
			if(roleId!=null) break;					
		}
		
		//to be finished
		if(roleId==null) return user.getOrgId();
		
		PAuthRole role = RoleUtil.getRole(roleId);
		if(role.getDataOrgId()!=null) return role.getDataOrgId();
		else return user.getOrgId();
	}
	
	private Map queryAuthOrg(String orgId)throws ServiceException{
		StringBuffer sb = new StringBuffer("");
		sb.append("select ao.org_id,ao.org_level,ao.l1_cdt,ao.l2_cdt,ao.l3_cdt");
		sb.append(" from p_auth_org ao");
		sb.append(" where ao.org_id='"+orgId+"'");
		log.debug(sb.toString());
		return jdbcDao.queryRecordBySQL(sb.toString());
	}	
}
