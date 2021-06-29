package designPattern.extend.serviceLocator;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/6/29 15:23
 */

public class Service1 implements Service {
    @Override
    public void execute(){
        System.out.println("Executing Service1");
    }

    @Override
    public String getName() {
        return "Service1";
    }

}
