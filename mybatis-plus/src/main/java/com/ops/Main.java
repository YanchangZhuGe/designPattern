package com.ops;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date ${DATE} ${TIME}
 */
public class Main {
    public static void main(String[] args) {
        System.out.println("Hello world!");
        String str = "JKZQ2022-02-310001";
        String http = "^((https|http|ftp|rtsp|mms)?:\\/\\/)[^\\s]+";
        String regex = "^JKZQ\\d{4}(\\-)\\d{2}\\1\\d{2}\\d{4}$";
        boolean matches = str.matches(regex);
        System.out.println(matches);
    }
}