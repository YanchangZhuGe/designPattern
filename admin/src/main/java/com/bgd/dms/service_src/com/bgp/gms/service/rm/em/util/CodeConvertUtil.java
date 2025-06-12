package com.bgp.gms.service.rm.em.util;

/*
 * author:���챪
 * 
 * date:2010-8-5
 * 
 * ����:������,��λ��,���ֻ�������໥ת��
 * 
 */
public class CodeConvertUtil {

	//private static final String gbRule = "GB2312";

	private static final int GB_SP_DIFF = 160;

	/*
	 * ������ת��Ϊ��λ��
	 * 
	 * ����:������ֳ������ֽ�,�ֱ��ȥ160,ת��Ϊ10���Ƽ�Ϊ��λ��
	 */
	public static String gbCodeToZoneCode(byte[] gbCode) {

		String zoneCode = null;
		gbCode[0] -= GB_SP_DIFF;
		gbCode[1] -= GB_SP_DIFF;
		zoneCode = String.valueOf(gbCode[0] * 100 + gbCode[1]);
		return zoneCode;
	}

	/*
	 * ��λ��ת��Ϊ������
	 */
	public static String zoneCodeToGbCode(String zoneCode) {

		String gbCode = "";
		byte[] bytes = new byte[2];
		String lowCode = zoneCode.substring(0, 2);
		String highCode = zoneCode.substring(2, 4);
		bytes[0] = (byte) (Integer.parseInt(lowCode) + 160);
		bytes[1] = (byte) (Integer.parseInt(highCode) + 160);
		String chara = new String(bytes);
		gbCode += chara;
		return gbCode;
	}
	
	
}
