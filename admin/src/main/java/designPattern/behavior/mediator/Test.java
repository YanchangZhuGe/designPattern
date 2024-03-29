package designPattern.behavior.mediator;

/**
 * 描述:使用 User 对象来显示他们之间的通信。
 *
 * @author WuYanchang
 * @date 2021/6/25 9:43
 */

public class Test {
    public static void main(String[] args) {
        User robert = new User("Robert");
        User john = new User("John");

        robert.sendMessage("Hi! John!");
        john.sendMessage("Hello! Robert!");
    }
}
