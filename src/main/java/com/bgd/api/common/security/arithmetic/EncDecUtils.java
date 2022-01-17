package com.bgd.api.common.security.arithmetic;


import com.bgd.platform.util.common.StringEncDec;
import com.bgd.platform.util.common.StringTool;
import com.bgd.platform.util.sm2.SM2Util;

public class EncDecUtils {
	
	/**
	 * 根据传输过来的加密算法以及密钥加密字符串
	 * @param enc_key 加密密钥
	 * @param enc_sf 加密算法
	 * @param str 需被加密的字符串
	 * @return
	 * @throws Exception
	 */
	public static String getEncString(String enc_key, String enc_sf, String str) {
		String encStr = "";
		if (!StringTool.isNull(str)) {
			if ("AES".equals(enc_sf)) {// AES加密
				encStr = StringEncDec.getEncryptEncode(str, enc_key);
			} else if ("SM2".equals(enc_sf)) {
				SM2Util sm2Util = new SM2Util();
				encStr = sm2Util.encrypt(str, enc_key);
			}
		}
		return encStr;
	}

	/**
	 * 根据传输过来的加密算法以及密钥解密字符串
	 * @param dec_key 解密密钥
	 * @param enc_sf 加密算法
	 * @param encStr 需被解密的字符串
	 * @return
	 */
	public static String getDecString(String dec_key, String enc_sf, String encStr) {
		String decStr = "";
		if (!StringTool.isNull(encStr)) {
			if ("AES".equals(enc_sf)) {// AES解密
				decStr = StringEncDec.getDecryptEncode(encStr, dec_key);
			} else if ("SM2".equals(enc_sf)) {
				SM2Util sm2Util = new SM2Util();
				decStr = sm2Util.decrypt(encStr, dec_key);
			}
		}
		return decStr;
	}
	
}
