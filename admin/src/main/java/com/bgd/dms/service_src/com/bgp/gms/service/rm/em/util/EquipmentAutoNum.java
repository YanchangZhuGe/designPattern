package com.bgp.gms.service.rm.em.util;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;


/*
 * author:���챪
 * 
 * date;2010-8-6
 * 
 * ���������豸���
 * 
 * �޸ģ�2010/8/29 �޸�ȥ������ͷ��λ
 */
public class EquipmentAutoNum {

	// ҵ������SXQ-�豸����
	// ;DB-����;TP-;����;CK-����;RK-���;SX-����;WX-ά�ޣ�RQMN��Ա���;PSQ��ͨ�豸����;PTP��ͨ�豸����
	// TSQ�豸����
	// RPSQ ��ͨ����
	// RPTP ��ͨ����
	// RJSQ ��������
	// RJTP ��������
	// ORSQ ��������
	// ESQ �����豸����
	// ETP �����豸����
	private static final String[] operTypeArray = { "SXQ", "DB", "TP", "CK", "RK", "SX", "WX", "RPSQ", "PSQ", "PTP", "RPTP", "TSQ", "TTP",
			"RJSQ", "RJTP", "RZSQ", "RZTP", "TDCK", "ORSQ", "ORDSQ", "ESQ","ETP","ECK","RPJH","RGCB","RYPX","RYBB" };
	// ҵ�����Ͷ�Ӧ�ı���
	private static final String[] operTypeTable = { "BGP_COMM_DEVICE_APPLY_INFO", "BGP_COMM_EQUIP_APPLY_INFO",
			"BGP_COMM_EQUIP_DISPATCH_INFO", "BGP_COMM_EQUIP_WAREHOUSE_INFO", "BGP_COMM_EQUIP_WAREHOUSE_INFO", "BGP_COMM_EQUIP_APPLY_INFO",
			"BGP_COMM_DEVICE_APPLY_INFO", "BGP_PROJECT_HUMAN_REQUIREMENT", "BGP_COMM_DEVICE_APPLY_INFO ", "BGP_COMM_EQUIP_DISPATCH_INFO",
			"BGP_HUMAN_PREPARE", "BGP_COMM_DEVICE_TRANS_INFO", "BGP_COMM_EQUIP_DISPATCH_INFO", "BGP_PROJECT_HUMAN_RELIEF",
			"BGP_HUMAN_PREPARE", "BGP_PROJECT_HUMAN_PROFESS", "BGP_HUMAN_PREPARE", "BGP_COMM_DEVICE_DET_WH_INFO",
			"BGP_COMM_DEVICE_APPLY_INFO_R", "BGP_COMM_DEVICE_DET_APP_INFO", "BGP_COMM_DEVICE_RETURN_INFO","BGP_COMM_EQU_RE_DISP_INFO"
			,"BGP_COMM_EQU_RE_WARE_INFO","bgp_comm_human_plan","bgp_comm_human_plan_cost","BGP_COMM_HUMAN_TRAINING_PLAN","bgp_comm_human_costreport"};
	// ҵ����������Ӧ���ֶ���
	private static final String[] operTypeField = { "APPLY_NO", "APPLY_NO", "DISPATCH_NO", "WAREHOUSE_NO", "WAREHOUSE_NO", "APPLY_NO",
			"APPLY_NO", "APPLY_NO", "APPLY_NO", "DISPATCH_NO", "PREPARE_ID", "APPLY_NO", "DISPATCH_NO", "APPLY_NO", "PREPARE_ID",
			"APPLY_NO", "PREPARE_ID", "WAREHOUSE_NO", "APPLY_NO", "APPLY_NO", "RETURN_NO","REDISP_NO","RE_WAREHOUSE_NO","PLAN_NO","PLAN_NO",
			"PLAN_NUMBER","REPORT_NO"};

	/*
	 * ��ȡ���ݺ�
	 * 
	 * ���������userName �û���, orgName ������֯����, operType ҵ������SXQ-�豸����
	 * ;DB-����;TP-;����;CK-����;RK-���;SX-����;WX-ά��
	 * 
	 * ���:���ݺ�
	 */
	public static String generateNumberByUserInfo(String userName, String orgName, String operType) {
		UserToken user = new UserToken();
		user.setUserName(userName);
		user.setOrgName(orgName);
		return generateNumberByUserToken(user, operType);
	}

