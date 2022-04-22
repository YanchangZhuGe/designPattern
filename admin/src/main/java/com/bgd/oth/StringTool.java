package com.bgd.oth;

import org.springframework.util.StringUtils;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2022/1/20 16:38
 */

public class StringTool extends StringUtils {

    public static boolean isNull(String userCode)
    {
        return !StringUtils.hasText(userCode);
    }
}
