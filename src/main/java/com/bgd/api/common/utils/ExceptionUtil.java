package com.bgd.api.common.utils;

/**
 * @author : guodg
 * @date : 2020/8/19
 * 截取需要的异常信息
 */
public class ExceptionUtil {
    /**
     * 获取异常信息，根据长度截取异常信息
     *
     * @param e   异常对象
     * @param len 默认1500字符
     * @return
     */
    public static String substrMessage(Exception e, int len) {
        String message = e.getMessage();
        if (message == null || len <= 0) {
            return message;
        } else if (message.length() <= len) {
            return message;
        } else {
            return message.substring(0, len);
        }
    }

    /**
     * 默认截取66个字符的异常信息
     *
     * @param e
     * @return
     */
    public static String substrMessage(Exception e) {
        return substrMessage(e, 66);
    }
}
