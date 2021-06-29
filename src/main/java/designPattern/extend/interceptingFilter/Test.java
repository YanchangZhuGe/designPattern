package designPattern.extend.interceptingFilter;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/6/29 15:20
 */

public class Test {
    public static void main(String[] args) {
        FilterManager filterManager = new FilterManager(new Target());
        filterManager.setFilter(new AuthenticationFilter());
        filterManager.setFilter(new DebugFilter());

        Client client = new Client();
        client.setFilterManager(filterManager);
        client.sendRequest("HOME");
    }
}
