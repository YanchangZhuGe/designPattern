package com.cnpc.sais.ibp.auth.util;

import com.cnpc.jcdp.util.AppCrypt;

/**
 * Project£∫CNLC OMS(Service)
 * 
 * Creator£∫rechete
 * 
 * Creator Time:2008-4-28 …œŒÁ10:17:47
 * 
 * Description£∫
 * 
 * Revision history£∫
 * 
 * 
 * 
 */
public class PasswordUtil {
	/**
	 * º”√‹
	 * @param value
	 * @return
	 */
	public static String encrypt(String value){
		return AppCrypt.encrypt(value);
	}
	
	/**
	 * Ω‚√‹
	 * @param value
	 * @return
	 */
	public static String decrypt(String value){
		return value;
	}
}
