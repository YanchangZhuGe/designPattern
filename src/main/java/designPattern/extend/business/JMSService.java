package designPattern.extend.business;

/**
 * 描述:创建实体服务类。
 *
 * @author WuYanchang
 * @date 2021/6/25 17:53
 */

public class JMSService implements BusinessService {

    @Override
    public void doProcessing() {
        System.out.println("Processing task by invoking JMS Service");
    }

}
