package designPattern.extend.business;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/6/25 17:54
 */

public class Client {

    BusinessDelegate businessService;

    public Client(BusinessDelegate businessService){
        this.businessService  = businessService;
    }

    public void doTask(){
        businessService.doTask();
    }

}
