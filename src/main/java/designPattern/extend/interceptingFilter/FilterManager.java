package designPattern.extend.interceptingFilter;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/6/29 15:20
 */

public class FilterManager {
    FilterChain filterChain;

    public FilterManager(Target target){
        filterChain = new FilterChain();
        filterChain.setTarget(target);
    }
    public void setFilter(Filter filter){
        filterChain.addFilter(filter);
    }

    public void filterRequest(String request){
        filterChain.execute(request);
    }
}