	/*
	 * ��ȡ���ݺ�
	 * 
	 * ���������userName �û���, orgName ������֯����, operType ҵ������SXQ-�豸����
	 * ;DB-����;TP-;����;CK-����;RK-���;SX-����;WX-ά��,date ��������
	 * 
	 * ���:���ݺ�
	 */
	public static String generateNumberByUserInfo(String userName, String orgName, String operType, String operUserDate) {
		UserToken user = new UserToken();
		user.setUserName(userName);
		user.setOrgName(orgName);
		return generateNumberByUserToken(user, operType, operUserDate);
	}

	/*
	 * ��ȡ���ݺ�
	 * 
	 * ���������UserToken user ����û��ĸ�����Ϣ����֯�ṹ,String operType ҵ������SXQ-�豸����
	 * ;DB-����;TP-;����;CK-����;RK-���;SX-����;WX-ά��
	 * 
	 * ���:���ݺ�
	 */

	public static String generateNumberByUserToken(UserToken user, String operType, String operUserDate) {

		String reNumber = "";
		String departmentType = "";
		String orgId = user.getOrgId();
		String orgSql = "select replace(replace(t.org_abbreviation,'����',''),'��','') org_name from comm_org_information t where t.org_id='"
				+ orgId + "'";
		String orgName = (String) (BeanFactory.getQueryJdbcDAO().queryRecordBySQL(orgSql).get("orgName"));
		departmentType = orgName;

		if ("PSQ".equals(operType) || "PTP".equals(operType) || "TSQ".equals(operType)||"ESQ".equals(operType)||"ETP".equals(operType)) {
			String L1, L2, L3, L4;
			L1 = "";
			if ("PSQ".equals(operType))
				L1 = "S";
			if ("ESQ".equals(operType))
				L1 = "B";
			if ("PTP".equals(operType))
				L1 = "D";
			if ("TSQ".equals(operType))
				L1 = "T";
			if ("TTP".equals(operType))
				L1 = "J";
			if ("ETP".equals(operType))
				L1 = "D";
			L2 = operUserDate;
			String serialNumber = "001";
			L3 = HanziConvertUtil.hanziToFirstPinYin(departmentType);
			reNumber = L1 + L2 + L3;
			serialNumber = calSerialNumberByOperType(operType, reNumber);
			L4 = serialNumber;
			reNumber += L4;
			return reNumber;
		}  else if ("ORSQ".equals(operType) || "ORDSQ".equals(operType)) {
			String L1 = orgName;
			String L2 = String.valueOf(Calendar.getInstance().get(Calendar.YEAR));
			reNumber = L1 + L2;
			String L3 = calSerialNumberByOperType(operType, reNumber);
			return L1 + L2 + L3;
		} else {
			String divisionType = "Z";

			String operUserName = "";
			String serialNumber = "001";

			reNumber = "";

			operUserName = user.getUserName();

			String L1, L2, L3, L4, L5, L6;

			if ("RPSQ".equals(operType) || "RPTP".equals(operType) || "RJSQ".equals(operType) || "RJTP".equals(operType)
					|| "RZSQ".equals(operType) || "RZTP".equals(operType) || "RPJH".equals(operType) || "RGCB".equals(operType)
					|| "RYPX".equals(operType) || "RYBB".equals(operType)) {
				L1 = "H";
				L2 = "";
				if ("RPSQ".equals(operType)) {
					L2 = "A";
				} else if ("RPTP".equals(operType)) {
					L2 = "D";
				} else if ("RJSQ".equals(operType)) {
					L2 = "R";
				} else if ("RJTP".equals(operType)) {
					L2 = "P";
				} else if ("RZSQ".equals(operType)) {
					L2 = "Z";
				} else if ("RZTP".equals(operType)) {
					L2 = "Y";
				} else if ("RPJH".equals(operType)) {
					L2 = "P";
				} else if ("RGCB".equals(operType)) {
					L2 = "C";
				} else if ("RYPX".equals(operType)) {
					L2 = "T";
				} else if ("RYBB".equals(operType)) {
					L2 = "B";
				}
				L3 = operUserDate.substring(2, 4);

				departmentType=departmentType.replaceAll("��","");
				departmentType=departmentType.replaceAll("��","");

				String orgCode = HanziConvertUtil.hanziToFirstPinYin(departmentType);
				if (orgCode != null && orgCode.length() > 2) {
					orgCode = orgCode.substring(0, 3);
				}

				L4 = orgCode;
				reNumber = L1 + L2 + L4 + L3;
				L5 = calSerialNumberByOperType(operType, reNumber);
				return L1 + L2 + L4 + L3 + L5;
			} else {
				L1 = divisionType;
				String orgCode = HanziConvertUtil.hanziToFirstPinYin(departmentType);
				if (!"SXQ".equals(operType) && !"PXQ".equals(operType)) {
					if (orgCode != null && orgCode.length() > 3) {
						orgCode = orgCode.substring(0, 3);
					}
				}
				L2 = orgCode;
				String userCode = HanziConvertUtil.hanziToFirstPinYin(operUserName);
				if (userCode != null && userCode.length() > 3) {
					userCode = userCode.substring(0, 3);
				}
				L3 = userCode;
				L4 = operUserDate;
				L5 = operType;
				reNumber = L1 + L2 + L3 + L4 + L5;
				serialNumber = calSerialNumberByOperType(operType, reNumber);
				L6 = serialNumber;
				reNumber += L6;
				return reNumber;
			}
		}

	}

