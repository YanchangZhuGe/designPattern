package com.cnpc.sais.ibp.auth.util;

public class AuthConstant {
	/**
	 * ���˵���parentMenuId����ֵ
	 */
	public static final String ROOT_MENU_PARENT_MENUID = "00000";
	
	/**
	 * ����֯������parentId����ֵ
	 */
	public static final String ROOT_ORG_ID = "00000";	
	
	/**
	 * ��������Ա�Ľ�ɫID
	 */
	public static final String SUPER_ROLE_ID = "INIT_AUTH_ROLE_012345678000000";	
	
	/**
	 * Ҷ�Ӳ˵��ı�ʶ��
	 */
	public static final String LEAF_MENU_FLAG = "1";	
	
	/**
	 * Ȩ��ģ��ҵ���쳣
	 */
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
	
	/**
	 * �û�״̬
	 */
	//����ʹ��״̬
	public static final String USER_NORMAL = "0";
	//����״̬
	public static final String USER_DISABLED = "1";
	//����״̬
	public static final String USER_REMOVED = "2";
}
