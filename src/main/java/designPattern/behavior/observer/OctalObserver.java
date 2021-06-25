package designPattern.behavior.observer;

/**
 * 描述:创建实体观察者类。
 *
 * @author WuYanchang
 * @date 2021/6/25 10:16
 */

public class OctalObserver extends Observer {

    public OctalObserver(Subject subject) {
        this.subject = subject;
        this.subject.attach(this);
    }

    @Override
    public void update() {
        System.out.println("Octal String: "
                + Integer.toOctalString(subject.getState()));
    }

}
