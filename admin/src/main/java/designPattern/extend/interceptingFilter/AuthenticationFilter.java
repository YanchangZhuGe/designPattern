package designPattern.extend.interceptingFilter;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/6/29 15:18
 */

public class AuthenticationFilter implements Filter {
    @Override
    public void execute(String request) {
        System.out.println("Authenticating request: " + request);
    }

}
