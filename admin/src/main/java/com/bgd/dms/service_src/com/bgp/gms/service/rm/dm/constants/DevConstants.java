package com.bgp.gms.service.rm.dm.constants;

public interface DevConstants {
	/** ��������Ա��¼�� */
	public static final String COMM_USER_SUPERADMIN = "superadmin";
	/** ����״̬��0-�ѱ���״̬ */
	public static final String STATE_SAVED = "0";
	/** ����״̬��9-���ύ״̬ */
	public static final String STATE_SUBMITED = "9";
	/** ����״̬���ѱ���״̬ */
	public static final String STATEDESC_SAVED = "δ�ύ";
	/** ����״̬�����ύ״̬ */
	public static final String STATEDESC_SUBMITED = "���ύ";
	/** ɾ����ǣ����� */
	public static final String BSFLAG_NORMAL = "0";
	/** ɾ����ǣ�ɾ�� */
	public static final String BSFLAG_DELETE = "1";
	/** ɾ����ǣ�ת���豸�м�״̬ */
	public static final String BSFLAG_INTERMEDIATE = "N";
	/** ��������/�����ύ */
	public static final String SAVE_FLAG_1 = "1";
	/** �豸�չ����� */
	public static final String SAVE_FLAG_0 = "0";
	/** �������ñ�ʶ��0������ */
	public static final String IFUNUSED_FLAG_0 = "0";
	/** �������ñ�ʶ��1���������� */
	public static final String IFUNUSED_FLAG_1 = "1";
	/** ���������豸��� */
	public static final String IFSCRAPLEFT_FLAG_1 = "1";
	/** ɾ����ǣ������� */
	public static final String BSFLAG_NEWADD = "N";
	/** �Ƿ������ϸ���� */
	public static final String ISADDDETAIL_YES = "Y";
	/** �Ƿ������ϸ���� */
	public static final String ISADDDETAIL_NO = "N";
	/** �Ƿ񿪾ݵ��䵥���� */
	public static final String ISPRINTFORM_YES = "Y";
	/** �Ƿ񿪾ݵ��䵥���� */
	public static final String ISPRINTFORM_NO = "N";
	/** S0000 */
	public static final String MIXTYPE_COMMON = "S0000";
	/** S0001 �����豸 */
	public static final String MIXTYPE_SWAP = "S0001";
	/** S0623 ��Դ*/
	public static final String MIXTYPE_ZHENYUAN = "S0623";
	/** S1405 ��������*/
	public static final String MIXTYPE_YIQI = "S1405";
	/** S14059999  �������������豸*/
	public static final String MIXTYPE_YIQI_FUSHU = "S14059999";
	/** �첨�� */
	public static final String MIXTYPE_JIANBOQI = "S14050208";
	/** �첨�������� */
	public static final String MIXTYPE_JIANBOQICESHIYI = "S14050301";
	/** С������ */
	public static final String MIXTYPE_XIAOZHESHEYI = "S140504";
	/** ���ּ첨�� */
	public static final String MIXTYPE_SHUZIJIANBOQI = "S1405020806";
	/** S0622 �������������ó��� */
	public static final String MIXTYPE_YIQICHE = "S0622";
	/** S1404 */
	public static final String MIXTYPE_CELIANG = "S1404";
	/** S140401 02 03 */
	public static final String MIXTYPE_CELIANG_01 = "S140401";
	public static final String MIXTYPE_CELIANG_02 = "S140402";
	public static final String MIXTYPE_CELIANG_03 = "S140403";
	/** S9000 ������������*/
	public static final String MIXTYPE_ZHUANGBEI_DZYQ = "S9000";
	/** S9001 ������е�������*/
	public static final String MIXTYPE_DAGANG_DZYQ = "S9001";
	/** װ�����񴦵��豸���ʿ�ORG_ID */
	public static final String MIXTYPE_ZHUANGBEI_ORGID = "C6000000005526";
	/** װ�����񴦵ĵ�����ID */
	public static final String MIXTYPE_ZHUANGBEI_ORGSUBID = "C105006";
	/** ��˾��org_sub_id��Ϣ */
	public static final String COMM_COM_ORGSUBID = "C105";
	/** ��˾��org_id��Ϣ */
	public static final String COMM_COM_ORGID = "C6000000000001";
	/** ��Դ��������orgid��Ϣ */
	public static final String MIXTYPE_ZHUANGBEI_ZY_ORGID = "C6000000000043";
	/**��������豸��������**/
	public static final String MIXTYPE_DAGANG_YQ_ORGID = "C6000000000040";
	/**������Ŀ����**/
	public static final String DEV_PROTYPE_JZ = "5000100004000000008";
	/**�ۺ��ﻯ̽��Ŀ����**/
	public static final String DEV_PROTYPE_ZH = "5000100004000000009";
	/**���Ŀ����**/
	public static final String DEV_PROTYPE_SH = "5000100004000000006";
	/**��������Ա�û�EMPID**/
	public static final String SUPERADMIN_EMP_ID = "8ad882732f4a003a012f4c7b37d50003";
	/**��������Ա�û���¼��**/
	public static final String SUPERADMIN_LOGIN_ID = "superadmin";
	/** ��̬��Ϣ�ı�ʶ 1:ȥ��Ŀ 2 ��Ŀ�黹 3 ����(�ɼ���ά��) 4 ����(�ɼ�û��) 5 �޺� (ά�����)6�޷�ά��7����ά��*/
	/**�豸ά�ޱ�������:����**/
	public static final String DEV_MAINTAIN_MAINTENANCE = "0110000037000000002";
	/**�豸ά�ޱ�������:ά��**/
	public static final String DEV_MAINTAIN_REPAIR = "0110000037000000001";
	/**�豸ά�ޱ�������:ί�⴦��**/
	public static final String DEV_MAINTAIN_OUT = "0110000037000000003";
	public static final String DYM_OPRTYPE_OUT = "1";
	public static final String DYM_OPRTYPE_IN = "2";
	public static final String DYM_OPRTYPE_WEIXIUOUT = "3";
	public static final String DYM_OPRTYPE_WEIXIUING = "4";
	public static final String DYM_OPRTYPE_WEIXIUIN = "5";
	public static final String DYM_OPRTYPE_WEIXIU_WF = "6";
	public static final String DYM_OPRTYPE_WEIXIU_BX = "7";
	/** �������豸��� */
	public static final String BACK_DEVTYPE_ZIYOU = "S0000";
	public static final String BACK_DEVTYPE_ZHENYUAN = "S0623";
	public static final String BACK_DEVTYPE_YIQI = "S1405";
	public static final String BACK_DEVTYPE_YIQI_FUSHU = "S14059999";
	public static final String BACK_DEVTYPE_CELIANG = "S1404";
	public static final String BACK_DEVTYPE_WAIZU = "S9999";
	public static final String BACK_DEVTYPE_JBQ = "S14050208";
	public static final String BACK_DEVTYPE_ZB_DZYQ = "S9000";
	public static final String BACK_DEVTYPE_DG_DZYQ = "S9001";
	public static final String BACK_DEVTYPE_SWAP = "S0001";
	/** ���������� 1:��������  2����������  3�������豸����   4:��������(�����ٴε���) */
	public static final String BACK_DEVTYPE_TOBACK = "1";
	public static final String BACK_DEVTYPE_TOREPAIR = "2";
	public static final String BACK_DEVTYPE_TOCHANGE = "3";
	public static final String BACK_DEVTYPE_TONOMIXBACK = "4";
	
