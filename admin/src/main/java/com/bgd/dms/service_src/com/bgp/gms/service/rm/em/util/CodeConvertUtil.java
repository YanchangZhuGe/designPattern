package com.bgp.gms.service.rm.em.util;

/*
 * author:邱庆豹
 * 
 * date:2010-8-5
 * 
 * 描述:国标码,区位码,汉字机内码的相互转换
 * 
 */
public class CodeConvertUtil {

	//private static final String gbRule = "GB2312";

	private static final int GB_SP_DIFF = 160;

	/*
	 * 国标码转换为区位码
	 * 
	 * 规则:国标码分成两个字节,分别减去160,转化为10进制即为区位码
	 */
	public static String gbCodeToZoneCode(byte[] gbCode) {

		String zoneCode = null;
		gbCode[0] -= GB_SP_DIFF;
		gbCode[1] -= GB_SP_DIFF;
		zoneCode = String.valueOf(gbCode[0] * 100 + gbCode[1]);
		return zoneCode;
	}

	/*
	 * 区位码转换为国标码
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
