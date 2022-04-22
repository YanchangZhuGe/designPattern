package designPattern.extend.business;

/**
 * 描述:创建业务查询服务。
 *
 * @author WuYanchang
 * @date 2021/6/25 17:53
 */

public class BusinessLookUp {
    public BusinessService getBusinessService(String serviceType) {
        if (serviceType.equalsIgnoreCase("EJB")) {
            return new EJBService();
        } else {
            return new JMSService();
        }
    }

}