	/** �Ӽ�̨���豸�볡   0:δ�볡  1�����볡  2���볡�� */
	public static final String DEV_LEAVING_NO = "0";
	public static final String DEV_LEAVING_YES = "1";
	public static final String DEV_LEAVING_MID = "2";
	
	/** �Ӽ�̨���豸ת�Ʊ�ʶ   2��ת����  */
	public static final String DEV_TRANSFER_STATE_MID = "2";
	
	/** ������Ŀ��ʶ  2:������Ŀ*/
	public static final String PROJECT_XN = "2";
	/** ������Ŀת�Ƶ���ʽ��Ŀ��gp_task_project����notes�ֶεĵı�ʶ */
	public static final String PROJECT_DELXN = "DELXN";
	/** ��Ϊ����ɾ��(����������Ŀת��ʽ��Ŀɾ��)������Ŀ��gp_task_project����notes�ֶεĵı�ʶ */
	public static final String PROJECT_DELXN_MAN = "MANDELXN";
	//½�ϵ�����Ŀ����
	public static final String TEAM_CELIANG = "0110000001000000001";
	public static final String TEAM_ZHENYUAN = "0110000001000000011";
	public static final String TEAM_YIQI = "0110000001000000018";
	//�ۺ��ﻯ̽��Ŀ����
	public static final String TEAM_ZH_CELIANG = "0110000001000004701";
	public static final String TEAM_ZH_YIQI = "0110000001000004601";
	//���Ŀ����
	public static final String TEAM_SH_YIQI = "0110000001001006201";
	
