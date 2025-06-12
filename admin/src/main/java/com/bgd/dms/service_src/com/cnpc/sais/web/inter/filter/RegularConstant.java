package com.cnpc.sais.web.inter.filter;

public class RegularConstant {
	//public static final String IMG_REGULAR = "src=\\s*\"*[\\.\\.\\/]*(images)\\/\\w*\\.[gif|jpg|png]{1}\\s*";
	//public static final String CSS_REGULAR = "href=\\s*\"*\\/[\\w*/]+(css)\\/\\w*\\.css\\s*\"";
	
	
	public static final String[] IMG_REGULAR = {"src=.*images/(JCDP_SAIS_IMG)/\\w*\\.[gif|jpg|png]{1}\\s*\"*"};
	public static final String[] CSS_REGULAR = {"href=.*css/(JCDP_SAIS_CSS)/\\w*\\.css{1}\\s*"};
//	public static final String[] TEXT_REGULAR = {"(JCDP[_\\w*]+)[\\:|\\&|\\#|\\.|<|'|\"|!|-]"};
	public static final String[] TEXT_REGULAR = {"(JCDP[_\\w*]+)([\\:|\\&|\\#|\\.|<|'|\"|!|-])\\2?"};
	public static final String[] JS_REGULAR = {"src=.*js/(JCDP_SAIS_JS)/\\w*\\.js{1}\\s*"};
	public static final String COUNTRY_CN = "cn";
	public static final String COUNTRY_EN = "en";
	
	public static final String IMG_REGULAR_OPEN = "img";
	public static final String CSS_REGULAR_OPEN = "css";
	public static final String TEXT_REGULAR_OPEN = "text";
	
	public static final String REGULAR_TR = "TR";
	public static final String REGULAR_CR = "CR";
	public static final String REGULAR_IR = "IR";
}
