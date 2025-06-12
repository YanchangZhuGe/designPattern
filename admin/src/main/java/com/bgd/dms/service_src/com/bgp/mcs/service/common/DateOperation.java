package com.bgp.mcs.service.common;

import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class DateOperation {
	
	public static boolean checkDate(String date){
		Pattern p = Pattern.compile("^\\d{4}-\\d{1,2}-\\d{1,2}$");
		Matcher match = p.matcher(date);
		if(match.matches()){
			return true;
		}else{
			return false;
		}
	}
	
	public static String afterNDays(String date, long n){
		String afterDate = "";
		if(checkDate(date)){
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			try{
				Date d = sdf.parse(date);
				d.setTime(d.getTime() + n*24*60*60*1000);
				afterDate = sdf.format(d);
			} catch (ParseException e) {
				e.printStackTrace();
			}
		}else{
			return date;
		}
		return afterDate;
	}
	
	public static long diffDaysOfDate(String maxDate, String smallDate){
		long diffDays = -1;
		if(checkDate(maxDate) && checkDate(smallDate)){
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			try{
				Date d1 = sdf.parse(maxDate);
				Date d2 = sdf.parse(smallDate);
				long l = d1.getTime() - d2.getTime();
				diffDays = l/(24*60*60*1000);
			} catch (ParseException e) {
				e.printStackTrace();
			}
		}else{
			return -1;
		}
		return diffDays;
	}
	
	// ��������Ԫ�صĴ����ʾ
		public static final String[] DATE_PATTERN = { "y", "M", "d", "H", "m", "s", "S" };
		
		/**
		 * ����sql���͵ĵ�ǰʱ��
		 * 
		 * ����ֵ����: java.sql.Date
		 * ����ֵ��ʽ��yyyy-MM-dd
		 */
		public static java.sql.Date getSqlDate() {
			return new java.sql.Date(System.currentTimeMillis());
		}
		
		/**
		 * ����util���͵ĵ�ǰʱ��
		 * 
		 * ����ֵ����: java.util.Date
		 * ����ֵ��ʽ��Tue Aug 07 22:22:07 CST 2007
		 */
		public static java.util.Date getUtilDate() {
			return new java.util.Date(System.currentTimeMillis());
		}
		
		// ˽�з���
		/**
		 * ��ʽ�����ڷ������ڲ�����
		 * 
		 * ��������� ����     ������     ע��
		 * 			object    date       ʱ��
		 * 			String    format     ��ʽ
		 * 
		 * ����ֵ���ͣ�String
		 */
		private static String format(Object date, String format) {
			SimpleDateFormat simpleFormat = new SimpleDateFormat(format);
			
			return simpleFormat.format(date);
		}
		
		/**
		 * ��ʽ������Ϊyyyy-MM-dd�ĸ�ʽ
		 * 
		 * ��������� ����     ������     ע��
		 * 			object    date       ʱ��
		 * 
		 * ����ֵ���ͣ�String
		 * ����ֵ��ʽ��yyyy-MM-dd
		 */
		public static String formatDate(Object date) {
			// ���ø�ʽ�����ڷ���
			return format(date,"yyyy-MM-dd");
		}
		
		/**
		 * ��ʽ������Ϊ�û�����ĸ�ʽ
		 * 
		 * yyyy ��
		 * MM   ��
		 * dd   ��
		 * HH   ʱ
		 * mm   ��
		 * ss   ��
		 * S    ����
		 * 
		 * ��������� ����     ������     ע��
		 * 			object    date       ʱ��
		 * 			String    format     ��ʽ
		 * 
		 * ����ֵ���ͣ�String
		 */
		public static String formatDate(Object date, String format) {
			// ���ø�ʽ�����ڷ���
			return format(date,format);
		}
		
		/**
		 * ��ʽ������Ϊyyyy-MM-dd HH:mm:ss�ĸ�ʽ
		 * 
		 * ��������� ����     ������     ע��
		 * 			object    date       ʱ��
		 * 
		 * ����ֵ���ͣ�String
		 * ����ֵ��ʽ��yyyy-MM-dd HH:mm:ss
		 */
		public static String formatDateTime(Object date) {
			// ���ø�ʽ�����ڷ���
			return format(date,"yyyy-MM-dd HH:mm:ss");
		}
		
		// ˽�з���
		/**
		 * ���ַ�������Ϊjava.util.Date�������͵ķ���
		 * 
		 * ��������� ����     ������       ע��
		 * 			String    dateStr      �����ַ���
		 * 			String    datePattern  ��ʽ���������ַ���
		 * 
		 * ����ֵ���ͣ�java.util.Date
		 */
		private static java.util.Date parseUtilDate(String dateStr, String datePattern) {
			SimpleDateFormat simpleFormat = new SimpleDateFormat(datePattern);
			
			try {
				return simpleFormat.parse(dateStr);
			} catch (ParseException e) {
				throw new RuntimeException(e);
			}
		}
		
		/**
		 * ���ַ�������Ϊjava.util.Date
		 * 
		 * ��������� ����     ������       ע��
		 * 			String    dateStr      �����ַ���
		 * 
		 * ����ֵ���ͣ�java.util.Date
		 */
		public static java.util.Date parseToUtilDate(String dateStr) {
			return parseUtilDate(dateStr,getDatePattern(dateStr));
		}
		
		/**
		 * ���ַ��������ɸ�ʽΪyyyy-MM-dd �� java.sql.Date
		 * 
		 * ��������� ����     ������       ע��
		 * 			String    dateStr      �����ַ���
		 * 
		 * ����ֵ���ͣ�java.sql.Date
		 */
		public static java.sql.Date parseToSQLDate(String dateStr) {
			return (new java.sql.Date(parseToUtilDate(dateStr).getTime()));
		}
		
		/**
		 * ���ַ��������ɸ�ʽΪyyyy-MM-dd HH:mm:ss �� java.sql.Timestamp
		 * 
		 * ��������� ����     ������       ע��
		 * 			String    dateStr      �����ַ���
		 * 
		 * ����ֵ���ͣ�java.sql.Timestamp
		 */
		public static java.sql.Timestamp parseToTimestamp(String dateStr) {
			return new Timestamp(parseToSQLDate(dateStr).getTime());
		}
		
		/**
		 * �������ڸ�ʽ
		 * 
		 * ��������� ����     ������       ע��
		 * 			String   dateString    �����ַ���
		 * 
		 * ����ֵ���ͣ�String
		 */
		private static String getDatePattern(final String dateString) {
			String temp = dateString;
			
			// ����������ʽ
			Pattern regexPattern = Pattern.compile("(\\d+)([\\D]{1})(.+)");
			
			// ��������ʽƥ�䴫����ַ���
			Matcher m = regexPattern.matcher(temp);
			
			StringBuffer sb = new StringBuffer();
			
			int j = 0;
			
			// �����ƥ���
			while (m.matches()) {
				sb.append(m.group(1).replaceAll("\\d{1}",DATE_PATTERN[j++]));
				
				sb.append(m.group(2));
				
				temp = m.group(3);
				
				m = regexPattern.matcher(temp);
			}
			
			sb.append(temp.replaceAll("\\d{1}",DATE_PATTERN[j++]));
			
			return sb.toString();
		}
		
		/**
		 * ��������ǻ��ǰһ�������
		 * @return
		 */
		public static String getNextTime() {
			Calendar cal = Calendar.getInstance();
			Date date = new Date();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			try {
				
				cal.setTime(date);
				cal.add(cal.DATE, -1);
				
				return sdf.format(cal.getTime());
			} catch (Exception e) {

				e.printStackTrace();
			}
			return null;
		} 
		
		/**
		 * �������ڼ�������ķ���
		 * @param startDate
		 * @param endDate
		 * @return
		 */
		public static int getDateSkip(String startDate, String endDate){
			Date date1 = parseUtilDate(startDate,"yyyy-MM-dd");
			Date date2 = parseUtilDate(endDate,"yyyy-MM-dd");
			
			long sec1 = date1.getTime();
			long sec2 = date2.getTime();
			
			long skipsec = sec2-sec1;
			
			return (int)(skipsec/86400000)+1;
		}
		
		/**
		 * �жϴ���������Ƿ�����������֮��
		 * ʱ������startDate~endDate
		 * �ж�ʱ��date
		 */
		public static boolean dateBetween(String startDate, String endDate, String date){
			Date date1 = parseUtilDate(startDate,"yyyy-MM-dd");
			Date date2 = parseUtilDate(endDate,"yyyy-MM-dd");
			Date date3 = parseUtilDate(date,"yyyy-MM-dd");
			
			long sec1 = date1.getTime();
			long sec2 = date2.getTime();
			long sec3 = date3.getTime();
			
			if (sec3 >= sec1 && sec3  <= sec2) {
				return true;
			} else {
				return false;
			}
			
		}
}
