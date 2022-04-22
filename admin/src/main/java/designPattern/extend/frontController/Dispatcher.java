package designPattern.extend.frontController;

/**
 * 描述:创建调度器 Dispatcher。
 *
 * @author WuYanchang
 * @date 2021/6/29 15:16
 */

public class Dispatcher {
    private StudentView studentView;
    private HomeView homeView;

    public Dispatcher() {
        studentView = new StudentView();
        homeView = new HomeView();
    }

    public void dispatch(String request) {
        if (request.equalsIgnoreCase("STUDENT")) {
            studentView.show();
        } else {
            homeView.show();
        }
    }
}
