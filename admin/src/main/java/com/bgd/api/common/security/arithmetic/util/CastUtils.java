package com.bgd.api.common.security.arithmetic.util;

import com.nstc.util.CastUtil;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * <p>Title: CastUtils.java</p>
 *
 * <p>Description: </p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author niujie
 * @since：2018-7-26 下午01:01:40
 */
public class CastUtils {

	private static final long serialVersionUID = 1L;

	/**
	 * @param d1
	 * @param d2
	 * @return
	 * @return boolean
	 * @Description:比较两个double值
	 * @author niujie
	 * @since：2018-8-3 上午03:03:53
	 */
	public static boolean toCompareDouble(double d1, double d2) {
		double dd1 = Math.round(d1 * 100) / 100.00;
		double dd2 = Math.round(d2 * 100) / 100.00;
		BigDecimal data1 = new BigDecimal(dd1);
		BigDecimal data2 = new BigDecimal(dd2);
		if (data1.compareTo(data2) != 0) {
			return true;
		}
		return false;
	}

	/**
	 * @param date
	 * @return
	 * @return String
	 * @Description:日期转换为字符串（yyyy-MM-dd）
	 * @author niujie
	 * @since：2018-8-3 上午03:04:14
	 */
	public static String datetoString(Date date) {
		String str = null;
		if (date != null) {
			str = new SimpleDateFormat("yyyy-MM-dd").format(date);
			return str;
		}
		return null;
	}

	/**
	 * @param m_endDate
	 * @param endDate
	 * @return
	 * @return boolean
	 * @Description:比较两个日期
	 * @author niujie
	 * @since：2018-8-3 上午03:04:49
	 */
	public static int compareDate(Date date1, Date date2) {
		if (date1 != null && date2 != null) {
			long d1 = date1.getTime();
			long d2 = date2.getTime();
			long d = d1 - d2;
			if (d >= 0) {
				return 1;
			} else {
				return -1;
			}
		} else {
			return 0;
		}
	}

	/**
	 * @param startDate
	 * @param endDate
	 * @return
	 * @return Object
	 * @Description:日期求差
	 * @author niujie
	 * @since：2018-8-3 上午05:40:35
	 */
	public static Integer subDate(Date startDate, Date endDate) {
		Integer day = 0;
		if (startDate != null && endDate != null) {
			Calendar cal = Calendar.getInstance();
			cal.setTime(startDate);
			long time1 = cal.getTimeInMillis();
			cal.setTime(endDate);
			long time2 = cal.getTimeInMillis();
			long between_days = (time2 - time1) / (1000 * 3600 * 24);
			return Integer.parseInt(String.valueOf(between_days));
		}
		return day;
	}

	public static List<Map<String, Object>> list4Sort(List<Map<String, Object>> list) {
		Collections.sort(list, new Comparator<Map<String, Object>>() {
			public int compare(Map<String, Object> o1,
							   Map<String, Object> o2) {
				return CastUtil.toInteger(o1.get("id")) - CastUtil.toInteger(o2.get("id"));
			}
		});
		return list;
	}

	public static void main(String[] args) {
		int ff = CastUtils.subDate(new Date(), new Date());
		System.out.println(ff);
	}

	public static Date toDate(String str) {
		Date date = new Date();
		try {
			date = new SimpleDateFormat("yyyy-MM-dd").parse(str);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return date;
	}
}
