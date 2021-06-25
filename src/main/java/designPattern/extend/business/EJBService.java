package designPattern.extend.business;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/6/25 17:53
 */

public class EJBService  implements BusinessService {

    @Override
    public void doProcessing() {
        System.out.println("Processing task by invoking EJB Service");
    }

}
