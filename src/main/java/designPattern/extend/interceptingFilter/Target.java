package designPattern.extend.interceptingFilter;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/6/29 15:19
 */

public class Target {
    public void execute(String request){
        System.out.println("Executing request: " + request);
    }
}
