package com.cnpc.jcdp.webapp.util;

import java.io.IOException;
import java.io.UnsupportedEncodingException;

import org.apache.commons.codec.binary.Base64;


public class Base64Util {

	public static String encodeStr(String src) throws UnsupportedEncodingException {
		Base64 encoder = new Base64();
		return new String(encoder.encodeBase64(src.getBytes("UTF-8")),"UTF-8");
	}
	
	public static String decodeStr(String src){
		Base64 decoder = new Base64();
		String re = "";
		try {
			re = new String(decoder.decodeBase64(src.getBytes("UTF-8")),"UTF-8");
		} catch (IOException e) {
			e.printStackTrace();
		}
		return re;
	}
	
	public static void main(String[] args) throws UnsupportedEncodingException {
		System.out.println(EscapeUtils.escape(encodeStr("1")));
		System.out.println("----------------");
		System.out.println("c3VwZXJhcZG1pcbg==".replace("c", "+"));
		System.out.println(EscapeUtils.unescape("c3VwZXJhZG1pbg=="));
		System.out.println(decodeStr("5piv5p2O56i76JG15aes5Y+R"));
		System.out.println("----------------");
		String s = "superadmin";
		System.out.println(encodeStr(s));
		System.out.println(EscapeUtils.escape(encodeStr(s)));
		System.out.println("----------------");
		System.out.println(EscapeUtils.unescape("5piv5p2O56i76JG15aes5Y%2BR"));
		System.out.println("----------------");
		System.out.println(Base64Util.decodeStr(EscapeUtils.unescape(EscapeUtils.escape(encodeStr(s)))));
	}
}
