package designPattern.extend.business;

/**
 * 描述:使用 BusinessDelegate 和 Client 类来演示业务代表模式。
 *
 * @author WuYanchang
 * @date 2021/6/25 17:54
 */

public class BusinessDelegatePatternDemo {

    public static void main(String[] args) {

        BusinessDelegate businessDelegate = new BusinessDelegate();
        businessDelegate.setServiceType("EJB");

        Client client = new Client(businessDelegate);
        client.doTask();

        businessDelegate.setServiceType("JMS");
        client.doTask();
    }
}