	/** ���ձ�ʶ */
	public static final String DEVRECEIVE_NO = "0";
	public static final String DEVRECEIVEING = "8";
	public static final String DEVRECEIVE = "1";
	/** �볡��ʶ */
	public static final String DEVLEAVING_NO = "0";
	public static final String DEVLEAVING_YES = "1";
	/** ά�޵������ */
	public static final String REPAIRTYPE_OUT = "1";
	public static final String REPAIRTYPE_IN = "2";
	/** �豸�����Ϣ(��ͣ) */
	public static final String OS_DANTAI = "1";
	public static final String OS_PILIANG = "2";
	/** �豸����״̬ */
	public static final String DEV_TECH_WANHAO = "0110000006000000001";
	public static final String DEV_TECH_DAIXIU = "0110000006000000006";
	public static final String DEV_TECH_DAIBAOFEI = "0110000006000000005";
	/** �豸ʹ��״̬ */
	public static final String DEV_USING_ZAIYONG = "0110000007000000001";
	public static final String DEV_USING_XIANZHI = "0110000007000000002";
	public static final String DEV_USING_TINGYONG = "0110000007000000003";
	public static final String DEV_USING_QITA = "0110000007000000006";
	/** �豸�ʲ�״̬ */
	public static final String DEV_ACCOUNT_BAOFEI = "0110000013000000001";
	public static final String DEV_ACCOUNT_CHUZHI = "0110000013000000002";
	public static final String DEV_ACCOUNT_ZAIZHANG = "0110000013000000003";
	public static final String DEV_ACCOUNT_HEBING = "0110000013000000004";
	public static final String DEV_ACCOUNT_WAIZU = "0110000013000000005";
	public static final String DEV_ACCOUNT_BUZAIZHANG = "0110000013000000006";
	/** ά�޹���״̬ ���ޡ����ޡ����㡢���*/
	public static final String DEV_REPAIR_STATUS_DAIXIU = "5110000225000000001";
	public static final String DEV_REPAIR_STATUS_ZAIXIU = "5110000225000000002";
	public static final String DEV_REPAIR_STATUS_WANCHENG = "5110000225000000003";
	public static final String DEV_REPAIR_STATUS_JIESUAN = "5110000225000000004";
	/** ά�޼���: 601������ 602��С�� 603������  604������ 605������  606������  
	 *  607��һ��ά������  608������ά������  609������ά������ 610�����ӹ�*/
	public static final String DEV_REPAIR_LEVEL_DAXIU = "601";
	public static final String DEV_REPAIR_LEVEL_XIAOXIU = "602";
	public static final String DEV_REPAIR_LEVEL_XIANGXIU = "603";
	public static final String DEV_REPAIR_LEVEL_JIGAI = "604";
	public static final String DEV_REPAIR_LEVEL_BAOYANG = "605";
	public static final String DEV_REPAIR_LEVEL_WUXIU = "606";
	public static final String DEV_REPAIR_LEVEL_YIJIBY = "607";
	public static final String DEV_REPAIR_LEVEL_ERJIBY = "608";
	public static final String DEV_REPAIR_LEVEL_SANJIBY = "609";
	public static final String DEV_REPAIR_LEVEL_JIJIAGONG = "610";
	/** ά������  ���ޡ����ޡ����ޡ����� */
	public static final String DEV_REPAIR_TYPE_ZIXIU = "0100400027000000003";
	public static final String DEV_REPAIR_TYPE_NEIXIU = "0100400027000000001";
	public static final String DEV_REPAIR_TYPE_WAIXIU = "0100400027000000002";
	public static final String DEV_REPAIR_TYPE_QITA = "0100400027000000004";
	/** ά�ޱ���������Դ  ������Դ  SAP:����SAP WTSC��ƽ̨¼��  YD�������ֳֻ�*/
	public static final String DEV_REPAIR_DATAFROM_SAP = "SAP";
	public static final String DEV_REPAIR_DATAFROM_YD = "YD";
	public static final String DEV_REPAIR_DATAFROM_WTSC = "WTSC";
	/** ά����Ŀ: 001�������� 002�������� 003���ֶ���  004��ǰ�� 005������  006������ 
	 *  007���������Ҽ�����  008����·  009��ɲ��ϵͳ 010����ѹ��
	 *  011���ཬ��  012������ͷ  013������  014��Һѹϵͳ  015����Ť���������
	 *  016���Ĵ�   017����̥   018����о   019��С��Ʒ   020�������Ǳ�   021������*/
	public static final String DEV_REPAIR_ITEM_FDJ = "001";
	public static final String DEV_REPAIR_ITEM_BSX = "002";
	public static final String DEV_REPAIR_ITEM_FDX = "003";
	public static final String DEV_REPAIR_ITEM_QQ = "004";
	public static final String DEV_REPAIR_ITEM_ZQ = "005";
	public static final String DEV_REPAIR_ITEM_HQ = "006";
	public static final String DEV_REPAIR_ITEM_CSXGJCJ = "007";
	public static final String DEV_REPAIR_ITEM_DL = "008";
	public static final String DEV_REPAIR_ITEM_SC = "009";
	public static final String DEV_REPAIR_ITEM_KYJ = "010";
	public static final String DEV_REPAIR_ITEM_NJB = "011";
	public static final String DEV_REPAIR_ITEM_DLT = "012";
	public static final String DEV_REPAIR_ITEM_JJ = "013";
	public static final String DEV_REPAIR_ITEM_YY = "014";
	public static final String DEV_REPAIR_ITEM_BNQLHQ = "015";
	public static final String DEV_REPAIR_ITEM_LD = "016";
	public static final String DEV_REPAIR_ITEM_LT = "017";
	public static final String DEV_REPAIR_ITEM_LX = "018";
	public static final String DEV_REPAIR_ITEM_XYP = "019";
	public static final String DEV_REPAIR_ITEM_YQYB = "020";
	public static final String DEV_REPAIR_ITEM_QT = "021";
	/** �����豸�ͷ������豸��ʶ */
	public static final String DEV_PRODUCTION_YES = "5110000186000000001";
	public static final String DEV_PRODUCTION_NO = "5110000186000000002";
	/**�豸����/�����ʶ**/
	public static final String DEV_IFCOUNTRY_GUONEI = "����";
	public static final String DEV_IFCOUNTRY_GUOWAI = "����";
	/** ��׼ʱ�� */
	public static final String DEV_FORMAT_DATE = "2006-01-01";
	/** �豸���޵�״̬ */
	public static final String DEV_REPAIR_BIANZHI = "0";
	public static final String DEV_REPAIR_SHENGXIAO = "1";
	public static final String DEV_REPAIR_ZUOFEI = "2";
	public static final String DEV_REPAIR_JUJIESHOU = "3";
	/** �������  ά�޵����� 0����ά��  1����ά�� */
	public static final String DEV_REPAIR_TYPE_IN = "0";
	public static final String DEV_REPAIR_TYPE_OUT = "1";
	/** �����豸���� ����״̬0�����ա�1������ɡ�2�ܽ���*/
	public static final String DEV_REPAIR_RECEIVE_DAIJIESHOU = "0";
	public static final String DEV_REPAIR_RECEIVE_YIJIESHOU = "1";
	public static final String DEV_REPAIR_RECEIVE_JUJIESHOU = "2";
	/** ����ά�� �ɹ���ϸ     ��Ч״̬  ����״̬ 0��Ч  1ʧЧ */
	public static final String DEV_REPAIR_DISPATCH_ENABLE = "0";
	public static final String DEV_REPAIR_DISPATCH_DISABLE = "1";
	/**����ά�� �ɹ�״̬ ASSIGNSTATE  0�����ɹ� 1���ɹ� **/
	public static final String DEV_REPAIR_ASSIGNSTATE0 = "0";
	public static final String DEV_REPAIR_ASSIGNSTATE1 = "1";
	/**����ά�� �ɹ�����״̬  RECIEVESTATE  0������ 1�ѽ��� 2�ܽ��� **/
	public static final String DEV_REPAIR_RECIEVESTATE0 = "0";
	public static final String DEV_REPAIR_RECIEVESTATE1 = "1";
	public static final String DEV_REPAIR_RECIEVESTATE2 = "2";
	/**����ά�� �ɹ��豸״̬  DEVSTATUS 0���� 1ά���� 2����� 3�޷�ά�� 4ά����� 5����ά��**/
	public static final String DEV_REPAIR_DEVSTATUS0 = "0";
	public static final String DEV_REPAIR_DEVSTATUS1 = "1";
	public static final String DEV_REPAIR_DEVSTATUS2 = "2";
	public static final String DEV_REPAIR_DEVSTATUS3 = "3";
	public static final String DEV_REPAIR_DEVSTATUS4 = "4";
	public static final String DEV_REPAIR_DEVSTATUS5 = "5";
	/**����ά�� �ɹ�ά��״̬  REPAIRSTATE 0���� 1ά���� 2����� 3�޷�ά�� 4ά����� 5����ά��**/
	public static final String DEV_REPAIR_REPAIRSTATE0 = "0";
	public static final String DEV_REPAIR_REPAIRSTATE1 = "1";
	public static final String DEV_REPAIR_REPAIRSTATE2 = "2";
	public static final String DEV_REPAIR_REPAIRSTATE3 = "3";
	public static final String DEV_REPAIR_REPAIRSTATE4 = "4";
	public static final String DEV_REPAIR_REPAIRSTATE5 = "5";
	/***decode  key**/
	public static final String DECODE_KEY_ERRORTYPE = "errortype";
	public static final String DECODE_KEY_DEVSTATUS = "devstatus";
	public static final String DECODE_KEY_CURRENCY = "currency";
	public static final String DECODE_KEY_ERRORDESC = "errordesc";
	public static final String DECODE_KEY_REPAIRSTATUS = "repairstatus";
	
