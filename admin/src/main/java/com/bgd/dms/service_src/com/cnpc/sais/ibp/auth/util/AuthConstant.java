package com.cnpc.sais.ibp.auth.util;

public class AuthConstant {
	/**
	 * 根菜单的parentMenuId属性值
	 */
	public static final String ROOT_MENU_PARENT_MENUID = "00000";
	
	/**
	 * 根组织机构的parentId属性值
	 */
	public static final String ROOT_ORG_ID = "00000";	
	
	/**
	 * 超级管理员的角色ID
	 */
	public static final String SUPER_ROLE_ID = "INIT_AUTH_ROLE_012345678000000";	
	
	/**
	 * 叶子菜单的标识符
	 */
	public static final String LEAF_MENU_FLAG = "1";	
	
	/**
	 * 权限模块业务异常
	 */
	//用户不存在
	public static final String SP_AUTH_USER_NOTEXIST = "SP_AUTH_USER_NOTEXIST";
	//用户被禁用
	public static final String SP_AUTH_USER_DISABLED = "SP_AUTH_USER_DISABLED";	
	//密码不正确 
	public static final String SP_AUTH_PWD_ERROR = "IBP_AUTH_PWD_ERROR";
	
	//数据权限异常
	public static final String SP_AUTH_DATAORG_ERROR = "SP_AUTH_DATAORG_ERROR";
	//角色已存在
	public static final String ROLE_EXIST = "SP_AUTH_ROLE_EXIST";
	
	/**
	 * 用户状态
	 */
	//正常使用状态
	public static final String USER_NORMAL = "0";
	//禁用状态
	public static final String USER_DISABLED = "1";
	//作废状态
	public static final String USER_REMOVED = "2";
}
