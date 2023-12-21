package com.example.utils.file.config;

import java.text.DecimalFormat;
import java.text.NumberFormat;

public class NumUtil {

    /**
     * 小数点后留2位
     * 
     * @param amount
     * @return
     */
    public static double getPoint2double(double amount) {
        NumberFormat nf = NumberFormat.getInstance();
        nf.setMaximumFractionDigits(2);
        return Double.parseDouble(nf.format(amount).replaceAll(",", ""));
    }

    /**
     * 小数点后留3位
     *
     * @param amount
     * @return
     */
    public static double getPoint3double(double amount) {
        NumberFormat nf = NumberFormat.getInstance();
        nf.setMaximumFractionDigits(3);
        return Double.parseDouble(nf.format(amount).replaceAll(",", ""));
    }

//    public static BigDecimal getPoint2BigDecimal(BigDecimal amount) {
//        NumberFormat nf = NumberFormat.getInstance();
//        nf.setMaximumFractionDigits(2);
//        return BigDecimalUtil.toBigDecimal(nf.format(amount).replaceAll(",", ""));
//    }

    public static double getPoint6double(double amount) {
        DecimalFormat df = new DecimalFormat("#.000000");
        return Double.parseDouble(df.format(amount));
    }

    public static String getPoint2String(double amount) {
        DecimalFormat df = new DecimalFormat("0.00");
        return df.format(amount);
    }

    public static String getPoint4String(double amount) {
        DecimalFormat df = new DecimalFormat("0.0000");
        return df.format(amount);
    }

    /**
     * 强制类型转化Object为double型
     * 
     * @param obj
     * @param def
     *            出现异常返回def
     * @return
     */
    public static double toDouble(Object obj, double def) {
        if (obj == null)
            return def;
        try {
            if (obj.getClass().equals(String.class))
                obj = ((String) obj).replaceAll(",", "");
            return Double.valueOf(String.valueOf(obj)).doubleValue();
        } catch (Exception e) {
            return def;
        }
    }
    
    /**
     * @Description:判断数值是否为0
     * @param number double
     * @return boolean
     * @author 杨庆祥
     * @since 2013-3-20 下午03:02:21
     */
    public static boolean isZero(double number) {
        return Math.abs(number) < 0.00001;
    }
}
