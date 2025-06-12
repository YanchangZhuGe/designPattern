package com.bgp.mcs.service.pm.service.common;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import javax.xml.bind.JAXBElement;
import javax.xml.datatype.XMLGregorianCalendar;
import javax.xml.namespace.QName;

import com.sun.org.apache.xerces.internal.jaxp.datatype.XMLGregorianCalendarImpl;

/**
 * 
 * ���⣺��ʯ�ͼ��Ź�˾��������ϵͳ
 * 
 * רҵ����̽רҵ
 * 
 * ��˾: �������
 * 
 * ���ߣ��ǿ��Dec 27, 2011
 * 
 * ������ ��P6�����е���ת��Ϊjava�������
 * 
 * ˵��: ����������
 */
public class P6TypeConvert {
	
	/**
	 * ���ַ�����ʽ�����ڰ�װΪ����Ҫ���XMLGregorianCalendar
	 * @param str String ��Ҫת�����ַ���
	 * @param format String �ַ����ĸ�ʽ yyyy-MM-dd
	 * @return XMLGregorianCalendar ת�����P6��ʽ������
	 * @throws ParseException
	 */
	public static XMLGregorianCalendar convert(String str, String format) throws ParseException{  
		SimpleDateFormat sdf = new SimpleDateFormat(format);
		Date date = sdf.parse(str);
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);

