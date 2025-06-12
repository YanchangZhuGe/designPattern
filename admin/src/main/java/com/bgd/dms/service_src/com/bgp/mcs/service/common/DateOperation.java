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
	
	// 定义日期元素的代表标示
		public static final String[] DATE_PATTERN = { "y", "M", "d", "H", "m", "s", "S" };
		
		/**
		 * 返回sql类型的当前时间
		 * 
		 * 返回值类型: java.sql.Date
		 * 返回值格式：yyyy-MM-dd
		 */
		public static java.sql.Date getSqlDate() {
			return new java.sql.Date(System.currentTimeMillis());
		}
		
		/**
		 * 返回util类型的当前时间
		 * 
		 * 返回值类型: java.util.Date
		 * 返回值格式：Tue Aug 07 22:22:07 CST 2007
		 */
		public static java.util.Date getUtilDate() {
			return new java.util.Date(System.currentTimeMillis());
		}
		
		// 私有方法
		/**
		 * 格式化日期方法，内部调用
		 * 
		 * 输入参数： 类型     参数名     注释
		 * 			object    date       时间
		 * 			String    format     格式
		 * 
		 * 返回值类型：String
		 */
		private static String format(Object date, String format) {
			SimpleDateFormat simpleFormat = new SimpleDateFormat(format);
			
			return simpleFormat.format(date);
		}
		
		/**
		 * 格式化日期为yyyy-MM-dd的格式
		 * 
		 * 输入参数： 类型     参数名     注释
		 * 			object    date       时间
		 * 
		 * 返回值类型：String
		 * 返回值格式：yyyy-MM-dd
		 */
		public static String formatDate(Object date) {
			// 调用格式化日期方法
			return format(date,"yyyy-MM-dd");
		}
		
		/**
		 * 格式化日期为用户定义的格式
		 * 
		 * yyyy 年
		 * MM   月
		 * dd   天
		 * HH   时
		 * mm   分
		 * ss   秒
		 * S    毫秒
		 * 
		 * 输入参数： 类型     参数名     注释
		 * 			object    date       时间
		 * 			String    format     格式
		 * 
		 * 返回值类型：String
		 */
		public static String formatDate(Object date, String format) {
			// 调用格式化日期方法
			return format(date,format);
		}
		
		/**
		 * 格式化日期为yyyy-MM-dd HH:mm:ss的格式
		 * 
		 * 输入参数： 类型     参数名     注释
		 * 			object    date       时间
		 * 
		 * 返回值类型：String
		 * 返回值格式：yyyy-MM-dd HH:mm:ss
		 */
		public static String formatDateTime(Object date) {
			// 调用格式化日期方法
			return format(date,"yyyy-MM-dd HH:mm:ss");
		}
		
		// 私有方法
		/**
		 * 将字符串解析为java.util.Date日期类型的方法
		 * 
		 * 输入参数： 类型     参数名       注释
		 * 			String    dateStr      日期字符串
		 * 			String    datePattern  格式化的日期字符串
		 * 
		 * 返回值类型：java.util.Date
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
		 * 将字符串解析为java.util.Date
		 * 
		 * 输入参数： 类型     参数名       注释
		 * 			String    dateStr      日期字符串
		 * 
		 * 返回值类型：java.util.Date
		 */
		public static java.util.Date parseToUtilDate(String dateStr) {
			return parseUtilDate(dateStr,getDatePattern(dateStr));
		}
		
		/**
		 * 将字符串解析成格式为yyyy-MM-dd 的 java.sql.Date
		 * 
		 * 输入参数： 类型     参数名       注释
		 * 			String    dateStr      日期字符串
		 * 
		 * 返回值类型：java.sql.Date
		 */
		public static java.sql.Date parseToSQLDate(String dateStr) {
			return (new java.sql.Date(parseToUtilDate(dateStr).getTime()));
		}
		
		/**
		 * 将字符串解析成格式为yyyy-MM-dd HH:mm:ss 的 java.sql.Timestamp
		 * 
		 * 输入参数： 类型     参数名       注释
		 * 			String    dateStr      日期字符串
		 * 
		 * 返回值类型：java.sql.Timestamp
		 */
		public static java.sql.Timestamp parseToTimestamp(String dateStr) {
			return new Timestamp(parseToSQLDate(dateStr).getTime());
		}
		
		/**
		 * 解析日期格式
		 * 
		 * 输入参数： 类型     参数名       注释
		 * 			String   dateString    日期字符串
		 * 
		 * 返回值类型：String
		 */
		private static String getDatePattern(final String dateString) {
			String temp = dateString;
			
			// 定义正则表达式
			Pattern regexPattern = Pattern.compile("(\\d+)([\\D]{1})(.+)");
			
			// 用正则表达式匹配传入的字符串
			Matcher m = regexPattern.matcher(temp);
			
			StringBuffer sb = new StringBuffer();
			
			int j = 0;
			
			// 如果有匹配的
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
		 * 这个方法是获得前一天的日期
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
		 * 计算日期间隔天数的方法
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
		 * 判断传入的日期是否在两个日期之间
		 * 时间区间startDate~endDate
		 * 判断时间date
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
