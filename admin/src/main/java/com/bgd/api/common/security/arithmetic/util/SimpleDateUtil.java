package com.bgd.api.common.security.arithmetic.util;

import com.nstc.common.utils.string.StringUtil;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * 日期工具类
 *
 * @author
 */
public class SimpleDateUtil {

    private final static String DATE_PATTERN = "yyyy-MM-dd";
    private final static String DATE_TIME_PATTERN = "yyyy-MM-dd HH:mm:ss";

    public static String getStringFromDate(Date date) {
        if (date == null) {
            return null;
        }
        String strDate = "";
        SimpleDateFormat sdf = new SimpleDateFormat(DATE_PATTERN);
        try {
            strDate = sdf.format(date);
        } catch (Exception e) {
            return null;
        } finally {
        }
        return strDate;
    }

    public static String getStringFromDate(Date date, String pattern) {
        if (date == null || StringUtil.isEmpty(pattern)) {
            return null;
        }
        String strDate = "";
        SimpleDateFormat sdf = new SimpleDateFormat(pattern);
        try {
            strDate = sdf.format(date);
        } catch (Exception e) {
            return null;
        } finally {
        }
        return strDate;
    }

    public static Date getDateFromString(String dateString) throws ParseException {
        if (StringUtil.isBlank(dateString)) {
            return null;
        }
        Date formateDate = null;
        DateFormat format = new SimpleDateFormat(DATE_PATTERN);
        try {
            formateDate = format.parse(dateString);
        } catch (ParseException e) {
            return null;
        }
        return formateDate;
    }

    public static Date getDateFromString(String dateString, String pattern) throws ParseException {
        if (StringUtil.isBlank(dateString)) {
            return null;
        }
        Date formateDate = null;
        DateFormat format = new SimpleDateFormat(pattern);
        try {
            formateDate = format.parse(dateString);
        } catch (ParseException e) {
            return null;
        }
        return formateDate;
    }

    /**
     * @描述 —— 格式化日期对象
     */
    public static Date dateToDate(Date date, String formatStr) {
        SimpleDateFormat sdf = new SimpleDateFormat(formatStr);
        String str = sdf.format(date);
        try {
            date = sdf.parse(str);
        } catch (Exception e) {
            return null;
        }
        return date;
    }

}