		XMLGregorianCalendar cal = new XMLGregorianCalendarImpl();
		cal.setYear(calendar.get(Calendar.YEAR));
		cal.setMonth(calendar.get(Calendar.MONTH) + 1);
		cal.setDay(calendar.get(Calendar.DAY_OF_MONTH));
		cal.setHour(calendar.get(Calendar.HOUR_OF_DAY));
		cal.setMinute(calendar.get(Calendar.MINUTE));
		cal.setSecond(calendar.get(Calendar.SECOND));
		//cal.setMillisecond(calendar.get(Calendar.MILLISECOND));
		cal.setTimezone(calendar.get(Calendar.ZONE_OFFSET) / 60000);
        return cal;  
    }
	
	/**
	 * �����ڰ�װΪ����Ҫ���XMLGregorianCalendar
	 * @param date ����
	 * @return XMLGregorianCalendar ת�����P6��ʽ������
	 * @throws ParseException
	 */
	public static XMLGregorianCalendar convert(Date date) throws ParseException{  
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);

		XMLGregorianCalendar cal = new XMLGregorianCalendarImpl();
		cal.setYear(calendar.get(Calendar.YEAR));
		cal.setMonth(calendar.get(Calendar.MONTH) + 1);
		cal.setDay(calendar.get(Calendar.DAY_OF_MONTH));
		cal.setHour(calendar.get(Calendar.HOUR_OF_DAY));
		cal.setMinute(calendar.get(Calendar.MINUTE));
		cal.setSecond(calendar.get(Calendar.SECOND));
		//cal.setMillisecond(calendar.get(Calendar.MILLISECOND));
		cal.setTimezone(calendar.get(Calendar.ZONE_OFFSET) / 60000);
        return cal;
    }
	
	/**
	 * ��P6��ʽ����ת��Ϊ����
	 * @param cal XMLGregorianCalendar
	 * @return Date ת���������
	 * @throws Exception
	 */
	public static Date convert(XMLGregorianCalendar cal) throws Exception{
		if (cal == null) {
			return null;
		}
		Calendar calendar = Calendar.getInstance();
		calendar.set(Calendar.YEAR, cal.getYear());
		calendar.set(Calendar.DATE, cal.getDay());
		calendar.set(Calendar.MONTH, cal.getMonth()-1);
		calendar.set(Calendar.DAY_OF_MONTH, cal.getDay());
		calendar.set(Calendar.HOUR_OF_DAY, cal.getHour());
		calendar.set(Calendar.MINUTE, cal.getMinute());
		calendar.set(Calendar.SECOND, cal.getSecond());
		//calendar.set(Calendar.MILLISECOND, cal.getMillisecond());
		//calendar.set(Calendar.ZONE_OFFSET, cal.getTimezone() * 60000);
		
		return calendar.getTime();
	}
	
	/**
	 * ��P6��ʽ���ڸ���ָ����ʽת��Ϊ�ַ���
	 * @param cal XMLGregorianCalendar
	 * @param format String ����yyyy-MM-dd
	 * @return String ת������ַ���
	 * @throws Exception
	 */
	public static String convert(XMLGregorianCalendar cal, String format) throws Exception{
		if (cal == null) {
			return null;
		}
		SimpleDateFormat sdf = new SimpleDateFormat(format);
		
		
		Calendar calendar = Calendar.getInstance();
		calendar.set(Calendar.YEAR, cal.getYear());
		calendar.set(Calendar.DATE, cal.getDay());
		calendar.set(Calendar.MONTH, cal.getMonth()-1);
		calendar.set(Calendar.DAY_OF_MONTH, cal.getDay());
		calendar.set(Calendar.HOUR_OF_DAY, cal.getHour());
		calendar.set(Calendar.MINUTE, cal.getMinute());
		calendar.set(Calendar.SECOND, cal.getSecond());
		//calendar.set(Calendar.MILLISECOND, cal.getMillisecond());
		//calendar.set(Calendar.ZONE_OFFSET, cal.getTimezone() * 60000);
		
		return sdf.format(calendar.getTime());
	}
	
	public static Date convert(JAXBElement<XMLGregorianCalendar> par) throws Exception{
		if (par == null || "".equals(par)) {
			return null;
		} else {
			return convert(par.getValue());
		}
	}
	
	public static String convert(JAXBElement<XMLGregorianCalendar> par, String format) throws Exception{
		if (par == null || "".equals(par)) {
			return null;
		} else {
			if (format == null || "".equals(format)) {
				format = "yyyy-MM-dd";
			}
			return convert(par.getValue(),format);
		}
	}
	
	public static JAXBElement<Double> convertDouble(String name, String namespace, String value){
		
		if (value == null || "".equals(value)) {
			return null;
		}
		
		JAXBElement<Double> d = new JAXBElement<Double>(new QName(namespace,name), Double.class, Double.parseDouble(value));
		
		return d;
	}
	
	public static JAXBElement<Integer> convertInteger(String name, String namespace, String value){
		
		if (value == null || "".equals(value)) {
			return null;
		}
		
		JAXBElement<Integer> d = new JAXBElement<Integer>(new QName(namespace,name), Integer.class, Integer.parseInt(value));
		
		return d;
	}
	
	public static JAXBElement<Integer> convertInteger(String name, String value){
		
		if (value == null || "".equals(value)) {
			return null;
		}
		
		JAXBElement<Integer> d = new JAXBElement<Integer>(new QName(name), Integer.class, Integer.parseInt(value));
		
		return d;
	}
	
	public static JAXBElement<XMLGregorianCalendar> convertXMLGregorianCalendar(String name, String namespace, String value, String format) throws Exception{
		
		if (value == null || "".equals(value)) {
			return null;
		}
		
		if (namespace == null || "".equals(namespace)) {
			JAXBElement<XMLGregorianCalendar> d = new JAXBElement<XMLGregorianCalendar>(new QName(name), XMLGregorianCalendar.class, convert(value, format));
			return d;
		} else {
			JAXBElement<XMLGregorianCalendar> d = new JAXBElement<XMLGregorianCalendar>(new QName(namespace,name), XMLGregorianCalendar.class, convert(value, format));
			return d;
		}
		
	}
	
	public static JAXBElement<XMLGregorianCalendar> convertXMLGregorianCalendar(String name, String namespace, Date date) throws Exception{
		
		if (date == null || "".equals(date)) {
			return null;
		}
		
		if (namespace == null || "".equals(namespace)) {
			JAXBElement<XMLGregorianCalendar> d = new JAXBElement<XMLGregorianCalendar>(new QName(name), XMLGregorianCalendar.class, convert(date));
			return d;
		} else {
			JAXBElement<XMLGregorianCalendar> d = new JAXBElement<XMLGregorianCalendar>(new QName(namespace,name), XMLGregorianCalendar.class, convert(date));
			return d;
		}
		
	}
	
	public static Double convertDouble(JAXBElement<Double> value){
		
		if (value == null || "".equals(value)) {
			return 0.0;
		}
		
		return value.getValue();
	}
	
	public static Integer convertInteger(JAXBElement<Integer> value){
		
		if (value == null || "".equals(value)) {
			return 0;
		}
		
		return value.getValue();
	}
	
	public static double convertDouble(Object value){
		
		if (value == null || "".equals(value)) {
			return 0.0;
		}
		
		double doubleValue = 0;
		try {
			doubleValue = Double.parseDouble((String) value);
		} catch (Exception e) {
			doubleValue = ((BigDecimal) value).doubleValue();
		}
		
		return doubleValue;
	}
	
	public static long convertLong(Object value){
		
		if (value == null || "".equals(value)) {
			return 0;
		}
		
		long longValue = 0;
		try {
			longValue = Long.parseLong((String) value);
		} catch (Exception e) {
			longValue = ((BigDecimal) value).longValue();
		}
		
		return longValue;
	}
	
	/** 
	 * 	�������������ĳ����ݿ��� userName->user_name
	 */
	public static String propertyToField(String property) {
		if (null == property) {
			return "";
		}
		char[] chars = property.toCharArray();
		StringBuffer field = new StringBuffer();
		for (char c : chars) {
			if (isUp(c)) {
				field.append("_" + String.valueOf(c).toLowerCase());
			} else {
				field.append(c);
			}
		}
		return field.toString();
	}
	
	/** 
	 * 	�����ݿ����ĳɶ��������� user_name->userName
	 */
	public static String fieldToProperty(String field) {
		if (null == field) {
			return "";
		}
		char[] chars = field.toCharArray();
		StringBuffer property = new StringBuffer();
		for (int i = 0; i < chars.length; i++) {
			char c = chars[i];
			if (c == '_') {
				int j = i + 1;
				if (j < chars.length) {
					property.append(String.valueOf(chars[j]).toUpperCase());
					i++;
				}
			} else {
				property.append(c);
			}
		}
		return property.toString();
	}
	
	/**
	* �ж��Ƿ��Ǵ�д��ĸ
	* @param c
	* @return
	*/
	private static Boolean isUp(char c) {
		if (c >= 'A' && c <= 'Z') {
			return true;
		}
		return false;
	}
	
	
	/**
	 * �����������õ���Ӧ��get������ userName �õ�getUserName
	 * @param property
	 * @return
	 */
	public static String getMethodName(String property){
		String str = "get";
		char c = property.charAt(0);
		str += String.valueOf(c).toUpperCase()+property.substring(1, property.length());
		return str;
	}
	
	public static Object convert(Object value){
		//System.out.println(value.getClass());
		if (value.getClass().toString().indexOf("JAXBElement") != -1) {
			javax.xml.bind.JAXBElement object = (javax.xml.bind.JAXBElement) value;
			//System.out.println(object.getValue());
			return object.getValue();
		} else if(value.getClass().toString().indexOf("Double") != -1) {
			Double d = (Double) value;
			//System.out.println(d.doubleValue());
			return d.doubleValue();
		} else if(value.getClass().toString().indexOf("Integer") != -1) {
			Integer i = (Integer) value;
			//System.out.println(i.intValue());
			return i.intValue();
		} else {
			//System.out.println(value);
			return value;
		}
	}
	public static XMLGregorianCalendar convertNew(Date date) throws ParseException{  
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);

		XMLGregorianCalendar cal = new XMLGregorianCalendarImpl();
		cal.setYear(calendar.get(Calendar.YEAR));
		cal.setMonth(calendar.get(Calendar.MONTH) + 1);
		cal.setDay(calendar.get(Calendar.DAY_OF_MONTH));
		cal.setHour(calendar.get(Calendar.HOUR_OF_DAY));
		cal.setMinute(calendar.get(Calendar.MINUTE));
		cal.setSecond(calendar.get(Calendar.SECOND));
		//cal.setMillisecond(calendar.get(Calendar.MILLISECOND));
		//cal.setTimezone(calendar.get(Calendar.ZONE_OFFSET) / 60000);
        return cal;
    }
	
	public static void main(String[] args) throws Exception {
		System.out.println(P6TypeConvert.convert("2012-02-23","yyyy-MM-dd"));
		System.out.println(propertyToField("userName"));
		System.out.println(fieldToProperty("user_name"));
		System.out.println(getMethodName("userName"));
	}
}
