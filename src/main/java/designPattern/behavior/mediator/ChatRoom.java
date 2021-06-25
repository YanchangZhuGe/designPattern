package designPattern.behavior.mediator;

import java.util.Date;

/**
 * 描述:创建中介类。
 *
 * @author WuYanchang
 * @date 2021/6/25 9:42
 */

public class ChatRoom {
    public static void showMessage(User user, String message) {
        System.out.println(new Date().toString() + " [" + user.getName() + "] : " + message);
    }
}
