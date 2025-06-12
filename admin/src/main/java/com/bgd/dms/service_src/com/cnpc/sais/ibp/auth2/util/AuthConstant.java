package com.cnpc.sais.ibp.auth2.util;

import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;

public class AuthConstant {
	
	/**
	 * ���˵���parentMenuId����ֵ
	 */
	public static final String ROOT_MENU_PARENT_MENUID = "00000";
	/**
	 * ��������ԱID
	 */
	public static final String SUPER_ADMIN_ID = "INIT_AUTH_USER_012345678000000";
	
	
	/**
	 * ��������Ա�Ľ�ɫID
	 */
	public static final String SUPER_ROLE_ID = "INIT_AUTH_ROLE_012345678000000";	
	/**
	 * ������ɫID
	 */
	public static final String COMMON_ROLE_ID = "INIT_AUTH_ROLE_012345678000001";
	
	/**
	 * ����Ա�Ľ�ɫID
	 */
	public static final String ADMIN_ROLE_ID = "INIT_AUTH_ROLE_012345678000002";
	/**
	 * Ҷ�Ӳ˵��ı�ʶ��
	 */
	public static final String LEAF_FLAG = "1";	
	
	/**
	 * Ȩ��ģ��ҵ���쳣
	 */
	//�û���Ϊ�գ�ֱ�ӷ��ʵ�¼srqʱ��
	public static final String SP_AUTH_LOGINID_NULL = "SP_AUTH_LOGINID_NULL";
	//�û�������
	public static final String SP_AUTH_USER_NOTEXIST = "SP_AUTH_USER_NOTEXIST";
	//�û�������
	public static final String SP_AUTH_USER_DISABLED = "SP_AUTH_USER_DISABLED";	
	//���벻��ȷ 
	public static final String SP_AUTH_PWD_ERROR = "IBP_AUTH_PWD_ERROR";
	
	//����Ȩ���쳣
	public static final String SP_AUTH_DATAORG_ERROR = "SP_AUTH_DATAORG_ERROR";
	//��ɫ�Ѵ���
	public static final String ROLE_EXIST = "SP_AUTH_ROLE_EXIST";
	//�����֤ϵͳ����
	public static final String SP_AUTH_IA_ERROR = "SP_AUTH_IA_ERROR";
	//�û�֤����֤ʧ��
	public static final String SP_AUTH_CERF_ERROR = "SP_AUTH_CERF_ERROR";
	//�û�IP��ֹ����
	public static final String SP_AUTH_IP_NOT_INTER = "SP_AUTH_IP_NOT_INTER";
	/**
	 * �û�״̬
	 */
	//����ʹ��״̬
	public static final String USER_NORMAL = "0";
	//����״̬
	public static final String USER_DISABLED = "1";
	//����״̬
	public static final String USER_REMOVED = "2";
	/**
	 * �û�����
	 */
	//��������Ա
	public static final String SUPER_ADMIN_USER_TYPE = "0";
	//ϵͳ����Ա
	public static final String SYSTEM_ADMIN_USER_TYPE = "1";
	//��ͨ����Ա
	public static final String ADMIN_USER_TYPE = "2";
	//��ͨ�û�
	public static final String COMMON_USER_TYPE = "3";
	/**
	 * ��֯�������ܼ�,��������Դ����
	 */
	public static final String MENU = "1";
	public static final String FUNC = "2";
	
	
	/**
	 * ������֯������ID����ֵ
	 */
	public static String ROOT_ORG_ID = "INIT_AUTH_ORG_012345678000000";	
	/**
	 * ��֯������ID�������ļ�dft_cfg.xml��ȡ�����û�����ã���Ĭ��ֵ����
	 */
	static {
		ConfigHandler mgDataHd = ConfigFactory.getCfgHandler();
		String rootOrgIdValue=  mgDataHd.getSingleNodeValue("app_config/root_org_id");
		if (rootOrgIdValue != null) {
			ROOT_ORG_ID = rootOrgIdValue;
		}
	}
}
