package designPattern.extend.serviceLocator;

/**
 * 描述:
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
