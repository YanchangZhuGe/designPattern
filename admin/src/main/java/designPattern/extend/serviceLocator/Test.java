package designPattern.extend.serviceLocator;

/**
 * 描述:使用 ServiceLocator 来演示服务定位器设计模式。
 *
 * @author WuYanchang
 * @date 2021/6/29 15:24
 */

public class Test {
    public static void main(String[] args) {
        Service service = ServiceLocator.getService("Service1");
        service.execute();
        service = ServiceLocator.getService("Service2");
        service.execute();
        service = ServiceLocator.getService("Service1");
        service.execute();
        service = ServiceLocator.getService("Service2");
        service.execute();
    }
}
