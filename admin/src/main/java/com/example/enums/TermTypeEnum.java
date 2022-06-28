package com.example.enums;

import com.nstc.ptms.validate.EnumValueLister;

import java.util.Calendar;
import java.util.Date;

public enum TermTypeEnum implements EnumValueLister {
    DAY("DY", "日"),
    WEEK("WK", "周"),
    MONTH("MT", "月");
    /**
     * 期间类型编号
     */
    private String termTypeNo;
    /**
     * 期间类型名称
     */
    private String termTypeName;

    public static String[] exhaustiveList() {
        return new String[]{DAY.termTypeNo, WEEK.termTypeNo, MONTH.termTypeNo};
    }

    /**
     * 获取当前时间段
     *
     * @param termTypeNo
     * @return
     */
    public static Date[] getCurrentTermByNo(String termTypeNo) {
        Date[] term = new Date[2];
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new Date());
        calendar.set(Calendar.HOUR_OF_DAY, 0);
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.set(Calendar.MILLISECOND, 0);

        if (DAY.termTypeNo.equals(termTypeNo)) {
            term[0] = calendar.getTime();
            term[1] = calendar.getTime();

        } else if (WEEK.termTypeNo.equals(termTypeNo)) {
            int weekDay = calendar.get(Calendar.DAY_OF_WEEK);
            if (Calendar.SUNDAY == weekDay) {
                calendar.add(Calendar.DAY_OF_YEAR, -1);
            } else {
                calendar.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
            }
            term[0] = calendar.getTime();
            calendar.add(Calendar.DAY_OF_YEAR, 6);
            term[1] = calendar.getTime();

        } else if (MONTH.termTypeNo.equals(termTypeNo)) {
            calendar.set(Calendar.DAY_OF_MONTH, 1);
            term[0] = calendar.getTime();
            calendar.add(Calendar.MONTH, 1);
            calendar.add(Calendar.DAY_OF_YEAR, -1);
            term[1] = calendar.getTime();
        }
        return term;
    }

    TermTypeEnum(String termTypeNo, String termTypeName) {
        this.termTypeNo = termTypeNo;
        this.termTypeName = termTypeName;
    }

    public String getTermTypeNo() {
        return termTypeNo;
    }

    public String getTermTypeName() {
        return termTypeName;
    }
}
