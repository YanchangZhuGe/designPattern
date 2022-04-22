package designPattern.behavior.observer;

/**
 * 描述:观察者模式
 *
 * @author WuYanchang
 * @date 2021/6/25 10:16
 */

public class Test {
    public static void main(String[] args) {
        Subject subject = new Subject();

        new HexaObserver(subject);
        new OctalObserver(subject);
        new BinaryObserver(subject);

        System.out.println("First state change: 15");
        subject.setState(15);
        System.out.println("Second state change: 10");
        subject.setState(10);
    }
}
