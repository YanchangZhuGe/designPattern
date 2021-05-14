package designPattern.creativion.factory.bingHe;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/5/14 17:47
 */

public class Test {
    public static void main(String[] args) {
        CircleCreate circleCreate = new CircleCreate();
        circleCreate.getShape().draw();

        LineCreate lineCreate = new LineCreate();
        lineCreate.getShape().draw();
    }
}
