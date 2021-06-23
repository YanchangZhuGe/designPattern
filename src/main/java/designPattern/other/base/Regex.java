package designPattern.other.base;

import java.util.regex.Pattern;

/**
 * 描述:正则表达式
 *
 * @author WuYanchang
 * @date 2021/6/23 16:15
 */

public class Regex {
    public static void main(String[] args) {
        String content = "I am noob " +
                "from runoob.com.";

        String pattern = ".*runoob.*";

        boolean isMatch = Pattern.matches(pattern, content);
        System.out.println("字符串中是否包含了 'runoob' 子字符串? " + isMatch);
    }
}
