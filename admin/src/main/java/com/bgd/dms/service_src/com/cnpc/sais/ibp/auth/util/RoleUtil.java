package com.cnpc.sais.ibp.auth.util;


import java.util.ArrayList;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.log4j.Logger;
import org.hibernate.Hibernate;


import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.sais.ibp.auth.pojo.PAuthFunction;
import com.cnpc.sais.ibp.auth.pojo.PAuthRole;
import com.cnpc.sais.ibp.auth.pojo.PAuthRoleFunc;
import com.cnpc.sais.ibp.auth.pojo.PAuthUser;
/**
 * Project：CNLC OMS(Service)
 * 
 * Creator：rechete
 * 
 * Creator Time:2008-4-28 上午10:17:47
 * 
 * Description：System Role Management Util
 * 
 * Revision history：
 * 
 * 
 * 
 */
public class RoleUtil {
	private static ILog log = LogFactory.getLogger(RoleUtil.class);	
	private static Map<String,PAuthRole> roles = new Hashtable();

	/**
	 * 获取所有角色的id，给superManager使用 
	 * @return
	 */
	public static List<String> getAllRoleIds(){
		List<String> roleIds = new ArrayList();
		Set keys = roles.keySet();
		roleIds.addAll(keys);
		return roleIds;
	}
	
	public static void addAll(List<PAuthRole> authRoles){
		roles.clear();
		for(int i=0;i<authRoles.size();i++){
			PAuthRole role = authRoles.get(i);
			Hibernate.initialize(role);
			roles.put(role.getRoleId(), role);
		}
	}
	
	/**
	 * 获取role拥有的功能集,从功能cache中获取
	 * @param role
	 * @return
	 */
    public static List<PAuthFunction> getFunctions(PAuthRole role){
	   	 List<PAuthFunction> funcs = new ArrayList();
	   	 if(role==null || role.getRoleFuncs()==null) return funcs;
	   	 
	   	 Iterator iter = role.getRoleFuncs().iterator();
	   	 while(iter.hasNext()){
	   		 PAuthRoleFunc roleFunc = (PAuthRoleFunc)iter.next();
	   		 PAuthFunction func =  FunctionUtil.getPAuthFunction(roleFunc.getFuncId());
	   		 if(func!=null) funcs.add(func);
	   	 }
	   	 return funcs;
    }	
	
	/**
	 * 根据roleId从缓存中读取Role
	 * @param roleId
	 * @return
	 */
	public static PAuthRole getRole(String roleId){
		return roles.get(roleId);
	}
	
	public static void clearRolePool(){
		roles.clear();
	}
	
	/**
	 * 获取用户拥有function的roles,通常只有一个role
	 * @return
	 */
	public static List<PAuthRole> getRoles(String funcId,PAuthUser user){
		List<PAuthRole> roles = user.getRoles();
		return null;
	}
	
	/**
	 * 根据用,分割开的多个roleId，查出他们具有的function code，重复的function code剔出
	 * @param roleIds
	 * @return
	 */
	public static String getFunctionCodesByRoleIds(String roleIds){		
		String functionCodes = "";
		if(roleIds==null) return functionCodes;
		
		//超级管理员，具有所有的功能权限
		if(roleIds.indexOf("INIT_AUTH_ROLE_012345678000000")>0){
			return FunctionUtil.getAllFuncCodes();
		}
		
		String[] roleArray = roleIds.split(",");
		for(int i=0;i<roleArray.length;i++){
			PAuthRole role = getRole(roleArray[i]);
			List<PAuthFunction> funcs = getFunctions(role);
			for(int j=0;j<funcs.size();j++){
				PAuthFunction function = funcs.get(j);
				if(function==null) continue;
				String funCode = function.getFuncCode();
				if(funCode!=null) funCode += ",";
				else continue;
				if(functionCodes.indexOf(funCode)>=0) continue;
				functionCodes += funCode;
			}
		}
		return functionCodes;
	}
	
	/**
	 * 新增角色后，更新缓存
	 * @param role
	 */
	public static void addRole(PAuthRole role){
		roles.put(role.getRoleId(), role);
	}
	
	/**
	 * 删除角色后，更新缓存
	 * @param role
	 */
	public static void deleteRole(PAuthRole role){
		roles.remove(role.getRoleId());
	}	

	/**
	 * 修改角色后，更新缓存
	 * @param role
	 */	
	public static void updateRole(PAuthRole role){
		roles.remove(role.getRoleId());
		roles.put(role.getRoleId(), role);
	}			
}
