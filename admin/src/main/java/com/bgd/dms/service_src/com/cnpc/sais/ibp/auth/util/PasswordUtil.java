package com.cnpc.sais.ibp.auth.util;

import com.cnpc.jcdp.util.AppCrypt;

/**
 * Project��CNLC OMS(Service)
 * 
 * Creator��rechete
 * 
 * Creator Time:2008-4-28 ����10:17:47
 * 
 * Description��
 * 
 * Revision history��
 * 
 * 
 * 
 */
public class PasswordUtil {
	/**
	 * ����
	 * @param value
	 * @return
	 */
	public static String encrypt(String value){
		return AppCrypt.encrypt(value);
	}
	
	/**
	 * ����
	 * @param value
	 * @return
	 */
	public static String decrypt(String value){
		return value;
	}
}
