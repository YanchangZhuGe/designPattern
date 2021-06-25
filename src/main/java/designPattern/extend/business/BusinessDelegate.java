package designPattern.extend.business;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/6/25 17:54
 */

public class BusinessDelegate {
    private BusinessLookUp lookupService = new BusinessLookUp();
    private BusinessService businessService;
    private String serviceType;

    public void setServiceType(String serviceType){
        this.serviceType = serviceType;
    }

    public void doTask(){
        businessService = lookupService.getBusinessService(serviceType);
        businessService.doProcessing();
    }

}
