package com.cnpc.sais.ibp.auth2.util;

import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;

public class AuthConstant {
	
	/**
	 * 根菜单的parentMenuId属性值
	 */
	public static final String ROOT_MENU_PARENT_MENUID = "00000";
	/**
	 * 超级管理员ID
	 */
	public static final String SUPER_ADMIN_ID = "INIT_AUTH_USER_012345678000000";
	
	
	/**
	 * 超级管理员的角色ID
	 */
	public static final String SUPER_ROLE_ID = "INIT_AUTH_ROLE_012345678000000";	
	/**
	 * 公共角色ID
	 */
	public static final String COMMON_ROLE_ID = "INIT_AUTH_ROLE_012345678000001";
	
	/**
	 * 管理员的角色ID
	 */
	public static final String ADMIN_ROLE_ID = "INIT_AUTH_ROLE_012345678000002";
	/**
	 * 叶子菜单的标识符
	 */
	public static final String LEAF_FLAG = "1";	
	
	/**
	 * 权限模块业务异常
	 */
	//用户名为空（直接访问登录srq时）
	public static final String SP_AUTH_LOGINID_NULL = "SP_AUTH_LOGINID_NULL";
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
	//身份认证系统错误
	public static final String SP_AUTH_IA_ERROR = "SP_AUTH_IA_ERROR";
	//用户证书认证失败
	public static final String SP_AUTH_CERF_ERROR = "SP_AUTH_CERF_ERROR";
	//用户IP禁止访问
	public static final String SP_AUTH_IP_NOT_INTER = "SP_AUTH_IP_NOT_INTER";
	/**
	 * 用户状态
	 */
	//正常使用状态
	public static final String USER_NORMAL = "0";
	//禁用状态
	public static final String USER_DISABLED = "1";
	//作废状态
	public static final String USER_REMOVED = "2";
	/**
	 * 用户类型
	 */
	//超级管理员
	public static final String SUPER_ADMIN_USER_TYPE = "0";
	//系统管理员
	public static final String SYSTEM_ADMIN_USER_TYPE = "1";
	//普通管理员
	public static final String ADMIN_USER_TYPE = "2";
	//普通用户
	public static final String COMMON_USER_TYPE = "3";
	/**
	 * 组织机构功能集,关联的资源类型
	 */
	public static final String MENU = "1";
	public static final String FUNC = "2";
	
	
	/**
	 * 顶级组织机构的ID属性值
	 */
	public static String ROOT_ORG_ID = "INIT_AUTH_ORG_012345678000000";	
	/**
	 * 组织机构根ID从配置文件dft_cfg.xml获取，如果没有配置，则按默认值处理
	 */
	static {
		ConfigHandler mgDataHd = ConfigFactory.getCfgHandler();
		String rootOrgIdValue=  mgDataHd.getSingleNodeValue("app_config/root_org_id");
		if (rootOrgIdValue != null) {
			ROOT_ORG_ID = rootOrgIdValue;
		}
	}
}
