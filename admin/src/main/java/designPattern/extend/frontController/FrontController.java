package designPattern.extend.frontController;

/**
 * 描述:创建前端控制器 FrontController。
 *
 * @author WuYanchang
 * @date 2021/6/29 15:16
 */

public class FrontController {

    private Dispatcher dispatcher;

    public FrontController() {
        dispatcher = new Dispatcher();
    }

    private boolean isAuthenticUser() {
        System.out.println("User is authenticated successfully.");
        return true;
    }

    private void trackRequest(String request) {
        System.out.println("Page requested: " + request);
    }

    public void dispatchRequest(String request) {
        //记录每一个请求
        trackRequest(request);
        //对用户进行身份验证
        if (isAuthenticUser()) {
            dispatcher.dispatch(request);
        }
    }
}
