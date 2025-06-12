package com.bgp.dms.util;

/*
 * @author zjb
 * @deprecated �豸״̬�嵥����ֵ˵����
 * */
public interface CommonConstants {
	/** ɾ����ǣ����� */
	public static final String BSFLAG_NORMAL = "0";
	/** ɾ����ǣ�ɾ�� */
	public static final String BSFLAG_DELETE = "1";
	/**
	 * �ʲ�״̬��account_stat��<font color="red">����</font>
	 * */
	public static final String ACCOUNT_STAT_BF = "0110000013000000001";
	/**
	 * �ʲ�״̬��account_stat��<font color="red">�Ѵ���</font>
	 * */
	public static final String ACCOUNT_STAT_ZCZ = "0110000013000000002";
	/**
	 * �ʲ�״̬��account_stat��<font color="red">����</font>
	 * */
	public static final String ACCOUNT_STAT_ZZ = "0110000013000000003";
	/**
	 * �ʲ�״̬��account_stat��<font color="red">�Ѻϲ�</font>
	 * 1�����ϲ����豸״̬Ϊ���Ѻϲ������������µ�״̬�ǡ���Ч������Ӧ�ļ�ֵ������Amis�б����
	 * ���磺�豸1�ϲ����豸2�ϣ��豸1��״̬�ǡ��Ѻϲ�����ԭֵ����ֵΪ0���豸2��״̬�ǡ���Ч����ԭֵ�������豸��ԭֵ֮�͡�
	 * */
	public static final String ACCOUNT_STAT_YHB = "0110000013000000004";
	/**
	 * ����״̬tech_stat <font color="red">���</font>
	 *  1���豸"�չ�����"��������á����ޡ������ϡ�����״̬��
	 * 2�����й����豸ά��ģ���������"����"��"����"��"���"״̬��
	 */
	public static final String TECH_STAT_WH = "0110000006000000001";
	/**
	 * ����״̬tech_stat <font color="red">������ </font>
	 * 1���豸"�չ�����"��������á����ޡ������ϡ�����״̬��
	 * 2�����й����豸ά��ģ���������"����"��"����"��"���"״̬��
	 */
	public static final String TECH_STAT_DBF = "0110000006000000005";
	/**
	 * ����״̬tech_stat <font color="red">���� </font>
	 * 1���豸"�չ�����"��������á����ޡ������ϡ�����״̬��
	 * 2�����й����豸ά��ģ���������"����"��"����"��"���"״̬��
	 */
	public static final String TECH_STAT_DX = "0110000006000000006";
	/**
	 * ����״̬tech_stat <font color="red">����</font>
	 *  1���豸"�չ�����"��������á����ޡ������ϡ�����״̬��
	 * 2�����й����豸ά��ģ���������"����"��"����"��"���"״̬��
	 */
	public static final String TECH_STAT_ZX = "0110000006000000007";
	/** ����״̬tech_stat <font color="red">����</font> */
	public static final String TECH_STAT_YS = "0110000006000000013";
	/**
	 * ʹ��״̬using_stat <font color="red">����</font>
	 *  1���豸��������߳����״̬��Ϊ"����"�� 
	 *  2��"ʹ��״̬"Ϊ"����"ʱ"����״̬"����Ϊ"���"
	 */
	public static final String USING_STAT_ZY = "0110000007000000001";
	/**
	 * ʹ��״̬using_stat <font color="red"></font>����
	 * 1���չ�������ɺ��Ϊ"����"�� 
	 * 2��"ʹ����״̬"Ϊ"����"ʱ"����״̬"����Ϊ"���"
	 */
	public static final String USING_STAT_XZ = "0110000007000000002";
	/** ʹ��״̬using_stat <font color="red">ͣ��</font> 
	 * ����Ŀ���豸��ͣ�ƻ���ʹ�ô�״̬������ͨ���ı�ͣ�ƻ��ڵ���Ŀ̨���л�ͣ�á� */
	public static final String USING_STAT_TY = "0110000007000000003";
	/** ʹ��״̬using_stat <font color="red">����</font> ʹ��״̬Ϊ"����"��
	 * ���豸"����״̬"ӦΪ�������ϡ����ޡ����ޡ����գ� */
	public static final String USING_STAT_QT = "0110000007000000006";
	/** �����ñ�ʶifunused <font color="red">����</font> */
	public static final String IFUNUSED_ZC = "0";
	/** �����ñ�ʶifunused <font color="red">�������� </font>
	 * �豸���һ������δʹ�ü�����ʶΪ "��������" */
	public static final String IFUNUSED_CQXZ = "1";
	/**
	 * �����豸��ʶifproduction <font color="red">�����豸</font>
	 * 1��װ�����񴦣�������(S0622)����Դ(S0623)�����̳�(S080401)��Ƥ��(S080105)��
	 * 2����̽�������(S0601)������(S080101)��Ƥ��(S080105)������(S080304)��������
	 * (S070301)����ˮ�޳�(S08010301,S08010302)�������������䳵(S08010304)��
	 * 3���ۺ��ﻯ̽������ͬ��̽���������豸Ϊ�������豸�� 4�������̽�������ʲ������䴬��Ϊ�����豸�� 5�����������ݶ�Ϊ�����豸
	 */
	public static final String IFPRODUCTION_SCSB = "5110000186000000001";
	/**
	 * �����豸��ʶifproduction <font color="red">�������豸</font>
	 * 1����λ����װ�����񴦼�����̽��������൥λ���豸��Ϊ�������豸�� 2���豸���ͣ��������豸���е��豸�����������豸���;�Ϊ�������豸��
	 */
	public static final String IFPRODUCTION_FSCSB = "5110000186000000002";
	/**
	 * ����/�����ʶifcountry ���� �������豸��λ�������еĵ�λ�豸��Ϊ"����".
	 */
	public static final String IFCOUNTRY_GN = "����";
	/**
	 * ����/�����ʶifcountry ���� �����豸��λ�������еĵ�λ�豸��Ϊ"����".
	 */
	public static final String IFCOUNTRY_GW = "����";
}
