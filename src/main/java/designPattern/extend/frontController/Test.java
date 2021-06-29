package designPattern.extend.frontController;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/6/29 15:16
 */

public class Test {
    public static void main(String[] args) {
        FrontController frontController = new FrontController();
        frontController.dispatchRequest("HOME");
        frontController.dispatchRequest("STUDENT");
    }
}