	/**RFID�豸��̬����**/
	/**�������**/
	public static final String RFID_DEV_DYM_OUT_TYPE_TPCK = "0";
	/**����ά�޳���**/
	public static final String RFID_DEV_DYM_OUT_TYPE_SNWX = "1";
	/**����ά�޳���**/
	public static final String RFID_DEV_DYM_OUT_TYPE_SWWX = "2";
	/**ת�Ƴ���**/
	public static final String RFID_DEV_DYM_OUT_TYPE_ZYCK = "3";
	/**���޳���**/
	public static final String RFID_DEV_DYM_OUT_TYPE_DXCK = "4";
	/**�������**/
	public static final String RFID_DEV_DYM_IN_TYPE_TPRK = "0";
	/**����ά�����**/
	public static final String RFID_DEV_DYM_IN_TYPE_SNWX = "1";
	/**����ά�����**/
	public static final String RFID_DEV_DYM_IN_TYPE_SWWX = "2";
	/**ת�����**/
	public static final String RFID_DEV_DYM_IN_TYPE_ZYCK = "3";
	/**ά�޷������**/
	public static final String RFID_DEV_DYM_IN_TYPE_WXFH = "4";
	
	/**DMS����ʱ���**/
	public static final String DMS_ASSESS_PERFECT_RATE = "5110000191000000001";
	/**DMS�����ʱ���**/
	public static final String DMS_ASSESS_USE_RATE = "5110000191000000002";
	/**DMS����ָ�길����**/
	public static final String DMS_ASSESS_FATHER_CODE = "5110000191";
	/**DMS���˹��ڱ�ʶ����**/
	public static final String DMS_ASSESS_INCOUNTRY = "5110000195000000001";
	/**DMS���˹����ʶ����**/
	public static final String DMS_ASSESS_OUTCOUNTRY = "5110000195000000002";
	