	/*
	 * ��ȡ���ݺ�
	 * 
	 * ���������UserToken user ����û��ĸ�����Ϣ����֯�ṹ,String operType ҵ������SXQ-�豸����
	 * ;DB-����;TP-;����;CK-����;RK-���;SX-����;WX-ά��
	 * 
	 * ��������Ĭ��ȡ��ǰ����
	 * 
	 * ���:���ݺ�
	 */
	public static String generateNumberByUserToken(UserToken user, String operType) {

		String operUserDate = "";
		operUserDate = new SimpleDateFormat("yyyyMMdd").format(new Date());
		return generateNumberByUserToken(user, operType, operUserDate);
	}

	/*
	 * ���ݲ���ҵ�����ͼ�ǰ���ֶ�������ˮ�ţ��̰߳�ȫ��,��֤ͬһҵ��ͬʱ����ʱ��ˮ�Ų����ͻ
	 */
	private synchronized static String calSerialNumberByOperType(String operType, String reNumber) {
		String serialNumber = null;
		String tableName = null;
		String tableField = null;

		for (int i = 0; operType != null && i < operTypeArray.length; i++) {
			if (operType.equals(operTypeArray[i])) {
				tableName = operTypeTable[i];
				tableField = operTypeField[i];
				String sql = "select max(distinct(" + tableField + ")) max_serial_number from " + tableName + " where   " + tableField
						+ " like '" + reNumber + "%'";
				if ("TP".equals(operType)) {
					sql += " and function_type = '2'";
				}
				if ("PTP".equals(operType)) {
					sql += " and function_type = '1'";
				}
				if ("RPTP".equals(operType)) {
					sql += " and requirement_no is not null ";
				}
				if ("RJTP".equals(operType)) {
					sql += " and human_relief_no is not null ";
				}
				if ("RZTP".equals(operType)) {
					sql += " and profess_no is not null ";
				}
				if ("RZSQ".equals(operType)) {
					// sql += " and proflag = '1'";
				}
				if ("RPSQ".equals(operType)) {
					sql += " and proflag = '0'";
				}
				String maxSerialNumber = (String) (BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql).get("maxSerialNumber"));
				int frontNum = reNumber.length();
				if (maxSerialNumber == null || "".equals(maxSerialNumber)) {
					serialNumber = "001";
				} else {
					serialNumber = String.valueOf((Integer.parseInt(maxSerialNumber.substring(frontNum)) + 1));
				}
				break;
			}
		}
		for (int i = 3; i > serialNumber.length();) {
			serialNumber = "0" + serialNumber;
		}
		return serialNumber;
	}

	public static void main(String[] args) {
		UserToken user = new UserToken();
		user.setUserName("��С");
		user.setOrgName("�¹�����");
		user.setOrgId("C4000000000451");

	}
}
