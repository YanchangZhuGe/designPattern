package designPattern.behavior.observer;

/**
 * 描述:创建实体观察者类。
 *
 * @author WuYanchang
 * @date 2021/6/25 10:15
 */

public class BinaryObserver extends Observer {

    public BinaryObserver(Subject subject) {
        this.subject = subject;
        this.subject.attach(this);
    }

    @Override
    public void update() {
        System.out.println("Binary String: "
                + Integer.toBinaryString(subject.getState()));
    }

}