	/**DMS����ģ������:��̽��**/
	public static final String DMS_ASSESS_MODEL_TYPE_WTC = "5110000198000000004";
	/**DMS����ģ������:װ������**/
	public static final String DMS_ASSESS_MODEL_TYPE_ZB = "5110000198000000005";
	/**DMSҪ����˸�����**/
	public static final String DMS_ASSESS_PLAT_FATHER_CODE = "5110000198";
	/**DMSҪ����˼������**/
	public static final String DMS_ASSESS_PLAT_LEVEL_0 = "0";
	/**DMSҪ����˼������**/
	public static final String DMS_ASSESS_PLAT_NOTE_R = "R";
	/**DMSҪ����˼������**/
	public static final String DMS_ASSESS_PLAT_NOTE_S = "S";
	
	/**DMS��ҳ������̽������-����ľ��̽��**/
	public static final String DMS_INDICATORE_TLMWTC_CODE = "tlmwtc";
	public static final String DMS_INDICATORE_TLMWTC_SUB_ID = "C105001005";
	public static final String DMS_INDICATORE_TLMWTC_ORG_ID = "C6000000000010";
	/**DMS��ҳ������̽������-�½���̽��**/
	public static final String DMS_INDICATORE_XJWTC_CODE = "xjwtc";
	public static final String DMS_INDICATORE_XJWTC_SUB_ID = "C105001002";
	public static final String DMS_INDICATORE_XJWTC_ORG_ID = "C6000000000011";
	/**DMS��ҳ������̽������-�¹���̽��**/
	public static final String DMS_INDICATORE_THWTC_CODE = "thwtc";
	public static final String DMS_INDICATORE_THWTC_SUB_ID = "C105001003";
	public static final String DMS_INDICATORE_THWTC_ORG_ID = "C6000000000013";
	/**DMS��ҳ������̽������-�ຣ��̽��**/
	public static final String DMS_INDICATORE_QHWTC_CODE = "qhwtc";
	public static final String DMS_INDICATORE_QHWTC_SUB_ID = "C105001004";
	public static final String DMS_INDICATORE_QHWTC_ORG_ID = "C6000000000012";
	/**DMS��ҳ������̽������-������̽��**/
	public static final String DMS_INDICATORE_CQWTC_CODE = "cqwtc";
	public static final String DMS_INDICATORE_CQWTC_SUB_ID = "C105005004";
	public static final String DMS_INDICATORE_CQWTC_ORG_ID = "C6000000000045";
	/**DMS��ҳ������̽������-���̽��**/
	public static final String DMS_INDICATORE_DGWTC_CODE = "dgwtc";
	public static final String DMS_INDICATORE_DGWTC_SUB_ID = "C105007";
	public static final String DMS_INDICATORE_DGWTC_ORG_ID = "C6000000000008";
	/**DMS��ҳ������̽������-�ɺ���̽��**/
	public static final String DMS_INDICATORE_LHWTC_CODE = "lhwtc";
	public static final String DMS_INDICATORE_LHWTC_SUB_ID = "C105063";
	public static final String DMS_INDICATORE_LHWTC_ORG_ID = "C6000000001888";
	/**DMS��ҳ������̽������-������̽��**/
	public static final String DMS_INDICATORE_HBWTC_CODE = "hbwtc";
	public static final String DMS_INDICATORE_HBWTC_SUB_ID = "C105005000";
	public static final String DMS_INDICATORE_HBWTC_ORG_ID = "C0000000000232";
	/**DMS��ҳ������̽������-������̽������**/
	public static final String DMS_INDICATORE_XXWTKFC_CODE = "xxwtkfc";
	public static final String DMS_INDICATORE_XXWTKFC_SUB_ID = "C105005001";
	public static final String DMS_INDICATORE_XXWTKFC_ORG_ID = "C6000000000060";
	/**DMS��ҳ������̽������-�ۺ��ﻯ̽��**/
	public static final String DMS_INDICATORE_ZHWHTC_CODE = "zhwhtc";
	public static final String DMS_INDICATORE_ZHWHTC_SUB_ID = "C105008";
	public static final String DMS_INDICATORE_ZHWHTC_ORG_ID = "C6000000000009";
	/**DMS��ҳ������̽������-������̽��**/
	public static final String DMS_INDICATORE_XNWTC_CODE = "xnwtc";
	public static final String DMS_INDICATORE_XNWTC_SUB_ID = "C105087";
	public static final String DMS_INDICATORE_XNWTC_ORG_ID = "C6000000008010";
	/**DMS��ҳ������̽������-������̽һ��˾**/
	public static final String DMS_INDICATORE_DQYGS_CODE = "dqygs";
	public static final String DMS_INDICATORE_DQYGS_SUB_ID = "C105092";
	public static final String DMS_INDICATORE_DQYGS_ORG_ID = "C6000000008170";
	/**DMS��ҳ������̽������-������̽����˾**/
	public static final String DMS_INDICATORE_DQEGS_CODE = "dqegs";
	public static final String DMS_INDICATORE_DQEGS_SUB_ID = "C105093";
	public static final String DMS_INDICATORE_DQEGS_ORG_ID = "C6000000008171";
	/**DMS��ҳ������̽������-װ������**/
	public static final String DMS_INDICATORE_ZBFWC_CODE = "zbfwc";
	public static final String DMS_INDICATORE_ZBFWC_SUB_ID = "C105006";
	public static final String DMS_INDICATORE_ZBFWC_ORG_ID = "C6000000000007";
	/**DMS��ҳ������̽������-���ʿ�̽��ҵ��**/
	public static final String DMS_INDICATORE_GJKTSYB_CODE = "gjktsyb";
	public static final String DMS_INDICATORE_GJKTSYB_SUB_ID = "C105002";
	public static final String DMS_INDICATORE_GJKTSYB_ORG_ID = "C6000000000003";
	/**DMS��ҳ������̽������-���̽��**/
	public static final String DMS_INDICATORE_SHWTC_CODE = "shwtc";
	public static final String DMS_INDICATORE_SHWTC_SUB_ID = "C105086";
	public static final String DMS_INDICATORE_SHWTC_ORG_ID = "C0000000000234";
	
