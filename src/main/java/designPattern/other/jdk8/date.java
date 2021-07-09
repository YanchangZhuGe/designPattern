package designPattern.other.jdk8;

import java.text.SimpleDateFormat;
import java.time.*;
import java.util.Calendar;
import java.util.Date;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/7/2 14:52
 */

public class date {
    public static void main(String args[]) {
        date java8tester = new date();
        java8tester.testLocalDateTime();
    }

    public void testLocalDateTime() {

        // 获取当前的日期时间
        LocalDateTime currentTime = LocalDateTime.now();
        System.out.println("当前时间: " + currentTime);

        LocalDate date1 = currentTime.toLocalDate();
        System.out.println("date1: " + date1);

        Month month = currentTime.getMonth();
        int day = currentTime.getDayOfMonth();
        int seconds = currentTime.getSecond();

        System.out.println("月: " + month + ", 日: " + day + ", 秒: " + seconds);

        LocalDateTime date2 = currentTime.withDayOfMonth(10).withYear(2012);
        System.out.println("date2: " + date2);

        // 12 december 2014
        LocalDate date3 = LocalDate.of(2014, Month.DECEMBER, 12);
        System.out.println("date3: " + date3);

        // 22 小时 15 分钟
        LocalTime date4 = LocalTime.of(22, 15);
        System.out.println("date4: " + date4);

        // 解析字符串
        LocalTime date5 = LocalTime.parse("20:15:30");
        System.out.println("date5: " + date5);
    }
}

//使用时区的日期时间API

class ZonedDateTime1 {
    public static void main(String args[]) {
        ZonedDateTime1 java8tester = new ZonedDateTime1();
        java8tester.testZonedDateTime();
    }

    public void testZonedDateTime() {

        // 获取当前时间日期
        ZonedDateTime date1 = ZonedDateTime.parse("2015-12-03T10:15:30+05:30[Asia/Shanghai]");
        System.out.println("date1: " + date1);

        ZoneId id = ZoneId.of("Europe/Paris");
        System.out.println("ZoneId: " + id);

        ZoneId currentZone = ZoneId.systemDefault();
        System.out.println("当期时区: " + currentZone);
    }

}

class a {
    public static void main(String[] args)  throws Exception {

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Calendar cd= Calendar.getInstance();//获取一个Calendar对象
        Calendar cd1= Calendar.getInstance();//获取一个Calendar对象

        String start = "2021-07-07";
        Date parse = null;
        Date now = new Date();
        now.setHours(0);
        now.setMinutes(0);
        now.setSeconds(0);
        cd1.setTime(now);//设置calendar日期
        Integer sum = new Integer(0);
        String shms = "1 +1 +0 ";
        String[] split = shms.trim().split("\\+");
        for (String s : split) {
            String trim = s.trim();
            sum += Integer.valueOf(trim);
            cd.setTime(sdf.parse(start));//设置calendar日期
            cd.add(Calendar.YEAR,sum);//增加n年

            long l = (cd.getTimeInMillis() - cd1.getTimeInMillis()) / (24*3600*1000);
            System.out.println(l);


        }
    }
}