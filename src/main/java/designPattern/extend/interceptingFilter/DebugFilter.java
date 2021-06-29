package designPattern.extend.interceptingFilter;

/**
 * 描述:创建实体过滤器。
 *
 * @author WuYanchang
 * @date 2021/6/29 15:19
 */

public class DebugFilter implements Filter {
    @Override
    public void execute(String request) {
        System.out.println("request log: " + request);
    }

}