	/**DMS��ҳ����װ�����񴦱���-������������**/
	public static final String DMS_INDICATORE_YQFWZX_CODE = "yqfwzx";
	public static final String DMS_INDICATORE_YQFWZX_SUB_ID = "C105006002";
	public static final String DMS_INDICATORE_YQFWZX_ORG_ID = "C6000000000042";
	/**DMS��ҳ������̽������-������������**/
	public static final String DMS_INDICATORE_CLFWZX_CODE = "clfwzx";
	public static final String DMS_INDICATORE_CLFWZX_SUB_ID = "C105006001";
	public static final String DMS_INDICATORE_CLFWZX_ORG_ID = "C6000000000041";
	/**DMS��ҳ������̽������-��Դ��������**/
	public static final String DMS_INDICATORE_ZYFWZX_CODE = "zyfwzx";
	public static final String DMS_INDICATORE_ZYFWZX_SUB_ID = "C105006003";
	public static final String DMS_INDICATORE_ZYFWZX_ORG_ID = "C6000000000043";
	/**DMS��ҳ������̽������-������ҵ��**/
	public static final String DMS_INDICATORE_BJZYB_CODE = "bjzyb";
	public static final String DMS_INDICATORE_BJZYB_SUB_ID = "C105006005";
	public static final String DMS_INDICATORE_BJZYB_ORG_ID = "C6000000005538";
	/**DMS��ҳ������̽������-�ػ���ҵ��**/
	public static final String DMS_INDICATORE_DHZYB_CODE = "dhzyb";
	public static final String DMS_INDICATORE_DHZYB_SUB_ID = "C105006006";
	public static final String DMS_INDICATORE_DHZYB_ORG_ID = "C6000000005543";
	/**DMS��ҳ������̽������-������ҵ��**/
	public static final String DMS_INDICATORE_HBZYB_CODE = "hbzyb";
	public static final String DMS_INDICATORE_HBZYB_SUB_ID = "C105006007";
	public static final String DMS_INDICATORE_HBZYB_ORG_ID = "C6000000005547";
	/**DMS��ҳ������̽������-�ɺ���ҵ��**/
	public static final String DMS_INDICATORE_LHZYB_CODE = "lhzyb";
	public static final String DMS_INDICATORE_LHZYB_SUB_ID = "C105006029";
	public static final String DMS_INDICATORE_LHZYB_ORG_ID = "C6000000007537";
	/**DMS��ҳ������̽������-����ľ��ҵ��**/
	public static final String DMS_INDICATORE_TLMZYB_CODE = "tlmzyb";
	public static final String DMS_INDICATORE_TLMZYB_SUB_ID = "C105006008";
	public static final String DMS_INDICATORE_TLMZYB_ORG_ID = "C6000000005551";
	/**DMS��ҳ������̽������-�¹���ҵ��**/
	public static final String DMS_INDICATORE_THZYB_CODE = "thzyb";
	public static final String DMS_INDICATORE_THZYB_SUB_ID = "C105006009";
	public static final String DMS_INDICATORE_THZYB_ORG_ID = "C6000000005555";
	/**DMS��ҳ������̽������-������ҵ��**/
	public static final String DMS_INDICATORE_XQZYB_CODE = "xqzyb";
	public static final String DMS_INDICATORE_XQZYB_SUB_ID = "C105006011";
	public static final String DMS_INDICATORE_XQZYB_ORG_ID = "C6000000005560";
	/**DMS��ҳ������̽������-������ҵ��**/
	public static final String DMS_INDICATORE_CQZYB_CODE = "cqzyb";
	public static final String DMS_INDICATORE_CQZYB_SUB_ID = "C105006004";
	public static final String DMS_INDICATORE_CQZYB_ORG_ID = "C6000000005534";
	
