package com.ops.designpattern.util;

import java.io.File;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/7/21 14:03
 */

public class Comment {

    public static String getPath(boolean locall) {

        String localPath = "D:" + File.separator + "demo" + File.separator;

        StringBuffer path = new StringBuffer();
        path.append("C:" + File.separator);
        path.append("Users" + File.separator);
        path.append("admin" + File.separator);
        path.append("Desktop" + File.separator);
        path.append("java" + File.separator);

        if (locall) {
            return localPath;
        } else {
            return path.toString();
        }
    }
}
