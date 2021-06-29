package designPattern.extend.interceptingFilter;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/6/29 15:19
 */

public class DebugFilter implements Filter {
    public void execute(String request){
        System.out.println("request log: " + request);
    }

}