	/**DMS��ҳ����ӿ�����ϸ����-��������**/
	public static final String DMS_INDICATORE_KGYS_CODE = "kgys";
	public static final String DMS_INDICATORE_KGYS_DET_ID = "239EE8BC11C6967BE050580A80F80D22";
	/**DMS��ҳ����ӿ�����ϸ����-��������**/
	public static final String DMS_INDICATORE_BYGL_CODE = "bygl";
	public static final String DMS_INDICATORE_BYGL_DET_ID = "239EE8BC11C6967BE050580A80F80D25";
	/**DMS��ҳ����ӿ�����ϸ����-�豸����**/
	public static final String DMS_INDICATORE_SBKQ_CODE = "sbkq";
	public static final String DMS_INDICATORE_SBKQ_DET_ID = "239EE8BC11C6967BE050580A80F80D26";
	/**DMS��ҳ����ӿ�����ϸ����-���˶���**/
	public static final String DMS_INDICATORE_DRDJ_CODE = "drdj";
	public static final String DMS_INDICATORE_DRDJ_DET_ID = "239EE8BC11C6967BE050580A80F80D27";
	/**DMS��ҳ����ӿ�����ϸ����-��ת��¼**/
	public static final String DMS_INDICATORE_YZJL_CODE = "yzjl";
	public static final String DMS_INDICATORE_YZJL_DET_ID = "239EE8BC11C6967BE050580A80F80D30";
	/**DMS��ҳ����ӿ�����ϸ����-�豸����**/
	public static final String DMS_INDICATORE_SBFH_CODE = "sbfh";
	public static final String DMS_INDICATORE_SBFH_DET_ID = "239EE8BC11C6967BE050580A80F80D23";
	/**DMS��ҳ����ӿ�����ϸ����-�չ�����**/
	public static final String DMS_INDICATORE_SGYS_CODE = "sgys";
	public static final String DMS_INDICATORE_SGYS_DET_ID = "239EE8BC11C6967BE050580A80F80D24";
	/**DMS��ҳ����ӿ�����ϸ����-�����豸����**/
	public static final String DMS_INDICATORE_TZSBGL_CODE = "tzsbgl";
	public static final String DMS_INDICATORE_TZSBGL_DET_ID = "239EE8BC11C6967BE050580A80F80D33";
	/**DMS��ҳ����ӿ�����ϸ����-���������̿�**/
	public static final String DMS_INDICATORE_DZYQPK_CODE = "dzyqpk";
	public static final String DMS_INDICATORE_DZYQPK_DET_ID = "239EE8BC11C6967BE050580A80F80E34";
	/**DMS��ҳ����ӿ�����ϸ����-������������**/
	public static final String DMS_INDICATORE_DZYQHS_CODE = "dzyqhs";
	public static final String DMS_INDICATORE_DZYQHS_DET_ID = "239EE8BC11C6967BE050580A80F80E35";
	/**DMS�豸��ϵϵͳ��¼��־ϵͳ��ʶ**/
	public static final String LOG_LOGIN_SYS_DMS = "DMS";
	/**GMS��Ŀ����ϵͳ��¼��־ϵͳ��ʶ**/
	public static final String LOG_LOGIN_SYS_GMS = "GMS";
	/**ϵͳ��¼��־:ϵͳ��¼���� PC�˵�½**/
	public static final String LOG_LOGIN_TYPE_PC = "PC";
	/**ϵͳ��¼��־:ϵͳ��¼���� ���Ŷ˵�½**/
	public static final String LOG_LOGIN_TYPE_RX = "RX";
	/**ϵͳ��¼��־:ϵͳ��¼����**/
	public static final String LOG_LOGIN_DESC = "��¼";
	/**���������ֱ�־:��Ŀ����ϵͳģ��coding_sort_id(����������Ŀ����ϵͳ���豸��ϵϵͳ)**/
	public static final String WORK_FLOW_CODE_GMS = "5110000004";
	/**���������ֱ�־:�豸��ϵϵͳģ��coding_sort_id(����������Ŀ����ϵͳ���豸��ϵϵͳ)**/
	public static final String WORK_FLOW_CODE_DMS = "5110000181";
}
