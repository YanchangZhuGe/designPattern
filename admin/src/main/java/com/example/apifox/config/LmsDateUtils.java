package com.example.apifox.config;

import java.util.Calendar;
import java.util.Date;

/**
 * @ClassName LmsDateUtils
 * @Description
 * @Author lihongling
 * @Date 2022/1/14 14:24
 **/
public class LmsDateUtils {
    /**
     *
     * @param nowTime   当前时间
     * @param startTime	开始时间
     * @param endTime   结束时间
     * @return
     * @author lihongling   判断当前时间在时间区间内
     */
    public static boolean isEffectiveDate(Date nowTime, Date startTime, Date endTime) {
        if (nowTime.getTime() == startTime.getTime()
                || nowTime.getTime() == endTime.getTime()) {
            return true;
        }

        Calendar date = Calendar.getInstance();
        date.setTime(nowTime);

        Calendar begin = Calendar.getInstance();
        begin.setTime(startTime);

        Calendar end = Calendar.getInstance();
        end.setTime(endTime);

        if (date.after(begin) && date.before(end)) {
            return true;
        } else {
            return false;
        }
    }
    /**
     * 通过时间秒毫秒数判断两个时间的间隔
     * @param date1
     * @param date2
     * @return
     */
    public static int differentDaysByMillisecond(Date date1,Date date2)
    {
        int days = (int) ((date2.getTime() - date1.getTime()) / (1000*3600*24));
        return days;
    }

    /**
     * date2比date1多的天数
     * @param date1
     * @param date2
     * @return
     */
    public static int differentDays(Date date1,Date date2)
    {
        Calendar cal1 = Calendar.getInstance();
        cal1.setTime(date1);

        Calendar cal2 = Calendar.getInstance();
        cal2.setTime(date2);
        int day1= cal1.get(Calendar.DAY_OF_YEAR);
        int day2 = cal2.get(Calendar.DAY_OF_YEAR);

        int year1 = cal1.get(Calendar.YEAR);
        int year2 = cal2.get(Calendar.YEAR);
        if(year1 != year2)   //同一年
        {
            int timeDistance = 0 ;
            for(int i = year1 ; i < year2 ; i ++)
            {
                if(i%4==0 && i%100!=0 || i%400==0)    //闰年
                {
                    timeDistance += 366;
                }
                else    //不是闰年
                {
                    timeDistance += 365;
                }
            }

            return timeDistance + (day2-day1) ;
        }
        else    //不同年
        {
            System.out.println("判断day2 - day1 : " + (day2-day1));
            return day2-day1;
        }
    }

    // 可能由于jar包冲突,引起com.nstc.util.DateUtil.getDate() 为空,故在本地实现该方法
    public static Date getDate(Date dt) {
        return dt == null ? null : encodeDate(getYear(dt), getMonth(dt), getDay(dt));
    }
    public static Date encodeDate(int y, int m, int d) {
        Calendar cl = Calendar.getInstance();
        cl.set(1, y);
        cl.set(2, m - 1);
        cl.set(5, d);
        cl.set(10, 0);
        cl.set(11, 0);
        cl.set(12, 0);
        cl.set(13, 0);
        cl.set(14, 0);
        return cl.getTime();
    }
    public static int getYear(Date d) {
        Calendar cl = Calendar.getInstance();
        cl.setTime(d);
        return cl.get(1);
    }
    public static int getMonth(Date d) {
        Calendar cl = Calendar.getInstance();
        cl.setTime(d);
        return cl.get(2) + 1;
    }
    public static int getDay(Date d) {
        Calendar cl = Calendar.getInstance();
        cl.setTime(d);
        return cl.get(5);
    }
}
