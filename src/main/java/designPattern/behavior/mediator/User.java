package designPattern.behavior.mediator;

/**
 * 描述:创建 user 类。
 *
 * @author WuYanchang
 * @date 2021/6/25 9:42
 */

public class User {
    private String name;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public User(String name) {
        this.name = name;
    }

    public void sendMessage(String message) {
        ChatRoom.showMessage(this, message);
    }
}
