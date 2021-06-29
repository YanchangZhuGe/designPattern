package designPattern.extend.interceptingFilter;

import java.util.ArrayList;
import java.util.List;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/6/29 15:19
 */

public class FilterChain {
    private List<Filter> filters = new ArrayList<Filter>();
    private Target target;

    public void addFilter(Filter filter){
        filters.add(filter);
    }

    public void execute(String request){
        for (Filter filter : filters) {
            filter.execute(request);
        }
        target.execute(request);
    }

    public void setTarget(Target target){
        this.target = target;
    }
}
