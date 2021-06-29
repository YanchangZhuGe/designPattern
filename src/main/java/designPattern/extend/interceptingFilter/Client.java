package designPattern.extend.interceptingFilter;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/6/29 15:20
 */

public class Client {
    FilterManager filterManager;

    public void setFilterManager(FilterManager filterManager){
        this.filterManager = filterManager;
    }

    public void sendRequest(String request){
        filterManager.filterRequest(request);
    }
}
