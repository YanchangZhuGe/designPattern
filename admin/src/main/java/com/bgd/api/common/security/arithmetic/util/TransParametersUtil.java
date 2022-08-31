package com.bgd.api.common.security.arithmetic.util;

/**
 * @author dell
 * @Title: TransParametersUtil
 * @Description: TODO
 * @Company:
 * @since 2021/6/2212:10
 */
public class TransParametersUtil {
    public static String transparameters(String content, String... params) {
        if (params == null || params.length == 0) {
            return content;
        }

        if (content == null || content.indexOf("{}") < 0) {
            return content;
        }
        for (String s : params) {
            s = s == null ? "" : s;
            content = content.replaceFirst("\\{}", s);
        }

        return content;
    }

    public static void main(String[] args) {
        String addParam = transparameters("额度不足，无法提交。合同金额：{}，额度余额：{}", "100", "200");
        System.out.println(addParam);
    }
}
