package designPattern.extend.serviceLocator;

/**
 * 描述:创建服务定位器。
 *
 * @author WuYanchang
 * @date 2021/6/29 15:24
 */

public class ServiceLocator {
    private static Cache cache;

    static {
        cache = new Cache();
    }

    public static Service getService(String jndiName) {

        Service service = cache.getService(jndiName);

        if (service != null) {
            return service;
        }

        InitialContext context = new InitialContext();
        Service service1 = (Service) context.lookup(jndiName);
        cache.addService(service1);
        return service1;
    }
}
